//
//  Copyright © 2022 Sightic Analytics AB All rights reserved.
//

import SwiftUI
import SighticAnalytics

struct StatusView: View {
    let sighticStatus: SighticStatus

    var body: some View {
        VStack {
            Text("SighticStatus")
                .font(.title)
                .padding()
            StatusLabel(sighticStatus: sighticStatus)
            AligntmentStatusLabel(sighticStatus: sighticStatus)
            HeadOffsetLabel(sighticStatus: sighticStatus)
            HeadTiltLabel(sighticStatus: sighticStatus)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.white)
    }
}

struct StatusLabel: View {
    let sighticStatus: SighticStatus

    func statusText() -> String{
        switch sighticStatus {
        case .instruction:
            return "instruction"
        case .align:
            return "align"
        case .countdown(let int):
            return "countdown(\(int))"
        case .test:
            return "test"
        @unknown default:
            return ""
        }
    }

    var body: some View {
        Text("SighticStatus: \(statusText())")
    }
}

struct AligntmentStatusLabel: View {
    let sighticStatus: SighticStatus

    func statusText() -> String? {
        guard case .align(let alignmentStatus) = sighticStatus else {
            return nil
        }
        switch alignmentStatus {
        case .noFaceTracked, .tooFarAway, .noAttention, .blink, .ok:
            return "\(alignmentStatus)"
        case .notCentered:
            return "notCentered"
        case .headTilted:
            return "headTilted"
        @unknown default:
            return ""
        }
    }

    var body: some View {
        if let statusText = statusText() {
            Text("SighticAlignmentStatus: \(statusText)")
        } else {
            EmptyView()
        }
    }
}

struct HeadOffsetLabel: View {
    let sighticStatus: SighticStatus

    func statusText() -> String? {
        guard case .align(let alignmentStatus) = sighticStatus else {
            return nil
        }
        guard case .notCentered(let headOffset) = alignmentStatus else {
            return nil
        }
        return "\(headOffset)"
    }

    var body: some View {
        if let statusText = statusText() {
            Text("SighticHeadOffset: \(statusText)")
        } else {
            EmptyView()
        }
    }
}

struct HeadTiltLabel: View {
    let sighticStatus: SighticStatus

    func statusText() -> String? {
        guard case .align(let alignmentStatus) = sighticStatus else {
            return nil
        }
        guard case .headTilted(let headTilt) = alignmentStatus else {
            return nil
        }
        return "\(headTilt)"
    }

    var body: some View {
        if let statusText = statusText() {
            Text("SighticHeadTilt: \(statusText)")
        } else {
            EmptyView()
        }
    }
}

struct StatusView_Previews: PreviewProvider {
    static func createSighticStatus() -> SighticStatus {
        let sighticHeadTilt: SighticHeadTilt = .Down
        let sighticAlignmentStatus: SighticAlignmentStatus = .headTilted(sighticHeadTilt)
        let sighticStatus: SighticStatus = .align(sighticAlignmentStatus)
        return sighticStatus
    }

    static var previews: some View {
        StatusView(sighticStatus: createSighticStatus())
    }
}
