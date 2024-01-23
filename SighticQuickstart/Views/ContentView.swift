//
// Copyright © 2022-2024 Sightic Analytics AB. All rights reserved.
//

import SighticAnalytics
import SwiftUI

/// Screens possible to navigate to.
enum Screen {
    /// Start screen.
    case start
    /// Sightic test screen
    case test(showInstructions: Bool, allowToSave: Bool)
    /// Send recording to Sightic backend and wait for result.
    case inference(SighticRecording, allowToSave: Bool)
    /// Display inference result.
    case result(SighticInference)
    /// Give feedback on the result.
    case feedback(SighticInference)
    /// Display an error.
    case error(Error)
}

struct ContentView: View {
    @State var screen: Screen = .start

    var body: some View {
        switch screen {
        case .start:
            StartView(screen: $screen)
        case .test(let showInstructions, let allowToSave):
            TestView(screen: $screen, showInstructions: showInstructions, allowToSave: allowToSave)
        case .inference(let recording, let allowToSave):
            InferenceView(screen: $screen, recording: recording, allowToSave: allowToSave)
        case .result(let inference):
            ResultView(screen: $screen, inference: inference)
        case .feedback(let inference):
            FeedbackView(screen: $screen, inference: inference)
        case .error(let error):
            ErrorView(screen: $screen, error: error)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
