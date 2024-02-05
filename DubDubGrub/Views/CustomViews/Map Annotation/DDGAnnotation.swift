//
//  DDGAnnotation.swift
//  DubDubGrub
//
//  Created by Sylvain Druaux on 04/02/2024.
//

import SwiftUI

struct DDGAnnotation: View {
    var location: DDGLocation
    var number: Int

    var body: some View {
        VStack {
            ZStack {
                MapBalloon()
                    .frame(width: 100, height: 70)
                    .foregroundColor(.brandPrimary)

                Image(uiImage: location.squareImage)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(.circle)
                    .offset(y: -11)

                if number > 0 {
                    Text("\(min(number, 99))")
                        .font(.system(size: 11, weight: .bold))
                        .frame(width: 26, height: 18)
                        .background(Color.pink)
                        .foregroundColor(.white)
                        .clipShape(.capsule)
                        .offset(x: 20, y: -28)
                }
            }

            Text(location.name)
                .font(.caption)
                .fontWeight(.semibold)
        }
    }
}

#Preview {
    DDGAnnotation(location: DDGLocation(record: MockData.location), number: 44)
}
