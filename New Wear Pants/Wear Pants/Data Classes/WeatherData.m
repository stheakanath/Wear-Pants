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

+ (NSString*) getBoundingBox:(NSString*)zipcode {
    NSData *data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", BOUNDING_URL, [zipcode stringByReplacingOccurrencesOfString:@" " withString:@"%20"], @"%22&format=json"]]];
    NSDictionary *boundingBox = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil] mutableCopy][@"query"][@"results"][@"place"][@"boundingBox"];
    return [NSString stringWithFormat:@"%@,%@,%@,%@", boundingBox[@"southWest"][@"longitude"], boundingBox[@"southWest"][@"latitude"], boundingBox[@"northEast"][@"longitude"], boundingBox[@"northEast"][@"latitude"]];
}

@end
