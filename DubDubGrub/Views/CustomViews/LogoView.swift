//
//  LogoView.swift
//  DubDubGrub
//
//  Created by Sylvain Druaux on 31/01/2024.
//

import SwiftUI

struct LogoView: View {
    var frameWidth: CGFloat

    var body: some View {
        Image(.ddgMapLogo)
            .resizable()
            .scaledToFit()
            .frame(width: frameWidth)
    }
}

#Preview {
    LogoView(frameWidth: 100)
}
