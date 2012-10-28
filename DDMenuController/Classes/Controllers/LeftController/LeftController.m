//
//  LeftController.m
//

#import "LeftController.h"
#import "CategoryRecentController.h"
#import "DDMenuController.h"
#import "MyPostController.h"
#import "NewPostsViewController.h"

@implementation LeftController

@synthesize tableView=_tableView;
@synthesize RowSelected;
@synthesize bubbleselected;

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
    RowSelected = 0;
    
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        tableView.delegate = (id<UITableViewDelegate>)self;
        tableView.dataSource = (id<UITableViewDataSource>)self;
        [self.view addSubview:tableView];
        self.tableView = tableView;
    }
    
    [_tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"navigation_background.png"]]];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    NSLog(@"LOADED???");
    
    //footer to remove empty cell separators
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    v.backgroundColor = [UIColor clearColor];
    
    bubbleselected = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithBool:YES],[NSNumber numberWithBool:YES],nil];//getfrom DDMENu!
    
    [_tableView setTableFooterView:v];
    [_tableView setScrollEnabled:NO];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.tableView = nil;
}


#pragma mark - UITableViewDataSource

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 26)];
    lbl.textAlignment = UITextAlignmentLeft;
    [lbl setTextColor:[UIColor grayColor]];
    [lbl setText:((section==0)?@"   Harsh Jariwala":@"   Bubble Visibility")];
    [lbl setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"blackbar.png"]]];
    lbl.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    return lbl;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 26;
}


- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 0)?10:6;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row%3!=0)
    {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        if(indexPath.row%3 == 1) {
            NSLog(@"asdad");
            [cell.contentView setBackgroundColor:[UIColor colorWithRed:32.0/255.0 green:32.0/255.0 blue:32.0/255.0 alpha:1]];
        }
        else if(indexPath.row%3 == 2) {
            [cell.contentView setBackgroundColor:[UIColor colorWithRed:70.0/255.0 green:70.0/255.0 blue:70.0/255.0 alpha:1]];
        }
        [cell setUserInteractionEnabled:NO];
        return cell;
    }
    
    
    if(indexPath.section==1)
    {
        SVSegmentedControl *SC = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"YES", @"NO", nil]];
        SC.crossFadeLabelsOnDrag = YES;
        SC.thumb.tintColor = [UIColor colorWithRed:239.0/255.0 green:57.0/255.0 blue:57.0/255.0 alpha:1];
        SC.center = CGPointMake(200, 22);
        SC.height = 28;
        [SC setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
        [SC addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
        [SC setTag:indexPath.row/3];
        
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        if([[bubbleselected objectAtIndex:(indexPath.row/3)] boolValue]) {
            [SC setSelectedIndex:0];
            [cell.textLabel setTextColor:[UIColor whiteColor]];
        }
        else {
            [SC setSelectedIndex:1];
            [cell.textLabel setTextColor:[UIColor lightGrayColor]];
        }
        
        if(indexPath.row/3 == 0)
            [cell.textLabel setText:@"Carnegie Mellon"];
        else if(indexPath.row/3 == 1)
            [cell.textLabel setText:@"Univ. of Pittsburgh"];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
        [cell addSubview:SC];
        
        return cell;
    }
    
    static NSString *CellIdentifier = @"SidebarIdent";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    NSArray *a = [[NSArray alloc] initWithObjects:@"Posts", @"My Posts", @"Add Post",@"Log Out", nil];
    NSArray *b = [[NSArray alloc] initWithObjects:@"Refresh.png", @"mypost.png", @"addpost.png",@"logout.png", nil];
    NSString *cat = [a objectAtIndex:(indexPath.row/3)];
    UIFont *f = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    UILabel *x = [[UILabel alloc] initWithFrame:CGRectMake(45,12,[cat sizeWithFont:f].width, [cat sizeWithFont:f].height)];
    [x setFont:f];
    
    [x setBackgroundColor:[UIColor clearColor]];
    UIImageView *i1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow1.png"]];
    [i1 setFrame:CGRectMake(240, 18, 10, 10)];
    UIView *viewSelected = [[UIView alloc] init];
    UIImageView *i2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow2.png"]];
    [i2 setFrame:CGRectMake(240, 18, 10, 10)];
    UIImageView *i3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[b objectAtIndex:(indexPath.row/3)]]];
    [i3 setFrame:CGRectMake(5, 6, 30, 30)];
    [viewSelected addSubview:i2];
    [viewSelected setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"selectedRow.png"]]];
    [cell setSelectedBackgroundView:viewSelected];
    [cell addSubview:i3];
    [x setText:[a objectAtIndex:(indexPath.row/3)]];
    [x setTextColor:[UIColor lightGrayColor]];
    [cell addSubview:i1];
    [cell addSubview:x];
    
    if(RowSelected == indexPath.row/3) {
        [_tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        [x setTextColor:[UIColor whiteColor]];
    }
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row%3!=0)
       return 1;
    
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row%3!=0||indexPath.section==1) {
        [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:RowSelected*3 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        return;
    }
    
    if(indexPath.row == RowSelected*3&&RowSelected!=3)
        return;
    
    else if(!(indexPath.row == RowSelected*3&&RowSelected==3))
    {
        NSIndexPath *x = [NSIndexPath indexPathForRow:RowSelected*3 inSection:0];
    
        RowSelected = indexPath.row/3;
    
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, x, nil] withRowAnimation:UITableViewRowAnimationNone];
    }
        
    
    // set the root controller
    DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    
    if(indexPath.row/3 == 1){
        MyPostController *mpc = [[MyPostController alloc] init];
        [menuController setRootController:mpc animated:YES];
    }
    else if(indexPath.row/3 == 2) {
        NewPostsViewController *np = [[NewPostsViewController alloc] init];
        [menuController setRootController:np animated:YES];
    }
    else if(indexPath.row/3 == 3) {
    }
    else {
        CategoryRecentController *controller = [[CategoryRecentController alloc] init];
        [menuController setRootController:controller animated:YES];
    }

}

- (void)segmentedControlChangedValue:(SVSegmentedControl *)segmentedControl {
    if([segmentedControl selectedIndex] == 1&&[[bubbleselected objectAtIndex:(segmentedControl.tag)] boolValue]) {
        [bubbleselected replaceObjectAtIndex:(segmentedControl.tag) withObject:[NSNumber numberWithBool:NO]];
    }
    else if ([segmentedControl selectedIndex] == 0&&![[bubbleselected objectAtIndex:(segmentedControl.tag)] boolValue]) {
        [bubbleselected replaceObjectAtIndex:(segmentedControl.tag) withObject:[NSNumber numberWithBool:YES]];
    }
    else
        return;
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:segmentedControl.tag*3 inSection:1], nil] withRowAnimation:UITableViewRowAnimationNone];
    [self setMarkets];
}

- (void)setMarkets {
    DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    [menuController setupMarkets:bubbleselected];
}

@end
