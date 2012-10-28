//
//  MyPostController.h
//
//  Created by Harsh Jariwala on 2/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDMenuController.h"

@interface MyPostController : UIViewController

@property(nonatomic,strong) UITableView *TableView;
@property(nonatomic) BOOL editmode;

-(void)editpressed;

@end
