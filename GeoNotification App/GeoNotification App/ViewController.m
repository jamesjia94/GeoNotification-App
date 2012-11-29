//
//  ViewController.m
//  GeoNotification App
//
//  Created by XLab Developer on 11/21/12.
//  Copyright (c) 2012 XLab Developer. All rights reserved.
//

#import "ViewController.h"
/**
 The view controller declares the existence of three UITextFields: latitude,longitude, and title. It declares a locationManager, whose delegate will be the View Controller itself, a NSMutableArray (_regionArray) to store the regions, and instantiates the mapView (the object that displays the map).
 */
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *latitudeField;
@property (weak, nonatomic) IBOutlet UITextField *longitudeField;
@property (weak, nonatomic) IBOutlet UITextField *titleField;

@end

@implementation ViewController
CLLocationManager *_locationManager;
NSMutableArray *_regionArray;
@synthesize mapView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    _regionArray=[[NSMutableArray alloc] init];
    [self initializeMap];
    [self initializeLocationManager];
    [_locationManager startUpdatingLocation];
}

- (void) initializeRegionMonitoring:(NSArray*)geofences {
    if(![CLLocationManager regionMonitoringAvailable]) {
        [self showAlertWithMessage:@"This app requires region monitoring features which are unavailable on this device."];
        return;
    }
    else if ([CLLocationManager authorizationStatus]!=kCLAuthorizationStatusAuthorized)
    {
        [self showAlertWithMessage:@"Please enable location services."];
        return;
    }
    else{
        for(CLRegion *geofence in geofences) {
            [_locationManager startMonitoringForRegion:geofence];
        }
    }
}

- (void)initializeLocationManager {
    if(![CLLocationManager locationServicesEnabled]) {
        [self showAlertWithMessage:@"You need to enable location services to use this app."];
        return;
    }
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
}

- (void)initializeMap {
    CLLocationCoordinate2D initialCoordinate;
    initialCoordinate.latitude = 37.87;
    initialCoordinate.longitude = 122.3;
    
    [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(initialCoordinate, 400, 400) animated:YES];
    self.mapView.centerCoordinate = initialCoordinate;
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
}


//Region Checks
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    [self showRegionAlert:@"Entering Region" forRegion:region.identifier];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    [self showRegionAlert:@"Exiting Region" forRegion:region.identifier];
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    NSLog(@"Started monitoring %@ region", region.identifier);
}


//Helper Functions
- (IBAction)appendRegionToArray:(UIButton *)sender {
    if ([_latitudeField.text length]>0 && [_longitudeField.text length]>0 && [_titleField.text length]>0){
        CLLocationDegrees latitude = _latitudeField.text.doubleValue;
        CLLocationDegrees longitude = _longitudeField.text.doubleValue;
        CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(latitude,longitude);
        CLLocationDistance regionRadius = 100;
        NSString *title = _titleField.text;
        [_regionArray addObject:[[CLRegion alloc] initCircularRegionWithCenter:centerCoordinate
                                                radius:regionRadius
                                                                    identifier:title]];
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:_titleField.text
                                  message:@"Appended region" delegate:self
                                  cancelButtonTitle:@"Confirm"
                                  otherButtonTitles:nil];
        [alertView show];
        
        [self initializeRegionMonitoring:_regionArray];
        _titleField.text=nil;
        _latitudeField.text=nil;
        _longitudeField.text=nil;
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Incomplete Fields"
                                                            message:@"Complete all fields"
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void) showRegionAlert:(NSString *)alertText forRegion:(NSString *)regionIdentifier {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:alertText
                                                      message:regionIdentifier
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
}

- (void)showAlertWithMessage:(NSString*)alertText {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Location Services Error"
                                                        message:alertText
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
}

-(IBAction)textFieldReturn:(UITextField *)sender
{
    [sender resignFirstResponder];
}
@end
