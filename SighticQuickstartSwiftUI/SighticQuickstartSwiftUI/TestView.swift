//
//  TestView.swift
//  SighticQuickstartSwiftUI
//
//  Copyright © 2022 Sightic Analytics AB All rights reserved.
//

import SwiftUI
import SighticAnalytics

/// The ``TestView`` acts as a container view for the ``SighticView``.
///
/// 1. Create a ``SighticView`` and let it occupy the whole screen.
/// 2. Provide an API key to the ``SighticView``.
/// 3. Provide a limit on how many times the app user is allow to fail
///   to do a recording before triggering completion handler with an error.
/// 3. Provide a completion handler to SighticView
///    - The completion handler will receive a
///      ``SighticRecordingResult`` which is of type ``Result``.
///    - ``SighticRecordingResult`` case ``.success`` contains ``SighticRecording``
///    - ``SighticRecordingResult`` case ``.failure`` contains ``SighticError``.
/// 4. ``SighticRecording`` implements the function ``performInference`` that sends the
///   recording to the Sightic backend for analysis.
/// 5. The ``performInference`` function returns a ``SighticInferenceResult``
///   which is of type ``Result``:
///     - ``SighticInferenceResult`` case ``.success`` contains ``SighticResult``
///     - ``SighticInferenceResult`` case ``.failure`` contains  ``SighticError``.
struct TestView: View {
    @Binding var appState: AppState

    func sendRecodingForAnalysis(_ sighticRecording: SighticRecording) {
        Task {
            /*
             - The app now has a SighticRecording that we can call
               performInference on to send the recording Sightic server
               for analysis.

             - We update appstate to show a waiting view while
               waiting for the test result from the Sightic backend.

             - We update the app state with the inference result after
               receving it back from performInference. It
               will be used in the ResultView.
             */
            appState = .waitingForAnalysis
            let inferenceResult = await sighticRecording.performInference()
            switch inferenceResult {
            case .success(let sighticInference):
                appState = .result(sighticInference)
            case .failure(let sighticError):
                appState = .error(sighticError)
            }
        }
    }

    var body: some View {
        SighticView(apiKey: "secret_api_key",
                    completion: { sighticRecordingResult in
            switch sighticRecordingResult {
            case .success(let sighticRecording):
                sendRecodingForAnalysis(sighticRecording)
            case .failure(let sighticError):
                appState = .error(sighticError)
            }
        })
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView(appState: .constant(.test))
    }
}
