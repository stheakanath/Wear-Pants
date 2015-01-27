//
//  ViewController.m
//  Wear Pants
//
//  Created by Sony Theakanath on 6/8/13.
//  Copyright (c) 2013 Sony Theakanath. All rights reserved.
//


#import "ViewController.h"

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
}














#pragma mark - Interface

- (void)startVariables {
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    interfaceArray = [[NSMutableArray alloc] initWithObjects:
                      [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)],
                      [[UILabel alloc] initWithFrame:CGRectMake(0, screenHeight/6, screenWidth, 50)],
                      [[UILabel alloc] initWithFrame:CGRectMake(0, screenHeight/3-25, screenWidth, 50)],
                      [UIButton buttonWithType:UIButtonTypeCustom],
                      [UIButton buttonWithType:UIButtonTypeCustom],
                      [[UIWebView alloc] initWithFrame:CGRectMake(screenWidth/2-5, screenHeight/2+55 , 170, 170)],
                      [[UILabel alloc] initWithFrame:CGRectMake(screenWidth/2-145, screenHeight/2+80, 150, 20)],
                      [[UILabel alloc] initWithFrame:CGRectMake(screenWidth/2-145, screenHeight/2+122.5, 150, 20)],
                      [[UILabel alloc] initWithFrame:CGRectMake(screenWidth/2-145, screenHeight/2+165, 150, 20)],
                      [[UILabel alloc] initWithFrame:CGRectMake(screenWidth/2-145, screenHeight/2+80, 140, 20)],
                      [[UILabel alloc] initWithFrame:CGRectMake(screenWidth/2-145, screenHeight/2+122.5, 140, 20)],
                      [[UILabel alloc] initWithFrame:CGRectMake(screenWidth/2-145, screenHeight/2+165, 140, 20)],
                      nil];
    [self setUpLocationServices];
}

