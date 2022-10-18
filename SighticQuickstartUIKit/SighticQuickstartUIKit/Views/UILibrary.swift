//
//  Copyright © 2022 Sightic Analytics AB All rights reserved.
//

import UIKit

class UIQuickstartTitle: UILabel {
    init(title: String) {
        super.init(frame: .zero)
        self.text = title
        translatesAutoresizingMaskIntoConstraints = false
        textAlignment = .center
        font = .preferredFont(forTextStyle: .title1)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class UIQuickstartBody: UILabel {
    init(text: String) {
        super.init(frame: .zero)
        self.text = text
        translatesAutoresizingMaskIntoConstraints = false
        textAlignment = .center
        font = .preferredFont(forTextStyle: .body)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class UIQuickstartButton: UIButton {
    private var action: (() -> Void)?
    init(title: String, action: @escaping (() -> Void)) {
        super.init(frame: .zero)
        self.action = action
        setTitle(title, for: .normal)
        setTitleColor(.blue, for: .normal)
        translatesAutoresizingMaskIntoConstraints = false
        addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }

    @objc
    private func buttonAction() {
        action?()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class UIQuickstartStackview: UIStackView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        axis = .vertical
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class UIQuickstartSpacer: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


