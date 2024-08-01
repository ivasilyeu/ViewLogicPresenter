//
//  UINavigationItem+Copy.swift
//
//  Created by IV on 01.12.2016.
//

import UIKit

// MARK: - UINavigationItem

extension UINavigationItem {

    /**
     Updates the receiver with the properties of the ``navigationBar``.

     - Parameter applyHandlers: ``true`` to copy references to the bar's button items, ``false`` to leave them unchanged
     */
    func update(with navigationItem: UINavigationItem, applyHandlers: Bool) {
        
        title = navigationItem.title
        titleView = navigationItem.titleView
        prompt = navigationItem.prompt
        backBarButtonItem = navigationItem.backBarButtonItem
        backButtonTitle = navigationItem.backButtonTitle
        hidesBackButton = navigationItem.hidesBackButton
        leftItemsSupplementBackButton = navigationItem.leftItemsSupplementBackButton

        if applyHandlers {
            leftBarButtonItems = navigationItem.leftBarButtonItems
            rightBarButtonItems = navigationItem.rightBarButtonItems
            leftBarButtonItem = navigationItem.leftBarButtonItem
            rightBarButtonItem = navigationItem.rightBarButtonItem
        }

        largeTitleDisplayMode = navigationItem.largeTitleDisplayMode
        searchController = navigationItem.searchController
        hidesSearchBarWhenScrolling = navigationItem.hidesSearchBarWhenScrolling
        if #available(iOS 14.0, *) {
            backButtonDisplayMode = navigationItem.backButtonDisplayMode
        }
        standardAppearance = navigationItem.standardAppearance
        compactAppearance = navigationItem.compactAppearance
        scrollEdgeAppearance = navigationItem.scrollEdgeAppearance

        if #available(iOS 15, *) {
            compactScrollEdgeAppearance = navigationItem.compactScrollEdgeAppearance
        }
    }
}
