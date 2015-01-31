//
//  AddScreen.m
//  Wear Pants
//
//  Created by Sony Theakanath on 1/28/15.
//  Copyright (c) 2015 Sony Theakanath. All rights reserved.
//

#import "AddScreen.h"
#import "ViewController.h"

@interface AddScreen ()

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, retain) ILGeoNamesLookup *geoNamesSearch;
@property BOOL searchControllerWasActive;
@property BOOL searchControllerSearchFieldWasFirstResponder;

@end

@implementation AddScreen

@synthesize searchResults, delegate, geoNamesSearch;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self searchResults];
    if(!geoNamesSearch) {
        NSString *userID = [self.delegate geoNamesUserIDForSearchController:self];
        geoNamesSearch = [[ILGeoNamesLookup alloc] initWithUserID:userID];
    }
     geoNamesSearch.delegate = self;
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    [self.searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.searchController.searchBar.barStyle = UIBarStyleBlackTranslucent;
    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.definesPresentationContext = YES;
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissView:)];
    [[self navigationItem] setLeftBarButtonItem:cancelButton];
    [self.navigationItem setTitle:@"Add City"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.searchControllerWasActive) {
        self.searchController.active = self.searchControllerWasActive;
        _searchControllerWasActive = NO;
        if (self.searchControllerSearchFieldWasFirstResponder) {
            [self.searchController.searchBar becomeFirstResponder];
            _searchControllerSearchFieldWasFirstResponder = NO;
        }
    }
}

- (void) setBackground:(UIImage*)image {
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [blurEffectView setFrame:[[UIScreen mainScreen] bounds]];
    UIImageView *test = [[UIImageView alloc] initWithImage:image];
    [test addSubview:blurEffectView];
    [self.tableView setBackgroundView:test];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    self.searchDisplayController.searchBar.prompt = NSLocalizedStringFromTable(@"ILGEONAMES_SEARCHING", @"ILGeoNames", @"");
    [self.searchResults removeAllObjects];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(delayedSearch:) withObject:[searchController.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] afterDelay:0.1];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)delayedSearch:(NSString*)searchString {
    [self.geoNamesSearch cancel];
    [self.geoNamesSearch search:searchString maxRows:5 startRow:0 language:nil];
}

- (IBAction)dismissView:(id)sender {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:NO];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    NSDictionary *geoname = [self.searchResults objectAtIndex:indexPath.row];
    if(geoname) {
        NSString *name = [geoname objectForKey:kILGeoNamesNameKey];
        cell.textLabel.text = name;
        NSString *subString = [geoname objectForKey:kILGeoNamesCountryNameKey];
        if (subString && ![subString isEqualToString:@""]) {
            NSString *admin1 = [geoname objectForKey:kILGeoNamesAdminName1Key];
            if (admin1 && ![admin1 isEqualToString:@""]) {
                subString = [admin1 stringByAppendingFormat:@", %@", subString];
                NSString *admin2 = [geoname objectForKey:kILGeoNamesAdminName2Key];
                if (admin2 && ![admin2 isEqualToString:@""])
                    subString = [admin2 stringByAppendingFormat:@", %@", subString];
            }
        } else
            subString = [geoname objectForKey:kILGeoNamesFeatureClassNameKey];
        cell.detailTextLabel.text = subString;
        cell.isAccessibilityElement = YES;
        cell.accessibilityLabel = [NSString stringWithFormat:@"%@, %@", name, subString];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.textLabel.textColor = [UIColor whiteColor];
    [cell.textLabel setShadowColor:[UIColor blackColor]];
    [cell.textLabel setShadowOffset:CGSizeMake(0.5, 0)];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    [cell.detailTextLabel setShadowColor:[UIColor blackColor]];
    [cell.detailTextLabel setShadowOffset:CGSizeMake(0.5, 0)];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self.geoNamesSearch cancel];
    self.geoNamesSearch.delegate = nil;
    [self.searchResults objectAtIndex:indexPath.row];
    NSLog(@"%@", [[self.searchResults objectAtIndex:indexPath.row] objectForKey:kILGeoNamesNameKey]);
    [ViewController addNewCity:[NSString stringWithFormat:@"%@, %@", [[self.searchResults objectAtIndex:indexPath.row] objectForKey:kILGeoNamesNameKey], [[self.searchResults objectAtIndex:indexPath.row] objectForKey:kILGeoNamesCountryNameKey]]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[tableView cellForRowAtIndexPath:indexPath].textLabel.text  message:@"New city added! Check Menu to check pants-friendliness." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:NO];
}

- (NSMutableArray *)searchResults {
    if(!searchResults)
        searchResults = [[NSMutableArray alloc] init];
    return searchResults;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self.geoNamesSearch cancel];
    self.geoNamesSearch.delegate = nil;
    [self.delegate geoNamesSearchController:self didFinishWithResult:nil];
}

- (void)geoNamesLookup:(ILGeoNamesLookup *)handler networkIsActive:(BOOL)isActive {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = isActive;
}

- (void)geoNamesLookup:(ILGeoNamesLookup *)handler didFindGeoNames:(NSArray *)geoNames totalFound:(NSUInteger)total {
    if ([geoNames count]) {
        self.searchDisplayController.searchBar.prompt = NSLocalizedStringFromTable(@"ILGEONAMES_SEARCH_PROMPT", @"ILGeoNames", @"");
        [self.searchResults setArray:geoNames];
        [self.tableView reloadData];
    } else {
        self.searchDisplayController.searchBar.prompt = NSLocalizedStringFromTable(@"ILGEONAMES_NO_RESULTS", @"ILGeoNames", @"");
        [self.searchResults removeAllObjects];
    }
    [self.searchDisplayController.searchResultsTableView reloadData];
    UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, nil);
}

- (void)geoNamesLookup:(ILGeoNamesLookup *)handler didFailWithError:(NSError *)error {
    NSLog(@"ILGeoNamesLookup has failed: %@", [error localizedDescription]);
    self.searchDisplayController.searchBar.prompt = NSLocalizedStringFromTable(@"ILGEONAMES_SEARCH_ERR", @"ILGeoNames", @"");
}

@end
