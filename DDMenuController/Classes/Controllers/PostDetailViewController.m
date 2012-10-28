//
//  PostDetailViewController.m
//
//  Created by Harsh Jariwala on 1/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PostDetailViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation PostDetailViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIScrollView *full = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 440)];
    [full setBackgroundColor:[UIColor clearColor]];
    
    ARScrollViewEnhancer *view = [[ARScrollViewEnhancer alloc] initWithFrame:CGRectMake(0, 70, 320, 280)];
    [view setBackgroundColor:[UIColor clearColor]];
    
    CGFloat contentheight = 425;
    
    [full addSubview:view];
    full.showsVerticalScrollIndicator = YES;
    full.scrollEnabled = YES;
    [full setBounces:YES];
    
    UITextView *text = [[UITextView alloc] init];
    text.text = @"asdaksdkka alskdjasl klksjdl ajldk sdklsdks dskdks jdnskjdns kjdnskdjs nkdjsnkdjs ndkjsn dksjnd jnsdkj nsk jnk jnsdkj nskjd nskjnkj nkjnkj nkj nkj nkjn ksjnk jsnk jsnkj kjn kjsndkjsd sdkjandlaksjdlkas lkj dkajdlk lk alkd a \nd adlasjdlask jlakd lkasj lkasj  lkjd lkaj lkjl kjaslk laks lkjld kjalskd lkjlk lkajl kajlkd l \nlkdjl akjdl kasld\nasd jalskdj laksdjlk ld \nas ajdlk dlkajdlaskjdlsajdlsd. .. .  / / ?sD/aSD? ad;ladljlk asd";
    [text setUserInteractionEnabled:NO];
    [text setBackgroundColor:[UIColor clearColor]];
    [text setDataDetectorTypes:UIDataDetectorTypeAll];
    [text setFrame:CGRectMake(15, 355, 290, [text.text sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14] constrainedToSize:CGSizeMake(290, 9999)].height)];
    
    contentheight+=text.frame.size.height;
    [full setContentSize:CGSizeMake(320, contentheight)];
    
    UIView *pdetail = [self persondetailview];
    
    [full addSubview:text];
    [full addSubview:pdetail];
    
    UIButton *contact = [[UIButton alloc] initWithFrame:CGRectMake(80, contentheight-80, 140, 30)];
    [full addSubview:contact];
    [contact setBackgroundColor:[UIColor blackColor]];
    [contact addTarget:self action:@selector(sendmail) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setTitle:@"Price"];
    //***********************
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage  imageNamed:@"post_detail_background.png"]]];
    [self.view addSubview:full];
}

- (void)sendmail
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController * emailController = [[MFMailComposeViewController alloc] init];
        emailController.mailComposeDelegate = self;
        
        [emailController setSubject:@"HELLO"];
        [emailController setMessageBody:@"I WANTS YOUR STUFFS" isHTML:YES];   
        [emailController setToRecipients:[NSArray arrayWithObject:@"hdj@andrew.cmu.edu"]];
        
        [self presentModalViewController:emailController animated:YES];
        
    }
    // Show error if no mail account is active
    else {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"You must have a mail account in order to send an email" delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:nil];
        [alertView show];
    }
}

- (UIView*)persondetailview
{
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    [container setBackgroundColor:[UIColor clearColor]];
    UIImageView *picture = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Refresh.png"]];
    [picture setFrame:CGRectMake(5, 10, 40, 40)];
    [container addSubview:picture];
    UIView *border1 = [[UIView alloc] initWithFrame:CGRectMake(0, 58, 320, 1)];
    UIView *border2 = [[UIView alloc] initWithFrame:CGRectMake(0, 59, 320, 1)];
    [border1 setBackgroundColor:[UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1]];
    [border2 setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1]];
    [container addSubview:border1];
    [container addSubview:border2];
    return container;
}

- (void)donothing
{
    NSLog(@"SUP DAWG HAHA");
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
