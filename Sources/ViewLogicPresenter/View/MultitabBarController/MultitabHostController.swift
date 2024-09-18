//
//  MultitabHostController.swift
//  IV
//
//  Created by IV on 01.01.2024.
//  Copyright © 2024 IV. All rights reserved.
//

import UIKit

final class MultitabHostController: FlowController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear

        if let hostedContent {
            finishInstall(childViewController: hostedContent)
        }
    }

    var hostedContent: UIViewController? {
        get {
            children.first
        }
        set {
            children.first?.uninstallFromParentViewController()
            
            if let newValue {
                installNonForcibly(childViewController: newValue)
            }
            applyChildForExternalPreferences(newValue)
        }
    }
}
