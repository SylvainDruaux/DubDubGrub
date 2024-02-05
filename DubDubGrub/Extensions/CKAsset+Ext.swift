//
//  CKAsset+Ext.swift
//  DubDubGrub
//
//  Created by Sylvain Druaux on 31/01/2024.
//

import CloudKit
import UIKit

extension CKAsset {
    func convertToUIImage(in dimension: ImageDimension) -> UIImage {
        let placeholder = ImageDimension.getPlaceholder(for: dimension)

        guard let fileUrl = fileURL else { return placeholder }

        do {
            let data = try Data(contentsOf: fileUrl)
            return UIImage(data: data) ?? placeholder
        } catch {
            return placeholder
        }
    }
}
