//
//  AppDelegate.m
//  Example
//
//  Created by Oleksandr Kirichenko on 12/15/16.
//  Copyright © 2016 Oleksandr Kirichenko. All rights reserved.
//

#import "AppDelegate.h"
#import "AKGADWrapper.h"

@interface AppDelegate ()

@property (weak, nonatomic) AKGADWrapperVC *wrappedVC;

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    __weak AppDelegate *weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:@"NoteRemoveAds" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note)
    {
        [weakSelf.wrappedVC removeAds:false]; //remove Ads only for this time
    }];
    
    UIViewController *mainVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
    AKGADWrapperVC *wrappedVC = [[AKGADWrapperVC alloc] initWithViewController:mainVC
                                                                      adUnitID:@"ca-app-pub-3940256099942544/2934735716"];
    wrappedVC.gender = GADBaseGenderMale;
    self.window.rootViewController = wrappedVC;
    self.wrappedVC = wrappedVC;
    
    return YES;
}

@end
