//
//  TestView.swift
//  SighticQuickstart
//
//  Copyright © 2022 Sightic Analytics AB All rights reserved.
//

import SwiftUI
import SighticAnalytics

/// The ``TestView`` acts as a container view for the ``SighticView``.
///
/// 1. Create a ``SighticView`` and let it occupy the whole screen.
/// 2. Provide an API key to the ``SighticView``.
/// 3. Provide a completion handler to SighticView
///    - The completion handler will receive a
///      ``SighticRecording``.
///    - ``SighticRecording`` implements the function
///      ``performInference`` that sends the recording
///      to the Sightic backend for analysis.
/// 4. The function ``peformInference`` will through an error if the API key
///    is not valid.
struct TestView: View {
    @Binding var appState: AppState

    var body: some View {
        SighticView(apiKey: "secret_api_key", completion: { sighticRecording in
                /*
                 The app now has the SighticRecording but we
                 want to present a waiting screen while waiting
                 for the result from Sightic backend.
                 We update the app state to trigger the waiting screen.
                 */
                appState = .waitingForAnalysis
            Task {
                do {
                    /*
                     Send the recording to Sightic for analysis. The result
                     will be returned when analysis is done. The QuickStart
                     app passes the result to the app state and uses this
                     in the result view.
                     */
                    let result = try await sighticRecording.performInference()
                        appState = .result(result)
                } catch SighticError.invalidApiKey {
                    print("Invalid API key")
                    appState = .start
                } catch {
                    print("Error while analyzing the result")
                    appState = .start
                }
            }
        })
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView(appState: .constant(.test))
    }
}