- (void)startInterface {
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    [[interfaceArray objectAtIndex:1] setFont:[UIFont fontWithName:@"Roboto-Light" size:20]];
    [[interfaceArray objectAtIndex:1] setBackgroundColor:[UIColor clearColor]];
    [[interfaceArray objectAtIndex:1] setText:@"Should I Wear Pants Today?"];
    [[interfaceArray objectAtIndex:1] setTextAlignment:NSTextAlignmentCenter];
    [[interfaceArray objectAtIndex:1] setLineBreakMode:NSLineBreakByWordWrapping];
    [[interfaceArray objectAtIndex:1] setNumberOfLines:0];
    [[interfaceArray objectAtIndex:1] setShadowColor:[UIColor blackColor]];
    [[interfaceArray objectAtIndex:1] setShadowOffset:CGSizeMake(0.5, 0)];
    [[interfaceArray objectAtIndex:1] setTextColor:[UIColor whiteColor]];
    [[interfaceArray objectAtIndex:2] setFont:[UIFont fontWithName:@"Roboto-Medium" size:50]];
    [[interfaceArray objectAtIndex:2] setBackgroundColor:[UIColor clearColor]];
    [[interfaceArray objectAtIndex:2] setText:@"Checking."];
    [[interfaceArray objectAtIndex:2] setTextAlignment:NSTextAlignmentCenter];
    [[interfaceArray objectAtIndex:2] setShadowColor:[UIColor blackColor]];
    [[interfaceArray objectAtIndex:2] setTextColor:[UIColor whiteColor]];
    [[interfaceArray objectAtIndex:2] setShadowOffset:CGSizeMake(0.5, 0)];
    for(int x = 0; x < 2; x++) {
        [[interfaceArray objectAtIndex:3+x] setFont:[UIFont fontWithName:@"Roboto-Light" size:16]];
        [[interfaceArray objectAtIndex:3+x] setBackgroundColor:[UIColor clearColor]];
        [[interfaceArray objectAtIndex:3+x] setTitleColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0] forState:UIControlStateNormal];
        [[interfaceArray objectAtIndex:3+x] setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [[interfaceArray objectAtIndex:3+x] setTitleColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0] forState:UIControlStateHighlighted];
        [[interfaceArray objectAtIndex:3+x] setTitleShadowColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [[interfaceArray objectAtIndex:3+x]  setBackgroundImage:[UIImage imageNamed:@"PredictButton.png"] forState:UIControlStateNormal];
        [[interfaceArray objectAtIndex:3+x]  setBackgroundImage:[UIImage imageNamed:@"PredictButton_Selected.png"] forState:UIControlStateHighlighted];
    }
    [[interfaceArray objectAtIndex:3] setFrame:CGRectMake(-150, screenHeight/3+60, 140, 35)];
    [[interfaceArray objectAtIndex:3] setTitle:@"Nice Prediction!" forState:UIControlStateNormal];
    [[interfaceArray objectAtIndex:3] addTarget:self action:@selector(nicePredictionPressed) forControlEvents:UIControlEventTouchUpInside];
    [[interfaceArray objectAtIndex:4] setFrame:CGRectMake(screenWidth+110, screenHeight/3+60, 140, 35)];
    [[interfaceArray objectAtIndex:4] setTitle:@"Bad Prediction" forState:UIControlStateNormal];
    [[interfaceArray objectAtIndex:4] addTarget:self action:@selector(badPredictionPressed) forControlEvents:UIControlEventTouchUpInside];    
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

- (void)setBackground:(NSString *)boundingbox intofweather:(int)typeofweather {
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
        bkgndimage =  [[UIImageView alloc] initWithImage:[[UIImage imageWithData:imageData] stackBlur:0]];
    } else {
        back = [UIImage imageNamed:@"cloud.jpg"];
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
    NSLog(@"-----------");
    [[interfaceArray objectAtIndex:1] setText:@"Should I Wear Pants Today?"];
    [[interfaceArray objectAtIndex:2] setFont:[UIFont fontWithName:@"Roboto-Medium" size:50]];
    int type = [self getCurrentTemperature:[[[saveddata componentsSeparatedByString:@","] objectAtIndex:2] stringByReplacingOccurrencesOfString:@" " withString:@""]];
    [self setBackground:[self getBoundingBox:[NSString stringWithFormat:@"%@%@",[[saveddata componentsSeparatedByString:@","] objectAtIndex:0], [[saveddata componentsSeparatedByString:@","] objectAtIndex:1]]] intofweather:type];
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
    __block BOOL finished = NO;
    [self.geoCoder reverseGeocodeLocation: locationManager.location completionHandler: ^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        NSString* locatedAt = [placemark.addressDictionary valueForKey:@"ZIP"];
        NSString* currcity = [placemark.addressDictionary valueForKey:@"City"];
        NSString* currstate = [placemark.addressDictionary valueForKey:@"State"];
        city = currcity;
        self.zipcode = locatedAt;
        finished = YES;
        if(finished == YES) {
            if([CLLocationManager authorizationStatus]) {
                int type = [self getCurrentTemperature:zipcode];
                [self setBackground:[self getBoundingBox:[NSString stringWithFormat:@"%@ %@", city, currstate]] intofweather:type];
                [self.navigationItem setTitle:city];
            } else {
                if(![CLLocationManager authorizationStatus]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Service Disabled" message:@"To re-enable, please go to Settings and turn on Location Service for this app." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert setTag:12];
                    [alert show];
                }
            }
        }
    }];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if ([alertView tag] == 12) {
        if (buttonIndex != 123) {
           [self setLocationDisabledScreen];
        }
    } else if ([alertView tag] == 0) {
        [self setLocationDisabledScreen];
    }
}

