//
//  DDGButton.swift
//  DubDubGrub
//
//  Created by Sylvain Druaux on 30/01/2024.
//

import SwiftUI

struct DDGButton: View {
    var title: String
    var color: Color = .brandPrimary

    var body: some View {
        Text(title)
            .bold()
            .frame(width: 280, height: 44)
            .foregroundColor(.white)
            .background(color)
            .cornerRadius(8)
    }
}

#Preview {
    DDGButton(title: "Create Profile")
}
