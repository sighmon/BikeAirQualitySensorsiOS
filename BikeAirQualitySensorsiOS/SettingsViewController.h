//
//  SettingsViewController.h
//  BikeAirQualitySensorsiOS
//
//  Created by Simon Loffler on 20/11/16.
//  Copyright © 2016 RedBearLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface SettingsViewController : UIViewController <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *ipTextField;
@property (weak, nonatomic) IBOutlet UISwitch *testSwitch;

- (IBAction)closeSwitch:(id)sender;
- (IBAction)ipTextFieldAction:(id)sender;
- (IBAction)testSwitchAction:(id)sender;

@end
