//
// Copyright © 2022-2025 Sightic Analytics AB. All rights reserved.
//

import IRISintegrate
import SwiftUI

/// Screens possible to navigate to.
enum Screen {
    /// Start screen.
    case start
    /// Sightic scan screen
    case scan
    /// Send recording to Sightic backend and wait for result.
    case inference(SighticRecording)
    /// Display inference result.
    case result(SighticInference)
    /// Display an error.
    case error(Error)
}

struct ContentView: View {
    @State var screen: Screen = .start

    var body: some View {
        switch screen {
        case .start:
            StartView(screen: $screen)
        case .scan:
            ScanView(screen: $screen)
        case .inference(let recording):
            InferenceView(screen: $screen, recording: recording)
        case .result(let inference):
            ResultView(screen: $screen, inference: inference)
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
