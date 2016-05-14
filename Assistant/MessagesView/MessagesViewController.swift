//
//  ViewController.swift
//  Assistant
//
//  Created by Bananos on 5/14/16.
//  Copyright © 2016 Bananos. All rights reserved.
//

import UIKit
import Dodo

final class MessagesViewController: UIViewController, UITextFieldDelegate, SRMDelegate {
    @IBOutlet weak var messagesTableView: MessagesTableView!
    @IBOutlet weak var typeMessageTextView: UITextField!
    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet weak var typeMessageViewBottomConstraint: NSLayoutConstraint!
    
    var client: SlackClient? {
        didSet { self.client?.start() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMessagesTableView()
        setupKeyboardNotifications()
        sendMessageButton.enabled = false
        typeMessageTextView.delegate = self
    }
    
    func setUserOrChannelName(name: String) {
        navigationController?.navigationBar.topItem?.title = name
    }
    
    private func setupMessagesTableView() {
        messagesTableView.dataSource = messagesTableView
        messagesTableView.delegate = messagesTableView
    }
    
    private func setupKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow),
                                                         name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide),
                                                         name:UIKeyboardWillHideNotification, object: nil)
    }
    
    // MARK: SRMRetriever
    
    func eventReceived(event: SlackEvent) {

    }
    
    // MARK: Actions
    
    @IBAction func sendMessage(sender: AnyObject) {
        guard let messageText = typeMessageTextView.text else { return }
        messagesTableView.addMessage(Message(message: messageText, messageType: .FromMe))
        typeMessageTextView.text = nil
        sendMessageButton.enabled = false
    }
    
    // MARK: Keyboard
    
    func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() else {
            return
        }
        UIView.animateWithDuration(0.3) {
            self.typeMessageViewBottomConstraint.constant = keyboardFrame.size.height
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        guard let keyboardFrame = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() else {
            return
        }
        UIView.animateWithDuration(0.3) {
            self.typeMessageViewBottomConstraint.constant = keyboardFrame.size.height
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }
    
    // UITextFieldDelegate
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        guard let text  = textField.text else { return false }
        if (text as NSString).stringByReplacingCharactersInRange(range, withString: string) == "" {
            sendMessageButton.enabled = false
        } else {
            sendMessageButton.enabled = true
        }
        return true
    }
}
