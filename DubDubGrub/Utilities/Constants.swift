//
//  Constants.swift
//  DubDubGrub
//
//  Created by Sylvain Druaux on 30/01/2024.
//

import UIKit

enum RecordType {
    static let location = "DDGLocation"
    static let profile = "DDGProfile"
}

enum PlaceholderImage {
    static let avatar = UIImage(resource: .defaultAvatar)
    static let banner = UIImage(resource: .defaultBannerAsset)
    static let square = UIImage(resource: .defaultSquareAsset)
}

enum ImageDimension {
    case square, banner

    static func getPlaceholder(for dimension: ImageDimension) -> UIImage {
        switch dimension {
        case .square:
            PlaceholderImage.square
        case .banner:
            PlaceholderImage.banner
        }
    }
}
