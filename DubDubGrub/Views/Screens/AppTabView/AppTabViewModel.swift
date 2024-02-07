//
//  AppTabViewModel.swift
//  DubDubGrub
//
//  Created by Sylvain Druaux on 04/02/2024.
//

import CoreLocation
import SwiftUI

extension AppTabView {
    final class AppTabViewModel: NSObject, ObservableObject {
        @Published var isShowingOnboardView = false
        @Published var alertItem: AlertItem?
        @AppStorage("hasSeenOnboardView") var hasSeenOnboardView = false {
            didSet { isShowingOnboardView = hasSeenOnboardView }
        }

        var deviceLocationManager: CLLocationManager?
        let kHasSeenOnboardView = "hasSeenOnboardView"

        func runStartupChecks() {
            if !hasSeenOnboardView {
                hasSeenOnboardView = true
            } else {
                checkIfLocationServicesEnabled()
            }
        }

        func checkIfLocationServicesEnabled() {
            if CLLocationManager.locationServicesEnabled() {
                deviceLocationManager = CLLocationManager()
                deviceLocationManager?.delegate = self
            } else {
                alertItem = AlertContext.locationDisabled
            }
        }

        private func checkLocationAuthorization() {
            guard let deviceLocationManager else { return }
            switch deviceLocationManager.authorizationStatus {
            case .notDetermined:
                deviceLocationManager.requestWhenInUseAuthorization()
            case .restricted:
                alertItem = AlertContext.locationRestricted
            case .denied:
                alertItem = AlertContext.locationDenied
            case .authorizedAlways, .authorizedWhenInUse:
                break
            @unknown default:
                break
            }
        }
    }
}

extension AppTabView.AppTabViewModel: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
