//
//  ContentView.swift
//  SighticQuickstartSwiftUI
//
//  Copyright © 2022 Sightic Analytics AB All rights reserved.
//

import SwiftUI
import SighticAnalytics

enum AppState {
    case start
    case test
    case waitingForAnalysis
    case result(SighticResult)
}

struct ContentView: View {
    @State var appState: AppState = .start

    var body: some View {
        switch appState {
        case .start:
            StartView(appState: $appState)
        case .test:
            TestView(appState: $appState)
        case .waitingForAnalysis:
            WaitingView()
        case .result:
            ResultView(appState: $appState)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
