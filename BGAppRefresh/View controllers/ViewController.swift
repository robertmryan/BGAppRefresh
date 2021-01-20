//
//  ViewController.swift
//  BGAppRefresh
//
//  Created by Robert Ryan on 5/28/20.
//  Copyright © 2020 Robert Ryan. All rights reserved.
//

import UIKit
import UserNotifications
import os.log

private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "ViewController")

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        logger.debug(#function)

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                logger.error("\(error.localizedDescription, privacy: .public)")
            }
        }
    }
}
