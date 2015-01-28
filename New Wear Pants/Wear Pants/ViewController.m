//
//  ViewController.m
//  Wear Pants
//
//  Created by Sony Theakanath on 1/26/15.
//  Copyright (c) 2015 Sony Theakanath. All rights reserved.
//


#import "ViewController.h"


@interface ViewController ()

@property (nonatomic, strong) AnimatedWeatherView *animatedView;
@property (nonatomic, strong) DetailedWeatherReport *reportView;
@property (nonatomic, strong) PredictionButton *niceButton;
@property (nonatomic, strong) PredictionButton *badButton;
@property (nonatomic, strong) RobotoFont *questionLabel;
@property (nonatomic, strong) RobotoFont *answerLabel;
@property (nonatomic, strong) UIImageView *flickrImage;
@property (nonatomic, strong) IBOutlet CLLocationManager *locationManager;
@property (nonatomic, strong) IBOutlet CLGeocoder *geoCoder;

@end

static NSMutableArray* savedLinks = nil;

@implementation ViewController

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

- (BOOL)connectedToInternet {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
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
    [self moveAnimations:TRUE];
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

- (void) getCurrentTemperature:(NSString*)desiredcity {
    if([self connectedToInternet]) {
        NSMutableDictionary *data = [WeatherData getTemperatureData:desiredcity];
        NSString *filepath = [data objectForKey:@"code"];
        [self.animatedView loadFile:filepath];
        double heatindex =[[data objectForKey:@"heatindex"] doubleValue];
        if(heatindex < [[savedLinks objectAtIndex:0] intValue])
            [self.answerLabel setText:@"YES"];
        else
            [self.answerLabel setText:@"NO"];
        [self.reportView setData:@[[NSString stringWithFormat:@"%i%@", [[data objectForKey:@"humidity"] intValue], @"%"], [NSString stringWithFormat:@"%i %@", [[data objectForKey:@"chill"] intValue], @"F"], [NSString stringWithFormat:@"%i%@", [[data objectForKey:@"avgtemp"] intValue], @" F"]]];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Not Connected to the Internet!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}

#pragma mark - Interface Functions

- (void)viewDidLoad {
    [self setUpLocationServices];
    [self unarchiveData];
    [self.view addSubview:[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)]];
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    self.animatedView = [[AnimatedWeatherView alloc] init];
    [self.view addSubview:self.animatedView];
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
    self.flickrImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    [self.view insertSubview:self.flickrImage atIndex:1];
    self.navigationItem.leftBarButtonItem = [[MenuBarButton alloc] init:@"MenuButton" target:self selector:@selector(leftDrawerButtonPress:)];
    self.navigationItem.rightBarButtonItem = [[MenuBarButton alloc] init:@"PlusIcon" target:self selector:@selector(rightDrawerButtonPress:)];
    [self.navigationItem setTitle:@"Searching Location"];
    [super viewDidLoad];
}

- (void) setLocationDisabledScreen {
    [self.navigationItem setTitle:@"Feature Unavailable"];
    [self.questionLabel setText:@"To re-enable current location feature, go to Settings > Privacy."];
    [self.answerLabel setText:@"Check Sidebar!"];
    [self.answerLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:40]];
}

- (void) moveAnimations:(BOOL)isNormal {
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    if (isNormal) {
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^ {
            [self.niceButton setFrame:CGRectMake(-150, screenHeight/3+60, 140, 35)];
            [self.badButton setFrame:CGRectMake(screenWidth+110, screenHeight/3+60, 140, 35)];
        } completion:^(BOOL finished){
            [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^ {
                [self.questionLabel setFrame:CGRectMake(0, screenHeight/4, screenWidth, 50)];
                [self.answerLabel setFrame:CGRectMake(0, screenHeight/2-50, screenWidth, 50)];
            } completion:^(BOOL finished){}];
        }];
    } else {
        [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^ {
            [self.questionLabel setFrame:CGRectMake(0, screenHeight/6, screenWidth, 50)];
            [self.answerLabel setFrame:CGRectMake(0, screenHeight/3-25, screenWidth, 50)];
        } completion:^(BOOL finished){
            [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^ {
                [self.niceButton setFrame:CGRectMake(screenWidth/2-145, screenHeight/3+60, 140, 35)];
                [self.badButton setFrame:CGRectMake(screenWidth/2+5, screenHeight/3+60, 140, 35)];
            } completion:^(BOOL finished){}];
        }];
    }
}

- (void)setBackground:(NSString *)boundingbox {
    UIImageView *bkgndimage = [WeatherData getFlickrBackground:boundingbox];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.7];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    self.flickrImage = bkgndimage;
    [self.view insertSubview:self.flickrImage atIndex:1];
    [UIView commitAnimations];
    [self moveAnimations:FALSE];
}

- (void)reloadFrame:(NSString*) saveddata {
    [self.questionLabel setText:@"Should I Wear Pants Today?"];
    [self.answerLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:50]];
    [self getCurrentTemperature:[[[saveddata componentsSeparatedByString:@","] objectAtIndex:2] stringByReplacingOccurrencesOfString:@" " withString:@""]];
    [self setBackground:[NSString stringWithFormat:@"%@%@",[[saveddata componentsSeparatedByString:@","] objectAtIndex:0], [[saveddata componentsSeparatedByString:@","] objectAtIndex:1]]];
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
        [self getCurrentTemperature:[placemark.addressDictionary valueForKey:@"ZIP"]];
        [self setBackground:[NSString stringWithFormat:@"%@ %@", [placemark.addressDictionary valueForKey:@"City"], [placemark.addressDictionary valueForKey:@"State"]]];
        [self.navigationItem setTitle:[placemark.addressDictionary valueForKey:@"City"]];
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

# pragma arguments - Public Functions

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

+ (NSMutableArray*) saveddata {
    return savedLinks;
}

@end
