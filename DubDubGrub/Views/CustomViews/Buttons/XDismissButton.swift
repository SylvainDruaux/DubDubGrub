//
//  XDismissButton.swift
//  DubDubGrub
//
//  Created by Sylvain Druaux on 31/01/2024.
//

import SwiftUI

struct XDismissButton: View {
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 30)
                .foregroundColor(.brandPrimary)

            Image(systemName: "xmark")
                .foregroundColor(.white)
                .imageScale(.small)
                .frame(width: 44, height: 44)
        }
    }
}

#Preview {
    XDismissButton()
}
