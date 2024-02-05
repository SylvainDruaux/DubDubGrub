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
                .frame(width: 80)
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
                            if index <= 3 {
                                AvatarView(image: profiles[index].avatarImage, size: 35)
                            } else if index == 4 {
                                AdditionalProfilesView(number: profiles.count - 4)
                            }
                        }
                    }
                }
            }
            .padding(.leading)
        }
    }
}

#Preview {
    LocationCell(location: DDGLocation(record: MockData.location), profiles: [])
}

struct AdditionalProfilesView: View {
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