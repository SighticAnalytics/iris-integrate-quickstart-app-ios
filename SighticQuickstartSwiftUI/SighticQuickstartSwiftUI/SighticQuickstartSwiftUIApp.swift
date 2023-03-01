//
// Copyright © 2022-2023 Sightic Analytics AB. All rights reserved.
//

import SwiftUI

@main
struct SighticQuickstartSwiftUI: App {
    static var apiKey: String {
        // TODO: Add your API key below. Get in touch with Sightic Analytics to acquire an API key.
        let apiKey = ""
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
