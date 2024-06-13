//
// Copyright © 2022-2024 Sightic Analytics AB. All rights reserved.
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

            HStack {
                SubstanceResult(substance: .alcohol, hasImpairment: inference.hasAlcoholImpairment)
                if let hasCannabisImpairment = inference.hasCannabisImpairment {
                    SubstanceResult(substance: .cannabis, hasImpairment: hasCannabisImpairment)
                }
            }

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

private struct SubstanceResult: View {
    let substance: Substance
    let hasImpairment: Bool
    let text: String
    private let cornerSize = CGSize(width: 20, height: 20)

    enum Substance {
        case alcohol
        case cannabis
    }

    var title: String {
        switch substance {
        case .alcohol: "Alcohol"
        case .cannabis: "Cannabis"
        }
    }

    init(substance: Substance, hasImpairment: Bool) {
        self.substance = substance
        self.hasImpairment = hasImpairment
        self.text = if hasImpairment {
            "Possible impairment."
        } else {
            "No impairment detected."
        }
    }

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Spacer()
            Text(title)
                .font(.title3)
            Spacer()
            Text(text).multilineTextAlignment(.center)
            Spacer()
        }
        .aspectRatio(1.0, contentMode: .fit)
        .frame(width: 150)
        .foregroundStyle(.white)
        .background(hasImpairment ? .orange : .green)
        .clipShape(RoundedRectangle(cornerSize: cornerSize))
    }
}

#Preview("Negative") {
    ResultView(
        screen: .constant(.result(SighticMock.inferenceNegative)),
        inference: SighticMock.inferenceNegative
    )
}

#Preview("Positive Alcohol") {
    ResultView(
        screen: .constant(.result(SighticMock.inferencePositiveAlcohol)),
        inference: SighticMock.inferencePositiveAlcohol
    )
}

#Preview("Positive Cannabis") {
    ResultView(
        screen: .constant(.result(SighticMock.inferencePositiveCannabis)),
        inference: SighticMock.inferencePositiveCannabis
    )
}

#Preview("SubstanceResult") {
    VStack(spacing: 16) {
        HStack {
            SubstanceResult(substance: .alcohol, hasImpairment: true)
            SubstanceResult(substance: .alcohol, hasImpairment: false)
        }
        HStack {
            SubstanceResult(substance: .cannabis, hasImpairment: true)
            SubstanceResult(substance: .cannabis, hasImpairment: false)
        }
    }
}
