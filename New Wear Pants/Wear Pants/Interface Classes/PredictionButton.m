//
//  PredictionButton.m
//  Wear Pants
//
//  Created by Sony Theakanath on 1/26/15.
//  Copyright (c) 2015 Sony Theakanath. All rights reserved.
//

#import "PredictionButton.h"

@implementation PredictionButton

- (id) init:(CGRect)frame setTitle:(NSString*)title target:(id)target selector:(SEL)sel {
    self = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:16]];
    [self setBackgroundColor:[UIColor clearColor]];
    [self setTitleColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0] forState:UIControlStateNormal];
    [self setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0] forState:UIControlStateHighlighted];
    [self setTitleShadowColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [self setBackgroundImage:[UIImage imageNamed:@"PredictButton"] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:@"PredictButton_Selected"] forState:UIControlStateHighlighted];
    [self setFrame:frame];
    [self setTitle:title forState:UIControlStateNormal];
    [self addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    return self;
}

@end
