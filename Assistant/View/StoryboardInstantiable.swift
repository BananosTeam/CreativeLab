//
//  StoryboardInstantiable.swift
//  Assistant
//
//  Created by Bananos on 5/14/16.
//  Copyright © 2016 Bananos. All rights reserved.
//

import UIKit

protocol StoryboardInstantiable {
    static var ControllerIdentifier: String { get }
    static var StoryboardName: String { get }
    static func instantiateFromStoryboard(configurator: ((controller: Self) -> Self)?) -> Self?
}

extension StoryboardInstantiable {
    static var StoryboardName: String { return "Main" }
    static func instantiateFromStoryboard(configurator: ((controller: Self) -> Self)? = nil) -> Self? {
        let storyboard = UIStoryboard(name: StoryboardName, bundle: nil)
        guard let controller = storyboard.instantiateViewControllerWithIdentifier(ControllerIdentifier) as? Self else {
            return nil
        }
        return configurator?(controller: controller) ?? controller
    }
}