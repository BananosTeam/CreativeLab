//
//  AppDelegate.swift
//  Assistant
//
//  Created by Bananos on 5/14/16.
//  Copyright © 2016 Bananos. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    var sharedDelegate: AppDelegate? {
        return UIApplication.sharedApplication().delegate as? AppDelegate
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        TrelloDataHandler.shared.loadData()
        if let token = Trello.shared.getToken() {
            let trelloRequester = TrelloRequester()
            trelloRequester.getCardsForMemberId("5736fea69bc9bb59fdee87a3") {
                print($0)
            }
        }
        
        if SlackClient.Token == nil {
            SlackClient.Authenticate()
        } else {
            SlackClient.currentClient = SlackClient()
            SlackClient.currentClient?.start()
            window?.rootViewController = NavigationController.instantiateFromStoryboard()
        }
        return true
    }
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        guard let components = NSURLComponents(URL: url, resolvingAgainstBaseURL: false),
            queries = components.queryItems else { return false }
        if !(queries.filter { $0.name == "code" }).isEmpty {
            SlackClient.ContinueAuthentication(url) { isAuthenticated in
                guard isAuthenticated else { return }
                SlackClient.currentClient = SlackClient()
                SlackClient.currentClient?.start()
                self.window?.rootViewController = NavigationController.instantiateFromStoryboard()
            }
            return true
        } else {
            Trello.shared.handleCallbackUrlWithQueryItems(queries)
            return true
        }
        return true
    }
    
}

