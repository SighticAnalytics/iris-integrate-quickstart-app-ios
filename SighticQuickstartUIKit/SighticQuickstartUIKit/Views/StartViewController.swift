//
//  Copyright © 2022 Sightic Analytics AB All rights reserved.
//

import UIKit
import SighticAnalytics

class StartViewController: UIViewController {
    var runAnyway: Bool = false
    var unsupportedSdkVersion = false

    let sv = UIQuickstartStackview()
    let errorUnsupportedSDKVersionText = UIQuickstartBody(text: "Unsupported SDK version (\(SighticVersion.sdkVersion))")
    var button: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        errorUnsupportedSDKVersionText.textColor = .red

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

        if !SighticSupportedDevices.isCurrentDeviceSupported {
            let errorMessage = UIQuickstartBody(text: "Unsupported iDevice")
            errorMessage.textColor = .red
            sv.addArrangedSubview(errorMessage)
            
            button?.setTitle("Go to test anyway", for: .normal)
        }

        sv.addArrangedSubview(button!)
        sv.addArrangedSubview(spacer2)

        NSLayoutConstraint.activate([
            spacer2.heightAnchor.constraint(equalTo: spacer1.heightAnchor)
        ])
    }
    
    func goToTest() {
        Task {
            await checkSdkVersions()

            if unsupportedSdkVersion {
                let stackView = self.view.subviews[0] as? UIQuickstartStackview
                stackView!.insertArrangedSubview(errorUnsupportedSDKVersionText, at: 4)
                self.view.setNeedsLayout()
                
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

    func checkSdkVersions() async {
        switch await SighticVersion.sdkVersions(apiKey: AppDelegate.apiKey) {
        case let .failure(error):
            print("Error while checking for supported versions: \(error)")
        case let .success(versions):
            if !versions.isCurrentVersionSupported {
                print("Current version is not supported. Supported versions are: \(versions.supportedVersions)")
                unsupportedSdkVersion = true
            }
            else {
                unsupportedSdkVersion = false
            }
        }
    }

}

