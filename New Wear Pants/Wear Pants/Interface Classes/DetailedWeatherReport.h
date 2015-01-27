//
//  DetailedWeatherReport.h
//  Wear Pants
//
//  Created by Sony Theakanath on 1/26/15.
//  Copyright (c) 2015 Sony Theakanath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RobotoFont.h"

@interface DetailedWeatherReport : UIView

- (id) init;
- (void) setData:(NSArray*)data;

@property (nonatomic, strong) RobotoFont *humidity;
@property (nonatomic, strong) RobotoFont *windTemp;
@property (nonatomic, strong) RobotoFont *avgTemp;

@end
