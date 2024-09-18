//
//  TabDescriptor.swift
//  vitalitytoday
//
//  Created by Igor Vasilev on 01.09.2023.
//  Copyright © 2023 IV. All rights reserved.
//

import class UIKit.UIImage
import Foundation

// MARK: - TabDescriptor

struct TabDescriptor: Hashable, Identifiable {

    init(id: String, title: String, image: UIImage, selectedImage: UIImage) {
        self.id = id
        self.title = title
        self.image = image
        self.selectedImage = selectedImage
    }

    /**
     */
    let id: String

    /**
     String that is going to be used as `UITabBarItem` title
     */
    var title: String

    /**
     Image that is going to be used as `UITabBarItem` icon's 'normal' state
     */
    var image: UIImage

    /**
     Image that is going to be used as `UITabBarItem` icon's 'selected' state
     */
    var selectedImage: UIImage
}
