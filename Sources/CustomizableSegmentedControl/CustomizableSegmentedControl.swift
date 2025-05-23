import SwiftUI

// MARK: - Segmented Control

public struct CustomizableSegmentedControl<Option: Hashable & Identifiable, SelectionView: View, SegmentContent: View>: View {

    // MARK: - Properties

    @Environment(\.segmentedControlInsets) var segmentedControlInsets
    @Environment(\.segmentedControlInterSegmentSpacing) var interSegmentSpacing
    @Environment(\.segmentedControlSlidingAnimation) var slidingAnimation
    @Environment(\.segmentedControlContentStyle) var contentStyle

    @Binding private var selection: Option
    private let options: [Option]
    private let selectionView: () -> SelectionView
    private let segmentContent: (_ option: Option, _ isSelected: Bool, _ isPressed: Bool) -> SegmentContent

    @State private var optionIsPressed: [Option.ID: Bool] = [:]

    private var segmentAccessibilityValueCompletion: (Int, Int) -> String = { index, count in
        "\(index) of \(count)"
    }

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
    ///   - segmentContent: Content of segment. Returns related option and isPressed parameters.
    public init(
        selection: Binding<Option>,
        options: [Option],
        selectionView: @escaping () -> SelectionView,
        @ViewBuilder segmentContent: @escaping (_ option: Option, _ isSelected: Bool, _ isPressed: Bool) -> SegmentContent
    ) {
        self._selection = selection
        self.options = options
        self.selectionView = selectionView
        self.segmentContent = segmentContent
    }

    // MARK: - UI

    public var body: some View {
        HStack(spacing: interSegmentSpacing) {
            ForEach(Array(zip(options.indices, options)), id: \.1.id) { index, option in
                Segment(
                    content: segmentContent(option, option.id == selection.id, optionIsPressed[option.id, default: false]),
                    selectionView: selectionView(),
                    isSelected: selection == option,
                    animation: slidingAnimation,
                    contentBlendMode: contentStyle.contentBlendMode,
                    firstLevelOverlayBlendMode: contentStyle.firstLevelOverlayBlendMode,
                    highestLevelOverlayBlendMode: contentStyle.highestLevelOverlayBlendMode,
                    isPressed: $optionIsPressed[option.id],
                    backgroundID: buttonBackgroundID,
                    namespaceID: namespaceID,
                    accessibiltyValue: segmentAccessibilityValueCompletion(index + 1, options.count),
                    action: { selection = option }
                )
                .zIndex(selection == option ? 0 : 1)
            }
        }
        .padding(segmentedControlInsets)
    }

}

// MARK: - Segment

extension CustomizableSegmentedControl {

    fileprivate struct Segment<SegmentSelectionView: View, Content: View>: View {

        // MARK: - Properties

        let content: Content
        let selectionView: SegmentSelectionView
        let isSelected: Bool
        let animation: Animation
        let contentBlendMode: BlendMode?
        let firstLevelOverlayBlendMode: BlendMode?
        let highestLevelOverlayBlendMode: BlendMode?
        @Binding var isPressed: Bool?
        let backgroundID: String
        let namespaceID: Namespace.ID
        let accessibiltyValue: String
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
                                .accessibilityHidden(true)
                        }
                    }
                    .overlay {
                        if let highestLevelOverlayBlendMode {
                            content
                                .blendMode(highestLevelOverlayBlendMode)
                                .accessibilityHidden(true)
                        }
                    }
                    .background {
                        if isSelected {
                            selectionView
                                .transition(.offset())
                                .matchedGeometryEffect(id: backgroundID, in: namespaceID)
                        }
                    }
                    .animation(animation, value: isSelected)
            }
            .buttonStyle(SegmentButtonStyle(isPressed: $isPressed))
            .accessibilityElement(children: .combine)
            .accessibilityAddTraits(isSelected ? .isSelected : [])
            .accessibilityRemoveTraits(isSelected ? [] : .isSelected)
            .accessibilityValue(accessibiltyValue)
        }

    }

}

// MARK: - CustomizableSegmentedControl + Custom Inits

extension CustomizableSegmentedControl {

    /// - parameters:
    ///   - selection: Current selection.
    ///   - options: All options in segmented control.
    ///   - insets: Inner insets from container. Default is EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0).
    ///   - interSegmentSpacing: Spacing between options. Default is 0.
    ///   - contentBlendMode: Blend mode applies to content. Default is difference.
    ///   - firstLevelOverlayBlendMode: Blend mode applies to first level overlay. Default is hue.
    ///   - highestLevelOverlayBlendMode: Blend mode applies to highest level overlay. Default is overlay..
    ///   - selectionView: Selected option background.
    ///   - segmentContent: Content of segment. Returns related option and isPressed parameter.s
    public init(
        selection: Binding<Option>,
        options: [Option],
        selectionView: SelectionView,
        @ViewBuilder segmentContent: @escaping (_ option: Option, _ isSelected: Bool, _ isPressed: Bool) -> SegmentContent
    ) {
        self.init(
            selection: selection,
            options: options,
            selectionView: { selectionView },
            segmentContent: segmentContent
        )
    }

}

// MARK: - SegmentButtonStyle

extension CustomizableSegmentedControl.Segment {

    private struct SegmentButtonStyle: ButtonStyle {

        @Binding var isPressed: Bool?

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

private extension CustomizableSegmentedControlContentStyle {

    var contentBlendMode: BlendMode? {
        switch self {
            case .default:
                return nil
            case .blendMode(let mode, _, _):
                return mode
        }
    }

    var firstLevelOverlayBlendMode: BlendMode? {
        switch self {
            case .default:
                return nil
            case .blendMode(_, let mode, _):
                return mode
        }
    }

    var highestLevelOverlayBlendMode: BlendMode? {
        switch self {
            case .default:
                return nil
            case .blendMode(_, _, let mode):
                return mode
        }
    }

}

// MARK: - CustomizableSegmentedControl + Accessibility Extensions

public extension CustomizableSegmentedControl {

    /// Add accessibility value to every segment
    ///
    /// - Parameters:
    ///     - completion: Takes index and total count. Returns neccessary string
    func segmentAccessibilityValue(_ completion: @escaping (Int, Int) -> String) -> Self {
        var copy = self
        copy.segmentAccessibilityValueCompletion = completion
        return copy
    }

}

// MARK: - View + Extensions

private extension View {

    @ViewBuilder
    func blendModeIfNotNil(_ mode: BlendMode?) -> some View {
        if let mode {
            blendMode(mode)
        } else {
            self
        }
    }

    @ViewBuilder
    func background<T: View>(
        alignment: Alignment = .center,
        @ViewBuilder _ content: () -> T
    ) -> some View {
        if #available(iOS 15.0, *) {
            background(alignment: alignment, content: content)
        } else {
            background(content(), alignment: alignment)
        }
    }

    @ViewBuilder
    func overlay<T: View>(
        alignment: Alignment = .center,
        @ViewBuilder _ content: () -> T
    ) -> some View {
        if #available(iOS 15.0, *) {
            overlay(alignment: alignment, content: content)
        } else {
            overlay(content(), alignment: alignment)
        }
    }

}
