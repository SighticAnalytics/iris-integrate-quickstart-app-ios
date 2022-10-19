//
//  Copyright © 2022 Sightic Analytics AB All rights reserved.
//

import UIKit
import SwiftUI
import SighticAnalytics

class TestViewController: UIViewController {
    func sendRecodingForAnalysis(_ sighticRecording: SighticRecording) {
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
            let inferenceResult = await sighticRecording.performInference()
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
        let sighticView = SighticView(apiKey: "secret_api_key",
                                      completion:
                                        { [weak self] sighticRecordingResult in
                                          guard let self = self else { return }
                                          switch sighticRecordingResult {
                                          case .success(let sighticRecording):
                                              self.sendRecodingForAnalysis(sighticRecording)
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
