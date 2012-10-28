//
//  CategoryRecentController.m
//  DDMenuController
//
//  Created by Devin Doty on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CategoryRecentController.h"
#import "PostDetailViewController.h"
#import "SBJson.h"
#import "CategoryPostsViewController.h"
#import "LeftController.h"

@implementation CategoryRecentController

@synthesize RecentView;
@synthesize CategoryView;
@synthesize SDC1;
@synthesize SDC2;
@synthesize recent;
@synthesize request, data, firsttime;

- (id)init {
    if ((self = [super init])) {
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    data = NO;
    firsttime = YES;
    
    NSLog(@"HELLO FROM CATRECCONT");
    
    if (!RecentView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        tableView.delegate = (id<UITableViewDelegate>)self;
        tableView.dataSource = (id<UITableViewDataSource>)self;
        [self.view addSubview:tableView];
        self.RecentView = tableView;
        UISearchBar *sb = [self newSearchBar:self];
        RecentView.tableHeaderView = sb;
        SDC1 = [self newSearchDisplayController:self bar:sb];
        
    }
    
    if(!CategoryView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        tableView.delegate = (id<UITableViewDelegate>)self;
        tableView.dataSource = (id<UITableViewDataSource>)self;
        [self.view addSubview:tableView];
        self.CategoryView = tableView;
        UISearchBar *sb = [self newSearchBar:self];
        CategoryView.tableHeaderView = sb;
        SDC2 = [self newSearchDisplayController:self bar:sb];
    }
    
    recent = NO;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"redbar.png"] forBarMetrics:UIBarMetricsDefault];
    NSURL *url = [NSURL URLWithString:@"http://localhost:3000/posts"];
    request = [ASIFormDataRequest requestWithURL:url];
}

- (void)viewDidAppear:(BOOL)animated {
    if(firsttime) {
        [self grabURLInBackground];
        firsttime = NO;
    }
    NSLog(@"SUpwwwewdwd");
}

- (void)grabURLInBackground
{
    [request setRequestMethod:@"POST"];
    SBJsonWriter *writ = [[SBJsonWriter alloc] init];
    NSNumber *y = [[NSNumber alloc] initWithInt:1];
    NSNumber *price = [[NSNumber alloc] initWithInt:6];
    NSString *x = [writ stringWithObject:[[NSDictionary alloc] initWithObjects:[NSArray arrayWithObject:[[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:@"Tit", price, @"description", @"17", @"1", @"1", [NSArray arrayWithObject:y], nil] forKeys:[NSArray arrayWithObjects: @"title", @"price", @"description", @"category_id", @"state_id", @"type_id", @"market_ids", nil]]] forKeys:[NSArray arrayWithObject:@"post"]]];
        
    [request setPostBody:[[NSMutableData alloc] initWithData:[x dataUsingEncoding:NSUTF8StringEncoding]]];
    [request setDelegate:self];
    [request setShouldPresentCredentialsBeforeChallenge:YES];//<hmmmmm
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request startAsynchronous];
} 

- (void)checkMarkets {
    NSMutableArray *bubbles = (((DDMenuController *)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController)).bubbleselected;
    BOOL anymarkets = NO;
    if([bubbles count]>1)
    {
        for(int i = [bubbles count]-1;i>-1;i--)
        {
            if([[bubbles objectAtIndex:i] boolValue])
                anymarkets = YES;
            
            NSLog(@"%@", [bubbles objectAtIndex:i]);
        }
    }
    else if([[bubbles objectAtIndex:0] boolValue])
    {
        anymarkets = YES;
    }
    
    if(anymarkets == NO)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Bubble selected!" 
                                                        message:@"You must have atleast one bubble selected to see any posts." 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)requestBack
{
    // Use when fetching text data
    //NSString *responseString = [requestBack responseString];
    
    if(recent)
        [RecentView reloadData];
    else
        [CategoryView reloadData];
}

- (void)requestFailed:(ASIHTTPRequest *)requestBack
{
     NSLog(@"failed with error: %d %@", [requestBack responseStatusCode], [[requestBack error] localizedDescription]);
    if(recent)
        [RecentView reloadData];
    else
        [CategoryView reloadData];
}

