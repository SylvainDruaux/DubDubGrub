//
//  ProfileViewModel.swift
//  DubDubGrub
//
//  Created by Sylvain Druaux on 01/02/2024.
//

import CloudKit

enum ProfileContext {
    case create, update
}

extension ProfileView {
    final class ProfileViewModel: ObservableObject {
        @Published var firstName = ""
        @Published var lastName = ""
        @Published var companyName = ""
        @Published var bio = ""
        @Published var avatar = PlaceholderImage.avatar
        @Published var isShowingPhotoPicker = false
        @Published var isLoading = false
        @Published var isCheckedIn = false
        @Published var alertItem: AlertItem?

        private var existingProfileRecord: CKRecord? {
            didSet { profileContext = .update }
        }

        var profileContext: ProfileContext = .create
        var buttonTitle: String { profileContext == .create ? "Create Profile" : "Update Profile" }
        var buttonAction: () { profileContext == .create ? createProfile() : updateProfile() }

        private var isValidProfile: Bool {
            guard !firstName.isEmpty,
                  !lastName.isEmpty,
                  !companyName.isEmpty,
                  !bio.isEmpty, bio.count <= 100,
                  avatar != PlaceholderImage.avatar else {
                return false
            }
            return true
        }

        func getCheckedInStatus() {
            guard let profileRecordID = CloudKitManager.shared.profileRecordID else { return }

            CloudKitManager.shared.fetchRecord(with: profileRecordID) { [self] result in
                DispatchQueue.main.async { [self] in
                    switch result {
                    case .success(let record):
                        if record["isCheckedIn"] as? CKRecord.Reference != nil {
                            isCheckedIn = true
                        } else {
                            isCheckedIn = false
                        }
                    case .failure:
                        break
                    }
                }
            }
        }

        func checkOut() {
            guard let profileID = CloudKitManager.shared.profileRecordID else {
                alertItem = AlertContext.unableToGetProfile
                return
            }

            showLoadingView()
            CloudKitManager.shared.fetchRecord(with: profileID) { result in
                switch result {
                case .success(let record):
                    record[DDGProfile.kIsCheckedIn] = nil
                    record[DDGProfile.kIsCheckedInNilCheck] = nil

                    CloudKitManager.shared.save(record: record) { [self] result in
                        hideLoadingView()
                        DispatchQueue.main.async { [self] in
                            switch result {
                            case .success:
                                HapticManager.playSuccess()
                                isCheckedIn = false
                            case .failure:
                                alertItem = AlertContext.unableToCheckInOrOut
                            }
                        }
                    }
                case .failure:
                    self.hideLoadingView()
                    DispatchQueue.main.async { self.alertItem = AlertContext.unableToCheckInOrOut }
                }
            }
        }

        private func createProfile() {
            guard isValidProfile else {
                alertItem = AlertContext.invalidProfile
                return
            }

            let profileRecord = createProfileRecord()
            guard let userRecord = CloudKitManager.shared.userRecord else {
                alertItem = AlertContext.noUserRecord
                return
            }

            userRecord["userProfile"] = CKRecord.Reference(recordID: profileRecord.recordID, action: .none)

            showLoadingView()
            CloudKitManager.shared.batchSave(records: [userRecord, profileRecord]) { result in
                DispatchQueue.main.async { [self] in
                    hideLoadingView()

                    switch result {
                    case .success(let records):
                        existingProfileRecord = records.first { $0.recordType == RecordType.profile }
                        CloudKitManager.shared.profileRecordID = existingProfileRecord?.recordID
                        alertItem = AlertContext.createProfileSuccess
                    case .failure:
                        alertItem = AlertContext.createProfileFailure
                    }
                }
            }
        }

        func getProfile() {
            guard let userRecord = CloudKitManager.shared.userRecord else {
                alertItem = AlertContext.noUserRecord
                return
            }

            guard let profileReference = userRecord["userProfile"] as? CKRecord.Reference else { return }

            let profileRecordID = profileReference.recordID

            showLoadingView()
            CloudKitManager.shared.fetchRecord(with: profileRecordID) { result in
                DispatchQueue.main.async { [self] in
                    hideLoadingView()
                    switch result {
                    case .success(let record):
                        existingProfileRecord = record

                        let profile = DDGProfile(record: record)
                        firstName = profile.firstName
                        lastName = profile.lastName
                        companyName = profile.companyName
                        bio = profile.bio
                        avatar = profile.avatarImage

                    case .failure:
                        alertItem = AlertContext.unableToGetProfile
                    }
                }
            }
        }

        private func updateProfile() {
            guard isValidProfile else {
                alertItem = AlertContext.invalidProfile
                return
            }

            guard let profileRecord = existingProfileRecord else {
                alertItem = AlertContext.unableToGetProfile
                return
            }

            profileRecord[DDGProfile.kFirstName] = firstName
            profileRecord[DDGProfile.kLastName] = lastName
            profileRecord[DDGProfile.kCompanyName] = companyName
            profileRecord[DDGProfile.kBio] = bio
            profileRecord[DDGProfile.kAvatar] = avatar.convertToCKAsset()

            showLoadingView()
            CloudKitManager.shared.save(record: profileRecord) { result in
                DispatchQueue.main.async { [self] in
                    hideLoadingView()
                    switch result {
                    case .success:
                        alertItem = AlertContext.updateProfileSuccess
                    case .failure:
                        alertItem = AlertContext.updateProfileFailure
                    }
                }
            }
        }

        private func createProfileRecord() -> CKRecord {
            let profileRecord = CKRecord(recordType: RecordType.profile)
            profileRecord[DDGProfile.kFirstName] = firstName
            profileRecord[DDGProfile.kLastName] = lastName
            profileRecord[DDGProfile.kCompanyName] = companyName
            profileRecord[DDGProfile.kBio] = bio
            profileRecord[DDGProfile.kAvatar] = avatar.convertToCKAsset()
            return profileRecord
        }

        private func showLoadingView() { isLoading = true }
        private func hideLoadingView() { isLoading = false }
    }
}
