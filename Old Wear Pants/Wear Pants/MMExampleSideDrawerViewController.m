//
//  MMEXAMPLESIDEDRAWERVIEWCONTROLLER
//  Wear Pants
//
//  Created by Sony Theakanath on 6/18/13.
//  Copyright (c) 2013 Sony Theakanath. All rights reserved.
//


#import "MMExampleSideDrawerViewController.h"
#import "MMSideDrawerTableViewCell.h"
#import "MMSideDrawerSectionHeaderView.h"
#import "ViewController.h"
#import "AppDelegate.h"

@implementation MMExampleSideDrawerViewController

@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.view addSubview:self.tableView];
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.tableView setSeparatorColor:[UIColor colorWithRed:49.0/255.0 green:54.0/255.0 blue:57.0/255.0 alpha:1.0]];
    [self.tableView setBackgroundColor:[UIColor colorWithRed:77.0/255.0 green:79.0/255.0 blue:80.0/255.0 alpha:1.0]];
    [self.view setBackgroundColor:[UIColor colorWithRed:66.0/255.0 green:69.0/255.0 blue:71.0/255.0 alpha:1.0]];
    self.drawerWidths = @[@(160),@(200),@(240),@(280),@(320)];
    [self.view setBackgroundColor:[UIColor clearColor]];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.tableView.numberOfSections-1)] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 1)
        return 3;
    else {
        NSMutableArray *savedLinks = [ViewController saveddata];
        return [savedLinks count]-1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MMSideDrawerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    }
    if(indexPath.section == 1) {
        if(indexPath.row == 0)
            [cell.textLabel setText:@"Pants Help"];
        else if(indexPath.row == 1)
            [cell.textLabel setText:@"Rate This App!"];
        else if(indexPath.row == 2)
            [cell.textLabel setText:@"sonytheakanath.com"];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    } else {
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        [cell addGestureRecognizer:longPress];
        NSMutableArray *savedLinks = [ViewController saveddata];
        if(indexPath.row != 0) {
            [cell.textLabel setText:[NSString stringWithFormat:@"%@,%@", [[[savedLinks objectAtIndex:indexPath.row+1] componentsSeparatedByString:@","] objectAtIndex:0], [[[savedLinks objectAtIndex:indexPath.row+1] componentsSeparatedByString:@","] objectAtIndex:1]]];
        } else {
            [cell.textLabel setText:@"Current Location"];
        }
    }
    return cell;
}

-(void) handleLongPress: (UIGestureRecognizer *)longPress {
    if (longPress.state==UIGestureRecognizerStateBegan) {
        CGPoint pressPoint = [longPress locationInView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:pressPoint];
        if(indexPath.row != 0) {
            [ViewController deleteCity:(int)indexPath.row];
            [self.tableView reloadData];
        }
    }
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0)
        return @"Saved Cities";
    else if(section == 1)
        return @"More Settings";
    else
        return @"More Settings";
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MMSideDrawerSectionHeaderView* headerView =  [[MMSideDrawerSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), 20.0f)];
    [headerView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [headerView setTitle:[tableView.dataSource tableView:tableView titleForHeaderInSection:section]];
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 23.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.0;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 1) {
        if(indexPath.row == 0){
            NSString *url = @"http://www.sonytheakanath.com/shouldiwearpantstoday";
            url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[url stringByAppendingFormat:@""]]];
        } else if(indexPath.row == 1) {
            //Reset url
            NSString *url = @"https://itunes.apple.com/us/app/should-i-wear-pants-today/id625891661?ls=1&mt=8";
            url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[url stringByAppendingFormat:@""]]];
        } else if(indexPath.row == 2) {
            NSString *url = @"http://www.sonytheakanath.com";
            url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[url stringByAppendingFormat:@""]]];
        }
    } else {
        if(indexPath.row == 0) {
            [delegate setLoadingView];
            [self.mm_drawerController closeDrawerAnimated:MMDrawerSideLeft completion:^(BOOL finished){
                [delegate reloadCurrentLocation];
            }];
        } else {
            NSMutableArray *savedLinks = [ViewController saveddata];
            [delegate setLoadingView];
            [self.mm_drawerController closeDrawerAnimated:MMDrawerSideLeft completion:^(BOOL finished){
                [delegate reloadFrame:[savedLinks objectAtIndex:indexPath.row+1]];
            }];
        }
    }
    [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
    }
}

@end
