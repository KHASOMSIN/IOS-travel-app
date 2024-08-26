import MapKit
import CoreLocation

extension ProvinceDetailViewController: CLLocationManagerDelegate {
    
     func calculateAndDisplayDistanceAndTime() {
        guard let userLocation = locationManager.location,
              let destinationCoordinate = destinationCoordinate else {
            print("User location or destination coordinate not available")
            return
        }
        
        let startCoordinate = userLocation.coordinate
        let distance = calculateDistance(from: startCoordinate, to: destinationCoordinate)
        let distanceInKilometers = distance / 1000
        kilometers.text = String(format: "Distance: %.2f Km", distanceInKilometers)
        
        calculateTravelTime(from: startCoordinate, to: destinationCoordinate) { time in
            if let time = time {
                let hours = Int(time / 3600)
                let minutes = Int((time.truncatingRemainder(dividingBy: 3600)) / 60)
                self.Estimated.text = "Travel time: \(hours)h \(minutes)m"
            } else {
                self.Estimated.text = "Travel time: can't calculate time"
            }
        }
    }
    
    private func calculateDistance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
        let fromLocation = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let toLocation = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return fromLocation.distance(from: toLocation) // Distance in meters
    }
    
    private func calculateTravelTime(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D, completion: @escaping (Double?) -> Void) {
        let sourcePlacemark = MKPlacemark(coordinate: from)
        let destinationPlacemark = MKPlacemark(coordinate: to)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: sourcePlacemark)
        request.destination = MKMapItem(placemark: destinationPlacemark)
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            if let error = error {
                print("Error calculating directions: \(error.localizedDescription)")
                completion(nil)
            } else if let route = response?.routes.first {
                completion(route.expectedTravelTime) // Travel time in seconds
            } else {
                print("No routes found")
                completion(nil)
            }
        }
    }
}
