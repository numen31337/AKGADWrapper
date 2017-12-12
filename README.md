# AKGADWrapper
![Platform](https://img.shields.io/cocoapods/p/AKGADWrapper.svg)
![CocoaPods](https://img.shields.io/cocoapods/l/AKGADWrapper.svg)
[![Build Status](https://travis-ci.org/numen31337/AKGADWrapper.svg?branch=master)](https://travis-ci.org/numen31337/AKGADWrapper)

`AKGADWrapper` is a wrapper for a `UIViewController` with a `GADBannerView` at the bottom which automatically handles autolayout of the wrapped `UIViewController`. This was a very common task, which I stumbled upon with, during the development of applications using AdMob monetising.

![AKVideoImageView Example](Resources/example.gif)

## Installation

#### Manually and Swift
As this class uses AdMob as the external dependency, there is no way to use it while specifying `use_frameworks!`, because currently, AdMob is the static library itself.

In order to use this class you just need to copy `AKGADWrapperVC.h` and `AKGADWrapperVC.m` files and install [SAMKeychain](https://cocoapods.org/pods/SAMKeychain) and [Google-Mobile-Ads-SDK](https://cocoapods.org/pods/Google-Mobile-Ads-SDK) libraries as dependencies or connect them manually.

#### CocoaPods: Objective-C only
Add the following line to your Podfile.

```
pod "AKGADWrapper", "~> 1.0"
```

Then run `pod install`.

## Usage

#### Example of wrapping `rootViewController`
```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	//Instantiate a UIViewController to wrap
	UIViewController *mainVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
	//Instantiate a AKGADWrapperVC with UIViewController to wrap and your Ad Unit ID 
	AKGADWrapperVC *wrappedVC = [[AKGADWrapperVC alloc] initWithViewController:mainVC adUnitID:@"ca-app-pub-3940256099942544/2934735716"];
	//Optionally set targeting options
	wrappedVC.gender = GADBaseGenderMale;
	//Set as the rootViewController
	self.window.rootViewController = wrappedVC; 
   
	return YES;
}
```

#### Removing Ads
To remove Ads simply call `removeAds:` with `true` for disabling them forever or `false` for just a particular banner.
```objective-c
[wrapper removeAds:false];
```

#### Delaying Ads presentation
In order to improve retention of your application, there is `showAdsAfter` feature which helps you to set a delay for presenting adds only after some amount of application launches. To start presenting Ads only on 3rd launch just set this property to `2` before presenting `AKGADWrapperVC` instance.
```objective-c
wrapper.showAdsAfter = 2;
```

## License (MIT)

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
