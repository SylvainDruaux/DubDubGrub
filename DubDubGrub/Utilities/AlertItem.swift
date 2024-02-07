//
//  AlertItem.swift
//  DubDubGrub
//
//  Created by Sylvain Druaux on 30/01/2024.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: Text
    let message: Text
    let dismissButton: Alert.Button

    var alert: Alert {
        Alert(title: title, message: message, dismissButton: dismissButton)
    }
}

enum AlertContext {
    // MARK: - MapView Errors

    static let unableToGetLocations = AlertItem(
        title: Text("Location Error"),
        message: Text("""
        Unable to retrieve locations at this time.
        Please try again.
        """),
        dismissButton: .default(Text("Ok"))
    )

    static let locationRestricted = AlertItem(
        title: Text("Location Restricted"),
        message: Text("Your location is restricted. This may be due to parental control."),
        dismissButton: .default(Text("Ok"))
    )

    static let locationDenied = AlertItem(
        title: Text("Location Denied"),
        message: Text("""
        Dub Dub Grub does not have permission to access your location.
        To change that, go to your phone's Settings > Dub Dub Grub > Location
        """),
        dismissButton: .default(Text("Ok"))
    )

    static let locationDisabled = AlertItem(
        title: Text("Location Services Disable"),
        message: Text("""
        Your phone's location services are disabled.
        To change that, go to your phone's Settings > Privacy > Location Services
        """),
        dismissButton: .default(Text("Ok"))
    )

    static let checkedInCount = AlertItem(
        title: Text("Server Error"),
        message: Text("""
        Unable to get the number of people checked into each loaction.
        Please check your internet connection and try again.
        """),
        dismissButton: .default(Text("Ok"))
    )

    // MARK: - LocationListView Errors

    static let unableToGetAllCheckedInProfiles = AlertItem(
        title: Text("Unable to Get Profiles"),
        message: Text("""
        Unable to retrieve checked in profiles to all locations.
        Please try again.
        """),
        dismissButton: .default(Text("Ok"))
    )

    // MARK: - ProfileView Errors

    static let invalidProfile = AlertItem(
        title: Text("Invalid Profile"),
        message: Text("""
        All fields are required as well as a profile photo. Your bio must be < 100 characters.
        Please try again.
        """),
        dismissButton: .default(Text("Ok"))
    )

    static let noUserRecord = AlertItem(
        title: Text("No User Record"),
        message: Text("""
        You must log into iCloud on your phone in order to utilize Dub Dub Grub's Profile.
        Please log in on your phone's settings screen.
        """),
        dismissButton: .default(Text("Ok"))
    )

    static let createProfileSuccess = AlertItem(
        title: Text("Profile Created Successfully"),
        message: Text("Your profile has succesfully been created."),
        dismissButton: .default(Text("Ok"))
    )

    static let createProfileFailure = AlertItem(
        title: Text("Failed to Create Profile"),
        message: Text("""
        We were unable to create created your profile at this time.
        Please try again later or contact customer support if this persists.
        """),
        dismissButton: .default(Text("Ok"))
    )

    static let unableToGetProfile = AlertItem(
        title: Text("Unable to Retrieve Profile"),
        message: Text("""
        We were unable to retrieve your profile at this time.
        Please check your internet connection and try again later or contact customer support if this persists.
        """),
        dismissButton: .default(Text("Ok"))
    )

    static let updateProfileSuccess = AlertItem(
        title: Text("Profile Updated Successfully"),
        message: Text("Your profile has succesfully been updated."),
        dismissButton: .default(Text("Sweet!"))
    )

    static let updateProfileFailure = AlertItem(
        title: Text("Profile Updated Failed"),
        message: Text("""
        We were unable to update your profile at this time.
        Please try again later.
        """),
        dismissButton: .default(Text("Ok"))
    )

    // MARK: - LocationDetailView Errors

    static let invalidPhoneNumber = AlertItem(
        title: Text("Invalid Phone Number"),
        message: Text("""
        The phone number for the location is invalid.
        Please look up the phone number yourself.
        """),
        dismissButton: .default(Text("Ok"))
    )

    static let unableToGetChecInStatus = AlertItem(
        title: Text("Server Error"),
        message: Text("""
        Unable to retrieve checked status of the current user.
        Please try again.
        """),
        dismissButton: .default(Text("Ok"))
    )

    static let unableToCheckInOrOut = AlertItem(
        title: Text("Server Error"),
        message: Text("""
        Unable to check in/out at this time.
        Please try again.
        """),
        dismissButton: .default(Text("Ok"))
    )

    static let unableToGetCheckedInProfiles = AlertItem(
        title: Text("Server Error"),
        message: Text("""
        Unable to get users checked into this location at this time.
        Please try again.
        """),
        dismissButton: .default(Text("Ok"))
    )
}
