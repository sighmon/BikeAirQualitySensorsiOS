//
//  AppDelegate.h
//  SimpleControl
//
//  Created by Cheong on 6/11/12.
//  Copyright (c) 2012 RedBearLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    BOOL isBackgroundMode;
    BOOL deferringUpdates;
}

@property (strong, nonatomic) UIWindow *window;

@end
