//
//  WeatherData.h
//  Wear Pants
//
//  Created by Sony Theakanath on 1/26/15.
//  Copyright (c) 2015 Sony Theakanath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherData : NSObject

+ (NSString*) getBoundingBox:(NSString*)zipcode;
+ (NSMutableDictionary*) getTemperatureData:(NSString*)zipcode;
+ (UIImageView*) getFlickrBackground:(NSString*) zipcode;

@end
