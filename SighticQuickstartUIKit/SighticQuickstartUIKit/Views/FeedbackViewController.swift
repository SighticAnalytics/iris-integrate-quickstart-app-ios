//
//  Copyright © 2023 Sightic Analytics AB All rights reserved.
//

import UIKit
import SighticAnalytics

class FeedbackViewController: UIViewController {

    let feedbackForm: UIQuickstartTextView
    var agreeWithResult: Bool = true

    init() {
        feedbackForm = UIQuickstartTextView()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func sendFeedback(feedbackText: String) async {
        if case .feedback(let sighticInference) = model.appState {
            let feedback = agreeWithResult ? Feedback.agree : Feedback.disagree
            let feedbackSentSuccess = await sighticInference.sendFeedback(agreement: feedback, comment: feedbackText)
            if !feedbackSentSuccess {
                showErrorAlert()
            } else {
                model.appState = .start
            }
        } else {
            model.appState = .start
        }
    }

    func showErrorAlert() {
        let alert = UIAlertController(title: "Feedback", message: "Failed to send feedback.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            model.appState = .start
        }))
        self.present(alert, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let sv = UIQuickstartStackview()
        sv.spacing = 10
        view.addSubview(sv)
        NSLayoutConstraint.activate([
            sv.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            sv.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            sv.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            sv.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])

        let title = UIQuickstartTitle(title: "Sightic SDK Quickstart")
        let body = UIQuickstartBody(text: "FeedbackView")
        let switchAgree = UIQuickstartSwitch(title: "Do you agree with the result?",
                                        initialValue: self.agreeWithResult,
                                        action: { isOn in
            self.agreeWithResult = isOn
        })
        let feedbackFormTitle = UIQuickstartBody(text: "Please add a comment about the result")
        let sendFeedbackButton = UIQuickstartButton(title: "Send feedback", action: {
            let _ = self.feedbackForm.resignFirstResponder()
            Task {
                await self.sendFeedback(feedbackText: self.feedbackForm.text)
            }
        })
        let skipFeedbackButton = UIQuickstartButton(title: "Skip feedback", action: {
            let _ = self.feedbackForm.resignFirstResponder()
            model.appState = .start
        })
        let spacer2 = UIQuickstartSpacer()

        sv.addArrangedSubview(title)
        sv.addArrangedSubview(body)
        sv.addArrangedSubview(switchAgree)
        sv.addArrangedSubview(feedbackFormTitle)
        sv.addArrangedSubview(feedbackForm)
        sv.addArrangedSubview(sendFeedbackButton)
        sv.addArrangedSubview(skipFeedbackButton)
        sv.addArrangedSubview(spacer2)
    }

    override func viewWillAppear(_ animated: Bool) {
        let _ = feedbackForm.becomeFirstResponder()
    }
}
