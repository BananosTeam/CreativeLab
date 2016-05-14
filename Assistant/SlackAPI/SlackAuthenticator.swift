//
//  SlackAuthenticator.swift
//  Assistant
//
//  Created by Bananos on 5/14/16.
//  Copyright © 2016 Bananos. All rights reserved.
//

import UIKit

struct SlackAuthenticator {
    static func Authenticate() -> Bool {
        guard let components = NSURLComponents(string: "https://slack.com/oauth/authorize") else {
            return false
        }
        components.queryItems = [
            NSURLQueryItem(name: "client_id", value: ClientID),
            NSURLQueryItem(name: "scope", value: "client"),
            NSURLQueryItem(name: "redirect_uri", value: AppScheme)
        ]
        guard let url = components.URL else { return false }
        UIApplication.sharedApplication().openURL(url)
        
        return true
    }
    
    static func ContinueAuthentication(url: NSURL, callback: Bool -> ()) {
        let codeComponents = NSURLComponents(URL: url, resolvingAgainstBaseURL: false)
        guard let queries = codeComponents?.queryItems,
            codeQuery = queries.filter({ $0.name == "code" }).first,
            code = codeQuery.value,
            components = NSURLComponents(string: SlackAPI + "oauth.access") else {
                return callback(false)
        }
        components.queryItems = [
            NSURLQueryItem(name: "code", value: code),
            NSURLQueryItem(name: "client_id", value: ClientID),
            NSURLQueryItem(name: "client_secret", value: ClientSecret),
            NSURLQueryItem(name: "redirect_uri", value: AppScheme)
        ]
        guard let accessURL = components.URL else {
            return callback(false)
        }
        RequestAuthenticationAccess(NSURLRequest(URL: accessURL), callback: callback)
    }
    
    private static func RequestAuthenticationAccess(request: NSURLRequest, callback: Bool -> ()) {
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, _, error in
            guard let data = data,
                json = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0)),
                dictionary = json as? [String: AnyObject],
                token = dictionary[SlackAccessTokenKey] as? String else {
                    return callback(false)
            }
            NSUserDefaults.standardUserDefaults().setValue(token, forKey: DefaultsSlackAccessTokenKey)
            callback(true)
        }
        task.resume()
    }
}