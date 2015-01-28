//
//  BackgroundLayer.m
//  BrokerTestApp
//
//  Created by Sony Theakanath on 1/26/15.
//  Copyright (c) 2015 Sony Theakanath. All rights reserved.
//

#import "BackgroundLayer.h"

@implementation BackgroundLayer

//Metallic grey gradient background
+ (CAGradientLayer*) greyGradient {
	
	UIColor *colorOne		= [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
	UIColor *colorTwo		= [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
	UIColor *colorThree	    = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
	UIColor *colorFour		= [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9];
    
	NSArray *colors =  [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, colorThree.CGColor, colorFour.CGColor, nil];
	
	NSNumber *stopOne		= [NSNumber numberWithFloat:0.0];
	NSNumber *stopTwo		= [NSNumber numberWithFloat:0.5];
	NSNumber *stopThree	    = [NSNumber numberWithFloat:0.99];
	NSNumber *stopFour		= [NSNumber numberWithFloat:1.0];
	
	NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, stopThree, stopFour, nil];
	
	CAGradientLayer *headerLayer = [CAGradientLayer layer];
	headerLayer.colors = colors;
	headerLayer.locations = locations;
	
	return headerLayer;
}

@end
