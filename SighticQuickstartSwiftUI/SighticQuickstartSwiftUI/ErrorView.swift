//
//  Copyright © 2022 Sightic Analytics AB All rights reserved.
//

import SwiftUI
import SighticAnalytics

struct ErrorView: View {
    @Binding var appState: AppState

    func generateErrorText(error: SighticError) -> String {
        let text = "SighticError: \(error.localizedDescription)"
        return text
    }

    var body: some View {
        switch appState {
        case .error(let sighticError):
            VStack {
                Text("Sightic SDK Quickstart")
                    .font(.title)
                    .padding()
                Spacer()
                Text("ErrorView")
                    .font(.title2)
                    .padding()
                Text(generateErrorText(error: sighticError))
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

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(appState: .constant(.error(SighticError.noConnection)))
    }
}

