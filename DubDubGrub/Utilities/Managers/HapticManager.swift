//
//  HapticManager.swift
//  DubDubGrub
//
//  Created by Sylvain Druaux on 07/02/2024.
//

import UIKit

enum HapticManager {
    static func playSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}
