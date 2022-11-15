//
//  Copyright © 2022 Sightic Analytics AB All rights reserved.
//

import SwiftUI
import SighticAnalytics

struct ResultView: View {
    @Binding var appState: AppState

    func generateResultText(_ inference: SighticInference) -> String {
        let text = "hasImpairment = \(inference.hasImpairment)"
        return text
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
                Button(action: {
                        appState = .start
                },
                       label: { Text("Go to start") })
                Spacer()
            }
        default:
            Text("Invalid app state")
        }
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(appState: .constant(.result(SighticInference(hasImpairment: true))))
    }
}
