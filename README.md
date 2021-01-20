#  Demo of iOS BGAppRefresh

This is example of `BGAppRefreshTaskRequest` in the [Background Tasks](https://developer.apple.com/documentation/backgroundtasks) framework.

This does the following:

 * Registers the background task in the app delegate’s `didFinishLaunchingWithOptions`.
 * Schedules the `BGAppRefreshTaskRequest` in the scene delegate’s `sceneDidEnterBackground`.
 * All the background task related code is placed in `BackgroundTaskManager` class to avoid cluttering the app delegate and the scene delegate.
 * The app refresh just does a simple request to https://httpbin.org.
 * All relevant events are logged using `Logger` (which allows you to watch these iOS events happen on your macOS Console). This is for iOS 14 and later. If you need to support iOS 13, then use `os_log` instead.
 * This posts `UserNotification` events so you can also see what’s happening from the device, too.
 * I have added a `#warning` where you may want to add a breakpoint if you want to [test this on physical device](https://developer.apple.com/documentation/backgroundtasks/starting_and_terminating_tasks_during_development).

See:

* [Background Tasks](https://developer.apple.com/documentation/backgroundtasks) documentation
* WWDC 2019 video [Advances in App Background Execution](https://developer.apple.com/videos/play/wwdc2019/707/)
* Documentation about how to test this in [Starting and Terminating Tasks During Development](https://developer.apple.com/documentation/backgroundtasks/starting_and_terminating_tasks_during_development)

---

19 January 2021

Copyright © 2021 Robert M. Ryan. All Rights Reserved.

See [License](LICENSE.md).
