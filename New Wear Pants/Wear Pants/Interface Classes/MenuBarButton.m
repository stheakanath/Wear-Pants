//
//  MenuBarButton.m
//  Wear Pants
//
//  Created by Sony Theakanath on 1/26/15.
//  Copyright (c) 2015 Sony Theakanath. All rights reserved.
//

#import "MenuBarButton.h"

@implementation MenuBarButton

- (id) init:(NSString*)imageName target:(id)target selector:(SEL)sel {
    UIImage *i = [UIImage imageNamed:imageName];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, i.size.width, i.size.height)];
    [button setBackgroundImage:i forState:UIControlStateNormal];
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    [button setShowsTouchWhenHighlighted:YES];
    self = [super initWithCustomView:button];
    return self;
}

@end
