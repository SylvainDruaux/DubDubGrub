//
//  CustomModifiers.swift
//  DubDubGrub
//
//  Created by Sylvain Druaux on 30/01/2024.
//

import SwiftUI

struct ProfileNameText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 32, weight: .bold))
            .lineLimit(1)
            .minimumScaleFactor(0.75)
            .disableAutocorrection(true)
    }
}
