//
//  LoginViewController.h
//  DDMenuController
//
//  Created by Harsh Jariwala on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) UIView *x2;
@property (strong, nonatomic) UIView *x3;
@property (strong, nonatomic) UIView *b1;
@property (strong, nonatomic) UIView *b2;
@property (strong, nonatomic) UITextField *emailfield;
@property (strong, nonatomic) UITextField *username;
@property (strong, nonatomic) UITextField *password;

- (void)animate1;
- (void)animate2;
- (void)requestFinished:(ASIHTTPRequest *)request;
- (void)requestFailed:(ASIHTTPRequest *)request;

@end
