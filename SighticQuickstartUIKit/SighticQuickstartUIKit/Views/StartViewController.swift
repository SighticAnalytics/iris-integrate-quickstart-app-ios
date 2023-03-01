//
// Copyright © 2022-2023 Sightic Analytics AB. All rights reserved.
//

import UIKit
import SighticAnalytics

/// The StartView shows
/// * SDK version
/// * Whether SDK version is supported by the SighticAnalytics backend
/// * Whether current device is supported by the SDK
/// * Two switches to let the QuickStart app user configure how to use the SighticInferenceView.
///
/// The app user can select whether SighticInferenceView should show instructions screens prior
/// to showing the alignment view.
///
/// The app user can select whether the QuickStart app shall overlay the alignment step in the
/// SighticInferenceView with its own alignment view. The QuickStart app implements a basic
/// AlignmentStatusViewController that shows the raw value of SighticStatus which is provided by
/// SighticInferenceView.
class StartViewController: UIViewController {
    let sv = UIQuickstartStackview()
    let deviceSupport = UIQuickstartBody(text: "Loading...")
    var button: UIButton?

    var sighticInferenceViewConfiguration = SighticInferenceViewConfiguration()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(sv)
        NSLayoutConstraint.activate([
            sv.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            sv.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            sv.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            sv.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])

        let title = UIQuickstartTitle(title: "Sightic SDK Quickstart")
        let sdkVersion = UIQuickstartBody(text: "SDK Version: \(SighticVersion.sdkVersion)")
        let spacer1 = UIQuickstartSpacer()
        let startViewTitle = UIQuickstartBody(text: "StartView")
        let spacer2 = UIQuickstartSpacer()
        let testConfigurationTitle = UIQuickstartBody(text: "SighticInferenceView configuration:")
        let switch1 = UIQuickstartSwitch(title: "Show instructions",
                                         initialValue: sighticInferenceViewConfiguration.showInstructions,
                                         action: { isOn in
            self.sighticInferenceViewConfiguration.showInstructions = isOn
            print("showInstructions = \(self.sighticInferenceViewConfiguration.showInstructions)")
        })
        let switch2 = UIQuickstartSwitch(title: "Allow-To-Save",
                                         initialValue: sighticInferenceViewConfiguration.allowToSave,
                                         action: { isOn in
            self.sighticInferenceViewConfiguration.allowToSave = isOn
            print("allow-to-save = \(self.sighticInferenceViewConfiguration.allowToSave)")
        })
        self.button = UIQuickstartButton(title: "Go to test", action: {
            self.goToTest()
        })
        let spacer3 = UIQuickstartSpacer()
        let sdkSupportTitle = UIQuickstartBody(text: "SDK version support?")
        let spacer4 = UIQuickstartSpacer()
        let deviceSupportTitle = UIQuickstartBody(text: "Device model support?")
        let spacer5 = UIQuickstartSpacer()

        // Title and SDK version
        sv.addArrangedSubview(title)
        sv.addArrangedSubview(sdkVersion)

        sv.addArrangedSubview(spacer1)

        sv.addArrangedSubview(startViewTitle)
        sv.addArrangedSubview(spacer2)

        // Two switches to let QuickStart app user configure SighticInferenceView
        sv.addArrangedSubview(testConfigurationTitle)
        sv.addArrangedSubview(switch1)
        sv.addArrangedSubview(switch2)
        sv.addArrangedSubview(button!)

        sv.addArrangedSubview(spacer3)

        // Show whether backend supports current SDK version
        sv.addArrangedSubview(sdkSupportTitle)

        sv.addArrangedSubview(spacer4)

        // Show whether current device is supported by the SDK
        sv.addArrangedSubview(deviceSupportTitle)
        sv.addArrangedSubview(deviceSupport)

        sv.addArrangedSubview(spacer5)

        NSLayoutConstraint.activate([
            spacer3.heightAnchor.constraint(equalTo: spacer1.heightAnchor),
            spacer5.heightAnchor.constraint(equalTo: spacer1.heightAnchor),
            spacer4.heightAnchor.constraint(equalTo: sdkSupportTitle.heightAnchor),
            spacer2.heightAnchor.constraint(equalTo: spacer1.heightAnchor)
        ])

        loadDeviceSupport()
    }

    func loadDeviceSupport() {
        Task {
            guard let device = try? await isDeviceModelSupported() else {
                return
            }

            if device.isCurrentSupported {
                deviceSupport.text = "iDevice supported (\(device.currentDevice))"
                deviceSupport.textColor = .green
            } else {
                deviceSupport.text = "Unsupported iDevice (\(device.currentDevice))"
                deviceSupport.textColor = .red
            }
        }
    }

    func goToTest() {
        Task {
            model.appState = .test(sighticInferenceViewConfiguration)
        }
    }

    func isDeviceModelSupported() async throws -> SighticSupportedDevices {
        do {
            return try await SighticSupportedDevices()
        } catch {
            print("Error while checking for supprted devices: \(error)")
            throw error
        }
    }
}
