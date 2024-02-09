//
//  ProfileSheetView.swift
//  DubDubGrub
//
//  Created by Sylvain Druaux on 06/02/2024.
//

import SwiftUI

// Alternative Profile Modal View for larger dynamic type sizes
// Presented as a sheet instead of a small pop up

struct ProfileSheetView: View {
    var profile: DDGProfile

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                AvatarView(image: profile.avatarImage, size: 110)
                    .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 6)
                    .accessibilityHidden(true)

                Text(profile.firstName + " " + profile.lastName)
                    .bold().font(.title2)
                    .minimumScaleFactor(0.9)

                Text(profile.companyName)
                    .fontWeight(.semibold)
                    .minimumScaleFactor(0.9)
                    .foregroundColor(.secondary)
                    .accessibilityLabel("Works at \(profile.companyName)")

                Text(profile.bio)
                    .minimumScaleFactor(0.9)
                    .accessibilityLabel("Bio, \(profile.bio)")
            }
            .padding()
        }
    }
}

#Preview {
    ProfileSheetView(profile: DDGProfile(record: MockData.profile))
        .environment(\.dynamicTypeSize, .accessibility5)
}
