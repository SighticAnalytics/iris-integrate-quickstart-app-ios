//
// Copyright © 2022-2024 Sightic Analytics AB. All rights reserved.
//

import SighticAnalytics
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
                    ? "The test result is positive."
                    : "The test result is negative.",
                background: inference.hasImpairment ? .orange : .green
            )

            Spacer()

            HugeButton("Done") {
                screen = .start
            }

            LargeButton("Give feedback", color: .green) {
                screen = .feedback(inference)
            }
            .padding()

            Spacer()
        }
    }
}

#Preview("Negative") {
    ResultView(
        screen: .constant(.result(SighticMock.inferenceNegative)),
        inference: SighticMock.inferenceNegative
    )
}

#Preview("Positive") {
    ResultView(
        screen: .constant(.result(SighticMock.inferencePositive)),
        inference: SighticMock.inferencePositive
    )
}
