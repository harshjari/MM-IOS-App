//
//  LoginViewController.m
//  DDMenuController
//
//  Created by Harsh Jariwala on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"

@implementation LoginViewController

@synthesize x2;
@synthesize x3;
@synthesize b1;
@synthesize b2;
@synthesize emailfield;
@synthesize username;
@synthesize password;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"welcome_screen_logo.png"]];
    [logo setFrame:CGRectMake(20, 0, 200, 70)];
    
    b1 = [[UIView alloc] initWithFrame:CGRectMake(10, 110, 226, 52)];
    b2 = [[UIView alloc] initWithFrame:CGRectMake(10, 170, 226, 52)];
    
    [b1 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"button_background_overlay.png"]]];
    [b2 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"button_background_overlay.png"]]];
    
    x2 = [[UIView alloc] init];
    x3 = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 220, 140)];
    
    UIButton *but1 = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *but2 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [but1 setFrame:CGRectMake(8, 7, 210, 39)];
    [but2 setFrame:CGRectMake(8, 7, 210, 39)];
    
    [but1 setBackgroundImage:[UIImage imageNamed:@"login_button.png"] forState:UIControlStateNormal];
    [but2 setBackgroundImage:[UIImage imageNamed:@"sign_up_button.png"] forState:UIControlStateNormal];
    
    [b1 addSubview:but1];
    [b2 addSubview:but2];
    
    [x2 setFrame:CGRectMake(40, 100, 240, 240)];
    [x2 addSubview:b1];
    [x2 addSubview:b2];
    [x2 addSubview:logo];
    
    [but1 addTarget:self action:@selector(animate1) forControlEvents:UIControlEventTouchUpInside];
    [but2 addTarget:self action:@selector(animate2) forControlEvents:UIControlEventTouchUpInside];
    emailfield = [[UITextField alloc] initWithFrame:CGRectMake(10, 170, 220, 40)];
    
    username = [[UITextField alloc] initWithFrame:CGRectMake(10, 60, 220, 40)];
    [username setPlaceholder:@"Username"];
    [username setBackgroundColor:[UIColor whiteColor]];
    password = [[UITextField alloc] initWithFrame:CGRectMake(10, 120, 220, 40)];
    [password setPlaceholder:@"Password"];
    [password setBackgroundColor:[UIColor whiteColor]];
    
    [x3 addSubview:username];
    [x3 addSubview:password];
    
    //[x2 setBackgroundColor:[UIColor redColor]];
    
    [emailfield setPlaceholder:@"Email"];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage  imageNamed:@"loginbackground.png"]]];
    [self.view addSubview:x2];
    
    [emailfield setDelegate:self];
    [username setDelegate:self];
    [password setDelegate:self];
    
    emailfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    emailfield.autocapitalizationType = UITextAutocapitalizationTypeNone;
    emailfield.autocorrectionType = UITextAutocorrectionTypeNo;
    emailfield.returnKeyType = UIReturnKeyDone;
    
    username.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    username.autocapitalizationType = UITextAutocapitalizationTypeNone;
    username.autocorrectionType = UITextAutocorrectionTypeNo;
    username.returnKeyType = UIReturnKeyNext;
    
    password.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    password.autocapitalizationType = UITextAutocapitalizationTypeNone;
    password.autocorrectionType = UITextAutocorrectionTypeNo;
    password.secureTextEntry = YES;
    password.returnKeyType = UIReturnKeyDone;

    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
	if (textField == username) {
        [password becomeFirstResponder];
    }
	else if (textField == password) {
        [self dismissModalViewControllerAnimated:NO];
        return YES;
        
        NSURL *url = [NSURL URLWithString:@"http://localhost:3000/users/sign_in"];
        NSURLCredential *creds = [ASIFormDataRequest savedCredentialsForHost:[url host] port:[[url port] intValue] protocol:[url scheme] realm:@"Application"];
        if(creds)
            NSLog(@"%@ %@",[creds user], [creds password]);
        
        //[ASIFormDataRequest removeCredentialsForHost:[url host] port:[[url port] intValue] protocol:[url scheme]  realm:@"Application"];
        
        ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
        [request setUsername:username.text];
        [request setPassword:password.text];
        [request setDelegate:self];
        [request setShouldPresentCredentialsBeforeChallenge:NO];
        [request addRequestHeader:@"Accept" value:@"application/json"];
        [request setUseSessionPersistence:YES];
        [request setUseKeychainPersistence:YES];
        [request startAsynchronous];
    }
    else if(textField == emailfield)
    {
        ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:@"http://localhost:3000/users/sign_in"]];
        [request setPostValue:@"email@email.com" forKey:@"email"];
        [request setDelegate:self];
        [request addRequestHeader:@"Accept" value:@"application/json"];
        [request setUseSessionPersistence:NO];
        [request startAsynchronous];
    }
        
	return YES;
}


- (void)requestFinished:(ASIHTTPRequest *)request {
    NSLog(@"YAY SUXESS PASS");
    NSLog(@"%@", [request responseString]);
    NSLog(@"%@", [request responseHeaders]);
    [self dismissModalViewControllerAnimated:NO];
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    
    NSLog(@"%@", [request responseString]);
    NSLog(@"%@", [request responseHeaders]);
    NSLog(@"SORRY FAIL PASS");
}

-(void)animate1 {
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         [b1 setAlpha:0];
                         [b2 setAlpha:0];
                         [x2 addSubview:x3];
                         [x2 setFrame:CGRectMake(40, 30, 240, 200)];
                     }];
    
    [username becomeFirstResponder];
    
}

-(void)animate2 {
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         [b1 setAlpha:0];
                         [b2 setAlpha:0];
                         [x2 addSubview:emailfield];
                         [x2 setFrame:CGRectMake(40, 30, 240, 200)];
                     }];
    
    [emailfield becomeFirstResponder];
    
}


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
