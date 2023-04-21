//
//  ContentView.swift
//  CustomizableSegmentedControlExample
//
//  Created by Artyom Zagoskin on 21.04.2023.
//

import CustomizableSegmentedControl
import SwiftUI

struct ContentView: View {

    @State private var selection: Option = .first
    private let options: [Option] = [.first, .second, .third]
    private let insets: EdgeInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4)
    private let interSegmentSpacing: CGFloat = 2

    var body: some View {
        VStack(alignment: .leading, spacing: 40) {
            Spacer()

            VStack(alignment: .leading, spacing: 12) {
                Text("Default CustomizableSegmentedControl")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .padding(.horizontal, 2)

                CustomizableSegmentedControl(
                    selection: $selection,
                    options: options,
                    insets: insets,
                    interSegmentSpacing: interSegmentSpacing,
                    selectionView: { selectionView },
                    segmentContent: { option, isPressed in
                        segmentView(title: option.title, imageName: option.imageName, isPressed: isPressed)
                            .colorMultiply(selection == option ? Color.black : .white)
                            .animation(.default, value: selection)
                    }
                )
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }

            VStack(alignment: .leading, spacing: 12) {
                Text("CustomizableSegmentedControl with blend mode")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .padding(.horizontal, 2)

                CustomizableSegmentedControl(
                    selection: $selection,
                    options: options,
                    insets: insets,
                    interSegmentSpacing: interSegmentSpacing,
                    contentStyle: .withBlendMode(),
                    selectionView: { selectionView },
                    segmentContent: { option, isPressed in
                        segmentView(title: option.title, imageName: option.imageName, isPressed: isPressed)
                    }
                )
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }

            Spacer()

            Text("You select \(selection.rawValue) option")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .padding(.horizontal, 2)

            Spacer()
        }
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

}

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
