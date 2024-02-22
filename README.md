# CustomizableSegmentedControl

If you're bored with standard segmented control, this framework is for you! `CustomizableSegmentedControl` is a customizable segmented control written in SwiftUI 2.0.

<img width="430" src="https://github.com/Inxel/CustomizableSegmentedControl/assets/49271404/594969f0-c519-4e67-95a4-b417755ab329">


# Features

- Supports any views
- Works with blend modes
- Works with right-to-left languages
- Easy to use

# Requirements

- iOS 15.0+
- macOS 12.0+
- Swift 5+

# Installation

### SPM
Add `https://github.com/Inxel/CustomizableSegmentedControl` using Package Dependecies.

### [CocoaPods](https://cocoapods.org/)
```bash
$ gem install cocoapods
```

To integrate `CustomizableSegmentedControl` into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '14.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'CustomizableSegmentedControl'
end
```

Then, run the following command:

```bash
$ pod install
```

### Manually
Just copy from `CustomizableSegmentedControl.swift` file and paste it to your project.

# Usage

Just setup `CustomizableSegmentedControl` view with parameters:
```swift
CustomizableSegmentedControl(
    selection: $selection,
    options: [.one, .two, .three],
    selectionView: {
        Color.white
            .clipShape(RoundedRectangle(cornerRadius: 10))
    },
    segmentContent: { option, isPressed in
        HStack(spacing: 4) {
            Text(option.title)
                .font(.system(size: 16, weight: .semibold, design: .rounded))

            option.imageName.map(Image.init(systemName:))
        }
        .foregroundColor(.white.opacity(isPressed ? 0.7 : 1))
        .lineLimit(1)
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity)
    }
)
.insets(.all, 4)
.segmentedControlContentStyle(.blendMode())
.segmentedControl(interSegmentSpacing: 2)
.segmentedControlSlidingAnimation(.bouncy)
.background(Color.blue)
.clipShape(RoundedRectangle(cornerRadius: 14))
```
<img width="435" alt="image" src="https://user-images.githubusercontent.com/49271404/233736860-74a50584-7d15-4c76-9224-b7d0e8160565.png">

Includes a small demo project showing how to use and customize it. Just clone the repo and build the Example project.

# Accessibility

Every segment of control supports voiceover. By default, there is a text like "Selected, first option, one of three, button".
You can change accessibility value (in example it's "one of three") with CustomizableSegmentedControl extension `segmentAccessibilityValue` which contains completion with index of current segment and total number of options.

# Contribution

Feel free to submit Pull Requests or send me your feedback and suggestions!

# Author

Artyom Zagoskin
- [GitHub](https://github.com/inxel)
- [LinkedIn](https://www.linkedin.com/in/artyomzagoskin/)
- [Other social networks](http://inxel.github.io/MyLinks/)

# License

`CustomizableSegmentedControl` is available under the MIT license. See the LICENSE file for more info.
