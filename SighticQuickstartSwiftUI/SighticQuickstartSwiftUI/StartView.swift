//
//  Copyright © 2022 Sightic Analytics AB All rights reserved.
//

import SwiftUI
import SighticAnalytics

struct StartView: View {
    @Binding var appState: AppState
    
    @State private var unsupportedDevice = false
    @State private var unsupportedSdkVersion = false
    @State private var runAnyway = false
    @State private var sighticInferenceViewConfiguration = SighticInferenceViewConfiguration()
    
    var body: some View {
        let showWarning =
            unsupportedSdkVersion ||
            unsupportedDevice
        
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
            if unsupportedDevice {
                Text("Unsupported iDevice")
                    .foregroundColor(.red)
            }
            if unsupportedSdkVersion {
                Text("Unsupported SDK version (\(SighticVersion.sdkVersion))")
                   .foregroundColor(.red)
            }
            Spacer()
        }
    }
    
    func goToTest() {
        Task {
            await checkSdkVersions()
            await checkDeviceModel()
                        
            if unsupportedSdkVersion || unsupportedDevice {
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
        case let .success(supportedDevices):
            unsupportedDevice = !supportedDevices.isCurrentSupported
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
