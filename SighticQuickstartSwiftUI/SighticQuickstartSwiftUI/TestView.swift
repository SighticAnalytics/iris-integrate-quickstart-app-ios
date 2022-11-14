//
//  Copyright © 2022 Sightic Analytics AB All rights reserved.
//

import SwiftUI
import SighticAnalytics

struct TestView: View {
    @Binding var appState: AppState

    func sendRecodingForAnalysis(_ sighticInferenceRecording: SighticInferenceRecording) {
        Task {
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