- (NSString*) getBoundingBox:(NSString *)localzipcode {
    NSArray *basecutstring = [[[[[[[NSString alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@%@", @"http://query.yahooapis.com/v1/public/yql?q=select%20%2A%20from%20geo.places%20where%20text%3D%22", [localzipcode stringByReplacingOccurrencesOfString:@" " withString:@"%20"], @"%22&format=xml"]]] encoding: NSASCIIStringEncoding] componentsSeparatedByString:@"<boundingBox><southWest>"] objectAtIndex:1] componentsSeparatedByString:@"</boundingBox>"] objectAtIndex:0] componentsSeparatedByString:@"<latitude>"];
    NSString *southwestlatitude = [[[basecutstring objectAtIndex:1] componentsSeparatedByString:@"</latitude>"] objectAtIndex:0];
    NSString *southwestlongitude = [[[[[[[basecutstring objectAtIndex:1] componentsSeparatedByString:@"</latitude>"] objectAtIndex:1] componentsSeparatedByString:@"<longitude>"] objectAtIndex:1] componentsSeparatedByString:@"</longitude>"] objectAtIndex:0];
    NSString *northeastlatitude = [[[basecutstring objectAtIndex:2] componentsSeparatedByString:@"</latitude>"] objectAtIndex:0];
    NSString *northeastlongitude = [[[[[[[basecutstring objectAtIndex:2] componentsSeparatedByString:@"</latitude>"] objectAtIndex:1] componentsSeparatedByString:@"<longitude>"] objectAtIndex:1] componentsSeparatedByString:@"</longitude>"] objectAtIndex:0];
    return [NSString stringWithFormat:@"%@,%@,%@,%@", southwestlongitude, southwestlatitude, northeastlongitude, northeastlatitude];
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

- (int) getCurrentTemperature: (NSString*)desiredcity {
    if([self connectedToInternet]) {
        [[interfaceArray objectAtIndex:5] loadHTMLString:@"" baseURL:nil];
        int type;
        NSURL* url = [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", @"http://xml.weather.yahoo.com/forecastrss?p=", desiredcity]];
        NSLog(@"Pulling Temperature URL: %@", url);
        NSString *blork = [[NSString alloc] initWithData:[NSData dataWithContentsOfURL:url] encoding: NSASCIIStringEncoding];
        NSString *typeofweather = [[[[[[[blork componentsSeparatedByString:@"<yweather:forecast"] objectAtIndex:1] componentsSeparatedByString:@"code=\""] objectAtIndex:1] componentsSeparatedByString:@"\""] objectAtIndex:0] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        NSString *filepath;
        if([typeofweather isEqualToString:@"32"] || [typeofweather isEqualToString:@"34"] || [typeofweather isEqualToString:@"36"] || [typeofweather isEqualToString:@"3200"]) {
            filepath = @"sun";
            type = 1;
        } else if ([typeofweather isEqualToString:@"31"] || [typeofweather isEqualToString:@"33"]  ) {
            filepath = @"nightclear";
            type = 2;
        } else if ([typeofweather isEqualToString:@"28"] || [typeofweather isEqualToString:@"30"]  ||  [typeofweather isEqualToString:@"44"]) {
            filepath = @"partlycloudyday";
            type = 3;
        } else if ([typeofweather isEqualToString:@"27"] || [typeofweather isEqualToString:@"29"]) {
            filepath = @"partlycloudynight";
            type = 3;
        } else if ([typeofweather isEqualToString:@"26"]) {
            filepath = @"cloudy";
            type = 3;
        } else if ([typeofweather isEqualToString:@"5"] || [typeofweather isEqualToString:@"6"] || [typeofweather isEqualToString:@"8"] || [typeofweather isEqualToString:@"9"] || [typeofweather isEqualToString:@"11"] || [typeofweather isEqualToString:@"12"]|| [typeofweather isEqualToString:@"40"]|| [typeofweather isEqualToString:@"4"]|| [typeofweather isEqualToString:@"45"]|| [typeofweather isEqualToString:@"47"]) {
            filepath = @"rain";
            type = 4;
        } else if ([typeofweather isEqualToString:@"7"] || [typeofweather isEqualToString:@"10"] || [typeofweather isEqualToString:@"35"] || [typeofweather isEqualToString:@"37"] || [typeofweather isEqualToString:@"17"] || [typeofweather isEqualToString:@"18"]|| [typeofweather isEqualToString:@"38"]|| [typeofweather isEqualToString:@"39"]) {
            filepath = @"sleet";
            type = 5;
        } else if ([typeofweather isEqualToString:@"13"] || [typeofweather isEqualToString:@"14"] || [typeofweather isEqualToString:@"15"] || [typeofweather isEqualToString:@"16"] || [typeofweather isEqualToString:@"41"] || [typeofweather isEqualToString:@"42"]|| [typeofweather isEqualToString:@"43"] || [typeofweather isEqualToString:@"46"]) {
            filepath = @"snow";
            type = 5;
        } else if ([typeofweather isEqualToString:@"0"] || [typeofweather isEqualToString:@"1"] || [typeofweather isEqualToString:@"2"] || [typeofweather isEqualToString:@"3"] || [typeofweather isEqualToString:@"19"] || [typeofweather isEqualToString:@"23"] || [typeofweather isEqualToString:@"24"] || [typeofweather isEqualToString:@"25"]) {
            filepath = @"wind";
            type = 6;
        } else if ([typeofweather isEqualToString:@"20"] || [typeofweather isEqualToString:@"21"] || [typeofweather isEqualToString:@"22"]) {
            filepath = @"fog";
            type = 6;
        } else {
            filepath = @"sun";
            type = 1;
        }
        if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0)) {
            filepath = [filepath stringByAppendingString:@"1"];
            [[[interfaceArray objectAtIndex:5] scrollView] setMinimumZoomScale:0.5];
            [[[interfaceArray objectAtIndex:5] scrollView] setMaximumZoomScale:0.5];
            [[[interfaceArray objectAtIndex:5] scrollView] setZoomScale:0.5];
        }
        NSString *finalpath = [[NSBundle mainBundle] pathForResource:filepath ofType: @"html"];
        [[interfaceArray objectAtIndex:5] loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:finalpath]]];

        //Pulling Data
        int windtemperature = [[[[[[[[[blork componentsSeparatedByString:@"<yweather:wind"] objectAtIndex:1] componentsSeparatedByString:@"/>"] objectAtIndex:0] componentsSeparatedByString:@"chill=\""] objectAtIndex:1] componentsSeparatedByString:@"\""] objectAtIndex:0] intValue];
        double humidity = [[[[[[[[[blork componentsSeparatedByString:@"<yweather:atmosphere"] objectAtIndex:1] componentsSeparatedByString:@"/>"] objectAtIndex:0]componentsSeparatedByString:@"humidity=\""] objectAtIndex:1] componentsSeparatedByString:@"\""] objectAtIndex:0] intValue]/100;
        int integerhumdity = (int)[[[[[[[[[blork componentsSeparatedByString:@"<yweather:atmosphere"] objectAtIndex:1] componentsSeparatedByString:@"/>"] objectAtIndex:0]componentsSeparatedByString:@"humidity=\""] objectAtIndex:1] componentsSeparatedByString:@"\""] objectAtIndex:0] intValue];
        hum = [NSString stringWithFormat:@"%i%@", integerhumdity, @"%"];
        //int windspeed = [[[[[[[[[blork componentsSeparatedByString:@"<yweather:wind"] objectAtIndex:1] componentsSeparatedByString:@"/>"] objectAtIndex:0] componentsSeparatedByString:@"speed=\""] objectAtIndex:1] componentsSeparatedByString:@"\""] objectAtIndex:0] intValue];
        int lowtemp = [[[[[[[[[blork componentsSeparatedByString:@"<yweather:forecast"] objectAtIndex:1] componentsSeparatedByString:@"/>"] objectAtIndex:0] componentsSeparatedByString:@"low=\""] objectAtIndex:1] componentsSeparatedByString:@"\""] objectAtIndex:0] intValue];
        int hightemp = [[[[[[[[[blork componentsSeparatedByString:@"<yweather:forecast"] objectAtIndex:1] componentsSeparatedByString:@"/>"] objectAtIndex:0] componentsSeparatedByString:@"high=\""] objectAtIndex:1] componentsSeparatedByString:@"\""] objectAtIndex:0] intValue];
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
        return type;
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Not Connected to the Internet!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    return -1;
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

-(void)doubleTap:(UITapGestureRecognizer*)gesture{
    [self.mm_drawerController bouncePreviewForDrawerSide:MMDrawerSideLeft completion:nil];
}

-(void)twoFingerDoubleTap:(UITapGestureRecognizer*)gesture{
    [self.mm_drawerController bouncePreviewForDrawerSide:MMDrawerSideLeft completion:nil];
}

#pragma mark - Other


- (void)viewDidLoad {
    [self startVariables];
    [self startInterface];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    //Naviagtion Bar Setup
   // [[UINavigationBar appearance] setTitleTextAttributes: @{ UITextAttributeTextColor: [UIColor whiteColor], UITextAttributeTextShadowColor: [UIColor blackColor], UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 0.7f)], UITextAttributeFont: [UIFont fontWithName:@"Roboto-Medium" size:20.0f]}];
  //  self.navigationController.navigationBar.translucent = YES;
  //  const CGFloat colorMask[6] = {222, 255, 222, 255, 222, 255};
  //  [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithCGImage: CGImageCreateWithMaskingColors([[UIImage alloc] init].CGImage, colorMask)] forBarMetrics:UIBarMetricsDefault];
    

    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    UIImage *menubuttonimage = [UIImage imageNamed:@"MenuButton.png"];
    CGRect menubuttonframe = CGRectMake(0, 0, menubuttonimage.size.width, menubuttonimage.size.height);
    UIButton *menubutton = [[UIButton alloc] initWithFrame:menubuttonframe];
    [menubutton setBackgroundImage:menubuttonimage forState:UIControlStateNormal];
    [menubutton addTarget:self action:@selector(leftDrawerButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [menubutton setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *menubarbutton = [[UIBarButtonItem alloc] initWithCustomView:menubutton];
    self.navigationItem.leftBarButtonItem = menubarbutton;
    UIImage *addbuttonimage = [UIImage imageNamed:@"plus_icon"];
    CGRect addbuttonframe = CGRectMake(0, 0, addbuttonimage.size.width, addbuttonimage.size.height);
    UIButton *addbutton = [[UIButton alloc] initWithFrame:addbuttonframe];
    [addbutton setBackgroundImage:addbuttonimage forState:UIControlStateNormal];
    [addbutton addTarget:self action:@selector(rightDrawerButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [addbutton setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *addbarbutton =[[UIBarButtonItem alloc] initWithCustomView:addbutton];
    self.navigationItem.rightBarButtonItem = addbarbutton;
    
    //Gestures
    UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    [doubleTap setNumberOfTapsRequired:2];
    [self.view addGestureRecognizer:doubleTap];
    UITapGestureRecognizer * twoFingerDoubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(twoFingerDoubleTap:)];
    [twoFingerDoubleTap setNumberOfTapsRequired:2];
    [twoFingerDoubleTap setNumberOfTouchesRequired:2];
    [self.view addGestureRecognizer:twoFingerDoubleTap];

    //Title and Rest
    [self.navigationItem setTitle:@"Searching Location"];
    [super viewDidLoad];
    
    //Other
    locationManager.delegate=self;
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [locationManager requestWhenInUseAuthorization];
        NSLog(@"TEST");
    } else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" message:@"To re-enable, please go to Settings and turn on Location Service for this app." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert setTag:0];
        [alert show];
    } else {
        [locationManager startUpdatingLocation];
        [NSTimer scheduledTimerWithTimeInterval:.2 target:self selector:@selector(getZipCode) userInfo:nil repeats:NO];
    }
    //For Testing, uncomment next line for final release
    //[self reloadFrame:@"New York City, NY, 10001"];
}

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
