//
// Copyright © 2022-2025 Sightic Analytics AB. All rights reserved.
//

import IRISintegrate

/// The errors we want to handle in the UI.
///
/// At different points in the IRIS integrate flow we can receive errors.
/// We wrap these in an enum that is an associated value on `Screen.error`.
enum Error {
    case sighticError(SighticError)
    case recordingError(SighticRecordingError)
}

extension Error: CustomStringConvertible {
    public var description: String {
        switch self {
        case .sighticError(let sighticError):
            sighticError.description
        case .recordingError(let sighticRecordingError):
            sighticRecordingError.description
        }
    }
}

extension SighticError: @retroactive CustomStringConvertible {
    public var description: String {
        switch self {
        case .invalidAPIKey:
            "Invalid API key."
        case .noConnection:
            "No internet connection."
        case .backendHTTPError(let code):
            "HTTP error \(code)."
        case .internalError(let code):
            "Internal error \(code)."
        }
    }
}

extension SighticRecordingError: @retroactive CustomStringConvertible {
    public var description: String {
        switch self {
        case .interrupted:
            "Scan was interrupted."
        case .user(let userError):
            userError.description
        case .devicePerformance:
            "The phone is too hot."
        case .noCameraPermission:
            "Access to the camera was denied."
        case .cancelled:
            "You cancelled the scan."
        case .createRecordingFailure:
            "Failed to create recording."
        case .deviceNotSupported:
            "Device is not supported."
        }
    }
}

extension SighticUserError: @retroactive CustomStringConvertible {
    public var description: String {
        switch self {
        case .eyesTooClosed:
            "You blinked too much."
        case .headNotCentered:
            "You were out of the camera view."
        case .headTilted(let tilt):
            switch tilt {
            case .up:
                "You looked up too much."
            case .down:
                "You looked down too much."
            case .left:
                "You looked too much to the left."
            case .right:
                "You looked too much to the right."
            }
        case .headTooClose:
            "You were too close to the phone."
        case .headTooFarAway:
            "You were too far away from the phone."
        case .noAttention:
            "You looked away from the screen too much."
        case .noFaceTracked:
            "Unable to track a face."
        case .notFollowingDot:
            "You didn't focus on the dot well enough."
        case .talking:
            "You were talking or opening your mouth too much."
        case .wrongDeviceOrientation:
            "You held the phone in the wrong orientation."
        }
    }
}
