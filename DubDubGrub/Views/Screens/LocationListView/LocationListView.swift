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

    var body: some View {
        NavigationView {
            List {
                ForEach(locationManager.locations) { location in
                    NavigationLink(destination: LocationDetailView(viewModel: LocationDetailViewModel(location: location))) {
                        LocationCell(
                            location: location,
                            profiles: viewModel.checkedInProfiles[location.id, default: []]
                        )
                    }
                }
            }
            .onAppear { viewModel.getCheckedInProfilesDictionary() }
            .navigationTitle("Grub Spots")
        }
    }
}

#Preview {
    LocationListView()
        .environmentObject(LocationManager())
}
