//
//  AppDelegate.swift
//  BGAppRefresh
//
//  Created by Robert Ryan on 5/28/20.
//  Copyright © 2020 Robert Ryan. All rights reserved.
//

import UIKit
import os

private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "AppDelegate")

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        logger.debug(#function)

        UNUserNotificationCenter.current().delegate = self

        BackgroundTaskManager.shared.register()

        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // you will not see this happen ... scene delegate gets this background notification

        logger.debug(#function)
    }
}

// MARK: - UISceneSession Lifecycle

extension AppDelegate {
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.list, .banner, .sound])
    }
}
