//
//  MMEXAMPLESIDEDRAWERVIEWCONTROLLER
//  Wear Pants
//
//  Created by Sony Theakanath on 6/18/13.
//  Copyright (c) 2013 Sony Theakanath. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "ViewControllerDelegate.h"
#import "UIViewController+MMDrawerController.h"

typedef NS_ENUM(NSInteger, MMDrawerSection){
    MMDrawerSectionViewSelection,
    MMDrawerSectionDrawerWidth,
    MMDrawerSectionShadowToggle,
    MMDrawerSectionOpenDrawerGestures,
    MMDrawerSectionCloseDrawerGestures,
    MMDrawerSectionCenterHiddenInteraction,
    MMDrawerSectionStretchDrawer,
};


@interface MMExampleSideDrawerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic,strong) NSArray * drawerWidths;
@property (nonatomic,assign)  id <ViewControllerDelegate> delegate;

@end
