//
//  AddCityViewController.m
//  Wear Pants
//
//  Created by Sony Theakanath on 6/18/13.
//  Copyright (c) 2013 Sony Theakanath. All rights reserved.
//

#import "AddCityViewController.h"
#import "ViewController.h"
#import "USLocation.h"

@interface AddCityViewController ()
@property (nonatomic) NSMutableArray *searchResults;
@end

@implementation AddCityViewController

#pragma mark - Lifecycle methods

- (void)showCancelButton {
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissView:)];
    [[self navigationItem] setLeftBarButtonItem:cancelButton];
    self.products = [USLocation city];
}

- (IBAction)dismissView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewDidLoad {
    self.searchResults = [NSMutableArray arrayWithCapacity:[self.products count]];
    [self showCancelButton];
    self.searchDisplayController.searchBar.scopeButtonTitles = nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self dismissViewControllerAnimated:YES completion:nil];
    //[ViewController addNewCity:[NSString stringWithFormat:@"%@, %@", [[[tableView cellForRowAtIndexPath:indexPath].textLabel.text componentsSeparatedByString:@","] objectAtIndex:0], [USLocation infofromcity:[tableView cellForRowAtIndexPath:indexPath].textLabel.text]]];
    [ViewController addNewCity:[NSString stringWithFormat:@"%@, %@", [tableView cellForRowAtIndexPath:indexPath].textLabel.text, [USLocation infofromcity:[tableView cellForRowAtIndexPath:indexPath].textLabel.text]]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[tableView cellForRowAtIndexPath:indexPath].textLabel.text  message:@"New city added! Check Menu to check pants-friendliness." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

#pragma mark - UITableView data source and delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (tableView == self.searchDisplayController.searchResultsTableView)
        return [self.searchResults count];
	else
        return [self.products count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *kCellID = @"CellIdentifier";
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kCellID];
	NSString *product;
	if (tableView == self.searchDisplayController.searchResultsTableView)
        product = [self.searchResults objectAtIndex:indexPath.row];
	else
        product = [self.products objectAtIndex:indexPath.row];
	cell.textLabel.text = product;
	return cell;
}

#pragma mark - Content Filtering

- (void)updateFilteredContentForProductName:(NSString *)productName type:(NSString *)typeName {
    if ((productName == nil) || [productName length] == 0) {
        if (typeName == nil)
            self.searchResults = [self.products mutableCopy];
        else {
            NSMutableArray *searchResults = [[NSMutableArray alloc] init];
            for (NSString *product in self.products) {
                if ([product isEqualToString:typeName])
                    [searchResults addObject:product];
            }
            self.searchResults = searchResults;
        }
        return;
    }
    [self.searchResults removeAllObjects];
    for (NSString *product in self.products)
	{
		if ((typeName == nil) || [product isEqualToString:typeName])
		{
            NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
            NSRange productNameRange = NSMakeRange(0, product.length);
            NSRange foundRange = [product rangeOfString:productName options:searchOptions range:productNameRange];
            if (foundRange.length > 0)
				[self.searchResults addObject:product];
		}
	}
}

#pragma mark - UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    NSString *scope;
    [self updateFilteredContentForProductName:searchString type:scope];
    return YES;
}

#pragma mark - State restoration

static NSString *SearchDisplayControllerIsActiveKey = @"SearchDisplayControllerIsActiveKey";
static NSString *SearchBarScopeIndexKey = @"SearchBarScopeIndexKey";
static NSString *SearchBarTextKey = @"SearchBarTextKey";
static NSString *SearchBarIsFirstResponderKey = @"SearchBarIsFirstResponderKey";
static NSString *SearchDisplayControllerSelectedRowKey = @"SearchDisplayControllerSelectedRowKey";
static NSString *TableViewSelectedRowKey = @"TableViewSelectedRowKey";

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
    UISearchDisplayController *searchDisplayController = self.searchDisplayController;
    BOOL searchDisplayControllerIsActive = [searchDisplayController isActive];
    [coder encodeBool:searchDisplayControllerIsActive forKey:SearchDisplayControllerIsActiveKey];
    if (searchDisplayControllerIsActive) {
        [coder encodeObject:[searchDisplayController.searchBar text] forKey:SearchBarTextKey];
        [coder encodeInteger:[searchDisplayController.searchBar selectedScopeButtonIndex] forKey:SearchBarScopeIndexKey];
        NSIndexPath *selectedIndexPath = [searchDisplayController.searchResultsTableView indexPathForSelectedRow];
        if (selectedIndexPath != nil)
            [coder encodeObject:selectedIndexPath forKey:SearchDisplayControllerSelectedRowKey];
        BOOL searchFieldIsFirstResponder = [searchDisplayController.searchBar isFirstResponder];
        [coder encodeBool:searchFieldIsFirstResponder forKey:SearchBarIsFirstResponderKey];
    }
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    if (selectedIndexPath != nil)
        [coder encodeObject:selectedIndexPath forKey:TableViewSelectedRowKey];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
    BOOL searchDisplayControllerIsActive = [coder decodeBoolForKey:SearchDisplayControllerIsActiveKey];
    if (searchDisplayControllerIsActive)
    {
        [self.searchDisplayController setActive:YES];
        NSInteger searchBarScopeIndex = [coder decodeIntegerForKey:SearchBarScopeIndexKey];
        [self.searchDisplayController.searchBar setSelectedScopeButtonIndex:searchBarScopeIndex];
        NSString *searchBarText = [coder decodeObjectForKey:SearchBarTextKey];
        if (searchBarText != nil)
            [self.searchDisplayController.searchBar setText:searchBarText];
        NSIndexPath *selectedIndexPath = [coder decodeObjectForKey:SearchDisplayControllerSelectedRowKey];
        if (selectedIndexPath != nil)
            [self.searchDisplayController.searchResultsTableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
        BOOL searchFieldIsFirstResponder = [coder decodeBoolForKey:SearchBarIsFirstResponderKey];
        if (searchFieldIsFirstResponder)
            [self.searchDisplayController.searchBar becomeFirstResponder];
    }
    NSIndexPath *selectedIndexPath = [coder decodeObjectForKey:TableViewSelectedRowKey];
    if (selectedIndexPath != nil)
        [self.tableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
}
@end