- (UISearchBar *)newSearchBar:(id)delegate{
    UISearchBar *mySearchBar = [[UISearchBar alloc] initWithFrame: CGRectMake(0.0,43,320,10)];
	mySearchBar.delegate = delegate;
	[mySearchBar sizeToFit];
    [mySearchBar setPlaceholder:@"What are you looking for?"];
    mySearchBar.backgroundColor = [UIColor colorWithRed:0.0 green:0.25098 blue:0.501961 alpha:1.0];
    return mySearchBar;
}

- (UISearchDisplayController *)newSearchDisplayController:(id)delegate bar:(UISearchBar *)b{
    
    UISearchDisplayController *SDC = [[UISearchDisplayController alloc] initWithSearchBar:b contentsController:delegate];
    
    [SDC setDelegate:delegate];
    [SDC setSearchResultsDataSource:delegate];
    
    
    return SDC;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.CategoryView = nil;
    self.RecentView = nil;
}

- (void)changetoRecent
{
    [self.view bringSubviewToFront:RecentView];
    recent = YES;
}

- (void)changetoCategories
{
    [self.view bringSubviewToFront:CategoryView];
    recent = NO;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	if(RecentView.tableHeaderView == searchBar)
    {
        NSLog(@"HELL!!!");
    }
    return;
	
}


#pragma mark - UITableViewDataSource

