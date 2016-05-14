//
//  SlackFetcher.swift
//  Assistant
//
//  Created by Bananos on 5/14/16.
//  Copyright © 2016 Bananos. All rights reserved.
//

import Foundation

struct SlackFetcher {
    static func FetchUsers(tokenQuery: String, callback: [SlackUser] -> ()) {
        guard let usersURL = NSURL(string: SlackAPI + "users.list?" + tokenQuery) else { return callback([]) }
        let task = NSURLSession.sharedSession().dataTaskWithURL(usersURL) { data, _, error in
            guard let data = data,
                json = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0)),
                dictionary = json as? [String: AnyObject],
                usersArray = dictionary["members"] as? [[String: AnyObject]] else {
                    return callback([])
            }
            callback(usersArray.flatMap { SlackUser(json: $0) })
        }
        task.resume()
    }
    
    static func FetchChannels(tokenQuery: String, callback: [SlackChannel] -> ()) {
        guard let channelsURL = NSURL(string: SlackAPI + "channels.list?" + tokenQuery) else { return callback([]) }
        let task = NSURLSession.sharedSession().dataTaskWithURL(channelsURL) { data, _, error in
            guard let data = data,
                json = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0)),
                dictionary = json as? [String: AnyObject],
                usersArray = dictionary["channels"] as? [[String: AnyObject]] else {
                    return callback([])
            }
            callback(usersArray.flatMap { SlackChannel(json: $0) })
        }
        task.resume()
    }
    
    static func FetchHistory(tokenQuery: String, channel: String, callback: [SlackMessage] -> ()) {
        guard let historyURL = NSURL(string: SlackAPI + "channels.history?channel=\(channel)" + tokenQuery) else {
            return callback([])
        }
        let task = NSURLSession.sharedSession().dataTaskWithURL(historyURL) { data, _, error in
            guard let data = data,
                json = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0)),
                dictionary = json as? [String: AnyObject],
                usersArray = dictionary["messages"] as? [[String: AnyObject]] else {
                    return callback([])
            }
            callback(usersArray.flatMap { SlackMessage(json: $0) })
        }
        task.resume()
    }
    
    static func FetchCurrentUser(tokenQuery: String, callback: SlackUser? -> ()) {
        guard let userURL = NSURL(string: SlackAPI + "auth.test?" + tokenQuery) else {
            return callback(nil)
        }
        let task = NSURLSession.sharedSession().dataTaskWithURL(userURL) { data, _, error in
            guard let data = data,
                json = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0)),
                dictionary = json as? [String: AnyObject],
                userID = dictionary["user_id"] as? String else {
                    return callback(nil)
            }
            FetchUserInfo(tokenQuery, userID: userID, callback: callback)
        }
        task.resume()
    }
    
    static func FetchUserInfo(tokenQuery: String, userID: String , callback: SlackUser? -> ()) {
        guard let userURL = NSURL(string: SlackAPI + "user.info?user=\(userID)" + tokenQuery) else {
            return callback(nil)
        }
        let task = NSURLSession.sharedSession().dataTaskWithURL(userURL) { data, _, error in
            guard let data = data,
                json = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0)),
                dictionary = json as? [String: AnyObject],
                user = SlackUser(json: dictionary) else {
                    return callback(nil)
            }
            callback(user)
        }
        task.resume()
    }
}
