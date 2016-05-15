//
//  Trello.swift
//  Assistant
//
//  Created by Dmitrii Celpan on 5/14/16.
//  Copyright © 2016 Bananos. All rights reserved.
//

import Foundation
import OAuthSwift

let TrelloAuthTokenKey = "TrelloOAuthToken"
let TrelloRequestTokenUrl = "https://trello.com/1/OAuthGetRequestToken"
let TrelloAuthorizeUrl = "https://trello.com/1/OAuthAuthorizeToken"
let TrelloAccessTokenUrl = "https://trello.com/1/OAuthGetAccessToken"
let TrelloAplicationKey = "3747c16d50a7a32dd4033a007ebe06e8"
let TrelloCustomerSecret = "ab51b7d5c6c1942af51613883c3dfdbfa896f0d9cfe0dbc04996c9d34a4765bc"

final class Trello {
    
    private var oAuthToken: String?
    
    static let shared = Trello()
    private init() {}
    private let userDefaults = NSUserDefaults.standardUserDefaults()
    
    func handleCallbackUrlWithQueryItems(queryItems: [NSURLQueryItem]?) {
        let tokenItem = queryItems?.filter() { $0.name == "oauth_token" }.first
        guard let token = tokenItem?.value else {
            return
        }
        userDefaults.setObject(token, forKey: TrelloAuthTokenKey)
        oAuthToken = token
        TrelloDataHandler.shared.loadData()
        let nc = UIApplication.sharedApplication().keyWindow?.rootViewController as! NavigationController
        nc.popViewControllerAnimated(false)
        nc.pushViewController(AssistantViewController.instantiateFromStoryboard()!, animated: true)
    }
    
    func performAuthorisation() {
        let oauthswift = OAuth1Swift(
            consumerKey:    TrelloAplicationKey,
            consumerSecret: TrelloCustomerSecret,
            requestTokenUrl: TrelloRequestTokenUrl,
            authorizeUrl:    TrelloAuthorizeUrl,
            accessTokenUrl:  TrelloAccessTokenUrl
        )
        oauthswift.authorizeWithCallbackURL(
            NSURL(string: "Assistant://")!,
            success: { credential, response, parameters in
                print(credential.oauth_token)
                print(credential.oauth_token_secret)
                print(parameters["user_id"])
            },
            failure: { error in
                print(error.localizedDescription)
            }
        )
    }
    
    func getToken() -> String? {
        let tokenMock =  "520c4f01f7ea99218e9fae48438c544016ccf4740bc5394354633fb6dd79ccb4"
        guard let token = userDefaults.objectForKey(TrelloAuthTokenKey) as? String else {
            userDefaults.setObject(tokenMock, forKey: TrelloAuthTokenKey)
            oAuthToken = tokenMock
            return nil
        }
        return token
    }
    
}















