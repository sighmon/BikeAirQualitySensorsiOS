//
//  AppDelegate.m
//  SimpleControl
//
//  Created by Cheong on 6/11/12.
//  Copyright (c) 2012 RedBearLab. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager requestAlwaysAuthorization];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.pausesLocationUpdatesAutomatically = YES;
    [locationManager setActivityType:CLActivityTypeFitness];
    
    // Set a movement threshold for new events.
    locationManager.distanceFilter = 5; // meters
    
    [locationManager startUpdatingLocation];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    // Setup for background location updates.
//    isBackgroundMode = YES;
//    [locationManager stopUpdatingLocation];
//    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
//    [locationManager setDistanceFilter:kCLDistanceFilterNone];
//    locationManager.pausesLocationUpdatesAutomatically = NO;
//    locationManager.activityType = CLActivityTypeOther;
//    [locationManager startUpdatingLocation];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    isBackgroundMode = NO;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

# pragma mark - CoreLocation

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // Send notification to the view controller
    [[NSNotificationCenter defaultCenter] postNotificationName:@"locationUpdated" object:locations];
    
    // Handle background updates
//    if (isBackgroundMode && !deferringUpdates)
//    {
//        deferringUpdates = YES;
//        [locationManager allowDeferredLocationUpdatesUntilTraveled:CLLocationDistanceMax timeout: 2];
//    }
}

-(void)locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error
{
    NSLog(@"Finished Deferred updates.");
    deferringUpdates = NO;
    
    // Do something?
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Location manager error: %@", error);
}

-(void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    NSLog(@"Location manager state: %ld, region: %@", (long)state, region);
}

@end
