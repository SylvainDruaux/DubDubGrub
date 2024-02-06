//
//  LocationDetailViewModel.swift
//  DubDubGrub
//
//  Created by Sylvain Druaux on 02/02/2024.
//

import CloudKit
import MapKit
import SwiftUI

enum CheckInStatus {
    case checkedIn, checkedOut
}

final class LocationDetailViewModel: ObservableObject {
    @Published var checkedInProfiles: [DDGProfile] = []
    @Published var isShowingProfileModal = false
    @Published var isShowingProfileSheet = false
    @Published var isCheckedIn = false
    @Published var isLoading = false
    @Published var alertItem: AlertItem?

    var location: DDGLocation
    var selectedProfile: DDGProfile?

    init(location: DDGLocation) {
        self.location = location
    }

    func getDirectionsToLocation() {
        let placemark = MKPlacemark(coordinate: location.location.coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = location.name

        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking])
    }

    func callLocation() {
        guard let url = URL(string: "tel://\(location.phoneNumber)") else {
            alertItem = AlertContext.invalidPhoneNumber
            return
        }
        UIApplication.shared.open(url)
    }

    func getCheckedInStatus() {
        guard let profileRecordID = CloudKitManager.shared.profileRecordID else { return }

        CloudKitManager.shared.fetchRecord(with: profileRecordID) { [self] result in
            DispatchQueue.main.async { [self] in
                switch result {
                case .success(let record):
                    if let reference = record["isCheckedIn"] as? CKRecord.Reference {
                        isCheckedIn = reference.recordID == location.id
                    } else {
                        isCheckedIn = false
                    }
                case .failure:
                    alertItem = AlertContext.unableToGetChecInStatus
                }
            }
        }
    }

    func updateCheckInStatus(to checkInStatus: CheckInStatus) {
        guard let profileRecordID = CloudKitManager.shared.profileRecordID else {
            alertItem = AlertContext.unableToGetProfile
            return
        }

        CloudKitManager.shared.fetchRecord(with: profileRecordID) { [self] result in
            switch result {
            case .success(let record):
                switch checkInStatus {
                case .checkedIn:
                    record[DDGProfile.kIsCheckedIn] = CKRecord.Reference(recordID: location.id, action: .none)
                    record[DDGProfile.kIsCheckedInNilCheck] = 1
                case .checkedOut:
                    record[DDGProfile.kIsCheckedIn] = nil
                    record[DDGProfile.kIsCheckedInNilCheck] = nil
                }

                CloudKitManager.shared.save(record: record) { result in
                    DispatchQueue.main.async { [self] in
                        switch result {
                        case .success(let record):
                            let profile = DDGProfile(record: record)
                            switch checkInStatus {
                            case .checkedIn:
                                checkedInProfiles.append(profile)
                            case .checkedOut:
                                checkedInProfiles.removeAll { $0.id == profile.id }
                            }

                            isCheckedIn = checkInStatus == .checkedIn
                        case .failure:
                            alertItem = AlertContext.unableToCheckInOrOut
                        }
                    }
                }
            case .failure:
                alertItem = AlertContext.unableToCheckInOrOut
            }
        }
    }

    func getCheckedInProfiles() {
        showLoadingView()
        CloudKitManager.shared.getCheckedInProfiles(for: location.id) { [self] result in
            DispatchQueue.main.async { [self] in
                switch result {
                case .success(let profiles):
                    checkedInProfiles = profiles
                case .failure:
                    alertItem = AlertContext.unableToGetCheckedInProfiles
                }
                hideLoadingView()
            }
        }
    }

    func show(profile: DDGProfile, in sizeCategory: ContentSizeCategory) {
        selectedProfile = profile
        if sizeCategory >= .accessibilityMedium {
            isShowingProfileSheet = true
        } else {
            isShowingProfileModal = true
        }
    }

    private func showLoadingView() { isLoading = true }
    private func hideLoadingView() { isLoading = false }
}
