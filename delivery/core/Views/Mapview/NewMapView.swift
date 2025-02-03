
//
//  NewMapView.swift
//  PackageDeliverySwiftUI
//
//  Created by Baris OZGEN on 9.06.2023.
//

import SwiftUI
import _MapKit_SwiftUI
import Combine

struct NewMapView: View {
    @Bindable var vm : MapViewModel
    @State private var cameraProsition: MapCameraPosition = .camera(MapCamera(centerCoordinate: .locU, distance: 3729, heading: 92, pitch: 70))
    
    @State var selectedItem: MKMapItem? = nil
    @Binding var selectedPickupItem: MKMapItem?
    @Binding var selectedDropOffItem: MKMapItem?
    @Binding var selectedDriverItem: MKMapItem?
    
    @Binding var selectedStep : EDeliveryChoiceSteps
    
    @State private var colorMyPin: LinearGradient = LinearGradient(colors: [.red, .orange], startPoint: .top, endPoint: .center)
    
    @Binding var searchText: String
    private let searchTextPublisher = PassthroughSubject<String, Never>()
    
    @Binding var selectedVehicle : EVehicleType?
    
    func updateCameraPosition(focus centerCoordinate: CLLocationCoordinate2D,
                              distance:Double,
                              heading: Double,
                              pitch:Double){
        withAnimation(.spring()){
            cameraProsition = .camera(MapCamera(centerCoordinate: centerCoordinate, distance: distance, heading: heading, pitch: pitch))
        }
    }
    var body: some View {
        Map(position: $cameraProsition,
            interactionModes: .all,
            selection: $selectedItem){
            
            // show drivers locations
            if selectedStep == .request &&
                selectedPickupItem != nil  && selectedDriverItem == nil {
                ForEach(vm.searchResultsForDrivers, id: \.self){ result in
                    let driver = EVehicleType.allCases.shuffled().first!
                    Annotation(driver.title, coordinate: result.placemark.coordinate) {
                        ZStack {
                            Circle()
                                .fill(driver.iconColor)
                                .shadow(color: .black, radius: 2)
                            Image(systemName: driver.image)
                                .padding (7)
                                .foregroundStyle(.white)
                        }
                        
                    }
                    .annotationTitles(.automatic)
                }
            }
            else if let selectedDriverItem,
                    let selectedVehicle {
                Annotation(selectedVehicle.title, coordinate: selectedDriverItem.placemark.coordinate) {
                    ZStack {
                        Circle()
                            .fill(selectedVehicle.iconColor)
                            .shadow(color: .black, radius: 2)
                        Image(systemName: selectedVehicle.image)
                            .padding (7)
                            .foregroundStyle(.white)
                    }
                    
                }
                .annotationTitles(.automatic)
            }
            // draw route from driver to pick up
            if let route = vm.routeDriverToPickup {
                MapPolyline(route)
                    .stroke(LinearGradient.gradientWalk, style: .strokeWalk)
            }
            // draw route from pick up to drop off
            if let route = vm.routePickupToDropOff {
                MapPolyline(route)
                    .stroke(.orange, lineWidth: 5)
            }
            
            // find my location. Here is demo
            ForEach(vm.myLocation, id: \.self){ result in
                Annotation(selectedPickupItem == nil ? "You are here" : "Pickup Point", coordinate: result.placemark.coordinate) {
                    pickupView
                        .onAppear{
                            updateCameraPosition(focus: .locU, distance: 992, heading: 70, pitch: 60)
                        }
                }
                .annotationTitles(.automatic)
            }
            
            // show drop off locations
            if selectedStep == .dropoff || selectedStep == .request {
                // show search result on the map for drop off loc
                if selectedDropOffItem == nil {
                    ForEach(vm.searchResults, id: \.self){ result in
                        
                        Annotation(result.name ?? "drop off", coordinate: result.placemark.coordinate) {
                            dropOffView
                        }
                        .annotationTitles(.automatic)
                    }
                }
                // if drop off item is selected show only it
                else if let selectedDropOffItem {
                    Annotation(selectedDropOffItem.name ?? "drop off", coordinate: selectedDropOffItem.placemark.coordinate) {
                        dropOffView
                    }
                    .annotationTitles(.automatic)
                }
                
            }
        }
            .mapControls{
                //MapUserLocationButton()
                MapCompass()
                MapScaleView()
                
            }
            .mapStyle(.standard(elevation: .automatic))
            .onAppear{
                vm.searchMyLocation()
                vm.searchDriverLocations()
            }
            .onChange(of: selectedItem){
                guard let selectedItem else {return}
                if selectedStep == .pickup {
                    selectedPickupItem = selectedItem
                }
                if selectedStep == .dropoff {
                    selectedDropOffItem = selectedItem
                }
                if selectedStep == .dropoff,
                   let selectedPickupItem,
                   let selectedDropOffItem {
                    vm.getDirections(
                        from: selectedPickupItem,
                        to: selectedDropOffItem,
                        step: selectedStep)
                }
                if selectedStep == .request,
                   let selectedPickupItem,
                   let selectedDriverItem {
                    vm.getDirections(
                        from: selectedDriverItem,
                        to: selectedPickupItem,
                        step: .request)
                }
            }
            .onChange(of: vm.searchResultsForDrivers){
                updateCameraPosition(focus: .locU, distance: 1429, heading: 92, pitch: 70)
            }
            .onChange(of: vm.searchResults){
                updateCameraPosition(focus: .locU, distance: 4129, heading: 92, pitch: 70)
            }
            .onChange(of: selectedStep){
                withAnimation(.spring()){
                    switch selectedStep {
                    case .pickup:
                        updateCameraPosition(focus: .locU, distance: 992, heading: 70, pitch: 60)
                    case .package:
                        if let selectedDriverItem {
                            updateCameraPosition(focus: selectedDriverItem.placemark.coordinate, distance: 992, heading: 70, pitch: 60)
                        }else {
                            updateCameraPosition(focus: .locU, distance: 2729, heading: 92, pitch: 70)
                        }
                    case .dropoff:
                        if let selectedDropOffItem {
                            updateCameraPosition(focus: selectedDropOffItem.placemark.coordinate, distance: 992, heading: 70, pitch: 60)
                        }else {
                            updateCameraPosition(focus: .locU, distance: 992, heading: 70, pitch: 60)
                        }
                        
                    case .request:
                        updateCameraPosition(focus: .locU, distance: 3729, heading: 92, pitch: 70)
                    }
                }
            }
            .onChange(of: selectedDropOffItem){
                if let selectedDropOffItem {
                    updateCameraPosition(focus: selectedDropOffItem.placemark.coordinate, distance: 3429, heading: 92, pitch: 60)
                }
            }
            .onChange(of: selectedDriverItem){
                if let selectedPickupItem,
                   let selectedDriverItem {
                    vm.getDirections(
                        from: selectedDriverItem,
                        to: selectedPickupItem,
                        step: .request)
                }
            }
            .onChange(of: selectedVehicle){oldV, newV in
                if newV != nil {
                    Task.detached{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 6.29) {
                            let randomIndex = Int.random(in: 0..<4)
                            selectedDriverItem = vm.searchResultsForDrivers[randomIndex]
                        }
                    }
                }
            }
            .onChange(of: searchText) { oldT, newT in
                if selectedPickupItem != nil &&
                    selectedStep == .dropoff &&
                    newT.count > 3 {
                    searchTextPublisher.send(newT)
                }
            }
            .onReceive(
                searchTextPublisher
                    .debounce(for: .milliseconds(729), scheduler: DispatchQueue.main)
            ) { debouncedSearchText in
                if let selectedPickupItem {
                    selectedDropOffItem = nil
                    vm.searchLocations(for: debouncedSearchText, from: selectedPickupItem.placemark.coordinate)
                }
            }
    }
    
    private var pickupView: some View {
        Image("profil_photo_baris")
            .resizable()
            .scaledToFit()
            .frame(width: 48)
            .clipShape(Circle())
            .padding(4)
            .background(colorMyPin)
            .clipShape(Circle())
            .offset(y: -16)
            .overlay(alignment: .bottom) {
                Image(systemName: "triangle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(colorMyPin)
                    .frame(width: 24)
                    .scaleEffect(y: -1)
                
            }
    }
    private var dropOffView: some View {
        Text("Drop\nOff")
            .foregroundStyle(.white)
            .font(.subheadline)
            .bold()
            .multilineTextAlignment(.center)
            .padding(7)
            .background(.black)
            .clipShape(Circle())
            .padding(4)
            .background(colorMyPin)
            .clipShape(Circle())
            .offset(y: -14)
            .overlay(alignment: .bottom) {
                Image(systemName: "triangle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(colorMyPin)
                    .frame(width: 24)
                    .scaleEffect(y: -1)
                
            }
    }
}

#Preview {
    NewMapView(vm: MapViewModel(),
               selectedPickupItem: .constant(nil),
               selectedDropOffItem:.constant(nil),
               selectedDriverItem: .constant(nil),
               selectedStep: .constant(.pickup),
               searchText: .constant(""),
               selectedVehicle: .constant(nil))
}
