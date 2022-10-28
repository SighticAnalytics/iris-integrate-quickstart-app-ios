//  Copyright © 2022 Sightic Analytics AB All rights reserved.

import SwiftUI
import SighticAnalytics

struct StartView: View {
    @Binding var appState: AppState

    var body: some View {
        VStack {
            Text("Sightic SDK Quickstart")
                .font(.title)
                .padding()
            Text("SDK version: \(SighticVersion.sdkVersion)")
                .font(.body)
                .padding()
            Spacer()
            Text("StartView")
                .font(.title2)
                .padding()
            Button(action: { appState = .test },
                   label: { Text("Go to test") })
            Spacer()
        }
    }
}

struct Start_Previews: PreviewProvider {
    static var previews: some View {
        StartView(appState: .constant(.start))
    }
}
