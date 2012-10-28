//
//  CategoryPostsViewController.h
//
//  Created by Harsh Jariwala on 2/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryPostsViewController : UIViewController

@property (nonatomic, retain) UITableView *tableview;
@property (nonatomic, retain) UISearchDisplayController *SDC;

- (UISearchBar *)newSearchBar:(id)delegate;
- (UISearchDisplayController *)newSearchDisplayController:(id)delegate bar:(UISearchBar *)b;

@end
