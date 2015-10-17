//
//  TableViewController.m
//  SimpleControl
//
//  Created by Cheong on 7/11/12.
//  Copyright (c) 2012 RedBearLab. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController () {
    
    float _temperature;
    float _humidity;
    float _particles;
    float _carbonMonoxide;
    char _heaterOn;
    
    int _deviceid;
    NSDate *_timestamp;
    double _latitude;
    double _longitude;
}

@end

@implementation TableViewController

@synthesize ble;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Setup CoreData
        [self initializeCoreData];
        [self initializeCoreLocation];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    ble = [[BLE alloc] init];
    [ble controlSetup];
    ble.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - BLE delegate

NSTimer *rssiTimer;

- (void)bleDidDisconnect
{
    NSLog(@"->Disconnected");

    [btnConnect setTitle:@"Connect" forState:UIControlStateNormal];
    [indConnecting stopAnimating];
    
    lblRSSI.text = @"---";
    sensorValues.text = @"t: --- h: --- s: --- *---*";
    
    [rssiTimer invalidate];
}

// When RSSI is changed, this will be called
-(void) bleDidUpdateRSSI:(NSNumber *) rssi
{
    lblRSSI.text = rssi.stringValue;
}

-(void) readRSSITimer:(NSTimer *)timer
{
    [ble readRSSI];
}

// When disconnected, this will be called
-(void) bleDidConnect
{
    NSLog(@"->Connected");

    [indConnecting stopAnimating];

    // Schedule to read RSSI every 1 sec.
    rssiTimer = [NSTimer scheduledTimerWithTimeInterval:(float)1.0 target:self selector:@selector(readRSSITimer:) userInfo:nil repeats:YES];
}

// When data is comming, this will be called
-(void) bleDidReceiveData:(unsigned char *)data length:(int)length
{
    // Decode struct data
    
    struct SENSOR_READINGS {
        float temperature;
        float humidity;
        float particles;
        float carbonMonoxide;
        char heaterOn;
    };
    
    struct SENSOR_READINGS sensorReadings;
    memcpy(&sensorReadings, data, sizeof(struct SENSOR_READINGS));
    
    _temperature = sensorReadings.temperature;
    _humidity = sensorReadings.humidity;
    _particles = sensorReadings.particles;
    _carbonMonoxide = sensorReadings.carbonMonoxide;
    _heaterOn = sensorReadings.heaterOn;
    
    _deviceid = 1;
    _timestamp = [NSDate date];
//    _latitude = ;
//    _longitude = ;
    
    sensorValues.text = [NSString stringWithFormat:@"t: %.01f h: %.01f p: %.01f %@: %.01f",
                         _temperature,
                         _humidity,
                         _particles,
                         _heaterOn ? @"C" : @"c",
                         _carbonMonoxide];
    
    NSLog(@"Length: %d, Raw data: %s", length, data);
    NSLog(@"Data: %@", sensorValues.text);
    
    // Save to core data if the data size is 17
    if ([self isLastDataValid] && length == 17) {
        [self saveToCoreData];
    }
    
    // TODO: Save to/append to file for the day's data?
    
    
}

#pragma mark - Actions

// Connect button will call to this
- (IBAction)btnScanForPeripherals:(id)sender
{
    if (ble.activePeripheral)
        if(ble.activePeripheral.state == CBPeripheralStateConnected)
        {
            [[ble CM] cancelPeripheralConnection:[ble activePeripheral]];
            [btnConnect setTitle:@"Connect" forState:UIControlStateNormal];
            return;
        }
    
    if (ble.peripherals)
        ble.peripherals = nil;
    
    [btnConnect setEnabled:false];
    [ble findBLEPeripherals:2];
    
    [NSTimer scheduledTimerWithTimeInterval:(float)2.0 target:self selector:@selector(connectionTimer:) userInfo:nil repeats:NO];
    
    [indConnecting startAnimating];
}

-(void) connectionTimer:(NSTimer *)timer
{
    [btnConnect setEnabled:true];
    [btnConnect setTitle:@"Disconnect" forState:UIControlStateNormal];
    
    if (ble.peripherals.count > 0)
    {
        [ble connectPeripheral:[ble.peripherals objectAtIndex:0]];
    }
    else
    {
        [btnConnect setTitle:@"Connect" forState:UIControlStateNormal];
        [indConnecting stopAnimating];
    }
}

