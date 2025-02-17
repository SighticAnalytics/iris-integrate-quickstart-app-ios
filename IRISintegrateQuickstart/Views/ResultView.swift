//
// Copyright © 2022-2025 Sightic Analytics AB. All rights reserved.
//

import IRISintegrate
import SwiftUI

/// View that presents the inference result.
struct ResultView: View {
    @Binding var screen: Screen
    let inference: SighticInference

    var body: some View {
        VStack {
            Header(
                title: "Result",
                subtitle: inference.hasImpairment
                    ? "The scan result is positive."
                    : "The scan result is negative.",
                background: inference.hasImpairment ? .orange : .green
            )

            Spacer()

            HugeButton("Done") {
                screen = .start
            }

            Spacer()
        }
    }
}

#Preview("Negative") {
    ResultView(
        screen: .constant(.result(SighticMock.inference(hasImpairment: false))),
        inference: SighticMock.inference(hasImpairment: false)
    )
}

#Preview("Positive") {
    ResultView(
        screen: .constant(.result(SighticMock.inference(hasImpairment: true))),
        inference: SighticMock.inference(hasImpairment: true)
    )
}
