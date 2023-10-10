//
//  CustomizableSegmentedControlContentStyle.swift
//
//
//  Created by Artyom Zagoskin on 10.10.2023.
//

import SwiftUI

/// Style of segment content
public enum CustomizableSegmentedControlContentStyle {
    /// Default style. You configure color for all states of content.
    case `default`
    /// Blend mode style. You configure colors, but some of them depends on background.
    /// - parameters:
    ///   - contentBlendMode: Blend mode applies to content. Default is difference.
    ///   - firstLevelOverlayBlendMode: Blend mode applies to first level overlay. Default is hue.
    ///   - highestLevelOverlayBlendMode: Blend mode applies to highest level overlay. Default is overlay..
    case blendMode(
        contentBlendMode: BlendMode = .difference,
        firstLevelOverlayBlendMode: BlendMode = .hue,
        highestLevelOverlayBlendMode: BlendMode = .overlay
    )
}
