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

    static var chipotle: CKRecord {
        let record = CKRecord(
            recordType: RecordType.location,
            recordID: CKRecord.ID(recordName: "BD731330-6FAF-A3DE-2592-677F9A62BBCA")
        )
        record[DDGLocation.kName] = "Chipotle"
        record[DDGLocation.kAddress] = "1 S Market St Ste 40"
        record[DDGLocation.kDescription] = """
        Our local San Jose One South Market Chipotle Mexican Grill is cultivating 
        a better world by serving responsibly sourced, classically-cooked, real food.
        """
        record[DDGLocation.kWebsiteURL] = "https://locations.chipotle.com/ca/san-jose/1-s-market-st"
        record[DDGLocation.kLocation] = CLLocation(latitude: 37.334967, longitude: -121.892566)
        record[DDGLocation.kPhoneNumber] = "408-938-0919"

        return record
    }
}
