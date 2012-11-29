//
//  ViewController.h
//  GeoNotification App
//
//  Created by XLab Developer on 11/21/12.
//  Copyright (c) 2012 XLab Developer. All rights reserved.
//
/**
 This application requires CoreLocation and MapKit libraries in order to build and run successfully; check link binary with libraries tab includes both libraries. The application allows the user to input coordinates (latitude,longitude) and a title in order to monitor that specified location in a radius of 100 meters.
 */
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
/**
 The UIViewController interface implements CLLocationManagerDelegate protocols in order to define the methods used to monitor user-defined regions. The user interface itself is simple: three fields to describe the region and a button to append the region to an array.
 */
@interface ViewController : UIViewController<CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

/**
 This method implements additional functionality to its super's viewDidLoad method by instantiating the NSMutableArray that stores regions and performs additional initalizations. Finally, it starts the generation of updates that report the user's current location by calling startUpdatingLocation of the locationManager.
 */
- (void)viewDidLoad;

/**
 This method checks to see if the device supports regionMonitoring and if locationServices are enabled. If all checks pass, startMonitoringForRegion is called. Otherwise, an error message is displayed and the application ends.
 */
- (void) initializeRegionMonitoring:(NSArray*)geofences;

/**
 This method checks to ensure location services are enabled. If so, a locationManager is instantiated and its delegate is set to the viewController. Otherwise, a notfication is generated stating that the user needs to enable location services.
 */
- (void)initializeLocationManager;

/**
 This method sets the mapView's default location to be the Berkeley Area and monitors the user's location.
 */
- (void)initializeMap;

/**
 Once the user enters a region that is currently being monitored, an alert pops up via showRegionAlert.
 */
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region;

/**
 This is a method solely for testing purposes. It creates a NSLog to confirm that the locationManager is now monitoring a new region.
 */
- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region;

/**
 This method is called once the submit button is pressed.  It checks if all the UITextFields have characters in them. If not, it will show a UIAlertView to notify the user to complete all fields. Otherwise,  it converts all the characters in the textfield to its corresponding Double value (nonnumerical values default to 0). A CLRegion is instantiated with the specified latitude, longitude, title, and radius of 100 meters, and is appended to the _regionArray.  A UIAlertview is generated to show the user that the submission was successful, and the textfields are cleared.
 */
- (IBAction)appendRegionToArray:(UIButton *)sender;

/**
 This method creates a UIAlertView that displays an alert whenever the method is called.
 */
- (void) showRegionAlert:(NSString *)alertText forRegion:(NSString *)regionIdentifier;

/**
 This method shows an alert with a message passed in as a parameter (alertText).
 */
- (void)showAlertWithMessage:(NSString*)alertText;

/**
 This method hides the keyboard whenever the return key is pressed in a textfield.
 */
-(IBAction)textFieldReturn:(UITextField *)sender;

@end
