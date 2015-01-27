//
//  AnimatedWeatherView.m
//  Wear Pants
//
//  Created by Sony Theakanath on 1/26/15.
//  Copyright (c) 2015 Sony Theakanath. All rights reserved.
//

#import "AnimatedWeatherView.h"

@implementation AnimatedWeatherView

- (id) init {
    self = [super initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width/2-5, [[UIScreen mainScreen] bounds].size.height/2+55 , 170, 170)];
    [self setBackgroundColor:[UIColor clearColor]];
    [self setOpaque:NO];
    [self setUserInteractionEnabled:NO];
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0)) {
        [[self scrollView] setMinimumZoomScale:0.5];
        [[self scrollView] setMaximumZoomScale:0.5];
        [[self scrollView] setZoomScale:0.5];
    }
    return self;
}

- (void)loadFile: (NSString*)file {
    [self loadHTMLString:@"" baseURL:nil];
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0))
        file = [file stringByAppendingString:@"1"];
    [self loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:file ofType: @"html"]]]];
}

@end
