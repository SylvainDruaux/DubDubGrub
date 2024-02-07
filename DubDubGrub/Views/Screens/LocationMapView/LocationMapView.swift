//
//  LocationMapView.swift
//  DubDubGrub
//
//  Created by Sylvain Druaux on 29/01/2024.
//

import MapKit
import SwiftUI

struct LocationMapView: View {
    @EnvironmentObject private var locationManager: LocationManager
    @StateObject var viewModel = LocationMapViewModel()
    @Environment(\.sizeCategory) var sizeCategory

    var body: some View {
        ZStack(alignment: .top) {
            Map(coordinateRegion: $viewModel.region, showsUserLocation: true, annotationItems: locationManager.locations) { location in
                MapAnnotation(coordinate: location.location.coordinate, anchorPoint: CGPoint(x: 0.5, y: 1)) {
                    DDGAnnotation(location: location, number: viewModel.checkedInProfiles[location.id] ?? 0)
                        .accessibilityLabel(viewModel.createVoiceOverSummary(for: location))
                        .onTapGesture {
                            locationManager.selectedLocation = location
                            viewModel.isShowingDetailView = true
                        }
                }
            }
            .accentColor(.pink)
            .ignoresSafeArea()

            LogoView(frameWidth: 125)
                .shadow(radius: 10)
                .accessibilityHidden(true)
        }
        .sheet(isPresented: $viewModel.isShowingDetailView) {
            if let selectedLocation = locationManager.selectedLocation {
                NavigationView {
                    viewModel.createLocationDetailView(for: selectedLocation, in: sizeCategory)
                        .toolbar {
                            Button("Dismiss") { viewModel.isShowingDetailView = false }
                        }
                }
                .accentColor(.brandPrimary)
            } else {
                // Create some empty state (unable to retrieve the location)
                EmptyView()
            }
        }
        .alert(item: $viewModel.alertItem) { $0.alert }
        .onAppear {
            if locationManager.locations.isEmpty { viewModel.getLocations(for: locationManager) }
            viewModel.getCheckedInCounts()
        }
    }
}

#Preview {
    LocationMapView()
        .environmentObject(LocationManager())
}
