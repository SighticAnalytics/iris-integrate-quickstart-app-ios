//
//  Copyright © 2022 Sightic Analytics AB All rights reserved.
//

import SwiftUI
import SighticAnalytics

struct SupportView: View {
    let deviceSupport: SighticSupportedDevices?
    
    var body: some View {
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
    @State private var runAnyway = false
    @State private var sighticInferenceViewConfiguration = SighticInferenceViewConfiguration()
        
    var body: some View {
        let showWarning = deviceSupport?.isCurrentSupported == false
        
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
            AllowToSaveToggle(allowToSave: $sighticInferenceViewConfiguration.allowToSave)
            Button(showWarning ? "Go to test anyway" : "Go to test") { goToTest() }
                .padding()
            SupportView(deviceSupport: deviceSupport)
            Spacer()
        }
        .onAppear {
            Task {
                await checkDeviceModel()
            }
        }
    }
    
    func goToTest() {
        Task {
            await checkDeviceModel()
                        
            if deviceSupport?.isCurrentSupported == false {
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
        do {
            self.deviceSupport = try await SighticSupportedDevices()
        }
        catch {
            print("Error while checking for supprted devices: \(error)")
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

struct AllowToSaveToggle: View {
    @Binding var allowToSave: Bool

    var body: some View {
        HStack {
            Spacer()
            Text("Allow to save")
            Toggle("Allow to save", isOn: $allowToSave).labelsHidden()
            Spacer()
        }
    }
}

struct Start_Previews: PreviewProvider {
    static var previews: some View {
        StartView(appState: .constant(.start))
    }
}
