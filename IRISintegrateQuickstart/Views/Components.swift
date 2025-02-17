//
// Copyright © 2022-2025 Sightic Analytics AB. All rights reserved.
//

import SwiftUI

struct Header<Style: ShapeStyle>: View {
    private let title: String
    private let subtitle: String
    private let background: Style

    init(
        title: String,
        subtitle: String,
        background: Style = .secondary
    ) {
        self.title = title
        self.subtitle = subtitle
        self.background = background
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.title)
                Text(subtitle)
                    .font(.headline)
            }
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .foregroundStyle(.white)
        .background()
        .backgroundStyle(background)
    }
}

struct HugeButton: View {
    private var label: String
    private var color: Color
    private var action: () -> Void

    init(
        _ label: String,
        color: Color = .accentColor,
        action: @escaping () -> Void
    ) {
        self.label = label
        self.color = color
        self.action = action
    }

    var body: some View {
        Button(
            action: action,
            label: {
                Text(label)
                    .font(.title)
                    .padding(.horizontal, 50)
                    .padding(.vertical, 20)
            }
        )
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.roundedRectangle(radius: .greatestFiniteMagnitude))
        .tint(color)
    }
}

struct LargeButton: View {
    private var label: String
    private var color: Color
    private var action: () -> Void

    init(
        _ label: String,
        color: Color = .accentColor,
        action: @escaping () -> Void
    ) {
        self.label = label
        self.color = color
        self.action = action
    }

    var body: some View {
        Button(
            action: action,
            label: {
                Text(label)
                    .font(.title3)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
            }
        )
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.roundedRectangle(radius: .greatestFiniteMagnitude))
        .tint(color)
    }
}

struct TextFrame: View {
    private var symbol: String
    private var title: String
    private var text: String

    init(symbol: String, title: String, text: String) {
        self.symbol = symbol
        self.title = title
        self.text = text
    }

    var body: some View {
        HStack {
            Image(systemName: symbol)
                .imageScale(.large)
                .padding(.trailing, 10)
            VStack(alignment: .leading, spacing: 10) {
                Text(title)
                    .font(.headline)
                Text(text)
                    .font(.caption)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(in: RoundedRectangle(cornerRadius: 8))
        .backgroundStyle(.quinary)
        .padding()
    }
}
