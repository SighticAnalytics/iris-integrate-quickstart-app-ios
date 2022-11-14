//  Copyright © 2022 Sightic Analytics AB All rights reserved.

import SwiftUI
import SighticAnalytics

/// The ``TestView`` acts as a container view for the ``SighticInferenceView``.
///
/// See https://github.com/EyescannerTechnology/sightic-sdk-ios/blob/main/README.md
/// regarding how to use the ``SighticInferenceView`` view.
struct TestView: View {
    @Binding var appState: AppState

    func sendRecodingForAnalysis(_ sighticInferenceRecording: SighticInferenceRecording) {
        Task {
            /*
             - The app now has a sighticInferenceRecording that we can call
               performInference on to send the recording Sightic server
               for analysis.

             - We update appstate to show a waiting view while
               waiting for the test result from the Sightic backend.

             - We update the app state with the inference result after
               receving it back from performInference. It
               will be used in the ResultView.
             */
            appState = .waitingForAnalysis
            let inferenceResult = await sighticInferenceRecording.performInference()
            switch inferenceResult {
            case .success(let sighticInference):
                appState = .result(sighticInference)
            case .failure(let sighticError):
                appState = .error(sighticError)
            }
        }
    }

    var body: some View {
        SighticInferenceView(
            apiKey: SighticQuickstartSwiftUI.apiKey,
            skipInstructions: false,
            completion: { sighticInferenceRecordingResult in
                switch sighticInferenceRecordingResult {
                case .success(let sighticInferenceRecording):
                    sendRecodingForAnalysis(sighticInferenceRecording)
                case .failure(let sighticError):
                    appState = .error(sighticError)
                }
            }
        )
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView(appState: .constant(.test))
    }
}
