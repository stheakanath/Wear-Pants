//
//  ViewController.h
//  Wear Pants
//
//  Created by Sony Theakanath on 1/26/15.
//  Copyright (c) 2015 Sony Theakanath. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
#import "AddScreen.h"
#import "AnimatedWeatherView.h"
#import "DetailedWeatherReport.h"
#import "MenuBarButton.h"
#import "MMDrawerVisualState.h"
#import "PredictionButton.h"
#import "Reachability.h"
#import "RobotoFont.h"
#import "UIViewController+MMDrawerController.h"
#import "ViewControllerDelegate.h"
#import "WeatherData.h"

@interface ViewController : UIViewController<CLLocationManagerDelegate, UIAlertViewDelegate, ViewControllerDelegate>

+ (NSMutableArray*) saveddata;
+ (void) addNewCity:(NSString*) newcitydata;
+ (void) deleteCity:(int)index;

@end
