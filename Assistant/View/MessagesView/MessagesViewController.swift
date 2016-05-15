//
//  ViewController.swift
//  Assistant
//
//  Created by Bananos on 5/14/16.
//  Copyright © 2016 Bananos. All rights reserved.
//

import UIKit

final class MessagesViewController: UIViewController, UITextFieldDelegate, StoryboardInstantiable {
    static let ControllerIdentifier = "MessagesViewController"
    @IBOutlet weak var messagesTableView: MessagesTableView!
    @IBOutlet weak var typeMessageTextView: UITextField!
    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet weak var typeMessageViewBottomConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMessagesTableView()
        setupKeyboardNotifications()
        sendMessageButton.enabled = false
        typeMessageTextView.delegate = self
    }
    
    private func setupMessagesTableView() {
        messagesTableView.dataSource = messagesTableView
        messagesTableView.delegate = messagesTableView
        messagesTableView.estimatedRowHeight = 30
        messagesTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    private func setupKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow),
                                                         name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide),
                                                         name:UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardSizeWillChange),
                                                         name:UIKeyboardWillChangeFrameNotification, object: nil)

    }
    
    // MARK: Actions
    
    @IBAction func sendMessage(sender: AnyObject) {
        guard let messageText = typeMessageTextView.text else { return }
        let slackMessage = SlackMessage(json: ["text": messageText])
        if arc4random_uniform(2) == 0 {
            DataPersistor.sharedPersistor.addMessage(Message(slackMessage:slackMessage, messageType: .FromMe))
            messagesTableView.reloadLastMessage()
        } else {
            DataPersistor.sharedPersistor.addMessage(Message(slackMessage:slackMessage, messageType: .ToMe))
            messagesTableView.reloadLastMessage()
        }
        typeMessageTextView.text = nil
    }
    
    // MARK: Keyboard
    
    func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() else {
            return
        }
        UIView.animateWithDuration(0.3) {
            self.typeMessageViewBottomConstraint.constant = keyboardFrame.size.height
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animateWithDuration(0.3) {
            self.typeMessageViewBottomConstraint.constant = 0
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardSizeWillChange(notification: NSNotification) {
        guard let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() else {
            return
        }
        typeMessageViewBottomConstraint.constant = keyboardFrame.size.height
        view.setNeedsLayout()
        view.layoutIfNeeded()
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        guard let text = textField.text where text != "" else { return false }
        sendMessage(sendMessageButton)
        return true
    }
}
