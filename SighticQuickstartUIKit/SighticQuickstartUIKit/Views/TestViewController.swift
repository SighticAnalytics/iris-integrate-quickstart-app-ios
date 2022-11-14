//
//  Copyright © 2022 Sightic Analytics AB All rights reserved.
//

import UIKit
import SwiftUI
import SighticAnalytics

class TestViewController: UIViewController {
    func sendRecodingForAnalysis(_ sighticInferenceRecording: SighticInferenceRecording) {
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

    override func viewDidLoad() {
        super.viewDidLoad()
        let sighticView = SighticInferenceView(apiKey: AppDelegate.apiKey,
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
