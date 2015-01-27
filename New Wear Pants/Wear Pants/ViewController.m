//
//  ViewController.m
//  Wear Pants
//
//  Created by Sony Theakanath on 6/8/13.
//  Copyright (c) 2013 Sony Theakanath. All rights reserved.
//


#import "ViewController.h"
#import "RobotoFont.h"
#import "MenuBarButton.h"
#import "PredictionButton.h"
#import "UIImage+StackBlur.h"
#import "WeatherData.h"

@interface ViewController ()

@end

static NSMutableArray* savedLinks = nil;

@implementation ViewController
@synthesize interfaceArray, locationManager, geoCoder, zipcode, city, avgtemp, hum;

#pragma mark - Geocoding Data

- (void) setUpLocationServices {
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [locationManager startUpdatingLocation];
    geoCoder = [[CLGeocoder alloc] init];
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)
        [locationManager requestWhenInUseAuthorization];
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" message:@"To re-enable, please go to Settings and turn on Location Service for this app." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert setTag:0];
        [alert show];
    } else {
        [locationManager startUpdatingLocation];
        [NSTimer scheduledTimerWithTimeInterval:.2 target:self selector:@selector(getZipCode) userInfo:nil repeats:NO];
    }
}

- (void)viewDidLoad {
    //modifiy code
    [self setUpLocationServices];
    [self startVariables];
    [self startInterface];
    
    //code below is final
    self.navigationItem.leftBarButtonItem = [[MenuBarButton alloc] init:@"MenuButton" target:self selector:@selector(leftDrawerButtonPress:)];
    self.navigationItem.rightBarButtonItem = [[MenuBarButton alloc] init:@"PlusIcon" target:self selector:@selector(rightDrawerButtonPress:)];
    [self.navigationItem setTitle:@"Searching Location"];
    [super viewDidLoad];
}








#pragma mark - Interface

- (void)startVariables {
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    interfaceArray = [[NSMutableArray alloc] initWithObjects:
                      [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)],
                      [[RobotoFont alloc] init:CGRectMake(0, screenHeight/6, screenWidth, 50) fontName:@"Roboto-Light" fontSize:20],
                      [[RobotoFont alloc] init:CGRectMake(0, screenHeight/3-25, screenWidth, 50) fontName:@"Roboto-Medium" fontSize:50],
                      [[PredictionButton alloc] init:CGRectMake(-150, screenHeight/3+60, 140, 35) setTitle:@"Nice Prediction!" target:self selector:@selector(nicePredictionPressed)],
                      [[PredictionButton alloc] init:CGRectMake(screenWidth+110, screenHeight/3+60, 140, 35) setTitle:@"Bad Prediction!" target:self selector:@selector(badPredictionPressed)],
                      [[UIWebView alloc] initWithFrame:CGRectMake(screenWidth/2-5, screenHeight/2+55 , 170, 170)],
                      [[UILabel alloc] initWithFrame:CGRectMake(screenWidth/2-145, screenHeight/2+80, 150, 20)],
                      [[UILabel alloc] initWithFrame:CGRectMake(screenWidth/2-145, screenHeight/2+122.5, 150, 20)],
                      [[UILabel alloc] initWithFrame:CGRectMake(screenWidth/2-145, screenHeight/2+165, 150, 20)],
                      [[UILabel alloc] initWithFrame:CGRectMake(screenWidth/2-145, screenHeight/2+80, 140, 20)],
                      [[UILabel alloc] initWithFrame:CGRectMake(screenWidth/2-145, screenHeight/2+122.5, 140, 20)],
                      [[UILabel alloc] initWithFrame:CGRectMake(screenWidth/2-145, screenHeight/2+165, 140, 20)],
                      nil];

}

