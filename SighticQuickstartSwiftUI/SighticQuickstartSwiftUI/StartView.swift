//
//  Copyright © 2022 Sightic Analytics AB All rights reserved.
//

import SwiftUI
import SighticAnalytics

struct StartView: View {
    @Binding var appState: AppState
    
    @State private var unsupportedSdkVersion = false
    @State private var runAnyway = false
    
    var body: some View {
        let showWarning =
            unsupportedSdkVersion ||
            !SighticSupportedDevices.isCurrentDeviceSupported
        
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
            if !SighticSupportedDevices.isCurrentDeviceSupported {
                Text("Unsupported iDevice")
                    .foregroundColor(.red)
            }
            if unsupportedSdkVersion {
                Text("Unsupported SDK version (\(SighticVersion.sdkVersion))")
                   .foregroundColor(.red)
            }
            Button(showWarning ? "Go to test anyway" : "Go to test") { goToTest() }
                .padding()
            Spacer()
        }
    }
    
    func goToTest() {
        Task {
            await checkSdkVersions()
            
            if unsupportedSdkVersion {
                guard runAnyway else {
                    // Make user click the button again
                    runAnyway = true
                    return
                }
            }

            appState = .test
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

struct Start_Previews: PreviewProvider {
    static var previews: some View {
        StartView(appState: .constant(.start))
    }
}
