//
//  LocationCell.swift
//  DubDubGrub
//
//  Created by Sylvain Druaux on 30/01/2024.
//

import SwiftUI

struct LocationCell: View {
    var location: DDGLocation
    var profiles: [DDGProfile]

    var body: some View {
        HStack {
            Image(uiImage: location.squareImage)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .clipShape(.circle)
                .padding(.vertical, 8)

            VStack(alignment: .leading) {
                Text(location.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)

                if profiles.isEmpty {
                    Text("Nobody's Checked In")
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                        .padding(.top, 2)
                } else {
                    HStack {
                        ForEach(profiles.indices, id: \.self) { index in
                            if showAvatar(at: index, count: profiles.count) {
                                AvatarView(image: profiles[index].avatarImage, size: 35)

                            } else if showAdditionalProfiles(at: index, count: profiles.count) {
                                AdditionalProfilesView(number: min(profiles.count - 4, 99))
                            }
                        }
                    }
                }
            }
            .padding(.leading)
        }
    }

    private func showAvatar(at index: Int, count: Int) -> Bool {
        index <= 3 || (index == 4 && count == 5)
    }

    private func showAdditionalProfiles(at index: Int, count: Int) -> Bool {
        index == 4 && count > 5
    }
}

#Preview {
    LocationCell(location: DDGLocation(record: MockData.location), profiles: [])
}

private struct AdditionalProfilesView: View {
    var number: Int

    var body: some View {
        Text("+\(number)")
            .font(.system(size: 14, weight: .semibold))
            .frame(width: 35, height: 35)
            .foregroundColor(.white)
            .background(Color.brandPrimary)
            .clipShape(.circle)
    }
}
