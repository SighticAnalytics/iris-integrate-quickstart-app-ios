//
//  Copyright © 2022 Sightic Analytics AB All rights reserved.
//

import UIKit
import SighticAnalytics

/// The `AlignmentHintViewController` is added as overlay over the `SighticInferenceView`
class AlignmentHintViewController: UIViewController {
    let alignmentStatusLabel = UIQuickstartAlignmentHint()
    let countdown = UIQuickstartCircle()
    let sv = UIQuickstartStackview()

    func handleSighticStatus(_ sighticStatus: SighticStatus) {
        if case .countdown(let countdownNumber) = sighticStatus {
            if countdown.superview == nil {
                sv.insertArrangedSubview(countdown, at: 2)
            }
            countdown.text = "\(countdownNumber)"
        } else {
            countdown.removeFromSuperview()
        }

        switch sighticStatus {
        case .align(let sighticAlignmentStatus):
            alignmentStatusLabel.text = sighticAlignmentStatus.message
        case .countdown:
            alignmentStatusLabel.text = SighticAlignmentStatus.ok.message
        case .instruction, .test:
            alignmentStatusLabel.text = ""
        @unknown default:
            break
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(sv)
        NSLayoutConstraint.activate([
            sv.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            sv.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            sv.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            sv.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])

        let spacer1 = UIQuickstartSpacer()
        let spacer2 = UIQuickstartSpacer()

        sv.addArrangedSubview(spacer1)
        sv.addArrangedSubview(alignmentStatusLabel)
        sv.addArrangedSubview(spacer2)

        NSLayoutConstraint.activate([
            spacer1.heightAnchor.constraint(equalToConstant: 180)
        ])
    }
}
