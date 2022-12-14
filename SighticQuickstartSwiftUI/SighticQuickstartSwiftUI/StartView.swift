//
//  Copyright © 2022 Sightic Analytics AB All rights reserved.
//

import SwiftUI
import SighticAnalytics

struct SupportView: View {
    let deviceSupport: SighticSupportedDevices?
    let unsupportedSdkVersion: Bool?
    
    var body: some View {
        if let unsupportedSdkVersion = unsupportedSdkVersion {
            SupportStatus(
                title: "SDK version support?",
                supported: !unsupportedSdkVersion,
                supportOK: "SDK version (\(SighticVersion.sdkVersion)) is supported",
                supportNotOK: "Unsupported SDK version (\(SighticVersion.sdkVersion))"
            )
        }
        if let deviceSupport = deviceSupport {
            SupportStatus(
                title: "Device model support?",
                supported: deviceSupport.isCurrentSupported,
                supportOK: "iDevice supported (\(deviceSupport.currentDevice))",
                supportNotOK: "Unsupported iDevice (\(deviceSupport.currentDevice))"
            )
        }
    }
}

struct SupportStatus: View {
    let title: String
    let supported: Bool
    let supportOK: String
    let supportNotOK: String
    
    var body: some View {
        VStack {
            Text(title)
            
            if supported {
                Text(supportOK)
                    .foregroundColor(.green)
            }
            else {
                Text(supportNotOK)
                    .foregroundColor(.red)
            }
        }
        .padding()
    }
}

struct StartView: View {
    @Binding var appState: AppState
    
    @State private var deviceSupport: SighticSupportedDevices? = nil
    @State private var unsupportedSdkVersion: Bool? = nil
    @State private var runAnyway = false
    @State private var sighticInferenceViewConfiguration = SighticInferenceViewConfiguration()
        
    var body: some View {
        let showWarning =
            unsupportedSdkVersion == true ||
            deviceSupport?.isCurrentSupported == false
        
        VStack {
            Text("Sightic SDK Quickstart")
                .font(.title)
                .padding()
            Text("SDK version: \(SighticVersion.sdkVersion)")
                .font(.body)
                .padding()
            Spacer()
            Text("StartView")
                .font(.title2)
                .padding()
            StartViewInstructionToggle(showInstructions:
                                        $sighticInferenceViewConfiguration.showInstructions)
            StartViewShowRawAlignmentStatusToggle(showRawAlignmentStatusToggle:
                                                    $sighticInferenceViewConfiguration.showRawAlignmentStatus)
            Button(showWarning ? "Go to test anyway" : "Go to test") { goToTest() }
                .padding()
            SupportView(deviceSupport: deviceSupport, unsupportedSdkVersion: unsupportedSdkVersion)
            Spacer()
        }
        .onAppear {
            Task {
                await checkSdkVersions()
                await checkDeviceModel()
            }
        }
    }
    
    func goToTest() {
        Task {
            await checkSdkVersions()
            await checkDeviceModel()
                        
            if unsupportedSdkVersion == true || deviceSupport?.isCurrentSupported == false {
                guard runAnyway else {
                    // Make user click the button again
                    runAnyway = true
                    return
                }
            }

            appState = .test(sighticInferenceViewConfiguration)
        }
    }
    
    func checkDeviceModel() async {
        switch await SighticSupportedDevices.load() {
        case let .success(deviceSupport):
            self.deviceSupport = deviceSupport
        case let .failure(error):
            print("Error while checking for supprted devices: \(error)")
        }
    }
    
    func checkSdkVersions() async {
        switch await SighticVersion.sdkVersions(apiKey: SighticQuickstartSwiftUI.apiKey) {
        case let .failure(error):
            print("Error while checking for supported versions: \(error)")
        case let .success(versions):
            print(versions)
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

struct StartViewInstructionToggle: View {
    @Binding var showInstructions: Bool

    var body: some View {
        HStack {
            Spacer()
            Text("Show instructions")
            Toggle("Show instructions", isOn: $showInstructions).labelsHidden()
            Spacer()
        }
    }
}

struct StartViewShowRawAlignmentStatusToggle: View {
    @Binding var showRawAlignmentStatusToggle: Bool

    var body: some View {
        HStack {
            Spacer()
            Text("Show raw alignment status")
            Toggle("Show raw alignment status", isOn: $showRawAlignmentStatusToggle).labelsHidden()
            Spacer()
        }
    }
}

struct Start_Previews: PreviewProvider {
    static var previews: some View {
        StartView(appState: .constant(.start))
    }
}
