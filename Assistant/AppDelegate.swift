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
    
    var slackClient: SlackClient? {
        get {
            return self.slackClient
        } set {
            if let value = newValue {
                messagesViewController?.client = value
            }
        }
    }
    
    var messagesViewController: MessagesViewController? {
        return self.window?.rootViewController?.childViewControllers.first as? MessagesViewController
    }

    var sharedDelegate: AppDelegate? {
        return UIApplication.sharedApplication().delegate as? AppDelegate
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        TrelloDataHandler.shared.loadData()
        if let token = Trello.shared.getToken() {
            let trelloRequester = TrelloRequester()
            trelloRequester.getMembers("5736fe2e5ab6038f5295e222") {
                print($0)
            }
        }
        
        if SlackClient.Token == nil {
            SlackClient.Authenticate()
        } else {
            slackClient = SlackClient()
        }
        
        return true
    }
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        guard let components = NSURLComponents(URL: url, resolvingAgainstBaseURL: false),
            queries = components.queryItems else { return false }
        if !(queries.filter { $0.name == "code" }).isEmpty {
            SlackClient.ContinueAuthentication(url) { isAuthenticated in
                guard isAuthenticated else { return }
                self.slackClient = SlackClient()
            }
            return true
        } else {
            Trello.shared.handleCallbackUrlWithQueryItems(queries)
            return true
        }
        return true
    }
    
}

