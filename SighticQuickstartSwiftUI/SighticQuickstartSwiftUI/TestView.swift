//
// Copyright © 2022-2023 Sightic Analytics AB. All rights reserved.
//

import SwiftUI
import SighticAnalytics

struct TestView: View {
    @Binding var appState: AppState
    @State var sighticStatus: SighticStatus = .instruction
    let allowToSave: Bool

    var body: some View {
        ZStack {
            SighticInferenceView(apiKey: SighticQuickstartSwiftUI.apiKey,
                                 showInstructions: sighticInferenceViewConfiguration.showInstructions,
                                 statusCallback: self.handleSighticStatus,
                                 completion: self.handleResult)
            if shallShowAlignmentHintView() {
                AlignmentHintView(sighticStatus: sighticStatus)
            }
        }
    }

    private var sighticInferenceViewConfiguration: SighticInferenceViewConfiguration {
        if case .test(let sighticInferenceViewConfiguration) = appState {
            return sighticInferenceViewConfiguration
        } else {
            return SighticInferenceViewConfiguration()
        }
    }

    /// Handle the result from the SighticInferenceView after the test has finished.
    private func handleResult(_ sighticInferenceRecordingResult: SighticInferenceRecordingResult) {
        switch sighticInferenceRecordingResult {
        case .success(let sighticInferenceRecording):
            self.sendRecodingForAnalysis(sighticInferenceRecording)
        case .failure(let sighticError):
            appState = .error(sighticError)
        }
    }

    /// Send the recording returned by the SighticInferenceView to the SighticAnalytics backend for analysis.
    private func sendRecodingForAnalysis(_ sighticInferenceRecording: SighticInferenceRecording) {
        Task {
            appState = AppState.waitingForAnalysis
            let inferenceResult = await sighticInferenceRecording.performInference(allowToSave: allowToSave)
            switch inferenceResult {
            case .success(let sighticInference):
                appState = .result(sighticInference)
            case .failure(let sighticError):
                appState = .error(sighticError)
            }
        }
    }

    /// Propagate `SighticStatus` to the `AliginmentHintView`.
    private func handleSighticStatus(_ sighticStatus: SighticStatus) {
        self.sighticStatus = sighticStatus
    }

    /// We only want to overlay `SighticInferenceView` with `AlignmentHintView`
    /// if `SighticStatus` is `align` or `countdown`.
    private func shallShowAlignmentHintView() -> Bool {
        switch sighticStatus {
        case .align, .countdown:
            return true
        case .instruction, .test:
            return false
        @unknown default:
            return false
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView(
            appState: .constant(.test(SighticInferenceViewConfiguration())),
            allowToSave: true
        )
    }
}
