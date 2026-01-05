import Foundation
import CoreLocation
import Combine

class qiblaservice: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = qiblaservice()
    
    @Published var heading: Double = 0
    @Published var qibladirection: Double = 0
    @Published var distance: Double = 0
    @Published var authorized = false
    @Published var facing = false
    @Published var turntext = ""
    @Published var location = ""
    
    private let manager = CLLocationManager()
    private let kaabalat = 21.4225
    private let kaabalonlon = 39.8262
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.headingFilter = 1
    }
    
    func request() {
        manager.requestWhenInUseAuthorization()
    }
    
    func start() {
        manager.startUpdatingLocation()
        manager.startUpdatingHeading()
    }
    
    func stop() {
        manager.stopUpdatingLocation()
        manager.stopUpdatingHeading()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            authorized = true
            start()
        case .denied, .restricted:
            authorized = false
            fallbacktoip()
        case .notDetermined:
            request()
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else { return }
        
        let kaaba = CLLocation(latitude: kaabalat, longitude: kaabalonlon)
        distance = loc.distance(from: kaaba) / 1000
        
        qibladirection = calculatebearing(from: loc.coordinate, to: kaaba.coordinate)
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(loc) { [weak self] placemarks, error in
            guard let placemark = placemarks?.first else { return }
            DispatchQueue.main.async {
                let city = placemark.locality ?? placemark.administrativeArea ?? ""
                let country = placemark.country ?? ""
                self?.location = "\(city), \(country)"
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        heading = newHeading.trueHeading >= 0 ? newHeading.trueHeading : newHeading.magneticHeading
        
        let diff = qibladirection - heading
        let normalized = (diff + 360).truncatingRemainder(dividingBy: 360)
        
        if normalized < 15 || normalized > 345 {
            facing = true
            turntext = "You're facing the Qibla"
        } else {
            facing = false
            if normalized > 180 {
                turntext = "Turn to your right"
            } else {
                turntext = "Turn to your left"
            }
        }
    }
    
    private func fallbacktoip() {
        guard let url = URL(string: "https://ipinfo.io/json") else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil,
                  let json = try? JSONDecoder().decode(iplocation.self, from: data) else { return }
            
            DispatchQueue.main.async {
                self?.location = "\(json.city), \(json.country)"
                let coords = json.loc.split(separator: ",").compactMap({ Double($0) })
                if coords.count == 2 {
                    let userloc = CLLocation(latitude: coords[0], longitude: coords[1])
                    let kaaba = CLLocation(latitude: self?.kaabalat ?? 0, longitude: self?.kaabalonlon ?? 0)
                    self?.distance = userloc.distance(from: kaaba) / 1000
                    self?.qibladirection = self?.calculatebearing(from: userloc.coordinate, to: kaaba.coordinate) ?? 0
                }
            }
        }.resume()
    }
    
    private func calculatebearing(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Double {
        let lat1 = from.latitude * .pi / 180
        let lon1 = from.longitude * .pi / 180
        let lat2 = to.latitude * .pi / 180
        let lon2 = to.longitude * .pi / 180
        
        let dlon = lon2 - lon1
        let y = sin(dlon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dlon)
        let bearing = atan2(y, x) * 180 / .pi
        
        return (bearing + 360).truncatingRemainder(dividingBy: 360)
    }
}
