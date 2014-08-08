//
//  USLocation.h
//  Wear Pants
//
//  Created by Sony Theakanath on 6/18/13.
//  Copyright (c) 2013 Sony Theakanath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface USLocation : NSObject 

+ (NSString*) infofromcity:(NSString*)wantcity;
+ (NSString*) infofromzipcode:(NSString*)wantzipcode;
+ (NSString*) getcitydata:(NSString*)city;
+ (NSArray*) zipcode;
+ (NSArray*) city;

@end
