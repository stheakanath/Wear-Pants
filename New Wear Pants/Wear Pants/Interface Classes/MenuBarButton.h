//
//  MenuBarButton.h
//  Wear Pants
//
//  Created by Sony Theakanath on 1/26/15.
//  Copyright (c) 2015 Sony Theakanath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuBarButton : UIBarButtonItem

- (id) init:(NSString*)imageName target:(id)target selector:(SEL)sel;

@end
