AMSloMoRangeSlider
============

iOS Slow Motion Video Range Slider in Swift

![amslomorangeslider](https://cloud.githubusercontent.com/assets/8356318/17716593/a7df7562-6409-11e6-83a3-55163d6d8008.gif)

### Code

```swift
let sloMoRangeSlider = AMSloMoRangeSlider(frame: CGRectMake(16, 16, 300, 20))
let url = NSBundle.mainBundle().URLForResource("video", withExtension: "mp4")
sloMoRangeSlider.videoAsset = AVAsset(URL: url!)
sloMoRangeSlider.delegate = self
```

### Delegate Methods

```swift
func slomoRangeSliderLowerThumbValueChanged() {
    print(self.sloMoRangeSlider.startTime.seconds)
}

func slomoRangeSliderUpperThumbValueChanged() {
    print(self.sloMoRangeSlider.stopTime.seconds)
}
```

## Installation

### CocoaPods

You can install the latest release version of CocoaPods with the following command:

```bash
$ gem install cocoapods
```

*CocoaPods v0.36 or later required*

Simply add the following line to your Podfile:

```ruby
platform :ios, '8.0' 
use_frameworks!

pod 'AMSloMoRangeSlider', :git => 'https://github.com/iAmrMohamed/AMSloMoRangeSlider.git' 
```

Then, run the following command:

```bash
$ pod install
```

## Requirements

- iOS 8.0+
- Xcode 7.3+

## License

AMSloMoRangeSlider is released under the MIT license. See LICENSE for details.
