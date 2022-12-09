//
//  Copyright © 2022 Sightic Analytics AB All rights reserved.
//

import UIKit
import SwiftUI
import SighticAnalytics

/// The TestViewController contains the SighticInferenceView. It might also add the AlignmentStatusViewController
/// as overlay on SighticInferenceView if the QuickStart app user has selected to "Show raw alignment status"
/// in the StartView. The purpose is to demonstrate how the app can implement its own version of the alignment view
/// instead of using the view provided by SighticAnalytics.
class TestViewController: UIViewController {
    var statusViewController: StatusViewController?
    var sighticViewController: UIHostingController<SighticInferenceView>?

    private var sighticInferenceViewConfiguration: SighticInferenceViewConfiguration {
        if case .test(let sighticInferenceViewConfiguration) = model.appState {
            return sighticInferenceViewConfiguration
        } else {
            return SighticInferenceViewConfiguration()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addSighticViewController()
        addAlignmentStatusViewController()
    }

    /// Create an instance of SighticInferenceView and provide callbacks to get  SighticStatus updates
    /// and the SighticInferenceRecordingResult. The SighticStatus can be used if the app wants
    /// to implement its own version of alignment view instead of using the default one provided
    /// by SighticAnalytics.
    private func addSighticViewController() {
        let sighticView =
        SighticInferenceView(apiKey: AppDelegate.apiKey,
                             showInstructions: sighticInferenceViewConfiguration.showInstructions,
                             statusCallback: self.handleSighticStatus,
                             completion: self.handleResult)

        sighticViewController = UIHostingController(rootView: sighticView)

        if let sighticViewController = sighticViewController {
            sighticViewController.view.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(sighticViewController.view)
            addChild(sighticViewController)
            sighticViewController.didMove(toParent: self)
            NSLayoutConstraint.activate([
                sighticViewController.view.topAnchor.constraint(equalTo: self.view.topAnchor),
                sighticViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                sighticViewController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                sighticViewController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            ])
        }
    }

    private func addAlignmentStatusViewController() {
        guard statusViewController == nil else { return }

        statusViewController = StatusViewController()

        if let statusViewController = statusViewController {
            view.addSubview(statusViewController.view)
            addChild(statusViewController)
            statusViewController.didMove(toParent: self)

            NSLayoutConstraint.activate([
                statusViewController.view.topAnchor.constraint(equalTo: self.view.topAnchor),
                statusViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                statusViewController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                statusViewController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            ])
        }
    }

    /// Handle the result from the SighticInferenceView after the test has finished.
    private func handleResult(_ sighticInferenceRecordingResult: SighticInferenceRecordingResult) {
        switch sighticInferenceRecordingResult {
        case .success(let sighticInferenceRecording):
            self.sendRecodingForAnalysis(sighticInferenceRecording)
        case .failure(let sighticError):
            model.appState = .error(sighticError)
        }
    }

    /// Send the recording returned by the SighticInferenceView to the SighticAnalytics backend for analysis.
    private func sendRecodingForAnalysis(_ sighticInferenceRecording: SighticInferenceRecording) {
        Task.init {
            model.appState = AppState.waiting
            let inferenceResult = await sighticInferenceRecording.performInference()
            switch inferenceResult {
            case .success(let sighticInference):
                model.appState = .result(sighticInference)
            case .failure(let sighticError):
                model.appState = .error(sighticError)
            }
        }
    }

    /// Use the `SighticStatus` to determine whether the `AlignmentStatusViewController` shall be shown.
    /// Propagate `SighticStatus` to the `AliginmentStatusViewController`.
    private func handleSighticStatus(_ sighticStatus: SighticStatus) {
        if shallShowAlignmentStatusView(sighticStatus) {
            showAlignmentView()
            statusViewController?.handleSighticStatus(sighticStatus)
        } else {
            showSighticView()
        }
    }

    /// We only want to overlay `SighticInferenceView` with our own `AlignmentStatusViewController`
    /// if `SighticStatus` is `align` or `countdown` and the QuickStart app user has selected to show
    /// raw alignment status in the `StartView`.
    private func shallShowAlignmentStatusView(_ sighticStatus: SighticStatus) -> Bool {
        switch sighticStatus {
        case .align, .countdown:
            if sighticInferenceViewConfiguration.showRawAlignmentStatus {
                return true
            } else {
                return false
            }
        case .instruction, .test:
            return false
        }
    }

    /// Show AlignmentStatusViewController on top of SighticInferenceView
    private func showAlignmentView() {
        if let statusViewController = statusViewController {
            view.bringSubviewToFront(statusViewController.view)
        }
    }
    /// Show SighticInferenceView on top of AlignmentStatusViewController
    private func showSighticView() {
        if let sighticViewController = sighticViewController {
            view.bringSubviewToFront(sighticViewController.view)
        }
    }
}
