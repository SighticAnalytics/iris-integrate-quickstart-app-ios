//
// Copyright © 2022-2025 Sightic Analytics AB. All rights reserved.
//

import IRISintegrate
import SwiftUI

/// View that displays the IRIS integrate scan flow.
struct ScanView: View {
    @Binding var screen: Screen

    var body: some View {
        SighticView { result in
            switch result {
            case .success(let recording):
                screen = .inference(recording)
            case .failure(let error):
                screen = .error(.recordingError(error))
            }
        }
    }
}

#Preview {
    ScanView(
        screen: .constant(.scan)
    )
}
