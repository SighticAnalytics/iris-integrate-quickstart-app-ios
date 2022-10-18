//
//  Copyright © 2022 Sightic Analytics AB All rights reserved.
//

import UIKit
import Combine

class HostViewController: UIViewController {
    var cancellable: AnyCancellable?
    var vc: UIViewController?

    /// Show view controller corresponding to current app state
    func navigate(appState: AppState) {
        vc?.removeFromParent()

        switch appState {
        case .start:
            vc = StartViewController()
        case .test:
            vc = TestViewController()
        case .waiting:
            vc = WaitingViewController()
        case .result:
            vc = ResultViewController()
        }

        guard let vc = vc else { fatalError() }

        view.addSubview(vc.view)
        addChild(vc)
        vc.didMove(toParent: self)

        NSLayoutConstraint.activate([
            vc.view.topAnchor.constraint(equalTo: self.view.topAnchor),
            vc.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            vc.view.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            vc.view.rightAnchor.constraint(equalTo: self.view.rightAnchor),
        ])

    }

    override func viewDidLoad() {
        cancellable = model.$appState.receive(on: DispatchQueue.main)
                                     .sink { [weak self] appState in
                                             guard let self = self else { fatalError()}
                                             self.navigate(appState: appState)
                                           }
    }
}
