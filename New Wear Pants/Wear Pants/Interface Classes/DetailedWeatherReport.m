//
//  DetailedWeatherReport.m
//  Wear Pants
//
//  Created by Sony Theakanath on 1/26/15.
//  Copyright (c) 2015 Sony Theakanath. All rights reserved.
//

#import "DetailedWeatherReport.h"

@implementation DetailedWeatherReport

- (id) init {
    self = [super initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width/2-145, [[UIScreen mainScreen] bounds].size.height/2+80, 150, 105)];
    [self addSubview:[[RobotoFont alloc] initWithWeather:CGRectMake(0, 0, 150, 20) setText:@"Humidity" setAlignment:NSTextAlignmentLeft]];
    [self addSubview:[[RobotoFont alloc] initWithWeather:CGRectMake(0, 42.5, 150, 20) setText:@"Wind Temp" setAlignment:NSTextAlignmentLeft]];
    [self addSubview:[[RobotoFont alloc] initWithWeather:CGRectMake(0, 85, 150, 20) setText:@"Avg Temp" setAlignment:NSTextAlignmentLeft]];
    self.humidity = [[RobotoFont alloc] initWithWeather:CGRectMake(0, 0, 140, 20) setText:@"" setAlignment:NSTextAlignmentRight];
    [self addSubview:self.humidity];
    self.windTemp = [[RobotoFont alloc] initWithWeather:CGRectMake(0, 42.5, 140, 20) setText:@"" setAlignment:NSTextAlignmentRight];
    [self addSubview:self.windTemp];
    self.avgTemp = [[RobotoFont alloc] initWithWeather:CGRectMake(0, 85, 140, 20) setText:@"" setAlignment:NSTextAlignmentRight];
    [self addSubview:self.avgTemp];
    return self;
}

- (void) setData:(NSArray*)data {
    [self.humidity setText:[data objectAtIndex:0]];
    [self.windTemp setText:[data objectAtIndex:1]];
    [self.avgTemp setText:[data objectAtIndex:2]];
}

@end
