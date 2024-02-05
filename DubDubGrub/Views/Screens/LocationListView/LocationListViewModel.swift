//
//  LocationListViewModel.swift
//  DubDubGrub
//
//  Created by Sylvain Druaux on 04/02/2024.
//

import CloudKit
import Foundation

final class LocationListViewModel: ObservableObject {
    @Published var checkedInProfiles: [CKRecord.ID: [DDGProfile]] = [:]

    func getCheckedInProfilesDictionary() {
        CloudKitManager.shared.getCheckedInProfilesDictionary { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let checkedInProfiles):
                    self.checkedInProfiles = checkedInProfiles
                case .failure:
                    print("Error getting back dictionary")
                }
            }
        }
    }
}
