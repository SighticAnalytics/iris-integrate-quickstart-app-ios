//
//  Copyright © 2022 Sightic Analytics AB All rights reserved.
//

import SwiftUI
import SighticAnalytics

struct ContentView: View {
    @State var appState: AppState = .start
    @AppStorage("allowToSave") var allowToSave = false

    var body: some View {
        switch appState {
        case .start:
            StartView(appState: $appState, allowToSave: $allowToSave)
        case .test:
            TestView(appState: $appState, allowToSave: allowToSave)
        case .waitingForAnalysis:
            WaitingView()
        case .result:
            ResultView(appState: $appState)
        case .error:
            ErrorView(appState: $appState)
        case .feedback:
            FeedbackView(appState: $appState)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
