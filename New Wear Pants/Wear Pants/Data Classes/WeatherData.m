//
//  WeatherData.m
//  Wear Pants
//
//  Created by Sony Theakanath on 1/26/15.
//  Copyright (c) 2015 Sony Theakanath. All rights reserved.
//

#import "WeatherData.h"

@implementation WeatherData

NSString* const BOUNDING_URL = @"http://query.yahooapis.com/v1/public/yql?q=select%20%2A%20from%20geo.places%20where%20text%3D%22";

NSString* const WEATHER_URL_FIRST = @"https://query.yahooapis.com/v1/public/yql?q=select%20item.forecast%2C%20item.condition.code%2C%20wind%2C%20atmosphere%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22";

NSString* const WEATHER_URL_LAST = @"%22)%20limit%201&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys";

NSString* const FLICKR_URL_FIRST = @"https://api.flickr.com/services/rest/?method=flickr.photos.search&format=json&nojsoncallback=1&media=photo&api_key=5340419091b235b4158194d4b71dd8dc&has_geo=1&extras=geo,url_m&bbox=";

NSString* const FLICKR_URL_LAST = @"&min_taken_date=2005-01-01%2000:00:00&group_id=1463451@N25&per_page=1";

NSDictionary* ANIMATION_TYPES = nil;

+ (void)initialize {
    ANIMATION_TYPES = @{ @[@32, @34, @36, @3200] : @"CLEAR_DAY", @[@31, @33] : @"CLEAR_NIGHT", @[@28, @30, @44] : @"PARTLY_CLOUDY_DAY", @[@27, @29] : @"PARTLY_CLOUDY_NIGHT", @[@26] : @"CLOUDY", @[@4, @5, @6, @8, @9, @11, @12, @40, @45, @47] : @"RAIN", @[@7, @10, @17, @18, @35, @37, @38, @39] : @"SLEET", @[@13, @14, @15, @16, @41, @42, @43, @46] : @"SNOW", @[@0, @1, @2, @3, @19, @23, @24, @25] : @"WIND", @[@20, @21, @22] : @"FOG", };
}

+ (NSString*) getBoundingBox:(NSString*)zipcode {
    NSData *data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", BOUNDING_URL, [zipcode stringByReplacingOccurrencesOfString:@" " withString:@"%20"], @"%22&format=json"]]];
    NSDictionary *places = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil] mutableCopy][@"query"][@"results"][@"place"];
    NSDictionary *boundingBox;
    if ([places isKindOfClass:[NSArray class]])
        boundingBox = [places mutableCopy][0][@"boundingBox"];
    else
        boundingBox = places[@"boundingBox"];
    return [NSString stringWithFormat:@"%@,%@,%@,%@", boundingBox[@"southWest"][@"longitude"], boundingBox[@"southWest"][@"latitude"], boundingBox[@"northEast"][@"longitude"], boundingBox[@"northEast"][@"latitude"]];
}

+ (NSMutableDictionary*) getTemperatureData:(NSString*)zipcode {
    NSMutableDictionary *finalresult = [[NSMutableDictionary alloc]initWithCapacity:10];
    NSData *data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", WEATHER_URL_FIRST, zipcode, WEATHER_URL_LAST]]];
    NSLog(@"%@", [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", WEATHER_URL_FIRST, zipcode, WEATHER_URL_LAST]]);
    NSDictionary *alldata = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil] mutableCopy][@"query"][@"results"][@"channel"];
    int weathercode = [alldata[@"item"][@"forecast"][@"code"] intValue];
    for (NSArray* elem in [ANIMATION_TYPES allKeys]) {
        if ([elem containsObject:@(weathercode)]) {
            [finalresult setObject:[ANIMATION_TYPES objectForKey:elem] forKey:@"animationtype"];
            break;
        }
    }
    [finalresult setObject:alldata[@"wind"][@"chill"] forKey:@"chill"];
    [finalresult setObject:alldata[@"atmosphere"][@"humidity"] forKey:@"humidity"];
    [finalresult setObject:alldata[@"item"][@"forecast"][@"low"] forKey:@"low"];
    [finalresult setObject:alldata[@"item"][@"forecast"][@"high"] forKey:@"high"];
    double humidity = [[finalresult objectForKey:@"humidity"] doubleValue]/100;
    double averagetemp = ([[finalresult objectForKey:@"high"] intValue]+[[finalresult objectForKey:@"low"] intValue])/2;
    double heatindex = -42.379 + 2.04901523*averagetemp + 10.14333127*humidity - 0.22475541*averagetemp*humidity - .00683783* pow(averagetemp, 2) - .05481717*pow(humidity, 2) + 1.22874*pow(10, -3)*pow(averagetemp, 2)*humidity + 8.5282*pow(humidity, 2)*pow(10, -4)*averagetemp - 1.99*pow(10, -6)*pow(humidity, 2)*pow(averagetemp, 2);
    [finalresult setObject:@(averagetemp) forKey:@"avgtemp"];
    [finalresult setObject:@(heatindex) forKey:@"heatindex"];
    return finalresult;
}

+ (UIImage*) getFlickrBackground:(NSString*) zipcode {
    NSString *boundingbox = [self getBoundingBox:zipcode];
    NSData *data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", FLICKR_URL_FIRST, boundingbox, FLICKR_URL_LAST]]];
    UIImage *bkgndimage;
    if (data && [[[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil] mutableCopy][@"photos"][@"total"] intValue] != 0) {
        NSString *picture_url = [[[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil] mutableCopy][@"photos"][@"photo"][0] mutableCopy][@"url_m"];
        NSData* imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:picture_url]];
        bkgndimage =  [[UIImage imageWithData:imageData] stackBlur:0];
    } else
        bkgndimage =  [[UIImage imageNamed:@"DefaultBackground.jpg"] stackBlur:1];
    return bkgndimage;
}

+ (CAGradientLayer*) greyGradient {
    UIColor *colorOne = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
    UIColor *colorTwo = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    UIColor *colorThree	= [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    UIColor *colorFour = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9];
    NSArray *colors =  [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, colorThree.CGColor, colorFour.CGColor, nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:0.5];
    NSNumber *stopThree = [NSNumber numberWithFloat:0.99];
    NSNumber *stopFour = [NSNumber numberWithFloat:1.0];
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, stopThree, stopFour, nil];
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    return headerLayer;
}

@end
