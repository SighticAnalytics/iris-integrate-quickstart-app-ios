//
//  Copyright © 2022 Sightic Analytics AB All rights reserved.
//

import UIKit
import SwiftUI
import SighticAnalytics

/// The ``TestViewController`` acts as a container view for the ``SighticInferenceView``.
///
/// See https://github.com/EyescannerTechnology/sightic-sdk-ios/blob/main/README.md
/// regarding how to use the ``SighticInferenceView`` view.
class TestViewController: UIViewController {
    func sendRecodingForAnalysis(_ sighticInferenceRecording: SighticInferenceRecording) {
        Task.init {
            /*
             - The app now has a SighticRecording that we can call
               performInference on to send the recording Sightic server
               for analysis.

             - We update appstate to show a waiting view while
               waiting for the test result from the Sightic backend.

             - We update the app state with the inference result after
               receving it back from performInference. It
               will be used in the ResultView.
             */
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

    override func viewDidLoad() {
        super.viewDidLoad()
        /// The API key e4c4e2f7-aedc-4462-a74f-5a43967346b9 is specific
        /// for the Quickstart app and shall not be used in production.
        let sighticView = SighticInferenceView(apiKey: "e4c4e2f7-aedc-4462-a74f-5a43967346b9",
                                               skipInstructions: false,
                                               completion:
                                                    { [weak self] sighticInferenceRecordingResult in
                                                      guard let self = self else { return }
                                                      switch sighticInferenceRecordingResult {
                                                      case .success(let sighticInferenceRecording):
                                                          self.sendRecodingForAnalysis(sighticInferenceRecording)
                                                      case .failure(let sighticError):
                                                          model.appState = .error(sighticError)
                                                  }
                                  })

        let sighticViewController = UIHostingController(rootView: sighticView)

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
