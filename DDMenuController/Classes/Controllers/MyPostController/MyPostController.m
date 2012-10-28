//
//  MyPostController.m
//
//  Created by Harsh Jariwala on 2/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyPostController.h"

@implementation MyPostController

@synthesize TableView;
@synthesize editmode;

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!TableView) {
        UITableView *TemptableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        TemptableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        TemptableView.delegate = (id<UITableViewDelegate>)self;
        TemptableView.dataSource = (id<UITableViewDataSource>)self;
        [self.view addSubview:TemptableView];
        TableView = TemptableView;
    }
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"redbar.png"] forBarMetrics:UIBarMetricsDefault];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    v.backgroundColor = [UIColor clearColor];
    [TableView setTableFooterView:v];
    [self.navigationItem setTitle:@"My Posts"];
    editmode = NO;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.TableView = nil;
}

- (void)editpressed
{
    if(editmode == NO)
        editmode = YES;
    else
        editmode = NO;
    [TableView reloadData];
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
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 76;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(editmode == NO) {
    
        static NSString *CellIdentifier = @"MyPostCells";
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
        
        UIImageView *i = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Refresh.png"]];
        [i setFrame:CGRectMake(2, -2, 64, 78)];
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(70, 8, 160, 22)];
        UILabel *bubble = [[UILabel alloc] initWithFrame:CGRectMake(88, 33, 160, 16)];
        UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(240, 11, 60, 18)];
        UILabel *Price = [[UILabel alloc] initWithFrame:CGRectMake(240, 42, 60, 26)];

        [title setText:[[NSString alloc] initWithString:@"Mint Like new thingy"]];
        [title setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
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
    else
    {
        static NSString *CellIdentifier = @"MyPostEditView";
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
        
        UIImageView *i = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Refresh.png"]];
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(70, 8, 160, 22)];
        UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(240, 11, 60, 18)];
        UILabel *Price = [[UILabel alloc] initWithFrame:CGRectMake(240, 42, 60, 26)];
        UIButton *Delbutton = [[UIButton alloc] init];
        UIButton *Renewbutton = [[UIButton alloc] init];
        [Delbutton setBackgroundImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
        [Renewbutton setBackgroundImage:[UIImage imageNamed:@"renew.png"] forState:UIControlStateNormal];
        
        [Delbutton addTarget:self action:@selector(editpressed) forControlEvents:UIControlEventTouchUpInside];
        [Renewbutton addTarget:self action:@selector(editpressed) forControlEvents:UIControlEventTouchUpInside];
        
        [i setFrame:CGRectMake(2, -2, 64, 78)];
        [Delbutton setFrame:CGRectMake(66, 30, 70, 40)];
        [Renewbutton setFrame:CGRectMake(136, 30, 70, 40)];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [title setText:[[NSString alloc] initWithString:@"Mint Like new thingy"]];
        [title setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
        
        [Price setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
        [Price setTextAlignment:UITextAlignmentRight];
        [Price setText:@"$115"];
        [Price setTextColor:[UIColor redColor]];
        
        [time setFont:[UIFont fontWithName:@"Helvetica" size:12]];
        [time setTextAlignment:UITextAlignmentRight];
        [time setText:@"1:15 AM"];
        [time setTextColor:[UIColor grayColor]];
        
        [cell addSubview:i];
        [cell addSubview:Delbutton];
        [cell addSubview:Renewbutton];
        [cell addSubview:title];
        [cell addSubview:time];
        [cell addSubview:Price];
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

@end
