//
//  WeatherData.m
//  Wear Pants
//
//  Created by Sony Theakanath on 1/26/15.
//  Copyright (c) 2015 Sony Theakanath. All rights reserved.
//

#import "WeatherData.h"

@implementation WeatherData

static NSString* const BOUNDING_URL = @"http://query.yahooapis.com/v1/public/yql?q=select%20%2A%20from%20geo.places%20where%20text%3D%22";

static NSString* const WEATHER_URL_FIRST = @"https://query.yahooapis.com/v1/public/yql?q=select%20item.forecast%2C%20item.condition.code%2C%20wind%2C%20atmosphere%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22";

static NSString* const WEATHER_URL_LAST = @"%22)%20limit%201&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys";

static NSDictionary* ANIMATION_TYPES = nil;

+ (void)initialize {
    ANIMATION_TYPES = @{ @[@32, @34, @36, @3200] : @"sun", @[@31, @33] : @"nightclear", @[@28, @30, @44] : @"partlycloudyday", @[@27, @29] : @"partlycloudynight", @[@26] : @"cloudy", @[@4, @5, @6, @8, @9, @11, @12, @40, @45, @47] : @"rain", @[@7, @10, @17, @18, @35, @37, @38, @39] : @"sleet", @[@13, @14, @15, @16, @41, @42, @43, @46] : @"snow", @[@0, @1, @2, @3, @19, @23, @24, @25] : @"wind", @[@20, @21, @22] : @"fog", };
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
    NSDictionary *alldata = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil] mutableCopy][@"query"][@"results"][@"channel"];
    int weathercode = [alldata[@"item"][@"forecast"][@"code"] intValue];
    for (NSArray* elem in [ANIMATION_TYPES allKeys]) {
        if ([elem containsObject:@(weathercode)]) {
            [finalresult setObject:[ANIMATION_TYPES objectForKey:elem] forKey:@"code"];
            break;
        }
    }
    [finalresult setObject:alldata[@"wind"][@"chill"] forKey:@"chill"];
    [finalresult setObject:alldata[@"atmosphere"][@"humidity"] forKey:@"humidity"];
    [finalresult setObject:alldata[@"item"][@"forecast"][@"low"] forKey:@"low"];
    [finalresult setObject:alldata[@"item"][@"forecast"][@"high"] forKey:@"high"];
    return finalresult;
}


@end
