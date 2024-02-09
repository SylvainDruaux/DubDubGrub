//
//  ProfileModalView.swift
//  DubDubGrub
//
//  Created by Sylvain Druaux on 03/02/2024.
//

import SwiftUI

struct ProfileModalView: View {
    @Binding var isShowingProfileModal: Bool
    var profile: DDGProfile

    var body: some View {
        ZStack {
            VStack {
                Spacer().frame(height: 60)

                Text(profile.firstName + " " + profile.lastName)
                    .bold().font(.title2)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)

                Text(profile.companyName)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                    .foregroundColor(.secondary)
                    .accessibilityLabel("Works at \(profile.companyName)")

                Text(profile.bio)
                    .lineLimit(3)
                    .minimumScaleFactor(0.75)
                    .padding(.vertical)
                    .accessibilityLabel("Bio, \(profile.bio)")
            }
            .padding()
            .frame(width: 300, height: 230)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(16)
            .overlay(alignment: .topTrailing) {
                Button {
                    withAnimation { isShowingProfileModal = false }
                } label: {
                    XDismissButton()
                }
            }

            AvatarView(image: profile.avatarImage, size: 110)
                .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 6)
                .offset(y: -120)
                .accessibilityHidden(true)
        }
        .accessibilityAddTraits(.isModal)
        .transition(.opacity.combined(with: .slide))
        .zIndex(2)
    }
}

#Preview {
    ProfileModalView(isShowingProfileModal: .constant(false), profile: DDGProfile(record: MockData.profile))
}
