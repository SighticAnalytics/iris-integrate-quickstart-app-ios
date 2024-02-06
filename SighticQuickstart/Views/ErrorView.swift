//
// Copyright © 2022-2024 Sightic Analytics AB. All rights reserved.
//

import SighticAnalytics
import SwiftUI

/// View displaying an error received by Sightic SDK.
struct ErrorView: View {
    @Binding var screen: Screen
    let error: Error

    @State var agreeWithResult: Bool = true
    @State var feedbackText: String = ""
    @FocusState var textEditorFocused: Bool
    @State private var showAlert = false

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
        error: .recordingError(.user(.headTooFarAway))
    )
}
