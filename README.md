# CustomizableSegmentedControl

If you're bored with standard segmented control, this framework is for you! `CustomizableSegmentedControl` is a customizable segmented control written in SwiftUI 2.0.

<img width="430" src="https://user-images.githubusercontent.com/49271404/233738945-40366273-ff28-4762-8ab4-691f5238c603.gif">


# Features

- Supports any views
- Works with blend modes
- Easy to use

# Requirements

- iOS 14.0+
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

### Manual
Just copy from `CustomizableSegmentedControl.swift` file and paste it to your project.

# Usage

Just setup `CustomizableSegmentedControl` view with parameters:
```swift
CustomizableSegmentedControl(
	selection: $selection,   					
	options: [.one, .two, .three],        	
	insets: .init(top: 4, leading: 4, bottom: 4, trailing: 4),          				
	interSegmentSpacing: 2,
	contentStyle: .withBlendMode(),
	animation: .default,
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
.background(Color.blue)
.clipShape(RoundedRectangle(cornerRadius: 14))
```
<img width="435" alt="image" src="https://user-images.githubusercontent.com/49271404/233736860-74a50584-7d15-4c76-9224-b7d0e8160565.png">

Includes a small demo project showing how to use and customize it.

# License

`CustomizableSegmentedControl` is available under the MIT license. See the LICENSE file for more info.
