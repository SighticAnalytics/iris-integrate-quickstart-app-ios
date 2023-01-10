//
//  Copyright © 2023 Sightic Analytics AB All rights reserved.
//

import UIKit

class UIQuickstartTextView: UIStackView {
    let textView = UITextView(frame: .zero)

    var text: String {
        return textView.text
    }

    override func resignFirstResponder() -> Bool {
        textView.resignFirstResponder()
    }

    override func becomeFirstResponder() -> Bool {
        textView.becomeFirstResponder()
    }

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        axis = .horizontal

        let leftSpacer = UIQuickstartSpacer()
        let rightSpacer = UIQuickstartSpacer()

        NSLayoutConstraint.activate([
            leftSpacer.widthAnchor.constraint(equalToConstant: 10),
            rightSpacer.widthAnchor.constraint(equalToConstant: 10),
            textView.heightAnchor.constraint(equalToConstant: 150)
        ])

        addArrangedSubview(leftSpacer)
        addArrangedSubview(textView)
        addArrangedSubview(rightSpacer)

        textView.layer.borderWidth = 1
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}

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

class UIQuickstartCircle: UIStackView {
    var text: String? {
        get {
            return l.text
        }
        set(newValue) {
            l.text = newValue
        }
    }

    private var l: UILabel

    init() {
        l = UILabel()
        super.init(frame: .zero)
        axis = .vertical
        translatesAutoresizingMaskIntoConstraints = false

        let spacer1 = UIQuickstartSpacer()
        let hStackView = createHStackView()
        let spacer2 = UIQuickstartSpacer()

        self.addArrangedSubview(spacer1)
        self.addArrangedSubview(hStackView)
        self.addArrangedSubview(spacer2)

        NSLayoutConstraint.activate([
            spacer1.heightAnchor.constraint(equalToConstant: 10),
            spacer2.heightAnchor.constraint(equalToConstant: 10)
        ])
    }

    func createHStackView() -> UIStackView {
        let hStackView = UIStackView()
        hStackView.axis = .horizontal
        hStackView.translatesAutoresizingMaskIntoConstraints = false

        let spacer1 = UIQuickstartSpacer()

        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .center
        l.numberOfLines = 0
        l.lineBreakMode = .byWordWrapping
        l.font = .preferredFont(forTextStyle: .largeTitle)
        l.layer.backgroundColor = UIColor.black.cgColor
        l.layer.borderColor = UIColor.green.cgColor
        l.layer.borderWidth = 3
        l.layer.cornerRadius = 50
        l.layer.opacity = 0.5
        l.textColor = .white

        NSLayoutConstraint.activate([
            l.heightAnchor.constraint(equalToConstant: 100),
            l.widthAnchor.constraint(equalToConstant: 100),
        ])

        let spacer3 = UIQuickstartSpacer()

        hStackView.addArrangedSubview(spacer1)
        hStackView.addArrangedSubview(l)
        hStackView.addArrangedSubview(spacer3)

        NSLayoutConstraint.activate([
            spacer1.widthAnchor.constraint(equalTo: spacer3.widthAnchor)
        ])

        return hStackView
    }

    override init(frame: CGRect) {
        l = UILabel()
        super.init(frame: frame)
        fatalError("init(frame:) has not been implemented")
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class UIQuickstartAlignmentHint: UIStackView {
    var text: String? {
        get {
            return l.text
        }
        set(newValue) {
            l.text = newValue
        }
    }

    private var l: UIQuickstartLabelExtraInnerMargin

    init() {
        l = UIQuickstartLabelExtraInnerMargin()
        super.init(frame: .zero)
        axis = .vertical
        translatesAutoresizingMaskIntoConstraints = false

        let spacer1 = UIQuickstartSpacer()
        let hStackView = createHStackView()
        let spacer2 = UIQuickstartSpacer()

        self.addArrangedSubview(spacer1)
        self.addArrangedSubview(hStackView)
        self.addArrangedSubview(spacer2)

        NSLayoutConstraint.activate([
            spacer1.heightAnchor.constraint(equalToConstant: 10),
            spacer2.heightAnchor.constraint(equalToConstant: 10)
        ])
    }

    func createHStackView() -> UIStackView {
        let hStackView = UIStackView()
        hStackView.axis = .horizontal
        hStackView.translatesAutoresizingMaskIntoConstraints = false

        let spacer1 = UIQuickstartSpacer()

        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .center
        l.numberOfLines = 0
        l.lineBreakMode = .byWordWrapping
        l.font = .preferredFont(forTextStyle: .body)
        l.textColor = .white
        l.layer.backgroundColor = UIColor.black.cgColor
        l.layer.opacity = 0.5
        l.layer.cornerRadius = 4

        let spacer3 = UIQuickstartSpacer()

        hStackView.addArrangedSubview(spacer1)
        hStackView.addArrangedSubview(l)
        hStackView.addArrangedSubview(spacer3)

        NSLayoutConstraint.activate([
            spacer1.widthAnchor.constraint(equalTo: spacer3.widthAnchor)
        ])

        return hStackView
    }

    override init(frame: CGRect) {
        l = UIQuickstartLabelExtraInnerMargin()
        super.init(frame: frame)
        fatalError("init(frame:) has not been implemented")
    }

    required init(coder: NSCoder) {
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

class UIQuickstartLabelExtraInnerMargin: UILabel {
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        textAlignment = .center
        numberOfLines = 0
        lineBreakMode = .byWordWrapping
        font = .preferredFont(forTextStyle: .body)
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        let leftInset: CGFloat = 10
        let rightInset: CGFloat = 10
        let topInset: CGFloat = 10
        let bottomInset: CGFloat = 10
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
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


