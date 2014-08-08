//
//  ViewControllerDelegate.h
//  Wear Pants
//
//  Created by Sony Theakanath on 6/19/13.
//  Copyright (c) 2013 Sony Theakanath. All rights reserved.
//

@protocol ViewControllerDelegate

- (void)reloadFrame: (NSString*) saveddata;
- (void)reloadCurrentLocation;
- (void)setLoadingView;

@end