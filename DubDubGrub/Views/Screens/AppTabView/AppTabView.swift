//
//  AppTabView.swift
//  DubDubGrub
//
//  Created by Sylvain Druaux on 29/01/2024.
//

import SwiftUI

struct AppTabView: View {
    @StateObject private var viewModel = AppTabViewModel()

    var body: some View {
        TabView {
            LocationMapView()
                .tabItem { Label("Map", systemImage: "map") }

            LocationListView()
                .tabItem { Label("Locations", systemImage: "building") }

            NavigationView {
                ProfileView()
            }
            .tabItem { Label("Profile", systemImage: "person") }
        }
        .onAppear {
            CloudKitManager.shared.getUserRecord()
            viewModel.runStartupChecks()
        }
        .accentColor(.brandPrimary)
        .sheet(isPresented: $viewModel.isShowingOnboardView, onDismiss: viewModel.checkIfLocationServicesEnabled) {
            OnboardView()
        }
    }
}

#Preview {
    AppTabView()
}
