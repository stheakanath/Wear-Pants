//
//  UIImage+StackBlur.h
//  stackBlur
//
//  Created by Sony Theakanath on 1/26/15.
//  Copyright (c) 2015 Sony Theakanath. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface UIImage (StackBlur) 

- (UIImage*) stackBlur:(NSUInteger)radius;
- (UIImage *) normalize;
+ (void) applyStackBlurToBuffer:(UInt8*)targetBuffer width:(const int)w height:(const int)h withRadius:(NSUInteger)inradius;

@end

