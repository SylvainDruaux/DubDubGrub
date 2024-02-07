//
//  LocationListView.swift
//  DubDubGrub
//
//  Created by Sylvain Druaux on 29/01/2024.
//

import SwiftUI

struct LocationListView: View {
    @EnvironmentObject private var locationManager: LocationManager
    @StateObject private var viewModel = LocationListViewModel()
    @Environment(\.sizeCategory) var sizeCategory

    var body: some View {
        NavigationView {
            List {
                ForEach(locationManager.locations) { location in
                    NavigationLink(destination: viewModel.createLocationDetailView(for: location, in: sizeCategory)) {
                        LocationCell(
                            location: location,
                            profiles: viewModel.checkedInProfiles[location.id, default: []]
                        )
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel(viewModel.createVoiceOverSummary(for: location))
                    }
                }
            }
            .navigationTitle("Grub Spots")
            .onAppear { viewModel.getCheckedInProfilesDictionary() }
            .alert(item: $viewModel.alertItem) { $0.alert }
        }
    }
}

#Preview {
    LocationListView()
        .environmentObject(LocationManager())
}
