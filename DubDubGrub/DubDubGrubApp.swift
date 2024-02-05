//
//  DubDubGrubApp.swift
//  DubDubGrub
//
//  Created by Sylvain Druaux on 29/01/2024.
//

import SwiftUI

@main
struct DubDubGrubApp: App {
    let locationManager = LocationManager()

    var body: some Scene {
        WindowGroup {
            AppTabView().environmentObject(locationManager)
        }
    }
}
