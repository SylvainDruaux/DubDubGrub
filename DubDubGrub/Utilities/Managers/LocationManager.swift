//
//  LocationManager.swift
//  DubDubGrub
//
//  Created by Sylvain Druaux on 30/01/2024.
//

import Foundation

final class LocationManager: ObservableObject {
    @Published var locations: [DDGLocation] = []
    var selectedLocation: DDGLocation?
}
