import Foundation
import CoreLocation

class locationservice: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = locationservice()
    
    @Published var latitude: Double?
    @Published var longitude: Double?
    @Published var city: String = ""
    @Published var country: String = ""
    @Published var authorized = false
    
    private let manager = CLLocationManager()
    private let defaults = UserDefaults(suiteName: "group.dev.cyendd.mizan")
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Load saved coordinates from shared UserDefaults
        if let lat = defaults?.double(forKey: "latitude"), let lon = defaults?.double(forKey: "longitude"), lat != 0 {
            latitude = lat
            longitude = lon
        }
    }
    
    func request() {
        manager.requestWhenInUseAuthorization()
    }
    
    func start() {
        manager.startUpdatingLocation()
    }
    
    func stop() {
        manager.stopUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            authorized = true
            start()
        case .denied, .restricted:
            authorized = false
            // Immediately fallback to IP location when GPS is denied
            fallbacktoip()
        case .notDetermined:
            request()
            // Also try IP fallback while waiting for user decision
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                if self?.latitude == nil {
                    self?.fallbacktoip()
                }
            }
        @unknown default:
            fallbacktoip()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        
        defaults?.set(latitude, forKey: "latitude")
        defaults?.set(longitude, forKey: "longitude")
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let placemark = placemarks?.first else { return }
            DispatchQueue.main.async {
                self?.city = placemark.locality ?? placemark.administrativeArea ?? ""
                self?.country = placemark.country ?? ""
            }
        }
        
        stop()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("location error: \(error.localizedDescription)")
        fallbacktoip()
    }
    
    private func fallbacktoip() {
        guard let url = URL(string: "https://ipinfo.io/json") else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else { return }
            
            if let json = try? JSONDecoder().decode(iplocation.self, from: data) {
                DispatchQueue.main.async {
                    self?.city = json.city
                    self?.country = json.country
                    let coords = json.loc.split(separator: ",").compactMap({ Double($0) })
                    if coords.count == 2 {
                        self?.latitude = coords[0]
                        self?.longitude = coords[1]
                        self?.defaults?.set(coords[0], forKey: "latitude")
                        self?.defaults?.set(coords[1], forKey: "longitude")
                    }
                }
            }
        }.resume()
    }
}

struct iplocation: Codable {
    let city: String
    let country: String
    let loc: String
}
