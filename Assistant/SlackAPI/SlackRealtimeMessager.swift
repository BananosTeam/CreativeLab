//
//  SlackRealtimeMessaging.swift
//  Assistant
//
//  Created by Bananos on 5/14/16.
//  Copyright © 2016 Bananos. All rights reserved.
//

import UIKit
import Starscream

class SlackRealtimeMessager: WebSocketDelegate {
    
    private var socket: WebSocket?
    
    var retriever: SRMRetriever?
    var delegate: SRMDelegate?
    
    let tokenQuery: String
    
    private var id = 1000
    
    init(tokenQuery: String) {
        self.tokenQuery = tokenQuery
    }
    
    func start() {
        guard let token = SlackClient.Token else { return }
        let startURL = NSURL(string: SlackAPI + "rtm.start?token=" + token)!
        let task = NSURLSession.sharedSession().dataTaskWithRequest(NSURLRequest(URL: startURL)) { data, _, error in
            guard let _data = data,
                json = try? NSJSONSerialization.JSONObjectWithData(_data, options: NSJSONReadingOptions(rawValue: 0)),
                dictionary = json as? [String: AnyObject],
                url = dictionary["url"] as? String,
                user = dictionary["self"] as? [String: AnyObject] else {
                    return
            }
            dispatch_sync(dispatch_get_main_queue()) {
                if let users = dictionary["users"] as? [[String: AnyObject]] {
                    self.retriever?.setUsers(users.flatMap { SlackUser(json: $0) })
                }
                if let channels = dictionary["channels"] as? [[String: AnyObject]] {
                    self.retriever?.setChannels(channels.flatMap { SlackChannel(json: $0) })
                }
                if let team = dictionary["team"] as? [String: AnyObject] {
                    self.retriever?.setTeam(SlackTeam(json: team))
                }
            }
            if let userID = user["id"] as? String {
                SlackFetcher.FetchUserInfo(self.tokenQuery, userID: userID, callback: self.retriever!.setCurrentUser)
            }
            self.socket = WebSocket(url: NSURL(string: url)!)
            self.socket?.delegate = self
            self.socket?.connect()
        }
        task.resume()
    }
    
    func sendMessage(message: String, channel: String) {
//        id += 1
//        let json = [
//            "text": message,
//            "channel": channel,
//            "id": id,
//            "type": "message"
//        ]
//        guard let data = try? NSJSONSerialization.dataWithJSONObject(json, options: NSJSONWritingOptions(rawValue: 0)) else {
//            return
//        }
//        socket?.writeData(data)
        guard let postURL = NSURL(string: SlackAPI + "chat.postMessage?channel=\(channel)&text=\(message)&" + tokenQuery) else {
            return
        }
        let task = NSURLSession.sharedSession().dataTaskWithURL(postURL) { data, _, error in
            return
        }
        task.resume()
    }
    
    func websocketDidConnect(socket: WebSocket) {
        print("WebSocket connected")
    }
    
    func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        start()
    }
    
    func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        guard let textData = text.dataUsingEncoding(NSUTF8StringEncoding),
            json = try? NSJSONSerialization.JSONObjectWithData(textData, options: NSJSONReadingOptions(rawValue: 0)),
            dictionary = json as? [String: AnyObject],
            event = SlackEvent(json: dictionary) else {
                return
        }
        delegate?.eventReceived(event)
    }
    
    func websocketDidReceiveData(socket: WebSocket, data: NSData) {
        guard let json = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0)),
            dictionary = json as? [String: AnyObject],
            event = SlackEvent(json: dictionary) else {
                return
        }
        delegate?.eventReceived(event)
    }
}