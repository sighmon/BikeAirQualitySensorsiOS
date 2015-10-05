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

@interface TableViewController : UITableViewController <BLEDelegate>
{
    IBOutlet UIButton *btnConnect;
    IBOutlet UIActivityIndicatorView *indConnecting;
    IBOutlet UILabel *lblRSSI;
    IBOutlet UILabel *sensorValues;
}

@property (strong, nonatomic) BLE *ble;
@property (strong) NSManagedObjectContext *managedObjectContext;

- (void)initializeCoreData;

@end