- (void)startInterface {
    [[interfaceArray objectAtIndex:1] setText:@"Should I Wear Pants Today?"];
    [[interfaceArray objectAtIndex:2] setText:@"Checking."];
    
    
    [[interfaceArray objectAtIndex:5] setBackgroundColor:[UIColor clearColor]];
    [[interfaceArray objectAtIndex:5] setOpaque:NO];
    [[interfaceArray objectAtIndex:5] setEnabled:NO];
    for(int x = 6; x < 12; x++) {
        [[interfaceArray objectAtIndex:x] setFont:[UIFont fontWithName:@"Roboto-Light" size:16.5]];
        [[interfaceArray objectAtIndex:x] setTextAlignment:NSTextAlignmentLeft];
        [[interfaceArray objectAtIndex:x] setBackgroundColor:[UIColor clearColor]];
        [[interfaceArray objectAtIndex:x] setShadowColor:[UIColor blackColor]];
        [[interfaceArray objectAtIndex:x] setShadowOffset:CGSizeMake(0.5, 0)];
        [[interfaceArray objectAtIndex:x] setTextColor:[UIColor whiteColor]];
    }
    for(int x = 9; x < 12; x++)
        [[interfaceArray objectAtIndex:x] setTextAlignment:NSTextAlignmentRight];
    [[interfaceArray objectAtIndex:6] setText:@"Humidity"];
    [[interfaceArray objectAtIndex:7] setText:@"Wind Temp"];
    [[interfaceArray objectAtIndex:8] setText:@"Avg Temp"];

    
    //Pulling Saved Data
    NSString* dataPath = [[NSString alloc] initWithString:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"data.plist"]];
    NSMutableArray *data = [[NSMutableArray alloc] init];
    if([[[NSFileManager alloc] init] fileExistsAtPath:dataPath])
        data = [NSKeyedUnarchiver unarchiveObjectWithFile:dataPath];
    if([data count] == 0) {
        [data insertObject:@"61" atIndex:0];
        [data insertObject:@"Current Location, 00000" atIndex:1];
        [[NSKeyedArchiver archivedDataWithRootObject:data] writeToFile:dataPath atomically:YES];
    }
    savedLinks = data;
    for (UIView *view in interfaceArray)
        if(![view superview])
            [[self view] addSubview:view];
}

- (void) moveScreenToNormal {
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^ {
        [[interfaceArray objectAtIndex:3] setFrame:CGRectMake(-150, screenHeight/3+60, 140, 35)];
        [[interfaceArray objectAtIndex:4] setFrame:CGRectMake(screenWidth+110, screenHeight/3+60, 140, 35)];
    } completion:^(BOOL finished){
        [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^ {
            [[interfaceArray objectAtIndex:1] setFrame:CGRectMake(0, screenHeight/4, screenWidth, 50)];
            [[interfaceArray objectAtIndex:2] setFrame:CGRectMake(0, screenHeight/2-50, screenWidth, 50)];
        } completion:^(BOOL finished){
        }];
    }];

}

- (void) nicePredictionPressed {
    [self moveScreenToNormal];
}

- (void) badPredictionPressed {
    int value;
    if([[[interfaceArray objectAtIndex:2] text] isEqualToString:@"YES"])
       value = [[savedLinks objectAtIndex:0] intValue]-1;
    else
        value = [[savedLinks objectAtIndex:0] intValue]+1;
    [savedLinks replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%i", value]];
    NSString* dataPath = [[NSString alloc] initWithString:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"data.plist"]];
    NSMutableArray *data = savedLinks;
    [[NSKeyedArchiver archivedDataWithRootObject:data] writeToFile:dataPath atomically:YES];
    [self moveScreenToNormal];
}

