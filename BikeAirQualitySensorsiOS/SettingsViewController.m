//
//  SettingsViewController.m
//  BikeAirQualitySensorsiOS
//
//  Created by Simon Loffler on 20/11/16.
//  Copyright © 2016 RedBearLab. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_ipTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    // Load defaults from NSUserDefaults
    [self loadUserDefaults];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)loadUserDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _ipTextField.text = [defaults objectForKey:kTestIpAddressPreference];
    _testSwitch.on = [defaults boolForKey:kTestSwitchPreference];
}

- (IBAction)closeSwitch:(id)sender
{
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

- (IBAction)ipTextFieldAction:(id)sender
{
    NSLog(@"TextField is now: %@", sender);
}

- (void)textFieldDidChange:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[sender text] forKey:kTestIpAddressPreference];
    [defaults synchronize];
    NSLog(@"TextField is now: %@", sender);
}

- (IBAction)testSwitchAction:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:_testSwitch.isOn forKey:kTestSwitchPreference];
    [defaults synchronize];
    
    NSString *switchText;
    if ([(UISwitch *)sender isOn]) {
        switchText = @"ON";
    } else {
        switchText = @"OFF";
    }
    NSLog(@"Switch is now: %@", switchText);
}

@end
