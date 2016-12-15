//
//  ViewController.m
//  Example
//
//  Created by Oleksandr Kirichenko on 12/15/16.
//  Copyright © 2016 Oleksandr Kirichenko. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)removeAdsButtonPressed:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NoteRemoveAds" object:nil];
}

@end
