//
//  Copyright © 2022 Sightic Analytics AB All rights reserved.
//

import SwiftUI

@main
struct SighticQuickstartSwiftUI: App {
    static var apiKey: String {
        //TODO: Add your API key below. Get in touch with Sightic Analytics to acquire an API key.
        let apiKey = "a15756c2-b5f1-41bf-8a3d-c38720100b23"
        guard !apiKey.isEmpty else {
            fatalError("No SighticAnalytics API key was set")
        }
        return apiKey
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
