//
//  UIView+Pinning.swift
//
//  Created by IV on 01.12.2016.
//

import UIKit

// MARK: - ViewPinOption

enum ViewPinOption: Hashable {

    case edge
    case safeArea
    case margin
}

// MARK: - ViewPinOptions

struct ViewPinOptions: Hashable {

    var top: ViewPinOption = .edge
    var bottom: ViewPinOption = .edge
    var leading: ViewPinOption = .edge
    var trailing: ViewPinOption = .edge

    static let edges: Self = .init(top: .edge, bottom: .edge, leading: .edge, trailing: .edge)

    static let safeArea: Self = .init(top: .safeArea, bottom: .safeArea, leading: .safeArea, trailing: .safeArea)

    static let margins: Self = .init(top: .margin, bottom: .margin, leading: .margin, trailing: .margin)
}

// MARK: - Pin Option Modifiers

extension ViewPinOptions {

    func withTop(_ top: ViewPinOption) -> Self {

        guard top != self.top else {
            return self
        }

        var options = self
        options.top = top
        return options
    }

    func withBottom(_ bottom: ViewPinOption) -> Self {

        guard bottom != self.bottom else {
            return self
        }

        var options = self
        options.bottom = bottom
        return options
    }

    func withLeading(_ leading: ViewPinOption) -> Self {

        guard leading != self.leading else {
            return self
        }

        var options = self
        options.leading = leading
        return options
    }

    func withTrailing(_ trailing: ViewPinOption) -> Self {

        guard trailing != self.trailing else {
            return self
        }

        var options = self
        options.trailing = trailing
        return options
    }
}

// MARK: - ViewPinPriorities

struct ViewPinPriorities {

    var top: UILayoutPriority = .required
    var bottom: UILayoutPriority = .required
    var leading: UILayoutPriority = .required
    var trailing: UILayoutPriority = .required

    static let required: Self = .init(top: .required, bottom: .required, leading: .required, trailing: .required)

    static let defaultHigh: Self = .init(top: .defaultHigh, bottom: .defaultHigh, leading: .defaultHigh, trailing: .defaultHigh)

    static let defaultLow: Self = .init(top: .defaultLow, bottom: .defaultLow, leading: .defaultLow, trailing: .defaultLow)
}

// MARK: - Priority Modifiers

extension ViewPinPriorities {

    func withTop(_ top: UILayoutPriority) -> Self {

        guard top != self.top else {
            return self
        }

        var priorities = self
        priorities.top = top
        return priorities
    }

    func withBottom(_ bottom: UILayoutPriority) -> Self {

        guard bottom != self.bottom else {
            return self
        }

        var priorities = self
        priorities.bottom = bottom
        return priorities
    }

    func withLeading(_ leading: UILayoutPriority) -> Self {

        guard leading != self.leading else {
            return self
        }

        var priorities = self
        priorities.leading = leading
        return priorities
    }

    func withTrailing(_ trailing: UILayoutPriority) -> Self {

        guard trailing != self.trailing else {
            return self
        }

        var priorities = self
        priorities.trailing = trailing
        return priorities
    }
}

// MARK: - ViewPinResult

struct ViewPinResult {

    var top: NSLayoutConstraint
    var bottom: NSLayoutConstraint
    var leading: NSLayoutConstraint
    var trailing: NSLayoutConstraint

    func activate() {
        NSLayoutConstraint.activate([top, bottom, leading, trailing])
    }

    func deactivate() {
        NSLayoutConstraint.deactivate([top, bottom, leading, trailing])
    }
}

// MARK: - Pinning

extension UIView {

    @discardableResult
    func pinToSuperview(options: ViewPinOptions = .edges, insets: NSDirectionalEdgeInsets = .zero, priorities: ViewPinPriorities = .required, deferActivation: Bool = false) -> ViewPinResult {

        guard let superview = superview else {
            preconditionFailure("cannot setup constraints: the view \(self) is not part of the hierarchy")
        }

        return pinTo(view: superview, options: options, insets: insets, priorities: priorities, deferActivation: deferActivation)
    }

    @discardableResult
    func pinTo(view: UIView, options: ViewPinOptions = .edges, insets: NSDirectionalEdgeInsets = .zero, priorities: ViewPinPriorities = .required, deferActivation: Bool = false) -> ViewPinResult {

        var leading, trailing: NSLayoutXAxisAnchor!
        var top, bottom: NSLayoutYAxisAnchor!
        view.borderAnchors(options: options, leading: &leading, trailing: &trailing, top: &top, bottom: &bottom)

        let leadingConstraint = leadingAnchor.constraint(equalTo: leading, constant: insets.leading)
        leadingConstraint.priority = priorities.leading

        let trailingConstraint = trailingAnchor.constraint(equalTo: trailing, constant: -insets.trailing)
        trailingConstraint.priority = priorities.trailing

        let topConstraint = topAnchor.constraint(equalTo: top, constant: insets.top)
        topConstraint.priority = priorities.top

        let bottomConstraint = bottomAnchor.constraint(equalTo: bottom, constant: -insets.bottom)
        bottomConstraint.priority = priorities.bottom

        let result = ViewPinResult(top: topConstraint, bottom: bottomConstraint, leading: leadingConstraint, trailing: trailingConstraint)
        if !deferActivation {
            result.activate()
        }
        return result
    }

    // MARK: Implementation

    private func borderAnchors(options: ViewPinOptions,
                               leading: inout NSLayoutXAxisAnchor!,
                               trailing: inout NSLayoutXAxisAnchor!,
                               top: inout NSLayoutYAxisAnchor!,
                               bottom: inout NSLayoutYAxisAnchor!) {

        let leadingGuide = guide(forOption: options.leading)
        let trailingGuide = guide(forOption: options.trailing)
        let topGuide = guide(forOption: options.top)
        let bottomGuide = guide(forOption: options.bottom)

        leading = leadingGuide?.leadingAnchor ?? leadingAnchor
        trailing = trailingGuide?.trailingAnchor ?? trailingAnchor
        top = topGuide?.topAnchor ?? topAnchor
        bottom = bottomGuide?.bottomAnchor ?? bottomAnchor
    }

    private func guide(forOption option: ViewPinOption) -> UILayoutGuide? {

        let guide: UILayoutGuide?
        switch option {
        case .edge:
            guide = nil
        case .safeArea:
            guide = safeAreaLayoutGuide
        case .margin:
            guide = layoutMarginsGuide
        }
        return guide
    }
}
