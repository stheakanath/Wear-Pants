//
//  AnimatedWeatherView.m
//  Wear Pants
//
//  Created by Sony Theakanath on 1/26/15.
//  Copyright (c) 2015 Sony Theakanath. All rights reserved.
//

#import "AnimatedWeatherView.h"

const NSString* HTML_FIRST = @"<!DOCTYPE html><html><head><title></title></head><body><canvas id=\"clear-day\" width=\"300\" height=\"300\"></canvas><script src=\"skycons.js\"></script><script>var icons = new Skycons({\"color\": \"white\"});icons.set(\"clear-day\", Skycons.";

const NSString* HTML_LAST = @");icons.play();</script></body></html>";

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

- (void)loadFile:(NSString*)animationtype {
    NSString *fulllink = [NSString stringWithFormat:@"%@%@%@", HTML_FIRST, animationtype, HTML_LAST];
    [self loadHTMLString: fulllink baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
}

@end
