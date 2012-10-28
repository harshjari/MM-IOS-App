//
//  CategoryRecentController.h
//

#import <UIKit/UIKit.h>
#import "DDMenuController.h"
#import "ASIFormDataRequest.h"

@interface CategoryRecentController : UIViewController

@property(nonatomic,strong) UITableView *RecentView;
@property(nonatomic,strong) UITableView *CategoryView;
@property(nonatomic,strong) UISearchDisplayController *SDC1;
@property(nonatomic,strong) UISearchDisplayController *SDC2;
@property(nonatomic) BOOL data;
@property(nonatomic) BOOL recent;
@property(nonatomic) BOOL firsttime;
@property(nonatomic,strong) ASIFormDataRequest *request;


- (void)grabURLInBackground;
- (void)requestFinished:(ASIHTTPRequest *)request;
- (void)requestFailed:(ASIHTTPRequest *)request;
- (void)changetoRecent;
- (void)checkMarkets;
- (void)changetoCategories;
- (UISearchBar *)newSearchBar:(id)delegate;
- (UISearchDisplayController *)newSearchDisplayController:(id)delegate bar:(UISearchBar *)b;

@end
