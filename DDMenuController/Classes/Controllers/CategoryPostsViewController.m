//
//  CategoryPostsViewController.m
//
//  Created by Harsh Jariwala on 2/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CategoryPostsViewController.h"
#import "DDMenuController.h"
#import "PostDetailViewController.h"

@implementation CategoryPostsViewController
@synthesize tableview, SDC;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(!tableview)
    {
        tableview = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        tableview.delegate = (id<UITableViewDelegate>)self;
        tableview.dataSource = (id<UITableViewDataSource>)self;
        [self.view addSubview:tableview];
        UISearchBar *sb = [self newSearchBar:self];
        tableview.tableHeaderView = sb;
        SDC = [self newSearchDisplayController:self bar:sb];
    }
    [self.navigationItem setTitle:@"Category"];
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
    
    UISearchDisplayController *temp = [[UISearchDisplayController alloc] initWithSearchBar:b contentsController:delegate];
    
    [temp setDelegate:delegate];
    [temp setSearchResultsDataSource:delegate];
    
    return temp;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    //Following code is a HACK --- should use (UIView *)tableView:(UITableView *)tableview viewForHeaderInSection:(NSInteger)section
    if(section == 0)
        return @"                        TODAY";
    else
        return @"                     YESTERDAY";
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 76;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if(tableView == SDC.searchResultsTableView)
    {
        static NSString *CellIdentifier = @"SDC1Cells";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.textLabel.text = [NSString stringWithFormat:@"SDC %i", indexPath.row];
        return cell;
    }
    
    static NSString *CellIdentifier = @"CategoryPostViewCells";
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

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableview deselectRowAtIndexPath:indexPath animated:YES];
    PostDetailViewController *pdvcont = [[PostDetailViewController alloc] init];
    DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    [menuController pushViewController:pdvcont animated:YES];
}

#pragma mark UISearchTableDelegate
- (void)searchDisplayController:(UISearchDisplayController *)cont didLoadSearchResultsTableView:(UITableView *)table
{
    [table setRowHeight:76];
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
