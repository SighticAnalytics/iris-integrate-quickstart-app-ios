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
        numberOfLines = 0
        lineBreakMode = .byWordWrapping
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

class UIQuickstartSwitch: UIStackView {
    private var action: ((Bool) -> Void)?

    init(title: String, initialValue: Bool, action: @escaping ((Bool) -> Void)) {
        super.init(frame: .zero)
        self.action = action
        axis = .vertical
        translatesAutoresizingMaskIntoConstraints = false

        let spacer1 = UIQuickstartSpacer()
        let hStackView = createHStackView(title: title, initialValue: initialValue)
        let spacer2 = UIQuickstartSpacer()

        self.addArrangedSubview(spacer1)
        self.addArrangedSubview(hStackView)
        self.addArrangedSubview(spacer2)

        NSLayoutConstraint.activate([
            spacer1.heightAnchor.constraint(equalToConstant: 10),
            spacer2.heightAnchor.constraint(equalToConstant: 10)
        ])
    }

    func createHStackView(title: String, initialValue: Bool) -> UIStackView {
        let hStackView = UIStackView()
        hStackView.axis = .horizontal
        hStackView.translatesAutoresizingMaskIntoConstraints = false

        let spacer1 = UIQuickstartSpacer()

        let l = UILabel()
        l.text = title
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .center
        l.numberOfLines = 0
        l.lineBreakMode = .byWordWrapping
        l.font = .preferredFont(forTextStyle: .body)

        let spacer2 = UIQuickstartSpacer()

        let s = UISwitch()
        s.addTarget(self, action: #selector(switchAction), for: .valueChanged)
        s.translatesAutoresizingMaskIntoConstraints = false
        s.setOn(initialValue, animated: false)

        let spacer3 = UIQuickstartSpacer()

        hStackView.addArrangedSubview(spacer1)
        hStackView.addArrangedSubview(l)
        hStackView.addArrangedSubview(spacer2)
        hStackView.addArrangedSubview(s)
        hStackView.addArrangedSubview(spacer3)

        NSLayoutConstraint.activate([
            spacer1.widthAnchor.constraint(equalTo: s.widthAnchor),
            spacer3.widthAnchor.constraint(equalTo: s.widthAnchor),
        ])

        return hStackView
    }

    @objc
    private func switchAction(_ sender: UISwitch) {
        action?(sender.isOn)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        fatalError("init(frame:) has not been implemented")
    }
    
    required init(coder: NSCoder) {
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


