//
//  ActivityViewController.swift
//  Assistant
//
//  Created by Bananos on 5/14/16.
//  Copyright © 2016 Bananos. All rights reserved.
//

import UIKit

final class ActivityViewController: UIViewController, StoryboardInstantiable {
    static let ControllerIdentifier = "ActivityViewController"
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        activityIndicator.hidden = true
        activityIndicator.stopAnimating()
    }
}
