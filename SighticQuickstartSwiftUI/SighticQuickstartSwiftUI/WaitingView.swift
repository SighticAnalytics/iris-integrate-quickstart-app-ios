//
// Copyright © 2022-2023 Sightic Analytics AB. All rights reserved.
//

import SwiftUI

struct WaitingView: View {
    var body: some View {
        VStack {
            Text("Sightic SDK Quickstart")
                .font(.title)
                .padding()
            Spacer()
            Text("Waiting for analysis result from Sightic backend...")
                .font(.title2)
                .padding()
            Spacer()
        }
    }
}

struct WaitingView_Previews: PreviewProvider {
    static var previews: some View {
        WaitingView()
    }
}
