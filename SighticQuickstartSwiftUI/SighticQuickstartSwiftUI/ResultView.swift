//
// Copyright © 2022-2023 Sightic Analytics AB. All rights reserved.
//

import SwiftUI
import SighticAnalytics

struct ResultView: View {
    @Binding var appState: AppState

    func generateResultText(_ inference: SighticInference) -> String {
        "hasImpairment = \(inference.hasImpairment)"
    }

    var body: some View {
        switch appState {
        case .result(let sighticInference):
            VStack {
                Text("Sightic SDK Quickstart")
                    .font(.title)
                    .padding()
                Spacer()
                Text("ResultView")
                    .font(.title2)
                    .padding()
                Text(generateResultText(sighticInference))
                    .padding()
                Button("Go to feedback") {
                    appState = .feedback(sighticInference)
                }
                Spacer()
            }
        default:
            Text("Invalid app state")
        }
    }
}
