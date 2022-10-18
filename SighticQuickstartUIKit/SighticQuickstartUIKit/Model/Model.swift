//
//  Copyright © 2022 Sightic Analytics AB All rights reserved.
//

import Combine
import SighticAnalytics

enum AppState {
    case start
    case test
    case waiting
    case result(SighticResult)
}

class Model {
    @Published var appState: AppState = .start
}

var model = Model()
