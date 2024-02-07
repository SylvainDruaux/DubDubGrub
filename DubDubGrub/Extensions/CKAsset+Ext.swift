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
        guard let fileUrl = fileURL else { return dimension.placeholder }

        do {
            let data = try Data(contentsOf: fileUrl)
            return UIImage(data: data) ?? dimension.placeholder
        } catch {
            return dimension.placeholder
        }
    }
}
