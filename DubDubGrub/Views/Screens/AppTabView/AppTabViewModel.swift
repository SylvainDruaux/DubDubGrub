//
//  AppTabViewModel.swift
//  DubDubGrub
//
//  Created by Sylvain Druaux on 04/02/2024.
//

import CoreLocation
import Foundation

final class AppTabViewModel: NSObject, ObservableObject {
    @Published var isShowingOnboardView = false
    @Published var alertItem: AlertItem?

    var deviceLocationManager: CLLocationManager?
    let kHasSeenOnboardView = "hasSeenOnboardView"

    var hasSeenOnboardView: Bool {
        UserDefaults.standard.bool(forKey: kHasSeenOnboardView)
    }

    func runStartupChecks() {
        if !hasSeenOnboardView {
            isShowingOnboardView = true
            UserDefaults.standard.setValue(true, forKey: kHasSeenOnboardView)
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

extension AppTabViewModel: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
