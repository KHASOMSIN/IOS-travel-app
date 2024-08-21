//
//  DetailLocation.swift
//  Tavel
//
//  Created by user245540 on 8/14/24.
//

import MapKit
import UIKit
import CoreLocation

extension PopularDetailViewController: CLLocationManagerDelegate {
    
    @IBAction func mapViewTapped() {
        
        let urlString = "comgooglemaps://?daddr=\(latitude),\(longitude)&directionsmode=driving"
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            // Fallback to Apple Maps if Google Maps is not installed
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
            mapItem.name = "ភូមិ ត្រពាំខ្ចៅ"
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
        }
    }

    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        // Request location authorization
        locationManager.requestWhenInUseAuthorization()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if #available(iOS 14.0, *) {
            switch manager.authorizationStatus {
            case .authorizedWhenInUse, .authorizedAlways:
                // Start updating location only when authorized
                locationManager.startUpdatingLocation()
            case .denied, .restricted:
                // Show an alert if the user denied or restricted location access
                showAlert(message: "Location access is denied or restricted. Please enable it in Settings.")
            case .notDetermined:
                // Request authorization again if not determined
                locationManager.requestWhenInUseAuthorization()
            @unknown default:
                fatalError("Unknown authorization status")
            }
        } else {
            // Fallback on earlier versions
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.last else { return }
        showLocation(for: userLocation.coordinate)
        
        // Perform distance calculation asynchronously
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.calculateDistanceAndTime(from: userLocation.coordinate)
        }
        
        locationManager.stopUpdatingLocation() // Stop updating to save battery
    }

    private func showLocation(for coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = locationame
        mapView.addAnnotation(annotation)
    }

    private func calculateDistanceAndTime(from userCoordinate: CLLocationCoordinate2D) {
        let destinationCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude) // Replace with actual destination coordinates

        let userPlacemark = MKPlacemark(coordinate: userCoordinate)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate)

        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: userPlacemark)
        request.destination = MKMapItem(placemark: destinationPlacemark)
        request.transportType = .automobile

        let directions = MKDirections(request: request)
        directions.calculate { [weak self] response, error in
            guard let response = response else {
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                }
                return
            }
            
            let route = response.routes[0]
            let distanceInKilometers = route.distance / 1000
            let travelTimeInMinutes = route.expectedTravelTime / 60

            // Update the UI on the main thread
            DispatchQueue.main.async {
                self?.Estimated.text = "Estimated Travel Time: \(String(format: "%.2f", travelTimeInMinutes)) minutes"
                self?.kilometers.text = "Distance: \(String(format: "%.2f", distanceInKilometers)) kilometers"
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error.localizedDescription)")
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Location Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

