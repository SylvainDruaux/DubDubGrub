//
//  View+Ext.swift
//  DubDubGrub
//
//  Created by Sylvain Druaux on 30/01/2024.
//

import SwiftUI

extension View {
    func profileNameStyle() -> some View {
        modifier(ProfileNameText())
    }

    func embedInScrollView() -> some View {
        GeometryReader { geometry in
            ScrollView {
                self.frame(minHeight: geometry.size.height, maxHeight: .infinity)
            }
        }
    }

    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    func determineColumns(for sizeCategory: ContentSizeCategory) -> [GridItem] {
        let numberOfColumns = sizeCategory >= .accessibilityMedium ? 1 : 3
        return Array(repeating: GridItem(.flexible()), count: numberOfColumns)
    }
}