- (void)setBackground:(NSString *)boundingbox {
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    NSArray *d1 = [[[NSString alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@%@", @"https://api.flickr.com/services/rest/?method=flickr.photos.search&media=photo&api_key=5340419091b235b4158194d4b71dd8dc&has_geo=1&extras=geo,url_m&bbox=", boundingbox, @"&min_taken_date=2005-01-01%2000:00:00&group_id=1463451@N25&per_page=5"]]] encoding: NSASCIIStringEncoding] componentsSeparatedByString:@"url_m=\""];
    NSLog(@"Flickr Pictures URL: %@%@%@", @"https://api.flickr.com/services/rest/?method=flickr.photos.search&media=photo&api_key=5340419091b235b4158194d4b71dd8dc&has_geo=1&extras=geo,url_m&bbox=", boundingbox, @"&min_taken_date=2005-01-01%2000:00:00&group_id=1463451@N25&per_page=5");
    UIImageView *bkgndimage;
    UIImage *back;
    if([d1 count] != 1) {
        NSArray *d2 = [[d1 objectAtIndex:1] componentsSeparatedByString:@"\""];
        NSString *link = [d2 objectAtIndex:0];
        NSURL *imageURL = [NSURL URLWithString:link];
        NSData* imageData = [NSData dataWithContentsOfURL:imageURL];
        bkgndimage =  [[UIImageView alloc] initWithImage:[[UIImage imageWithData:imageData] stackBlur:1]];
    } else {
        back = [UIImage imageNamed:@"DefaultBackground.jpg"];
        bkgndimage =  [[UIImageView alloc] initWithImage:[back stackBlur:1]];
    }
    UIView *v = [self.view viewWithTag:900];
    v.hidden = YES;
    [self.view bringSubviewToFront:v];
    [v removeFromSuperview];
    CAGradientLayer *bgLayer = [BackgroundLayer greyGradient];
	bgLayer.frame = self.view.bounds;
    [bkgndimage.layer insertSublayer:bgLayer atIndex:0];
    bkgndimage.contentMode = UIViewContentModeScaleAspectFill;
    [bkgndimage setFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    [bkgndimage setTag:900];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.7];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    [self.view insertSubview:bkgndimage atIndex:1];
    [UIView commitAnimations];
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^ {
        [[interfaceArray objectAtIndex:1] setFrame:CGRectMake(0, screenHeight/6, screenWidth, 50)];
        [[interfaceArray objectAtIndex:2] setFrame:CGRectMake(0, screenHeight/3-25, screenWidth, 50)];
    } completion:^(BOOL finished){
        [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^ {
            [[interfaceArray objectAtIndex:3] setFrame:CGRectMake(screenWidth/2-145, screenHeight/3+60, 140, 35)];
            [[interfaceArray objectAtIndex:4] setFrame:CGRectMake(screenWidth/2+5, screenHeight/3+60, 140, 35)];
        } completion:^(BOOL finished){}];
    }];
}

- (void)reloadFrame:(NSString*) saveddata {
    NSLog(@"CALLED");
    NSLog(@"-----------");
    [[interfaceArray objectAtIndex:1] setText:@"Should I Wear Pants Today?"];
    [[interfaceArray objectAtIndex:2] setFont:[UIFont fontWithName:@"Roboto-Medium" size:50]];
    [self getCurrentTemperature:[[[saveddata componentsSeparatedByString:@","] objectAtIndex:2] stringByReplacingOccurrencesOfString:@" " withString:@""]];
    [self setBackground:[WeatherData getBoundingBox:[NSString stringWithFormat:@"%@%@",[[saveddata componentsSeparatedByString:@","] objectAtIndex:0], [[saveddata componentsSeparatedByString:@","] objectAtIndex:1]]]];
    [self.navigationItem setTitle:[[saveddata componentsSeparatedByString:@","] objectAtIndex:0]];
}

- (void) setLoadingView {
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    UIView *v = [self.view viewWithTag:900];
    v.hidden = YES;
    [self.view setBackgroundColor:[UIColor blackColor]];
    [[interfaceArray objectAtIndex:3] setFrame:CGRectMake(-150, screenHeight/3+60, 140, 35)];
    [[interfaceArray objectAtIndex:4] setFrame:CGRectMake(screenWidth+110, screenHeight/3+60, 140, 35)];
    [[interfaceArray objectAtIndex:2] setText:@"Should I Wear Pants Today?"];
    [[interfaceArray objectAtIndex:2] setText:@"Please Wait"];
    [[interfaceArray objectAtIndex:9] setText:@"Loading"];
    [[interfaceArray objectAtIndex:10] setText:@"Loading"];
    [[interfaceArray objectAtIndex:11] setText:@"Loading"];
    [self.navigationItem setTitle:@"Loading"];
}

#pragma mark - Pulling Location Information

-(void) getZipCode {
    [self.geoCoder reverseGeocodeLocation: locationManager.location completionHandler: ^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        NSString* locatedAt = [placemark.addressDictionary valueForKey:@"ZIP"];
        NSString* currcity = [placemark.addressDictionary valueForKey:@"City"];
        NSString* currstate = [placemark.addressDictionary valueForKey:@"State"];
        city = currcity;
        self.zipcode = locatedAt;
        [self getCurrentTemperature:zipcode];
        [self setBackground:[WeatherData getBoundingBox:[NSString stringWithFormat:@"%@ %@", city, currstate]]];
        [self.navigationItem setTitle:city];

    }];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if ([alertView tag] == 0)
        [self setLocationDisabledScreen];
}

- (void) reloadCurrentLocation {
    if([CLLocationManager authorizationStatus]) {
        [[interfaceArray objectAtIndex:1] setText:@"Should I Wear Pants Today?"];
        [[interfaceArray objectAtIndex:2] setFont:[UIFont fontWithName:@"Roboto-Medium" size:50]];
        [self getZipCode];
    } else {
        if(![CLLocationManager authorizationStatus]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Service Disabled" message:@"To re-enable, please go to Settings and turn on Location Service for this feature." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert setTag:12];
            [alert show];
        }
    }
}

- (void) setLocationDisabledScreen {
    [self.navigationItem setTitle:@"Feature Unavailable"];

    [[interfaceArray objectAtIndex:1] setText:@"To re-enable current location feature, go to Settings > Privacy."];
    [[interfaceArray objectAtIndex:2] setText:@"Check Sidebar!"];
    [[interfaceArray objectAtIndex:2] setFont:[UIFont fontWithName:@"Roboto-Medium" size:40]];
}

- (BOOL)connectedToInternet {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}

+ (void) addNewCity:(NSString*) newcitydata {
    NSString* dataPath = [[NSString alloc] initWithString:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"data.plist"]];
    NSMutableArray *data = [[NSMutableArray alloc] init];
    if([[[NSFileManager alloc] init] fileExistsAtPath:dataPath])
        data = [NSKeyedUnarchiver unarchiveObjectWithFile:dataPath];
    [data addObject:newcitydata];
    savedLinks = data;
    [[NSKeyedArchiver archivedDataWithRootObject:data] writeToFile:dataPath atomically:YES];
}

