//
//  Copyright © 2022 Sightic Analytics AB All rights reserved.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    static var apiKey: String {
        //TODO: Add your API key below. Get in touch with Sightic Analytics to retrieve an API key.
        let apiKey = "a15756c2-b5f1-41bf-8a3d-c38720100b23"
        guard !apiKey.isEmpty else {
            fatalError("No SighticAnalytics API key was set")
        }
        return apiKey
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
