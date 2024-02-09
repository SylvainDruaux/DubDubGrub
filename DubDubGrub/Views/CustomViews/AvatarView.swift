//
//  AvatarView.swift
//  DubDubGrub
//
//  Created by Sylvain Druaux on 30/01/2024.
//

import SwiftUI

struct AvatarView: View {
    var image: UIImage
    var size: CGFloat

    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .clipShape(.circle)
    }
}

#Preview {
    AvatarView(image: PlaceholderImage.avatar, size: 90)
}
