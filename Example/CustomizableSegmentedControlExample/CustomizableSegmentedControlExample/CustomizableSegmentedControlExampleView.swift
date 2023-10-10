//
//  CustomizableSegmentedControlExampleView.swift
//  CustomizableSegmentedControlExample
//
//  Created by Artyom Zagoskin on 21.04.2023.
//

import CustomizableSegmentedControl
import SwiftUI

// MARK: - Example

struct CustomizableSegmentedControlExampleView: View {

    @Environment(\.colorScheme) private var colorScheme

    @State private var selection: Option = .first
    private let options: [Option] = [.first, .second, .third]
    private let insets: EdgeInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4)
    private let interSegmentSpacing: CGFloat = 2

    @State private var animation: SegmentedControlAnimation = .default

    var body: some View {
        VStack(alignment: .leading, spacing: 40) {
            Spacer()

            VStack(alignment: .leading, spacing: 12) {
                Text("Default CustomizableSegmentedControl")
                    .padding(.horizontal, 2)

                CustomizableSegmentedControl(
                    selection: $selection,
                    options: options,
                    insets: insets,
                    interSegmentSpacing: interSegmentSpacing,
                    animation: animation.value,
                    selectionView: { selectionView },
                    segmentContent: { option, isPressed in
                        segmentView(title: option.title, imageName: option.imageName, isPressed: isPressed)
                            .colorMultiply(selection == option ? Color.black : .white)
                            .animation(.default, value: selection)
                    }
                )
                .segmentAccessibilityValue { index, totalSegmentsCount in
                    "Custom accessibility value. Current segment is \(index) of \(totalSegmentsCount)"
                }
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }

            VStack(alignment: .leading, spacing: 12) {
                Text("CustomizableSegmentedControl with blend mode")
                    .padding(.horizontal, 2)

                CustomizableSegmentedControl(
                    selection: $selection,
                    options: options,
                    insets: insets,
                    interSegmentSpacing: interSegmentSpacing,
                    contentStyle: .withBlendMode(),
                    animation: animation.value,
                    selectionView: { selectionView },
                    segmentContent: { option, isPressed in
                        segmentView(title: option.title, imageName: option.imageName, isPressed: isPressed)
                    }
                )
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }

            Text("\(selection.title) option is selected")
                .padding(.horizontal, 2)

            Spacer()

            animationPicker
                .padding(.horizontal, 2)

            Spacer()
        }
        .font(.system(size: 18, weight: .bold, design: .rounded))
        .padding()
    }

    private var selectionView: some View {
        Color.white
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    private func segmentView(title: String, imageName: String?, isPressed: Bool) -> some View {
        HStack(spacing: 4) {
            Text(title)
                .font(.system(size: 16, weight: .semibold, design: .rounded))

            imageName.map(Image.init(systemName:))
        }
        .foregroundColor(.white.opacity(isPressed ? 0.7 : 1))
        .lineLimit(1)
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity)
    }

    private var animationPicker: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("You can use any animation you want. Some of them:")
                .font(.system(size: 16, weight: .semibold, design: .rounded))

            Button {
                animation = .default
            } label: {
                HStack(spacing: 12) {
                    Radiobutton(isSelected: animation == .default)

                    Text("Default")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            Button {
                animation = .spring
            } label: {
                HStack(spacing: 12) {
                    Radiobutton(isSelected: animation == .spring)

                    Text("Spring")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .foregroundColor(colorScheme == .dark ? .white : .black)
        .font(.system(size: 14, weight: .semibold, design: .rounded))
    }

}

extension CustomizableSegmentedControlExampleView {

    // MARK: - Option

    enum Option: String, Identifiable, Hashable {
        case first
        case second
        case third

        var id: String { rawValue }
        var title: String { rawValue.capitalized }
        var imageName: String? {
            switch self {
                case .first, .third:
                    return nil
                case .second:
                    return "suit.heart.fill"
            }
        }
    }

    // MARK: - Animation

    enum SegmentedControlAnimation {
        case `default`
        case spring

        var value: Animation {
            switch self {
                case .default:
                    return .default
                case .spring:
                    return .interpolatingSpring(stiffness: 180, damping: 15)
            }
        }
    }

}

// MARK: - Radiobutton

struct Radiobutton: View {

    // MARK: - Properties

    let isSelected: Bool

    // MARK: - UI

    var body: some View {
        content
            .animation(.linear(duration: 0.15), value: isSelected)
    }

    private var content: some View {
        ZStack {
            radiobuttonShape
                .stroke(
                    isSelected ? Color.blue : .gray,
                    lineWidth: 1
                )
                .background(
                    radiobuttonShape
                        .fill(Color.clear)
                )
                .frame(width: 20, height: 20)

            if isSelected {
                radiobuttonShape
                    .fill(Color.blue)
                    .frame(width: 10, height: 10)
            }
        }
    }

    private var radiobuttonShape: some Shape {
        Circle()
    }

}
