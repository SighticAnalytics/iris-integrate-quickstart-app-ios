//
//  Copyright © 2022 Sightic Analytics AB All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let sv = UIQuickstartStackview()
        view.addSubview(sv)
        NSLayoutConstraint.activate([
            sv.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            sv.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            sv.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            sv.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])

        let title = UIQuickstartTitle(title: "Sightic SDK Quickstart")
        let spacer1 = UIQuickstartSpacer()
        let body = UIQuickstartBody(text: "StartView")
        let button = UIQuickstartButton(title: "Go to test", action: {
            model.appState = .test
        })
        let spacer2 = UIQuickstartSpacer()

        sv.addArrangedSubview(title)
        sv.addArrangedSubview(spacer1)
        sv.addArrangedSubview(body)
        sv.addArrangedSubview(button)
        sv.addArrangedSubview(spacer2)

        NSLayoutConstraint.activate([
            spacer2.heightAnchor.constraint(equalTo: spacer1.heightAnchor)
        ])
    }
}

