//
//  BIKSensorDataMO+CoreDataProperties.m
//  BikeAirQualitySensorsiOS
//
//  Created by Simon Loffler on 5/10/2015.
//  Copyright © 2015 RedBearLab. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "BIKSensorDataMO+CoreDataProperties.h"

@implementation BIKSensorDataMO (CoreDataProperties)

@dynamic deviceid;
@dynamic timestamp;
@dynamic latitude;
@dynamic longitude;
@dynamic temperature;
@dynamic humidity;
@dynamic particles;
@dynamic carbonmonoxide;

@end
