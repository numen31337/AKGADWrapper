# AKGADWrapper
![Platform](https://img.shields.io/cocoapods/p/AKGADWrapper.svg)
![CocoaPods](https://img.shields.io/cocoapods/l/AKGADWrapper.svg)

`AKGADWrapper` is a wrapper for a `UIViewController` with a `GADBannerView` at the bottom which automatically handles autolayout of the wrapped `UIViewController`. This was a very common task, which I stumbled upon with, during the development of applications using AdMob monetising.

![AKVideoImageView Example](Resources/example.gif)

##Installation

####Manually and Swift
As this class uses AdMob as the external dependency, there is no way to use it while specifying `use_frameworks!`, because currently, AdMob is the static library itself.

In order to use this class you just need to copy `AKGADWrapperVC.h` and `AKGADWrapperVC.m` files and install [SAMKeychain](https://cocoapods.org/pods/SAMKeychain) and [Google-Mobile-Ads-SDK](https://cocoapods.org/pods/Google-Mobile-Ads-SDK) libraries as dependencies or connect them manually.

####CocoaPods: Objective-C only
Add the following line to your Podfile.

```
pod "AKGADWrapper", "~> 1.0"
```

Then run `pod install`.

##License (MIT)

Copyright (c) 2016 Oleksandr Kirichenko

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.