+ (void) deleteCity:(int)index {
    NSMutableArray *newarray = [savedLinks mutableCopy];
    [newarray removeObjectAtIndex:index+1];
    NSString* dataPath = [[NSString alloc] initWithString:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"data.plist"]];
    [[NSKeyedArchiver archivedDataWithRootObject:newarray] writeToFile:dataPath atomically:YES];
    savedLinks = newarray;
}

#pragma mark - Pulling Weather Information

- (void) getCurrentTemperature: (NSString*)desiredcity {
    if([self connectedToInternet]) {
        [[interfaceArray objectAtIndex:5] loadHTMLString:@"" baseURL:nil];

       // NSLog(@"%@", city);
        NSURL* url = [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", @"http://xml.weather.yahoo.com/forecastrss?p=", desiredcity]];
        NSLog(@"Pulling Temperature URL: %@", url);
        NSString *blork = [[NSString alloc] initWithData:[NSData dataWithContentsOfURL:url] encoding: NSASCIIStringEncoding];
        NSString *typeofweather = [[[[[[[blork componentsSeparatedByString:@"<yweather:forecast"] objectAtIndex:1] componentsSeparatedByString:@"code=\""] objectAtIndex:1] componentsSeparatedByString:@"\""] objectAtIndex:0] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        //NSLog(typeofweather);
        NSMutableDictionary *data = [WeatherData getTemperatureData:desiredcity];
        
        NSString *filepath = [data objectForKey:@"code"];

        if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0)) {
            filepath = [filepath stringByAppendingString:@"1"];
            [[[interfaceArray objectAtIndex:5] scrollView] setMinimumZoomScale:0.5];
            [[[interfaceArray objectAtIndex:5] scrollView] setMaximumZoomScale:0.5];
            [[[interfaceArray objectAtIndex:5] scrollView] setZoomScale:0.5];
        }
        NSString *finalpath = [[NSBundle mainBundle] pathForResource:filepath ofType: @"html"];
        [[interfaceArray objectAtIndex:5] loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:finalpath]]];

        //Pulling Data
        int windtemperature = [[data objectForKey:@"chill"] intValue];
        int humi = [[data objectForKey:@"humidity"] doubleValue];
        hum = [NSString stringWithFormat:@"%i%@", humi, @"%"];
        double humidity = humi/100;
        int hightemp = [[data objectForKey:@"high"] intValue];
        int lowtemp = [[data objectForKey:@"low"] intValue];
        double averagetemp = (hightemp+lowtemp)/2;
        self.avgtemp = [NSString stringWithFormat:@"%i%@", (int)averagetemp, @" F"];
        double heatindex = -42.379 + 2.04901523*averagetemp + 10.14333127*humidity - 0.22475541*averagetemp*humidity - .00683783* pow(averagetemp, 2) - .05481717*pow(humidity, 2) + 1.22874*pow(10, -3)*pow(averagetemp, 2)*humidity + 8.5282*pow(humidity, 2)*pow(10, -4)*averagetemp - 1.99*pow(10, -6)*pow(humidity, 2)*pow(averagetemp, 2);
        NSLog(@"Heat Index: %f", heatindex);
        //Measu ring and Relaying Information
        if(heatindex < [[savedLinks objectAtIndex:0] intValue]) {
            [[interfaceArray objectAtIndex:2] setText:@"YES"];
            [self.view setBackgroundColor:[UIColor whiteColor]];
        } else {
            [[interfaceArray objectAtIndex:2] setText:@"NO"];
            [self.view setBackgroundColor:[UIColor blackColor]];
        }
        [[interfaceArray objectAtIndex:9] setText:hum];
        [[interfaceArray objectAtIndex:10] setText:[NSString stringWithFormat:@"%i %@", windtemperature, @"F"]];
        [[interfaceArray objectAtIndex:11] setText:avgtemp];

    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Not Connected to the Internet!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }

}

+(NSMutableArray*) saveddata {
    return savedLinks;
}

#pragma mark - Button/Gesture Handling

-(void)rightDrawerButtonPress:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    AddCityViewController *myVC = (AddCityViewController *)[storyboard instantiateViewControllerWithIdentifier:@"MainNavigationController"];
    [self presentViewController:myVC animated:YES completion:nil];
}

-(void)leftDrawerButtonPress:(id)sender {
    [self.mm_drawerController setDrawerVisualStateBlock:[MMDrawerVisualState swingingDoorVisualStateBlock]];
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}


#pragma mark - Other




- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
  //  NSLog(@"%@", [CLLocationManager authorizationStatus]);
    NSLog(@"Test");
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [locationManager startUpdatingLocation];
        [NSTimer scheduledTimerWithTimeInterval:.2 target:self selector:@selector(getZipCode) userInfo:nil repeats:NO];
    } else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" message:@"To re-enable, please go to Settings and turn on Location Service for this app." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert setTag:0];
       [alert show];
    }
}

- (void) viewDidUnload {
    [self setLocationManager:nil];
    [self setGeoCoder:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
