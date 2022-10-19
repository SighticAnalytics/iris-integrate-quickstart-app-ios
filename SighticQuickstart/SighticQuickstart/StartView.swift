//
//  Start.swift
//  SighticQuickstart
//
//  Copyright © 2022 Sightic Analytics AB All rights reserved.
//

import SwiftUI

struct StartView: View {
    @Binding var appState: AppState

    var body: some View {
        VStack {
            Text("Sightic SDK Quickstart")
                .font(.title)
                .padding()
            Spacer()
            Text("StartView")
                .font(.title2)
                .padding()
            Button(action: { appState = .test },
                   label: { Text("Go to test") })
            Spacer()
        }
    }
}

struct Start_Previews: PreviewProvider {
    static var previews: some View {
        StartView(appState: .constant(.start))
    }
}
