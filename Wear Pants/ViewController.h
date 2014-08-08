//
//  ViewController.h
//  Wear Pants
//
//  Created by Sony Theakanath on 6/8/13.
//  Copyright (c) 2013 Sony Theakanath. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
#import "ViewControllerDelegate.h"
#import "AddCityViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "MMDrawerVisualState.h"
#import "UIImage+StackBlur.h"
#import "BackgroundLayer.h"
#import "Reachability.h"
#import "USLocation.h"

@interface ViewController : UIViewController<CLLocationManagerDelegate, UIAlertViewDelegate, ViewControllerDelegate, UIWebViewDelegate> {
    NSMutableArray *interfaceArray;
    NSString *city;
    NSString *avgtemp;
    NSString *hum;
}

+ (NSMutableArray*) saveddata;
+ (void) addNewCity:(NSString*) newcitydata;
+ (void) deleteCity:(int)index;

@property (nonatomic, retain) NSMutableArray *interfaceArray;
@property (strong, nonatomic) IBOutlet CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet CLGeocoder *geoCoder;
@property (retain, nonatomic) NSString *zipcode;
@property (retain, nonatomic) NSString *city;
@property (retain, nonatomic) NSString *avgtemp;
@property (retain, nonatomic) NSString* hum;

@end