/*- (UIView *)tableView:(UITableView *)tableview viewForHeaderInSection:(NSInteger)section
{
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    lbl.textAlignment = UITextAlignmentCenter;
    [lbl setTextColor:[UIColor whiteColor]];
    [lbl setText:((section==0)?@"Today":@"Yesterday")];
    [lbl setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"section_bar.png"]]];
    lbl.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    return lbl;
}*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(tableView == RecentView)
        return 2;
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    if(CategoryView == tableView)
        return [[NSMutableArray arrayWithObjects:@"All Posts",@"Appliances",@"Books",@"Car Pool",@"Clothings & Accessories",@"Electronics",@"Events",@"Free Stuff",@"Furniture",@"Housing",@"Looking for",@"Lost & Found",@"Musical Instruments",@"Other",@"Vehicles",@"Work & Listings",nil] count];
    else
        return 10;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    //Following code is a HACK --- should use (UIView *)tableView:(UITableView *)tableview viewForHeaderInSection:(NSInteger)section
    if(tableView == RecentView)
    {
        if(section == 0)
            return @"                        TODAY";
        else
            return @"                     YESTERDAY";
    }
    else
    {
        return NULL;
    
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView == RecentView)
    {
        return 76;
    }
    else
        return 46;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"WHAHAHAHAHAHNOOOO!");
    
    if(tableView == RecentView)
    {
        static NSString *CellIdentifier = @"RecentIdent";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        else
        {
            for(UIView *view in cell.subviews)
            {
                if([view class] == [UILabel class] || [view class] == [UIImageView class])
                {
                    [view removeFromSuperview];
                }
            }
        }
        
        //cell.textLabel.text = [NSString stringWithFormat:@"Recent number %i", indexPath.row];
        //UIFont *f = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        
        UIImageView *i = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Refresh.png"]];
        [i setFrame:CGRectMake(2, -2, 64, 78)];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(70, 8, 160, 22)];
        //[title setBackgroundColor:[UIColor blueColor]];
        UILabel *bubble = [[UILabel alloc] initWithFrame:CGRectMake(88, 33, 160, 16)];
        //[bubble setBackgroundColor:[UIColor redColor]];
        UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(240, 11, 60, 18)];
        //[time setBackgroundColor:[UIColor blueColor]];
        UILabel *Price = [[UILabel alloc] initWithFrame:CGRectMake(240, 42, 60, 26)];
        //[Price setBackgroundColor:[UIColor blackColor]];
        //if(arc4random()%2==0)
        [title setText:[[NSString alloc] initWithString:@"Mint Like new thingy"]];
        //else
        //    [title setText:[[NSString alloc] initWithString:@"Mint Like thingy"]];
        [title setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
        //title.font
        [bubble setFont:[UIFont fontWithName:@"Helvetica" size:12]];
        [bubble setText:@"BUBBLY BUBBLES"];
        [bubble setTextColor:[UIColor grayColor]];
        
        [Price setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
        [Price setTextAlignment:UITextAlignmentRight];
        [Price setText:@"$115"];
        [Price setTextColor:[UIColor redColor]];
        
        [time setFont:[UIFont fontWithName:@"Helvetica" size:12]];
        [time setTextAlignment:UITextAlignmentRight];
        [time setText:@"1:15 AM"];
        [time setTextColor:[UIColor grayColor]];
        
        UIImageView *i1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow1.png"]];
        [i1 setFrame:CGRectMake(305, 31, 10, 10)];
        
        [cell addSubview:i];
        [cell addSubview:i1];
        [cell addSubview:title];
        [cell addSubview:bubble];
        [cell addSubview:time];
        [cell addSubview:Price];
        
        return cell;
    }
    else if(tableView == CategoryView)
    {
        NSMutableArray *a = [NSMutableArray arrayWithObjects:@"All Posts",@"Appliances",@"Books",@"Car Pool",@"Clothings & Accessories",@"Electronics",@"Events",@"Free Stuff",@"Furniture",@"Housing",@"Looking for",@"Lost & Found",@"Musical Instruments",@"Other",@"Vehicles",@"Work & Listings",nil];
        NSMutableArray *b = [NSMutableArray arrayWithObjects:@"(51)",@"(25)",@"(61)",@"(123)",@"(83)",@"(65)",@"(25)",@"(34)",@"(98)",@"(65)",@"(72)",@"(40)",@"(6)",@"(28)",@"(95)",@"(47)",nil];
        static NSString *CellIdentifier = @"CategoryIdent";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        else
        {
            NSLog(@"----------------------------");
            for (UIView *view in cell.subviews) {
                if([view class] == [UILabel class] || [view class] == [UIImageView class])
                {
                    [view removeFromSuperview];
                }
            }
        }
        NSString *cat = [a objectAtIndex:indexPath.row];
        NSString *num = [b objectAtIndex:indexPath.row];
        UIFont *f = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        
        UIImageView *i = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Refresh.png"]];
        [i setFrame:CGRectMake(6, 1, 40, 40)];
        
        UILabel *y = [[UILabel alloc] initWithFrame:CGRectMake(52, 13, [cat sizeWithFont:f].width, [cat sizeWithFont:f].height)];
        [y setText:cat];
        [y setFont:f];
        [y setTextColor:[UIColor darkGrayColor]];
        
        UILabel *x = [[UILabel alloc] initWithFrame:CGRectMake(55+[cat sizeWithFont:f].width, 13, [num sizeWithFont:f].width, [num sizeWithFont:f].height)];
        [x setFont:f];
        [x setText:[b objectAtIndex:indexPath.row]];
        [x setTextColor:[UIColor lightGrayColor]];
        
        UIImageView *i1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow1.png"]];
        [i1 setFrame:CGRectMake(305, 17, 10, 10)];
        
        [cell addSubview:x];
        [cell addSubview:y];
        [cell addSubview:i];
        [cell addSubview:i1];
        
        return cell;
    }
    else if(tableView == SDC1.searchResultsTableView)
    {
        static NSString *CellIdentifier = @"SDC1Cells";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.textLabel.text = [NSString stringWithFormat:@"SDC1 %i", indexPath.row];
        return cell;
    }
    else if(tableView == SDC2.searchResultsTableView)
    {
        static NSString *CellIdentifier = @"SDC2Cells";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.textLabel.text = [NSString stringWithFormat:@"SDC2 %i", indexPath.row];
        return cell;
    }
    return NULL;
        
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)sb {
    if ([((DDMenuController *)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController) showingleftviewornot]) {
        [((DDMenuController *)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController) showRootController:YES];
        return NO;
    }
    return YES;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView==RecentView) {
        [RecentView deselectRowAtIndexPath:indexPath animated:YES];
        PostDetailViewController *pdvcont = [[PostDetailViewController alloc] init];
        DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
        [menuController pushViewController:pdvcont animated:YES];
    }
    else
    {
        [CategoryView deselectRowAtIndexPath:indexPath animated:YES];
        CategoryPostsViewController *cpvc = [[CategoryPostsViewController alloc] init];
        DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
        [menuController pushViewController:cpvc animated:YES];
    }
}

@end
