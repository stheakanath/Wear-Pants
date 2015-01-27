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
static NSString *const WEATHER_URL_LAST = @"%22)%20limit%201&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys";


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

+ (void) getTemperatureData:(NSString*)city withZipCode:(NSString*)zipcode {
    NSData *data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@", WEATHER_URL_FIRST, [city stringByReplacingOccurrencesOfString:@" " withString:@"%20"], zipcode, WEATHER_URL_LAST]]];
    NSDictionary *alldata = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil] mutableCopy][@"query"][@"results"][@"channel"];
    NSLog(@"%@", alldata);
}

@end
