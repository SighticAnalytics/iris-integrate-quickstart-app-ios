//
// Copyright © 2022-2023 Sightic Analytics AB. All rights reserved.
//

import UIKit
import SwiftUI
import SighticAnalytics

/// The TestViewController contains the SighticInferenceView. It also adds the AlignmentStatusViewController
/// as overlay on SighticInferenceView. AlignmentStatusViewController makes use of the optional `statusCallback` parameter
/// to `SighticInferenceView` to get updates with `SighticStatus`.
class TestViewController: UIViewController {
    var alignmentHintViewController: AlignmentHintViewController?
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
        addAlignmentHintViewController()
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

    private func addAlignmentHintViewController() {
        guard alignmentHintViewController == nil else { return }
        alignmentHintViewController = AlignmentHintViewController()
        guard let alignmentHintViewController = alignmentHintViewController else {
            fatalError("missing alignment hint view controller")
        }

        // ...otherwise you can't tap the buttons in the simulator view below it
        alignmentHintViewController.view.isUserInteractionEnabled = false

        view.addSubview(alignmentHintViewController.view)
        addChild(alignmentHintViewController)
        alignmentHintViewController.didMove(toParent: self)

        NSLayoutConstraint.activate([
            alignmentHintViewController.view.topAnchor.constraint(equalTo: self.view.topAnchor),
            alignmentHintViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            alignmentHintViewController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            alignmentHintViewController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor),
        ])
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
            let inferenceResult = await sighticInferenceRecording.performInference(allowToSave: sighticInferenceViewConfiguration.allowToSave)
            switch inferenceResult {
            case .success(let sighticInference):
                model.appState = .result(sighticInference)
            case .failure(let sighticError):
                model.appState = .error(sighticError)
            }
        }
    }

    /// Use the `SighticStatus` to show alignment hints using the `AlignmentStatusViewController` as an overlay
    private func handleSighticStatus(_ sighticStatus: SighticStatus) {
        if shallShowAlignmentHintView(sighticStatus) {
            showAlignmentHintView()
            alignmentHintViewController?.handleSighticStatus(sighticStatus)
        } else {
            showSighticView()
        }
    }

    /// We only want to overlay `SighticInferenceView` with our own `AlignmentStatusViewController`
    /// if `SighticStatus` is `align` or `countdown`
    private func shallShowAlignmentHintView(_ sighticStatus: SighticStatus) -> Bool {
        switch sighticStatus {
        case .align, .countdown:
            return true
        case .instruction, .test:
            return false
        @unknown default:
            return false
        }
    }

    /// Show AlignmentHintViewController on top of SighticInferenceView
    private func showAlignmentHintView() {
        if let alignmentHintViewController = alignmentHintViewController {
            view.bringSubviewToFront(alignmentHintViewController.view)
        }
    }

    /// Show SighticInferenceView on top of AlignmentStatusViewController
    private func showSighticView() {
        if let sighticViewController = sighticViewController {
            view.bringSubviewToFront(sighticViewController.view)
        }
    }
}
