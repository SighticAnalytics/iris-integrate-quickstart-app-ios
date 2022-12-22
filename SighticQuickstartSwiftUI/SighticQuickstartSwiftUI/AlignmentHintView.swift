//
//  Copyright © 2022 Sightic Analytics AB All rights reserved.
//

import SwiftUI
import SighticAnalytics

struct AlignmentHintView: View {
    let sighticStatus: SighticStatus

    var isCountdown: Bool {
        switch sighticStatus {
        case .countdown:
            return true
        case .test, .instruction, .align:
            return false
        @unknown default:
            return false
        }
    }

    var body: some View {
        VStack {
            Spacer()
            .frame(height: 150)
            AlignmentHintLabel(sighticStatus: sighticStatus)
            CountdownView(sighticStatus: sighticStatus)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct CountdownView: View {
    let sighticStatus: SighticStatus

    var countdownNumber: Int? {
        switch sighticStatus {
        case .countdown(let countdownNumber):
            return countdownNumber
        case .test, .instruction, .align:
            return nil
        @unknown default:
            return nil
        }
    }

    struct CountdownCircle: View {
        let countdownNumber: Int

        var body: some View {
            VStack {
                ZStack {
                    Circle()
                        .foregroundColor(Color.black.opacity(0.5))
                        .overlay(Circle().stroke(Color.green,lineWidth: 5))
                    Text(verbatim: "\(countdownNumber)")
                        .font(.system(size: 46))
                        .foregroundColor(.white)
                }
                .frame(width: 100, height: 100, alignment: .center)
                .padding()
            }
        }
    }

    var body: some View {
        if let countdownNumber = self.countdownNumber {
            CountdownCircle(countdownNumber: countdownNumber)
        } else {
            EmptyView()
        }
    }
}

struct AlignmentHintLabel: View {
    let sighticStatus: SighticStatus

    func statusText() -> String? {
        switch sighticStatus {
        case .align(let sighticAlignmentStatus):
            return sighticAlignmentStatus.message
        case .countdown:
            return SighticAlignmentStatus.ok.message
        case .instruction, .test:
            return nil
        @unknown default:
            break
        }
        return nil
    }

    var body: some View {
        if let statusText = statusText() {
            Text(statusText)
            .foregroundColor(.white)
            .padding(EdgeInsets(top: 2, leading: 4, bottom: 2, trailing: 4))
            .background(.black.opacity(0.5))
            .cornerRadius(4)
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
        AlignmentHintView(sighticStatus: createSighticStatus())
    }
}
