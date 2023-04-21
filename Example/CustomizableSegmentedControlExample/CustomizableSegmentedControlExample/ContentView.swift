//
//  ContentView.swift
//  CustomizableSegmentedControlExample
//
//  Created by Artyom Zagoskin on 21.04.2023.
//

import SwiftUI

@available(iOS 14.0, *)
struct ContentView: View {

    @State private var selection: Option = .first
    private let options: [Option] = [.first, .second, .third]
    private let insets: EdgeInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4)
    private let interSegmentSpacing: CGFloat = 2

    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Spacer()

            VStack(alignment: .leading, spacing: 12) {
                Text("Default segmented control")
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
                Text("Segmented control with blend mode")
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

@available(iOS 14, *)
/// Style of segment content
public enum CustomizableSegmentedControlContentStyle {
    /// Default style. You configure color for all states of content.
    case `default`
    /// Blend mode style. You configure colors, but some of them depends on background.
    /// - parameters:
    ///   - contentBlendMode: Blend mode applies to content. Default is difference.
    ///   - firstLevelOverlayBlendMode: Blend mode applies to first level overlay. Default is hue.
    ///   - highestLevelOverlayBlendMode: Blend mode applies to highest level overlay. Default is overlay..
    case withBlendMode(
        contentBlendMode: BlendMode = .difference,
        firstLevelOverlayBlendMode: BlendMode = .hue,
        highestLevelOverlayBlendMode: BlendMode = .overlay
    )
}

// MARK: - Segmented Control

@available(iOS 14, *)
public struct CustomizableSegmentedControl<Option: Hashable & Identifiable, SelectionView: View, SegmentContent: View>: View {

    // MARK: - Properties

    @Binding private var selection: Option
    private let options: [Option]
    private let insets: EdgeInsets
    private let interSegmentSpacing: CGFloat
    private let contentStyle: CustomizableSegmentedControlContentStyle
    private let selectionView: () -> SelectionView
    private let segmentContent: (Option, Bool) -> SegmentContent

    @State private var optionIsPressed: [Option.ID: Bool] = [:]

    @Namespace private var namespaceID
    private let buttonBackgroundID: String = "buttonOverlayID"

    // MARK: - Init

    /// - parameters:
    ///   - selection: Current selection.
    ///   - options: All options in segmented control.
    ///   - insets: Inner insets from container. Default is EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0).
    ///   - interSegmentSpacing: Spacing between options. Default is 0.
    ///   - contentBlendMode: Blend mode applies to content. Default is difference.
    ///   - firstLevelOverlayBlendMode: Blend mode applies to first level overlay. Default is hue.
    ///   - highestLevelOverlayBlendMode: Blend mode applies to highest level overlay. Default is overlay..
    ///   - selectionView: Selected option background.
    ///   - segmentContent: Content of segment. Returns related option and isPressed parameter.
    public init(
        selection: Binding<Option>,
        options: [Option],
        insets: EdgeInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0),
        interSegmentSpacing: CGFloat = 0,
        contentStyle: CustomizableSegmentedControlContentStyle = .default,
        selectionView: @escaping () -> SelectionView,
        @ViewBuilder segmentContent: @escaping (Option, Bool) -> SegmentContent
    ) {
        self._selection = selection
        self.options = options
        self.insets = insets
        self.interSegmentSpacing = interSegmentSpacing
        self.contentStyle = contentStyle
        self.selectionView = selectionView
        self.segmentContent = segmentContent
        self.optionIsPressed = Dictionary(uniqueKeysWithValues: options.lazy.map { ($0.id, false) })
    }

    // MARK: - UI

    public var body: some View {
        HStack(spacing: interSegmentSpacing) {
            ForEach(options) { option in
                Segment(
                    content: segmentContent(option, optionIsPressed[option.id, default: false]),
                    selectionView: selectionView(),
                    isSelected: selection == option,
                    contentBlendMode: contentStyle.contentBlendMode,
                    firstLevelOverlayBlendMode: contentStyle.firstLevelOverlayBlendMode,
                    highestLevelOverlayBlendMode: contentStyle.highestLevelOverlayBlendMode,
                    isPressed: .init(
                        get: { optionIsPressed[option.id, default: false] },
                        set: { optionIsPressed[option.id] = $0 }
                    ),
                    backgroundID: buttonBackgroundID,
                    namespaceID: namespaceID,
                    action: { selection = option }
                )
                .zIndex(selection == option ? 0 : 1)
            }
        }
        .padding(insets)
    }

}

