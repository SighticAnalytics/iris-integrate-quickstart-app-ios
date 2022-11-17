//
//  Copyright © 2022 Sightic Analytics AB All rights reserved.
//

import UIKit
import SighticAnalytics

class StartViewController: UIViewController {
    var runAnyway: Bool = false

    let sv = UIQuickstartStackview()
    let errorMessages = UIQuickstartBody(text: "")
    var button: UIButton?

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
        let body1 = UIQuickstartBody(text: "SDK Version: \(SighticVersion.sdkVersion)")
        let spacer1 = UIQuickstartSpacer()
        let body2 = UIQuickstartBody(text: "StartView")
        self.button = UIQuickstartButton(title: "Go to test", action: {
            self.goToTest()
        })
        let spacer2 = UIQuickstartSpacer()
        
        
        sv.addArrangedSubview(title)
        sv.addArrangedSubview(body1)
        sv.addArrangedSubview(spacer1)
        sv.addArrangedSubview(body2)
        sv.addArrangedSubview(button!)
        sv.addArrangedSubview(spacer2)

        NSLayoutConstraint.activate([
            spacer2.heightAnchor.constraint(equalTo: spacer1.heightAnchor)
        ])
    }
    
    func setErrorMessages(_ messages: [String]) {
        guard !messages.isEmpty else {
            sv.removeArrangedSubview(errorMessages)
            return
        }

        errorMessages.text = messages.joined(separator: "\n")
        errorMessages.textColor = .red
        sv.insertArrangedSubview(errorMessages, at: 4)
    }
    
    func goToTest() {
        Task {
            let isSDKSupported = (try? await isSDKVersionSupported()) ?? true
            let isDeviceModelSupported = (try? await isDeviceModelSupported()) ?? true
            
            var errorMessages: [String] = []
            if isSDKSupported == false {
                errorMessages.append("Unsupported SDK version (\(SighticVersion.sdkVersion))")
            }
            if isDeviceModelSupported == false {
                errorMessages.append("Unsupported iDevice")
            }
            setErrorMessages(errorMessages)

            if isSDKSupported == false || isDeviceModelSupported == false {
                button?.setTitle("Go to test anyway", for: .normal)

                guard self.runAnyway else {
                    // Make user click the button again
                    self.runAnyway = true
                    return
                }
            }

            model.appState = .test
        }
    }

    func isDeviceModelSupported() async throws -> Bool {
        switch await SighticSupportedDevices.load() {
        case let .failure(error):
            print("Error while checking for supprted devices: \(error)")
            throw error
        case let .success(supportedDevices):
            return supportedDevices.isCurrentSupported
        }
    }
    
    func isSDKVersionSupported() async throws -> Bool {
        switch await SighticVersion.sdkVersions(apiKey: AppDelegate.apiKey) {
        case let .failure(error):
            print("Error while checking for supported versions: \(error)")
            throw error
        case let .success(versions):
            if !versions.isCurrentVersionSupported {
                print("Current version is not supported. Supported versions are: \(versions.supportedVersions)")
                return false
            }
            else {
                return true
            }
        }
    }

}

