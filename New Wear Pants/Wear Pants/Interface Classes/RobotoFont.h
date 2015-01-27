//
//  RobotoFont.h
//  Wear Pants
//
//  Created by Sony Theakanath on 1/26/15.
//  Copyright (c) 2015 Sony Theakanath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RobotoFont : UILabel

- (id) init:(CGRect)frame fontName:(NSString*)font fontSize:(CGFloat)size;
- (id) initWithWeather:(CGRect)frame setText:(NSString*)text setAlignment:(NSTextAlignment)a;

@end
