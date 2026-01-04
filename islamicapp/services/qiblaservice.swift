import Foundation
import CoreLocation
import Combine

class qiblaservice: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = qiblaservice()
    
    private let manager = CLLocationManager()
    @Published var heading: Double = 0
    @Published var qiblabearing: Double = 0
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        manager.startUpdatingHeading()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        heading = newHeading.magneticHeading
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        qiblabearing = calculatebearing(from: location.coordinate)
    }
    
    private func calculatebearing(from coordinate: CLLocationCoordinate2D) -> Double {
        let kaabaLat = 21.422487
        let kaabaLon = 39.826206
        
        let lat1 = coordinate.latitude * .pi / 180
        let lon1 = coordinate.longitude * .pi / 180
        let lat2 = kaabaLat * .pi / 180
        let lon2 = kaabaLon * .pi / 180
        
        let dLon = lon2 - lon1
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let bearing = atan2(y, x) * 180 / .pi
        
        return (bearing + 360).truncatingRemainder(dividingBy: 360)
    }
}
