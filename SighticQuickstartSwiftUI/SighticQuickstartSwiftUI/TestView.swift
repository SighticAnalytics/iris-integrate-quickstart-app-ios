//
//  Copyright © 2022 Sightic Analytics AB All rights reserved.
//

import SwiftUI
import SighticAnalytics

struct TestView: View {
    @Binding var appState: AppState
    @State var sighticStatus: SighticStatus = .instruction

    var body: some View {
        ZStack {
            SighticInferenceView(apiKey: SighticQuickstartSwiftUI.apiKey,
                                 showInstructions: sighticInferenceViewConfiguration.showInstructions,
                                 statusCallback: self.handleSighticStatus,
                                 completion: self.handleResult)
            if shallShowAlignmentStatusView() {
                StatusView(sighticStatus: sighticStatus)
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
            let inferenceResult = await sighticInferenceRecording.performInference()
            switch inferenceResult {
            case .success(let sighticInference):
                appState = .result(sighticInference)
            case .failure(let sighticError):
                appState = .error(sighticError)
            }
        }
    }

    /// Use the `SighticStatus` to determine whether the `AlignmentStatusViewController` shall be shown.
    /// Propagate `SighticStatus` to the `AliginmentStatusViewController`.
    private func handleSighticStatus(_ sighticStatus: SighticStatus) {
        self.sighticStatus = sighticStatus
    }

    /// We only want to overlay `SighticInferenceView` with our own `AlignmentStatusViewController`
    /// if `SighticStatus` is `align` or `countdown` and the QuickStart app user has selected to show
    /// raw alignment status in the `StartView`.
    private func shallShowAlignmentStatusView() -> Bool {
        guard case .test(let sighticInferenceViewConfiguration) = appState else { return false }

        switch sighticStatus {
        case .align, .countdown:
            if sighticInferenceViewConfiguration.showRawAlignmentStatus {
                return true
            } else {
                return false
            }
        case .instruction, .test:
            return false
        }
    }


}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView(appState: .constant(.test(SighticInferenceViewConfiguration())))
    }
}
