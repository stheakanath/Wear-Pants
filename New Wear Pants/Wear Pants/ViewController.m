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
#import "AnimatedWeatherView.h"
#import "DetailedWeatherReport.h"

@interface ViewController ()

@property (nonatomic, strong) AnimatedWeatherView *animatedView;
@property (nonatomic, strong) DetailedWeatherReport *reportView;
@property (nonatomic, strong) PredictionButton *niceButton;
@property (nonatomic, strong) PredictionButton *badButton;
@property (nonatomic, strong) RobotoFont *questionLabel;
@property (nonatomic, strong) RobotoFont *answerLabel;
@property (strong, nonatomic) IBOutlet CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet CLGeocoder *geoCoder;

@end

static NSMutableArray* savedLinks = nil;

@implementation ViewController
@synthesize zipcode, city, avgtemp, hum;

#pragma mark - Geocoding Data

- (void) setUpLocationServices {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [self.locationManager startUpdatingLocation];
    self.geoCoder = [[CLGeocoder alloc] init];
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)
        [self.locationManager requestWhenInUseAuthorization];
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" message:@"To re-enable, please go to Settings and turn on Location Service for this app." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
        [self.locationManager startUpdatingLocation];
        [NSTimer scheduledTimerWithTimeInterval:.2 target:self selector:@selector(getZipCode) userInfo:nil repeats:NO];
    }
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

- (void) badPredictionPressed {
    int value;
    if([[self.answerLabel text] isEqualToString:@"YES"])
        value = [[savedLinks objectAtIndex:0] intValue]-1;
    else
        value = [[savedLinks objectAtIndex:0] intValue]+1;
    [savedLinks replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%i", value]];
    NSString* dataPath = [[NSString alloc] initWithString:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"data.plist"]];
    NSMutableArray *data = savedLinks;
    [[NSKeyedArchiver archivedDataWithRootObject:data] writeToFile:dataPath atomically:YES];
    [self moveScreenToNormal];
}

#pragma mark - Data Processing

- (void) unarchiveData {
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
}

#pragma mark - Interface Functions

- (void)viewDidLoad {
    [self setUpLocationServices];
    [self unarchiveData];
    [self.view addSubview:[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)]];
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    self.animatedView = [[AnimatedWeatherView alloc] init];
    [self.view addSubview: self.animatedView];
    self.reportView = [[DetailedWeatherReport alloc] init];
    [self.view addSubview:self.reportView];
    self.niceButton = [[PredictionButton alloc] init:CGRectMake(-150, screenHeight/3+60, 140, 35) setTitle:@"Nice Prediction!" target:self selector:@selector(moveScreenToNormal)];
    [self.view addSubview:self.niceButton];
    self.badButton = [[PredictionButton alloc] init:CGRectMake(screenWidth+110, screenHeight/3+60, 140, 35) setTitle:@"Bad Prediction!" target:self selector:@selector(badPredictionPressed)];
    [self.view addSubview:self.badButton];
    self.questionLabel = [[RobotoFont alloc] init:CGRectMake(0, screenHeight/6, screenWidth, 50) fontName:@"Roboto-Light" fontSize:20];
    [self.questionLabel setText:@"Should I Wear Pants Today?"];
    [self.view addSubview:self.questionLabel];
    self.answerLabel = [[RobotoFont alloc] init:CGRectMake(0, screenHeight/3-25, screenWidth, 50) fontName:@"Roboto-Medium" fontSize:50];
    [self.answerLabel setText:@"Checking."];
    [self.view addSubview:self.answerLabel];
    self.navigationItem.leftBarButtonItem = [[MenuBarButton alloc] init:@"MenuButton" target:self selector:@selector(leftDrawerButtonPress:)];
    self.navigationItem.rightBarButtonItem = [[MenuBarButton alloc] init:@"PlusIcon" target:self selector:@selector(rightDrawerButtonPress:)];
    [self.navigationItem setTitle:@"Searching Location"];
    [super viewDidLoad];
}














- (void) moveScreenToNormal {
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^ {
        [self.niceButton setFrame:CGRectMake(-150, screenHeight/3+60, 140, 35)];
        [self.badButton setFrame:CGRectMake(screenWidth+110, screenHeight/3+60, 140, 35)];
    } completion:^(BOOL finished){
        [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^ {
            [self.questionLabel setFrame:CGRectMake(0, screenHeight/4, screenWidth, 50)];
            [self.answerLabel setFrame:CGRectMake(0, screenHeight/2-50, screenWidth, 50)];
        } completion:^(BOOL finished){
        }];
    }];

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
        [self.questionLabel setFrame:CGRectMake(0, screenHeight/6, screenWidth, 50)];
        [self.answerLabel setFrame:CGRectMake(0, screenHeight/3-25, screenWidth, 50)];
    } completion:^(BOOL finished){
        [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^ {
            [self.niceButton setFrame:CGRectMake(screenWidth/2-145, screenHeight/3+60, 140, 35)];
            [self.badButton setFrame:CGRectMake(screenWidth/2+5, screenHeight/3+60, 140, 35)];
        } completion:^(BOOL finished){}];
    }];
}

- (void)reloadFrame:(NSString*) saveddata {
    NSLog(@"CALLED");
    NSLog(@"-----------");
    [self.questionLabel setText:@"Should I Wear Pants Today?"];
    [self.answerLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:50]];
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
    [self.niceButton setFrame:CGRectMake(-150, screenHeight/3+60, 140, 35)];
    [self.badButton setFrame:CGRectMake(screenWidth+110, screenHeight/3+60, 140, 35)];
    [self.answerLabel setText:@"Should I Wear Pants Today?"];
    [self.answerLabel setText:@"Please Wait"];
    
    [self.reportView setData:@[@"Loading", @"Loading", @"Loading"]];
    [self.navigationItem setTitle:@"Loading"];
}

#pragma mark - Pulling Location Information

-(void) getZipCode {
    [self.geoCoder reverseGeocodeLocation: self.locationManager.location completionHandler: ^(NSArray *placemarks, NSError *error) {
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
        [self.questionLabel setText:@"Should I Wear Pants Today?"];
        [self.answerLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:50]];
        [self getZipCode];
    } else {
        if(![CLLocationManager authorizationStatus]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Service Disabled" message:@"To re-enable, please go to Settings and turn on Location Service for this feature." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
}

- (void) setLocationDisabledScreen {
    [self.navigationItem setTitle:@"Feature Unavailable"];

    [self.questionLabel setText:@"To re-enable current location feature, go to Settings > Privacy."];
    [self.answerLabel setText:@"Check Sidebar!"];
    [self.answerLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:40]];
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
        NSMutableDictionary *data = [WeatherData getTemperatureData:desiredcity];
        NSString *filepath = [data objectForKey:@"code"];
        [self.animatedView loadFile:filepath];
        

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
            [self.answerLabel setText:@"YES"];
            [self.view setBackgroundColor:[UIColor whiteColor]];
        } else {
            [self.answerLabel setText:@"NO"];
            [self.view setBackgroundColor:[UIColor blackColor]];
        }
        [self.reportView setData:@[hum, [NSString stringWithFormat:@"%i %@", windtemperature, @"F"], avgtemp]];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Not Connected to the Internet!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }

}

+(NSMutableArray*) saveddata {
    return savedLinks;
}



@end
