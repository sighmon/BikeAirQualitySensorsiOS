//
//  TableViewController.h
//  SimpleControl
//
//  Created by Cheong on 7/11/12.
//  Copyright (c) 2012 RedBearLab. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BLE.h"
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>

#import "BIKSensorDataMO+CoreDataProperties.h"

@interface TableViewController : UITableViewController <BLEDelegate, CLLocationManagerDelegate>
{
    IBOutlet UIButton *btnConnect;
    IBOutlet UIActivityIndicatorView *indConnecting;
    IBOutlet UILabel *lblRSSI;
    IBOutlet UIProgressView *rssiProgressView;
    IBOutlet UILabel *sensorValues;
//    IBOutlet LineChartView *lineChart;
    
    CLLocationManager *locationManager;
}

@property (strong, nonatomic) BLE *ble;
@property (strong) NSManagedObjectContext *managedObjectContext;

- (void)initializeCoreData;

@end
