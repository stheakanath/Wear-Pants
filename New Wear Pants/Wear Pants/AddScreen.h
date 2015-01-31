//
//  AddScreen.h
//  Wear Pants
//
//  Created by Sony Theakanath on 1/28/15.
//  Copyright (c) 2015 Sony Theakanath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ILGeoNamesLookup.h"

@protocol AddScreenDelegate;

@interface AddScreen : UITableViewController<UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating, ILGeoNamesLookupDelegate> {
    NSMutableArray *searchResults;
    ILGeoNamesLookup *geoNamesSearch;
}

@property(nonatomic, assign) id <AddScreenDelegate> delegate;

- (void) setBackground:(UIImage*)image;

@end

@protocol AddScreenDelegate

@required

- (NSString*)geoNamesUserIDForSearchController:(AddScreen*)controller;
- (void)geoNamesSearchController:(AddScreen*)controller didFinishWithResult:(NSDictionary*)result;

@end

