//
// Copyright © 2022-2024 Sightic Analytics AB. All rights reserved.
//

import IRISintegrate
import SwiftUI

/// View that displays the IRIS integrate scan flow.
struct ScanView: View {
    @Binding var screen: Screen
    let showInstructions: Bool
    let allowToSave: Bool

    var body: some View {
        SighticView(
            apiKey: IRISintegrateQuickstart.apiKey,
            configuration: SighticConfiguration(
                showInstructions: showInstructions,
                sendUsageTelemetry: true
            )
        ) { result in
            switch result {
            case .success(let recording):
                screen = .inference(recording, allowToSave: allowToSave)
            case .failure(let error):
                screen = .error(.recordingError(error))
            }
        }
    }
}

#Preview {
    ScanView(
        screen: .constant(.scan(showInstructions: true, allowToSave: true)),
        showInstructions: true, allowToSave: true
    )
}
