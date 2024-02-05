//
//  MockData.swift
//  DubDubGrub
//
//  Created by Sylvain Druaux on 30/01/2024.
//

import CloudKit

enum MockData {
    static var location: CKRecord {
        let record = CKRecord(recordType: RecordType.location)
        record[DDGLocation.kName] = "Sean's Bar and Grill"
        record[DDGLocation.kAddress] = "123 Main Street"
        record[DDGLocation.kDescription] = "This is a test description. Isn't it answome? Not sure how long too make it to test the 3 lines."
        record[DDGLocation.kWebsiteURL] = "https://seanallen.co"
        record[DDGLocation.kLocation] = CLLocation(latitude: 37.331516, longitude: -121.891054)
        record[DDGLocation.kPhoneNumber] = "111-111-1111"

        return record
    }

    static var profile: CKRecord {
        let record = CKRecord(recordType: RecordType.profile)
        record[DDGProfile.kFirstName] = "Sarah"
        record[DDGProfile.kLastName] = "Connor"
        record[DDGProfile.kCompanyName] = "Skynet"
        record[DDGProfile.kBio] = "I betrayed them all and here is my army of Terminators. You can run and hide, they will find you anyway."

        return record
    }
}
