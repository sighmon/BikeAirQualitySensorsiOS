//
//  BIKSensorDataMO+CoreDataProperties.h
//  BikeAirQualitySensorsiOS
//
//  Created by Simon Loffler on 10/10/2015.
//  Copyright © 2015 RedBearLab. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "BIKSensorDataMO.h"

NS_ASSUME_NONNULL_BEGIN

@interface BIKSensorDataMO (CoreDataProperties)

@property (nonatomic) float carbonmonoxide;
@property (nonatomic) int16_t deviceid;
@property (nonatomic) BOOL heaterOn;
@property (nonatomic) float humidity;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic) float particles;
@property (nonatomic) float temperature;
@property (nonatomic) NSDate *timestamp;

@end

NS_ASSUME_NONNULL_END
