
//  CardCRUD.swift
//  Assistant
//
//  Created by Dmitrii Celpan on 5/15/16.
//  Copyright © 2016 Bananos. All rights reserved.
//

import Foundation
import Alamofire

final class CardCRUD {
    
    func createCard(listId: String) {
        let params = ["due": NSNull(),
                      "idList": listId]
        let module = "/cards"
        postRequest(module, params: params) { (response) in
            print(response)
        }
    }
    
    func updateCard(cardId: String) {
        let params = ["name": "Changed name"]
        let module = "/cards/\(cardId)"
        putRequest(module, params: params) { (response) in
            print(response)
        }
    }
    
    func deleteCard(cardId: String) {
        let module = "/cards/\(cardId)"
        deleteRequest(module, params: nil) { (response) in
            print(response)
        }
    }
    
    private func deleteRequest(module: String, params: [String: AnyObject]?, callback:(response: Response<AnyObject, NSError>?) -> Void) {
        guard let url = NSURL(string: TrelloURL + module) else {
            callback(response: nil)
            return
        }
        let request = Alamofire.request(.DELETE,
                                        url,
                                        parameters: defaultParams,
                                        encoding: .JSON,
                                        headers: trelloHeaders)
        request.responseJSON { (response: Response<AnyObject, NSError>) -> Void in
            callback(response: response)
        }
    }
    
    private func postRequest(module: String, params: [String: AnyObject], callback:(response: Response<AnyObject, NSError>?) -> Void) {
        guard let url = NSURL(string: TrelloURL + module) else {
            callback(response: nil)
            return
        }
        let request = Alamofire.request(.POST,
                                        url,
                                        parameters: defaultParams,
                                        encoding: .JSON,
                                        headers: trelloHeaders)
        request.responseJSON { (response: Response<AnyObject, NSError>) -> Void in
            callback(response: response)
        }
    }
    
    private func putRequest(module: String, params: [String: AnyObject], callback:(response: Response<AnyObject, NSError>?) -> Void) {
        guard let url = NSURL(string: TrelloURL + module) else {
            callback(response: nil)
            return
        }
        let request = Alamofire.request(.PUT,
                                        url,
                                        parameters: defaultParams,
                                        encoding: .JSON,
                                        headers: trelloHeaders)
        request.responseJSON { (response: Response<AnyObject, NSError>) -> Void in
            callback(response: response)
        }
    }
    
    private var trelloHeaders: [String: String] {
        return [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }
    
    private var defaultParams: [String: String] {
        guard let token = Trello.shared.getToken() else {
            return ["key": TrelloAplicationKey]
        }
        return ["key": TrelloAplicationKey,
                "token": token ]
    }
    
}
