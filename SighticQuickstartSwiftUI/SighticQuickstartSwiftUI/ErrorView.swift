//
//  Copyright © 2022 Sightic Analytics AB All rights reserved.
//

import SwiftUI
import SighticAnalytics

struct ErrorView: View {
    @Binding var appState: AppState

    func generateErrorText(error: SighticError) -> String {
        let text = "SighticError: \(error.localizedDescription)"
        return text
    }

    var body: some View {
        switch appState {
        case .error(let sighticError):
            VStack {
                Text("Sightic SDK Quickstart")
                    .font(.title)
                    .padding()
                Spacer()
                Text("ErrorView")
                    .font(.title2)
                    .padding()
                Text(generateErrorText(error: sighticError))
                    .padding()
                if case let .recordingFailed(recordingError) = sighticError {
                    Text("Test failed because \(recordingError.reasonString).")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.red)
                        .padding()
                }
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

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(appState: .constant(.error(SighticError.noConnection)))
    }
}

extension SighticRecordingError {
    public var reasonString: String {
        switch self {
        case .interrupted:
            return "the recording was interrupted"
        case let .alignment(alignmentStatus):
            switch alignmentStatus {
            case .noFaceTracked:
                return "there was no face in the frame"
            case .tooFarAway:
                return "the phone was held too far away"
            case .noAttention:
                return "the user was not looking at the display"
            case .blink:
                return "the user blinked too much"
            case let .notCentered(offset):
                switch offset {
                case .down:
                    return "the phone was held too low"
                case .up:
                    return "the phone was held too high"
                case .left:
                    return "the phone was held too far to the left"
                case .right:
                    return "the phone was held too far to the right"
                case .noOffset:
                    return ""
                @unknown default:
                    return ""
                }
            case .ok:
                return ""
            case let .headTilted(tilt):
                switch tilt {
                case .Up:
                    return "the user looked up"
                case .Down:
                    return "the user looked down"
                case .Left:
                    return "the user looked left"
                case .Right:
                    return "the user looked right"
                case .NoTilt:
                    return ""
                @unknown default:
                    return ""
                }
            @unknown default:
                return ""
            }
        @unknown default:
            return ""
        }
    }
}
