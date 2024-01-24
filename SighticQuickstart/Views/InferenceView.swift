//
// Copyright © 2022-2024 Sightic Analytics AB. All rights reserved.
//

import SighticAnalytics
import SwiftUI

/// View that is displayed while waiting for an inference result.
struct InferenceView: View {
    @Binding var screen: Screen
    let recording: SighticRecording
    let allowToSave: Bool

    var body: some View {
        VStack {
            Header(
                title: "Hold on",
                subtitle: "Waiting for inference result..."
            )

            Spacer()

            ProgressView()
                .controlSize(.extraLarge)

            Spacer()
        }
        .task {
            switch await recording.performInference(allowToSave: allowToSave) {
            case .success(let inference):
                screen = .result(inference)
            case .failure(let error):
                screen = .error(.sighticError(error))
            }
        }
    }
}

#Preview {
    InferenceView(
        screen: .constant(.inference(SighticMock.recording, allowToSave: false)),
        recording: SighticMock.recording,
        allowToSave: false
    )
}
