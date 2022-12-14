//
//  Copyright © 2022 Sightic Analytics AB All rights reserved.
//

import UIKit
import SighticAnalytics

/// The `StatusViewController` is added as overlay over the `SighticInferenceView`
/// in the `TestViewController` if the QuickStart app user has selected to "Show raw alignment status"
/// in the `StartViewController`. The purpose is to demonstrate how the app can implement its own
/// version of the alignment view instead of using the view provided by SighticAnalytics.
class StatusViewController: UIViewController {
    let sighticStatusLabel = UIQuickstartBody(text: "")
    let alignmentStatusLabel = UIQuickstartBody(text: "")
    let offsetOrTiltLabel = UIQuickstartBody(text: "")

    func handleSighticAlignmentStatus(_ aligmentStatus: SighticAlignmentStatus) {

        var alignmentStatusLabelText = "SighticAlignmentStatus: "
        switch aligmentStatus {
        case .noFaceTracked, .tooFarAway, .noAttention, .blink, .ok:
            alignmentStatusLabelText += "\(aligmentStatus)"
            offsetOrTiltLabel.text = ""
        case .notCentered(let sighticHeadOffset):
            alignmentStatusLabelText += "notCentered"
            offsetOrTiltLabel.text = "SighticHeadOffset: \(sighticHeadOffset)"
        case .headTilted(let sighticHeadTilt):
            alignmentStatusLabelText += "headTilted"
            offsetOrTiltLabel.text = "SighticHeadTilt: \(sighticHeadTilt)"
        @unknown default:
            break
        }
        alignmentStatusLabel.text = alignmentStatusLabelText
    }

    func handleSighticStatus(_ sighticStatus: SighticStatus) {
        var sighticStatusLabelText = "SighticStatus: "
        switch sighticStatus {
        case .instruction:
            sighticStatusLabelText += "instruction"
        case .align:
            sighticStatusLabelText += "align"
        case .countdown(let int):
            sighticStatusLabelText += "countdown(\(int))"
        case .test:
            sighticStatusLabelText += "test"
        @unknown default:
            break
        }
        sighticStatusLabel.text = sighticStatusLabelText

        switch sighticStatus {
        case .align(let sighticAlignmentStatus):
            handleSighticAlignmentStatus(sighticAlignmentStatus)
        case .countdown, .instruction, .test:
            alignmentStatusLabel.text = ""
            offsetOrTiltLabel.text = ""
        @unknown default:
            break
        }
    }

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

        let title = UIQuickstartTitle(title: "SighticStatus")
        let spacer1 = UIQuickstartSpacer()
        let spacer2 = UIQuickstartSpacer()

        sv.addArrangedSubview(title)
        sv.addArrangedSubview(spacer1)
        sv.addArrangedSubview(sighticStatusLabel)
        sv.addArrangedSubview(alignmentStatusLabel)
        sv.addArrangedSubview(offsetOrTiltLabel)
        sv.addArrangedSubview(spacer2)

        NSLayoutConstraint.activate([
            spacer2.heightAnchor.constraint(equalTo: spacer1.heightAnchor)
        ])
    }
}
