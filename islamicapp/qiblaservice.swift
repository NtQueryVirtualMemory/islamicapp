import Foundation
import CoreLocation
import Combine

class qiblaservice: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = qiblaservice()
    
    @Published var heading: Double = 0
    @Published var qiblabearing: Double = 0
    @Published var authorized: Bool = false
    
    private let manager = CLLocationManager()
    private let kaaba = CLLocation(latitude: 21.4225, longitude: 39.8262)
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.headingFilter = 1
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        manager.startUpdatingHeading()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        DispatchQueue.main.async {
            self.heading = newHeading.magneticHeading
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        calculateqibla(from: location)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            authorized = true
            manager.startUpdatingLocation()
            manager.startUpdatingHeading()
        default:
            authorized = false
            fetchlocationbyip()
        }
    }
    
    private func fetchlocationbyip() {
        Task {
            do {
                let loc = try await prayerservice.shared.locate()
                let coords = loc.coordinates
                let location = CLLocation(latitude: coords.lat, longitude: coords.lon)
                calculateqibla(from: location)
            } catch {
                print(error)
            }
        }
    }
    
    private func calculateqibla(from location: CLLocation) {
        let lat1 = location.coordinate.latitude * .pi / 180
        let lon1 = location.coordinate.longitude * .pi / 180
        let lat2 = kaaba.coordinate.latitude * .pi / 180
        let lon2 = kaaba.coordinate.longitude * .pi / 180
        
        let dlon = lon2 - lon1
        
        let y = sin(dlon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dlon)
        
        var bearing = atan2(y, x) * 180 / .pi
        if bearing < 0 {
            bearing += 360
        }
        
        DispatchQueue.main.async {
            self.qiblabearing = bearing
        }
    }
}
