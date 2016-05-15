//
//  NavigatoinController.swift
//  Assistant
//
//  Created by Bananos on 5/15/16.
//  Copyright © 2016 Bananos. All rights reserved.
//

import UIKit

final class NavigationController: ENSideMenuNavigationController, StoryboardInstantiable {
    static let ControllerIdentifier = "NavigationController"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSideMenu()
    }
    
    private func setupSideMenu() {
        let menuViewController = SideMenuViewController.instantiateFromStoryboard()!
        sideMenu = ENSideMenu(sourceView: view, menuViewController: menuViewController, menuPosition: .Left)
        sideMenu?.menuWidth = 240.0
        sideMenu?.delegate = menuViewController
        view.bringSubviewToFront(navigationBar)
    }
}
