//
//  ResultView.swift
//  SighticQuickstartSwiftUI
//
//  Copyright © 2022 Sightic Analytics AB All rights reserved.
//

import SwiftUI
import SighticAnalytics

struct ResultView: View {
    @Binding var appState: AppState
    
    var body: some View {
        switch appState {
        case .result(let sighticResult):
            VStack {
                Text("Sightic SDK Quickstart")
                    .font(.title)
                    .padding()
                Spacer()
                Text("ResultView")
                    .font(.title2)
                    .padding()
                Text("sighticResult.hasImpairment = \(String(sighticResult.hasImpairment))")
                    .padding()
                Button(action: {
                        appState = .start
                },
                       label: { Text("Go to start") })
                Spacer()
            }
        default:
            Text("Invalid app state")
        }
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(appState: .constant(.result(SighticResult(hasImpairment: true))))
    }
}
