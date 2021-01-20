//
//  BackgroundAppRefreshManager.swift
//  BGAppRefresh
//
//  Created by Robert Ryan on 1/19/21.
//  Copyright © 2021 Robert Ryan. All rights reserved.
//

import Foundation
import UserNotifications
import BackgroundTasks
import os.log

private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "BackgroundAppRefreshManager")
private let backgroundTaskIdentifier = "com.robertmryan.BGAppRefresh.refresh"

class BackgroundTaskManager {
    static let shared = BackgroundTaskManager()

    private init() { }
}

// MARK: Public methods

extension BackgroundTaskManager {

    func register() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: backgroundTaskIdentifier, using: .main, launchHandler: handleTask(_:))
    }
    
    func handleTask(_ task: BGTask) {
        scheduleAppRefresh()

        show(message: task.identifier)

        let request = performRequest { error in
            task.setTaskCompleted(success: error == nil)
        }

        task.expirationHandler = {
            task.setTaskCompleted(success: false)
            request.cancel()
        }
    }

    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: backgroundTaskIdentifier)

        var message = "Scheduled"
        do {
            try BGTaskScheduler.shared.submit(request)
            logger.log("task request submitted to scheduler")
            #warning("add breakpoint at previous line")

            // at (lldb) prompt, type:
            //
            // e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"com.robertmryan.BGAppRefresh.bgapprefresh"]
        } catch BGTaskScheduler.Error.notPermitted {
            message = "BGTaskScheduler.shared.submit notPermitted"
        } catch BGTaskScheduler.Error.tooManyPendingTaskRequests {
            message = "BGTaskScheduler.shared.submit tooManyPendingTaskRequests"
        } catch BGTaskScheduler.Error.unavailable {
            message = "BGTaskScheduler.shared.submit unavailable"
        } catch {
            message = "BGTaskScheduler.shared.submit \(error.localizedDescription)"
        }

        show(message: message)
    }
}

// MARK: - Private utility methods

private extension BackgroundTaskManager {

    func show(message: String) {
        logger.debug("\(message, privacy: .public)")
        let content = UNMutableNotificationContent()
        content.title = "AppRefresh task"
        content.body = message
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                logger.error("\(message, privacy: .public) error: \(error.localizedDescription, privacy: .public)")
            }
        }
    }

    @discardableResult
    func performRequest(completion: @escaping (Error?) -> Void) -> URLSessionTask {
        logger.debug("starting bg network request")

        let url = URL(string: "https://httpbin.org/get")!
        let task = URLSession.shared.dataTask(with: url) { _, _, error in
            logger.debug("finished bg network request")
            completion(error)
        }

        task.resume()

        return task
    }
}
