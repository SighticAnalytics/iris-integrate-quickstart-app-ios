//
// Copyright © 2022-2024 Sightic Analytics AB. All rights reserved.
//

import IRISintegrate
import SwiftUI

/// View that presents a UI for providing feedback on the inference result.
struct FeedbackView: View {
    @Binding var screen: Screen
    let inference: SighticInference

    @State private var isAgreeing: Bool = true
    @State private var comment: String = ""
    @State private var isSending: Bool = false
    @State private var showAlert = false
    @FocusState private var editorFocused: Bool

    var body: some View {
        VStack {
            Header(
                title: "Feedback",
                subtitle: "Give us your feedback on the result."
            )

            VStack {
                Toggle("Do you agree with the result?", isOn: $isAgreeing)

                TextEditor(text: $comment)
                    .focused($editorFocused)
                    .padding(4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8).stroke(.secondary)
                    )
                    .frame(height: 150)
                    .padding(.vertical)

                HStack {
                    Button("Cancel") { screen = .start }

                    Spacer()

                    if isSending {
                        ProgressView()
                    } else {
                        Button("Send") {
                            Task { await sendFeedback() }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
            .disabled(isSending)
            .padding()

            Spacer()
        }
        .onAppear {
            editorFocused = true
        }
        .alert(
            "Send failed",
            isPresented: $showAlert,
            actions: {
                Button("OK") { showAlert = false }
            },
            message: {
                Text("Failed to send feedback to Sightic Analytics.")
            }
        )
    }

    @MainActor
    private func sendFeedback() async {
        isSending = true
        defer { isSending = false }

        do {
            try await Task { try await inference.sendFeedback(
                isAgreeing ? .agree : .disagree,
                comment: comment
            )}.value
            screen = .start
        } catch {
            showAlert = true
        }
    }
}

#Preview {
    FeedbackView(
        screen: .constant(.result(SighticMock.inferenceNegative)),
        inference: SighticMock.inferenceNegative
    )
}
