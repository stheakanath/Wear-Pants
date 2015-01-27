//
//  RobotoFont.m
//  Wear Pants
//
//  Created by Sony Theakanath on 1/26/15.
//  Copyright (c) 2015 Sony Theakanath. All rights reserved.
//

#import "RobotoFont.h"

@implementation RobotoFont

- (id) init:(CGRect)frame fontName:(NSString*)font fontSize:(CGFloat)size {
    self = [super initWithFrame:frame];
    [self setBackgroundColor:[UIColor clearColor]];
    [self setTextAlignment:NSTextAlignmentCenter];
    [self setLineBreakMode:NSLineBreakByWordWrapping];
    [self setNumberOfLines:0];
    [self setShadowColor:[UIColor blackColor]];
    [self setShadowOffset:CGSizeMake(0.5, 0)];
    [self setTextColor:[UIColor whiteColor]];
    [self setFont:[UIFont fontWithName:font size:size]];
    return self;
}

- (id) initWithWeather:(CGRect)frame setText:(NSString*)text setAlignment:(NSTextAlignment)a {
    self = [self init:frame fontName:@"Roboto-Light" fontSize:16.5];
    [self setText:text];
    [self setTextAlignment:a];
    return self;
}

@end
