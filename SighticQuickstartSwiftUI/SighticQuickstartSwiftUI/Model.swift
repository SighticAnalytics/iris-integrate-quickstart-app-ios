//
//  Copyright © 2023 Sightic Analytics AB All rights reserved.
//

import Foundation
import SighticAnalytics

struct SighticInferenceViewConfiguration {
    var showInstructions: Bool = false
}

enum AppState {
    case start
    case test(SighticInferenceViewConfiguration)
    case waitingForAnalysis
    case result(SighticInference)
    case error(SighticError)
    case feedback(SighticInference)
}
