
//
//  MapViewModel.swift
//  PackageDeliverySwiftUI
//
//
//
@preconcurrency import MapKit
import Observation
import SwiftUI

@Observable class MapViewModel/*:ObservedObject*/ {
     var routePickupToDropOff: MKRoute? = MKRoute()
    var routeDriverToPickup: MKRoute? = MKRoute()

   var routePolyline: MKPolyline? = MKPolyline()
  var lookAroundScene: MKLookAroundScene? = nil
 var searchResultsForDrivers: [MKMapItem] = []
    var searchResults: [MKMapItem] = []
    var myLocation: [MKMapItem] = []

    func getDirectionsPolyLine(selectedItem : MKMapItem) {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: .locU))
        request.destination = selectedItem
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            if let route = response?.routes.first, error == nil {
                DispatchQueue.main.async { [weak self] in
                    self?.routePolyline = route.polyline
                }
            }
        }
    }
    func getDirections(from pickup: MKMapItem, to dropOff : MKMapItem, step selectedStep : EDeliveryChoiceSteps) {
        if selectedStep == .dropoff {routePickupToDropOff = nil}
        else if selectedStep == .request {routeDriverToPickup = nil}
        else {return}
        
        let request = MKDirections.Request()
        request.source = pickup
        request.destination = dropOff
        request.transportType = .automobile
        
        Task.detached {
            let directions = MKDirections(request: request)
            do {
                let response = try await directions.calculate()
                DispatchQueue.main.async { [weak self] in
                    if selectedStep == .dropoff {
                        self?.routePickupToDropOff = response.routes.first
                    }else {
                        self?.routeDriverToPickup = response.routes.first
                    }
                }
            } catch {
                
                print("Error: \(error)")
            }
        }
    }
    
    func getLookAroundScene(selectedItem : MKMapItem) {
        lookAroundScene = nil
        Task.detached {
            let request = MKLookAroundSceneRequest(mapItem: selectedItem)
            do {
                let scene = try await request.scene
                DispatchQueue.main.async { [weak self] in
                    self?.lookAroundScene = scene
                }
            } catch {
                
                print("Error: \(error)")
            }
        }
    }
  
    func searchDriverLocations() {
        let request = MKLocalSearch.Request ()
        request.naturalLanguageQuery = "coffee"
        request.resultTypes = .pointOfInterest
        request.region = MKCoordinateRegion(
            center: .locU,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        Task.detached {
            let search = MKLocalSearch(request: request)
            let response = try? await search.start()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.92) { [weak self] in
                self?.searchResultsForDrivers = response?.mapItems ?? []
            }
        }
    }
    
    func searchLocations(for query: String, from location: CLLocationCoordinate2D) {
        let request = MKLocalSearch.Request ()
        request.naturalLanguageQuery = query
        request.resultTypes = .pointOfInterest 
        request.region = MKCoordinateRegion(
            center: location,
            span: MKCoordinateSpan(latitudeDelta: 0.0092, longitudeDelta: 0.0092))
        Task.detached {
            let search = MKLocalSearch(request: request)
            let response = try? await search.start()
            DispatchQueue.main.async { [weak self] in
                self?.searchResults = response?.mapItems ?? []
            }
        }
    }
   
    func searchMyLocation() {
        let request = MKLocalSearch.Request ()
        request.naturalLanguageQuery = "coffee fellows"
        request.resultTypes = .pointOfInterest
        request.region = MKCoordinateRegion(
            center: .locU,
            span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002))
        Task.detached {
            let search = MKLocalSearch(request: request)
            let response = try? await search.start()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.29) { [weak self] in
                if let mapItems = response?.mapItems{
                    self?.myLocation = [mapItems[0]]
                    CLLocationCoordinate2D.locU = mapItems[0].placemark.coordinate
                }
            }
        }
    }
}
