//
// Copyright © 2022-2023 Sightic Analytics AB. All rights reserved.
//

import SwiftUI
import SighticAnalytics

struct FeedbackView: View {
    @Binding var appState: AppState
    @State var agreeWithResult: Bool = true
    @State var feedbackText: String = ""
    @FocusState var textEditorFocused: Bool
    @State private var showAlert = false

    func sendFeedback() async {
        if case .feedback(let sighticInference) = appState {
            let feedbackSentSuccess = await sighticInference.sendFeedback(
                agreement: agreeWithResult ? Feedback.agree : Feedback.disagree,
                comment: feedbackText
            )
            if !feedbackSentSuccess {
                showAlert = true
            } else {
                appState = .start
            }
        } else {
            appState = .start
        }
    }

    var body: some View {
        switch appState {
        case .feedback:
            VStack {
                Text("Sightic SDK Quickstart")
                    .font(.title)
                    .padding()
                Spacer()
                Text("FeedbackView")
                    .font(.title2)
                    .padding()
                Toggle("Do you agree with the result?", isOn: $agreeWithResult)
                    .padding()
                TextEditor(text: $feedbackText)
                    .focused($textEditorFocused)
                    .onAppear {
                        self.textEditorFocused = true
                    }
                    .border(.black)
                    .padding()
                    .frame(height: 150)
                Button("Send feedback") {
                    Task { await sendFeedback() }
                }
                .padding()
                Button("Skip feedback") {
                    appState = .start
                }
                .padding()
                Spacer()
            }
            .alert("Send failed", isPresented: $showAlert, actions: {
                Button("OK") { appState = .start }
            }, message: {
                Text("Failed to send feedback to backend.")
            })
        default:
            Text("Invalid app state")
        }
    }
}
