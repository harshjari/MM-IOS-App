//
//  LeftController.h
//

#import <UIKit/UIKit.h>
#import "SVSegmentedControl.h"

@interface LeftController : UIViewController <UITableViewDelegate>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic) NSUInteger RowSelected;
@property(nonatomic,strong) NSMutableArray *bubbleselected;

- (void)segmentedControlChangedValue:(SVSegmentedControl*)segmentedControl;
- (void)setMarkets;

@end
