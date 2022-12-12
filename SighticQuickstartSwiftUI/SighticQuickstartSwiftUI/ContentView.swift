//
//  Copyright © 2022 Sightic Analytics AB All rights reserved.
//

import SwiftUI
import SighticAnalytics


struct SighticInferenceViewConfiguration {
    var showInstructions: Bool = false
    var showRawAlignmentStatus: Bool = false
}

enum AppState {
    case start
    case test(SighticInferenceViewConfiguration)
    case waitingForAnalysis
    case result(SighticInference)
    case error(SighticError)
}

struct ContentView: View {
    @State var appState: AppState = .start

    var body: some View {
        switch appState {
        case .start:
            StartView(appState: $appState)
        case .test:
            TestView(appState: $appState)
        case .waitingForAnalysis:
            WaitingView()
        case .result:
            ResultView(appState: $appState)
        case .error:
            ErrorView(appState: $appState)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
