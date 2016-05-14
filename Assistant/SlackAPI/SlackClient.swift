//
//  SlackClient.swift
//  Assistant
//
//  Created by Bananos on 5/14/16.
//  Copyright © 2016 Bananos. All rights reserved.
//

import UIKit

let ClientID = "15764343809.42973950866"
let ClientSecret = "7803d2c6d031339be30040d740424378"
let AppScheme = "Assistant://"
let SlackAccessTokenKey = "access_token"
let DefaultsSlackAccessTokenKey = "slack_access_token"
let DefaultsSlackUserIDKey = "slack_user_id"
let DefaultsSlackTeamIDKey = "slack_team_id"
let SlackAPI = "https://slack.com/api/"

class SlackClient {
    
    static var Token: String? { return NSUserDefaults.standardUserDefaults().valueForKey(DefaultsSlackAccessTokenKey) as? String }
    
    let accessToken: String
    var tokenQuery: String { return "token=" + accessToken }
    
    let messager: SlackRealtimeMessager
    
    var dataRetriever: SRMRetriever? {
        get {
            return messager.retriever
        } set {
            messager.retriever = newValue
        }
    }
    var delegate: SRMDelegate? {
        get {
            return messager.delegate
        } set {
            messager.delegate = newValue
        }
    }
    
    init?() {
        guard let token = SlackClient.Token else {
            return nil
        }
        accessToken = token
        messager = SlackRealtimeMessager(tokenQuery: "token=" + accessToken)
    }
    
    func start() {
        messager.start()
    }
    
    // MARK: Fetching
    
    func getCurrentUser(callback: SlackUser? -> ()) {
        SlackFetcher.FetchCurrentUser(tokenQuery, callback: callback)
    }
    
    func getUsers(callback: [SlackUser] -> ()) {
        SlackFetcher.FetchUsers(tokenQuery, callback: callback)
    }
    
    func getChannels(callback: [SlackChannel] -> ()) {
        SlackFetcher.FetchChannels(tokenQuery, callback: callback)
    }
    
    
    // MARK: Authentication
    
    static func Authenticate() -> Bool {
        return SlackAuthenticator.Authenticate()
    }
    
    static func ContinueAuthentication(url: NSURL, callback: Bool -> ()) {
        SlackAuthenticator.ContinueAuthentication(url, callback: callback)
    }
}








