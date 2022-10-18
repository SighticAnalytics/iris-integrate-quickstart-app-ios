//
//  Copyright © 2022 Sightic Analytics AB All rights reserved.
//

import UIKit
import SwiftUI
import SighticAnalytics

class TestViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let sighticView = SighticView(apiKey: "secret_api_key", completion: { sighticRecording in
            /*
             The app now has the SighticRecording. We
             want to present a waiting screen while waiting
             for the result from Sightic backend.
             We update the app state to trigger the waiting screen.
             */
            model.appState = AppState.waiting
            Task {
                do {
                    /*
                     Send the recording to Sightic for analysis. The result
                     will be returned when analysis is done. The QuickStart
                     app passes the result to the app state and uses this
                     in the result view.
                     */
                    let result = try await sighticRecording.performInference()
                    model.appState = .result(result)
                } catch SighticError.invalidApiKey {
                    print("Invalid API key")
                    model.appState = .start
                } catch {
                    print("Error while analyzing the result")
                    model.appState = .start
                }
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
