//
//  AKGADWrapperVC.m
//  AKGADWrapper
//
//  Created by Oleksandr Kirichenko on 2/7/16.
//  Copyright © 2016 Oleksandr Kirichenko. All rights reserved.
//

#import "AKGADWrapperVC.h"
#import "SAMKeychain.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface AKGADWrapperVC() <GADBannerViewDelegate>

@property (strong, nonatomic) NSString *adUnitID;

@property (weak, nonatomic, readwrite, nullable) UIViewController *wrappedViewController;
@property (weak, nonatomic) UIView *containerView;
@property (weak, nonatomic) GADBannerView *adMobView;
@property (weak, nonatomic) NSLayoutConstraint *containerToBottomConstraint;

@property (assign, nonatomic) BOOL adsRemoved;
@property (assign, nonatomic) BOOL adsViewIsHidden;

@property (assign, nonatomic) NSInteger launchesWithoutAds;

@end


@implementation AKGADWrapperVC

static NSString *const kKeyAdsRemoved = @"kKeyAdsRemoved";
static NSString *const kKeyLaunchesWithoutAds = @"kKeyLaunchesWithoutAds";


#pragma mark - Lifecycle

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithViewController:(nonnull UIViewController *)controller
                              adUnitID:(nonnull NSString *)adUnitID
{
    NSCParameterAssert([adUnitID isKindOfClass:[NSString class]]);
    NSCParameterAssert([controller isKindOfClass:[UIViewController class]]);
    
    self = [super init];
    
    if (self) {
        self.showAdsAfter = 0;
        self.adUnitID = adUnitID;
        
        self.wrappedViewController = controller;
        [self addChildViewController:controller];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(appDidBecomeActive)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initBannerView];
    [self loadBanner];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return self.wrappedViewController.preferredStatusBarStyle;
}


#pragma mark - Keychain Properties

- (NSInteger)launchesWithoutAds
{
    return [self keychainIntForKey:kKeyLaunchesWithoutAds];
}

- (void)setLaunchesWithoutAds:(NSInteger)launchesWithoutAds
{
    [self setKeychainInt:launchesWithoutAds forKey:kKeyLaunchesWithoutAds];
}

- (BOOL)adsRemoved
{
    return [self keychainIntForKey:kKeyAdsRemoved];
}

- (void)setAdsRemoved:(BOOL)adsRemoved
{
    [self setKeychainInt:adsRemoved forKey:kKeyAdsRemoved];
}

- (NSInteger)keychainIntForKey:(nonnull NSString *)key
{
    NSCParameterAssert(key);
    
    NSUInteger intValue;
    NSData *intData = [SAMKeychain passwordDataForService:[self keychainServiceID] account:key];
    
    if (intData) {
        [intData getBytes:&intValue length:sizeof(intValue)];
        return intValue;
    } else {
        return 0;
    }
}

- (void)setKeychainInt:(NSInteger)intValue forKey:(nonnull NSString *)key
{
    NSCParameterAssert(key);
    
    NSData *intData = [NSData dataWithBytes:&intValue length:sizeof(intValue)];
    [SAMKeychain setPasswordData:intData forService:[self keychainServiceID] account:key];
}

- (NSString *)keychainServiceID
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleIdentifierKey];
}


#pragma mark - Initialization Logic

- (void)initBannerView
{
    GADBannerView *bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    [self.view addSubview:bannerView];
    self.adMobView = bannerView;
    self.adMobView.hidden = YES;
    self.adMobView.rootViewController = self;
    self.adMobView.delegate = self;
    self.adMobView.adUnitID = self.adUnitID;
    
    UIView *containerView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:containerView];
    self.containerView = containerView;
    
    [containerView addSubview:self.wrappedViewController.view];
    
    [self setupLayout];
}

- (void)setupLayout
{
    [self.containerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.adMobView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
    NSLayoutConstraint *containerToBottomConstraint =
    [NSLayoutConstraint constraintWithItem:self.containerView
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0
                                  constant:0];
    [self.view addConstraint:containerToBottomConstraint];
    self.containerToBottomConstraint = containerToBottomConstraint;
    
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.adMobView
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.adMobView
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.adMobView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.containerView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
}

- (void)loadBanner
{
    if (self.adMobView == nil) { return; }
    if (self.adsRemoved == YES) { return; }
    if (self.launchesWithoutAds <= self.showAdsAfter) { return; }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        GADRequest *bannerRequest = [[GADRequest alloc] init];
        bannerRequest.gender = (GADGender)self.gender;
        if (self.birthday) { bannerRequest.birthday = self.birthday; }
        if (self.locationAccuracy != 0 && self.locationLatitude != 0 && self.locationLongitude != 0) {
            [bannerRequest setLocationWithLatitude:self.locationLatitude
                                         longitude:self.locationLongitude
                                          accuracy:self.locationAccuracy];
        }
        bannerRequest.testDevices = @[kGADSimulatorID];
        [self.adMobView loadRequest:bannerRequest];
    });
}


#pragma mark - Logic

- (void)appDidBecomeActive
{
    if (self.launchesWithoutAds <= self.showAdsAfter) {
        self.launchesWithoutAds += 1;
    } else {
        [self loadBanner];
    }
}

- (void)showBannerView:(BOOL)show
{
    if (show) { self.adMobView.hidden = NO; }
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.15 animations:^{
		CGFloat bottomOffset = self.bottomLayoutGuide.length + self.adMobView.bounds.size.height;
		self.containerToBottomConstraint.constant = show ? -bottomOffset : 0;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (!show) { self.adMobView.hidden = YES; }
    }];
}

- (void)restoreAdsForever
{
    self.adsRemoved = NO;
    self.adsViewIsHidden = NO;
    
    [self loadBanner];
}

- (void)removeAds:(BOOL)forever
{
    if (forever) { self.adsRemoved = YES; }
    
    self.adsViewIsHidden = YES;
    [self showBannerView:NO];
}


#pragma mark - GADBannerViewDelegate

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error
{
    self.adsViewIsHidden = YES;
    [self showBannerView:NO];
    
    NSLog(@"didFailToReceiveAdWithError: %@", error);
}

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView
{
    if (!self.adsRemoved && !self.adsViewIsHidden) {
        [self showBannerView:YES];
    }
}

@end