// MARK: - Segment

@available(iOS 14, *)
extension CustomizableSegmentedControl {

    fileprivate struct Segment<SelectionView: View, Content: View>: View {

        // MARK: - Properties

        let content: Content
        let selectionView: SelectionView
        let isSelected: Bool
        let contentBlendMode: BlendMode?
        let firstLevelOverlayBlendMode: BlendMode?
        let highestLevelOverlayBlendMode: BlendMode?
        @Binding var isPressed: Bool
        let backgroundID: String
        let namespaceID: Namespace.ID
        let action: () -> Void

        // MARK: - UI

        var body: some View {
            Button(action: action) {
                content
                    .blendModeIfNotNil(contentBlendMode)
                    .overlay {
                        if let firstLevelOverlayBlendMode {
                            content
                                .blendMode(firstLevelOverlayBlendMode)
                        }
                    }
                    .overlay {
                        if let highestLevelOverlayBlendMode {
                            content
                                .blendMode(highestLevelOverlayBlendMode)
                        }
                    }
                    .background {
                        if isSelected {
                            selectionView
                                .transition(.offset())
                                .matchedGeometryEffect(id: backgroundID, in: namespaceID)
                        }
                    }
                    .animation(.default, value: isSelected)
            }
            .buttonStyle(SegmentButtonStyle(isPressed: $isPressed))
        }

    }

}

// MARK: - SegmentButtonStyle

@available(iOS 14, *)
extension CustomizableSegmentedControl.Segment {

    @available(iOS 14, *)
    private struct SegmentButtonStyle: ButtonStyle {

        @Binding var isPressed: Bool

        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .contentShape(Rectangle())
                .onChange(of: configuration.isPressed) { newValue in
                    isPressed = newValue
                }
        }

    }

}

// MARK: - CustomizableSegmentedControlContentStyle + Properties

@available(iOS 14, *)
private extension CustomizableSegmentedControlContentStyle {

    var contentBlendMode: BlendMode? {
        switch self {
            case .default:
                return nil
            case .withBlendMode(let blendMode, _, _):
                return blendMode
        }
    }

    var firstLevelOverlayBlendMode: BlendMode? {
        switch self {
            case .default:
                return nil
            case .withBlendMode(_, let blendMode, _):
                return blendMode
        }
    }

    var highestLevelOverlayBlendMode: BlendMode? {
        switch self {
            case .default:
                return nil
            case .withBlendMode(_, _, let blendMode):
                return blendMode
        }
    }

}

// MARK: - View + Extensions

@available(iOS 14.0, *)
private extension View {

    @ViewBuilder
    func blendModeIfNotNil(_ mode: BlendMode?) -> some View {
        if let mode {
            blendMode(mode)
        } else {
            self
        }
    }

//    @ViewBuilder
//    func background<T: View>(
//        alignment: Alignment = .center,
//        @ViewBuilder _ content: () -> T
//    ) -> some View {
//        if #available(iOS 15.0, *) {
//            background(alignment: alignment, content: content)
//        } else {
//            background(content(), alignment: alignment)
//        }
//    }
//
//    @ViewBuilder
//    func overlay<T: View>(
//        alignment: Alignment = .center,
//        @ViewBuilder _ content: () -> T
//    ) -> some View {
//        if #available(iOS 15.0, *) {
//            overlay(alignment: alignment, content: content)
//        } else {
//            overlay(content(), alignment: alignment)
//        }
//    }

}