- (IBAction)exportToCSV:(id)sender
{
    // Export to a CSV that you can download via iTunes
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SensorData"];
    [request setReturnsObjectsAsFaults:NO];
    NSError *error = nil;
    NSArray *results = [[self managedObjectContext] executeFetchRequest:request error:&error];
    if (!results) {
        NSLog(@"Error fetching SensorData objects: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    } else {
        NSLog(@"Loading results...");
        // Loop thorugh the saved data and write to a CSV
        NSMutableArray *loadedData = [[NSMutableArray alloc] init];
        [loadedData addObject: @"deviceid, timestamp, latitude, longitude, humidity, temperature, particles, carbonmonoxide, heaterOn" ];

        for (BIKSensorDataMO *result in results) {
            
            // Set date to ISO 8601
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            NSLocale *adelaideLocale = [NSLocale localeWithLocaleIdentifier:@"Australia/Adelaide"];
            [dateFormatter setLocale:adelaideLocale];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
            NSString *iso8601String = [dateFormatter stringFromDate:result.timestamp];
            
            // Add it to the array of CoreData
            [loadedData addObject:[NSString stringWithFormat:@"%hd, %@, %f, %f, %f, %f, %f, %f, %hhd",
                                   result.deviceid,
                                   iso8601String,
                                   result.latitude,
                                   result.longitude,
                                   result.humidity,
                                   result.temperature,
                                   result.particles,
                                   result.carbonmonoxide,
                                   (char)result.heaterOn]];
        }
        
        if (loadedData.count > 1) {
            NSLog(@"Loaded %lu results, saving to a file.", (unsigned long)loadedData.count);
            // Export to a file
            [self writeToTextFile:[loadedData componentsJoinedByString:@" \n"]];
        } else {
            NSLog(@"ERROR: no results loaded.. sadface.");
        }
    }
}

#pragma mark - File manager

//Method writes a string to a text file
-(void)writeToTextFile: (NSString *)dataString
{
    // Get the documents directory:
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths lastObject];
    
    // Make a file name to write the data to using the documents directory
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *adelaideLocale = [NSLocale localeWithLocaleIdentifier:@"Australia/Adelaide"];
    [dateFormatter setLocale:adelaideLocale];
    [dateFormatter setDateFormat:@"yyyy-MM-dd-HH.mm.ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    NSString *filename = [NSString stringWithFormat:@"sensor-data-%@.csv", dateString];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:filename];
    NSError *error;
    [dataString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (!error) {
        NSLog(@"File successfully created: %@", filename);
    } else {
        NSLog(@"ERROR writing file: %@\n%@", [error localizedDescription], [error userInfo]);
    }
}

#pragma mark - CoreData

-(void)initializeCoreData
{
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"SensorData" withExtension:@"momd"];
    NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSAssert(mom != nil, @"Error initializing Managed Object Model");
    
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [moc setPersistentStoreCoordinator:psc];
    [self setManagedObjectContext:moc];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [documentsURL URLByAppendingPathComponent:@"SensorData.sqlite"];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        NSError *error = nil;
        NSPersistentStoreCoordinator *psc = [[self managedObjectContext] persistentStoreCoordinator];
        NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
        NSAssert(store != nil, @"Error initializing PSC: %@\n%@", [error localizedDescription], [error userInfo]);
    });
}

- (void)saveToCoreData
{
    BIKSensorDataMO *sensorDataManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"SensorData" inManagedObjectContext:[self managedObjectContext]];
    
    sensorDataManagedObject.deviceid = _deviceid;
    sensorDataManagedObject.timestamp = _timestamp;
    sensorDataManagedObject.latitude = _latitude;
    sensorDataManagedObject.longitude = _longitude;
    sensorDataManagedObject.humidity = _humidity;
    sensorDataManagedObject.temperature = _temperature;
    sensorDataManagedObject.particles = _particles;
    sensorDataManagedObject.carbonmonoxide = _carbonMonoxide;
    sensorDataManagedObject.heaterOn = _heaterOn;
    
    NSError *error = nil;
    if ([[self managedObjectContext] save:&error] == NO) {
        NSAssert(NO, @"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
    } else {
        NSLog(@"Saved sensor data: %@", sensorDataManagedObject);
    }
}

# pragma mark - convinience functions

- (bool)isLastDataValid
{
    if (_humidity != 0 &&
        _temperature != 0 &&
        _particles != 0 &&
        _carbonMonoxide != 0 &&
        _deviceid != 0 &&
        _timestamp &&
        _latitude != 0 &&
        _longitude != 0) {
        return true;
    } else {
        return false;
    }
}

# pragma mark - CoreLocation

-(void)initializeCoreLocation
{
    if (locationManager == nil) {
        locationManager = [[CLLocationManager alloc] init];
    }
    
    locationManager.delegate = self;
    [locationManager requestWhenInUseAuthorization];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // Set a movement threshold for new events.
    locationManager.distanceFilter = 5; // meters
    
    [locationManager requestLocation];
    
    [locationManager startUpdatingLocation];
    [locationManager startMonitoringSignificantLocationChanges];
    
}

-(void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    NSLog(@"Location manager state: %ld, region: %@", (long)state, region);
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation *location = [locations lastObject];
    _latitude = location.coordinate.latitude;
    _longitude = location.coordinate.longitude;
    NSDate *eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (fabs(howRecent) < 15.0) {
        // If the event is recent, do something with it.
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              location.coordinate.latitude,
              location.coordinate.longitude);
        
        _latitude = location.coordinate.latitude;
        _longitude = location.coordinate.longitude;
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Location manager error: %@", error);
}

@end
