//
// Copyright © 2022-2025 Sightic Analytics AB. All rights reserved.
//

import IRISintegrate
import SwiftUI

/// View displaying an error received by Sightic SDK.
struct ErrorView: View {
    @Binding var screen: Screen
    let error: Error

    var body: some View {
        VStack {
            Header(
                title: "Error",
                subtitle: error.description,
                background: .red
            )

            Spacer()

            HugeButton("Done") {
                screen = .start
            }

            Spacer()
        }
    }
}

#Preview {
    ErrorView(
        screen: .constant(.start),
        error: .recordingError(.user(.notFollowingDot))
    )
}
