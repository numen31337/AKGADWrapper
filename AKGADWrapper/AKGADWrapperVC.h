//
//  AKGADWrapperVC.h
//  AKGADWrapper
//
//  Created by Oleksandr Kirichenko on 2/7/16.
//  Copyright © 2016 Oleksandr Kirichenko. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 A wrapper for a UIViewController with a GADBannerView at the bottom
 */
@interface AKGADWrapperVC : UIViewController

typedef NS_ENUM(NSInteger, GADBaseGender) {
    GADBaseGenderUnknown,
    GADBaseGenderMale,
    GADBaseGenderFemale
};

/** Optional user's gender */
@property (assign, nonatomic) GADBaseGender gender;
/** Optional user's birthday */
@property (strong, nonatomic, nullable) NSDate *birthday;
/** Optional user's location */
@property (assign, nonatomic) CGFloat locationLongitude;
/** Optional user's location */
@property (assign, nonatomic) CGFloat locationLatitude;
/** Optional user's location */
@property (assign, nonatomic) CGFloat locationAccuracy;

/**
 Number of app launches without presenting ads, default is 0. 
 You can set this number for example to 3, to show ads only on a 4th launch
 */
@property (assign, nonatomic) NSInteger showAdsAfter;

/** The wrapped UIViewController */
@property (weak, nonatomic, readonly, nullable) UIViewController *wrappedViewController;

/**
 * Designated Initializer
 *
 * @param controller Instance of a UIViewController to wrap
 * @param adUnitID Ad unit ID for your banner at the bottom of the view controller
 * @return A wrapped view controller with the GADBannerView at the bottom
 */
- (nonnull instancetype)initWithViewController:(nonnull UIViewController *)controller
                                      adUnitID:(nonnull NSString *)adUnitID;

/** Permanently restore ads presentation if they was removed forever */
- (void)restoreAdsForever;

/**
 * Removes ads
 *
 * @param forever Pass `true` to remove ads forever or `false` to disable ads until next banner will be received
 */
- (void)removeAds:(BOOL)forever;

@end
