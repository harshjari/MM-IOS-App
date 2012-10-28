//
//  DDMenuController.m
//  DDMenuController
//
//  Created by Devin Doty on 11/30/11.
//  Copyright (c) 2011 toaast. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
#import <QuartzCore/QuartzCore.h>
#import "DDMenuController.h"
#import "CategoryRecentController.h"
#import "MyPostController.h"
#import "NewPostsViewController.h"
#import "PostDetailViewController.h"
#import "LeftController.h"
#import "CategoryPostsViewController.h"

#define kMenuOverlayWidth 55.0f
#define kMenuBounceOffset 4.0f
#define kMenuBounceDuration .3f
#define kMenuSlideDuration .3f


@interface DDMenuController (Internal)
- (void)showLeftController:(BOOL)animated; 
- (void)showShadow:(BOOL)val;
- (void)placeRightBarButtonItem;
- (void)placeLeftBarButtonItem;
@end

@implementation DDMenuController

@synthesize delegate;

@synthesize leftController=_left;

@synthesize tap=_tap;
@synthesize pan=_pan;
@synthesize bubbleselected;

- (id)initWithRootViewController:(UIViewController*)controller {
    if ((self = [super initWithRootViewController:controller])) {

    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!_tap) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self.view addGestureRecognizer:tap];
        [tap setEnabled:NO];
        _tap = tap;
    }
    
    if (!_pan) {
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        pan.delegate = (id<UIGestureRecognizerDelegate>)self;
        [self.view addGestureRecognizer:pan];
        _pan = pan;
    }
    
    bubbleselected = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithBool:YES],[NSNumber numberWithBool:YES],nil];
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
    _tap = nil;
    _pan = nil;
}


#pragma mark - UINavigationController push overide  

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (!_menuFlags.showingLeftView) {
        [super pushViewController:viewController animated:animated];
        [self placeRightBarButtonItem];
        NSLog(@"push place left");
        [self placeLeftBarButtonItem];
        return;
    }
  
}


#pragma mark - GestureRecognizers

- (void)pan:(UIPanGestureRecognizer*)gesture {

    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        [self showShadow:YES];
        _panOriginX = self.view.frame.origin.x;        
        _panVelocity = CGPointMake(0.0f, 0.0f);
        
        if([gesture velocityInView:self.view].x > 0) {
            _panDirection = DDMenuPanDirectionRight;
        } else {
            _panDirection = DDMenuPanDirectionLeft;
        }

    }
    
    if (gesture.state == UIGestureRecognizerStateChanged) {
        
        CGPoint velocity = [gesture velocityInView:self.view];
        if((velocity.x*_panVelocity.x + velocity.y*_panVelocity.y) < 0) {
            _panDirection = (_panDirection == DDMenuPanDirectionRight) ? DDMenuPanDirectionLeft : DDMenuPanDirectionRight;
        }
        
        _panVelocity = velocity;        
        CGPoint translation = [gesture translationInView:self.view];
        CGRect frame = self.view.frame;
        frame.origin.x = _panOriginX + translation.x;
        
        if (frame.origin.x >= 0.0f && !_menuFlags.showingLeftView) {
            
            if (_menuFlags.canShowLeft) {
                
                _menuFlags.showingLeftView = YES;
                [self.view.superview insertSubview:self.leftController.view belowSubview:self.view];
                
            } else {
                frame.origin.x = 0.0f; // ignore right view if it's not set
            }
            
        } else if (frame.origin.x <= 0.0f) {
            
            if(_menuFlags.showingLeftView) {
                _menuFlags.showingLeftView = NO;
                [self.leftController.view removeFromSuperview];
            }
            
            frame.origin.x = 0.0f; // ignore left view if it's not set
            
        }
        
        self.view.frame = frame;

    } else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
        
        //  Finishing moving to left, right or root view with current pan velocity
        [self.view setUserInteractionEnabled:NO];
        
        DDMenuPanCompletion completion = DDMenuPanCompletionRoot; // by default animate back to the root
        
        if (_panDirection == DDMenuPanDirectionRight && _menuFlags.showingLeftView) {
            completion = DDMenuPanCompletionLeft;
        }
        
        CGPoint velocity = [gesture velocityInView:self.view];    
        if (velocity.x < 0.0f) {
            velocity.x *= -1.0f;
        }
        BOOL bounce = (velocity.x > 800);
        CGFloat originX = self.view.frame.origin.x;
        CGFloat width = self.view.frame.size.width;
        CGFloat span = (width - kMenuOverlayWidth);
        CGFloat duration = kMenuSlideDuration; // default duration with 0 velocity
        
        
        if (bounce) {
            duration = (span / velocity.x); // bouncing we'll use the current velocity to determine duration
        } else {
            duration = ((span - originX) / span) * duration; // user just moved a little, use the defult duration, otherwise it would be too slow
        }
        
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            if (completion == DDMenuPanCompletionLeft) {
                [self showLeftController:NO];
            } else {
                [self showRootController:NO];
            }
            [self.view.layer removeAllAnimations];
            [self.view setUserInteractionEnabled:YES];
        }];
        
        CGPoint pos = self.view.layer.position;
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        
        NSMutableArray *keyTimes = [[NSMutableArray alloc] initWithCapacity:bounce ? 3 : 2];
        NSMutableArray *values = [[NSMutableArray alloc] initWithCapacity:bounce ? 3 : 2];
        NSMutableArray *timingFunctions = [[NSMutableArray alloc] initWithCapacity:bounce ? 3 : 2];
        
        [values addObject:[NSValue valueWithCGPoint:pos]];
        [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
        [keyTimes addObject:[NSNumber numberWithFloat:0.0f]];
        if (bounce) {
            
            duration += kMenuBounceDuration;
            [keyTimes addObject:[NSNumber numberWithFloat:1.0f - ( kMenuBounceDuration / duration)]];
            if (completion == DDMenuPanCompletionLeft) {
                
                [values addObject:[NSValue valueWithCGPoint:CGPointMake(((width/2) + span) + kMenuBounceOffset, pos.y)]];
                
            } else if (completion == DDMenuPanCompletionRight) {
                
                [values addObject:[NSValue valueWithCGPoint:CGPointMake(-((width/2) - (kMenuOverlayWidth-kMenuBounceOffset)), pos.y)]];
                
            } else {
                
                // depending on which way we're panning add a bounce offset
                if (_panDirection == DDMenuPanDirectionLeft) {
                    [values addObject:[NSValue valueWithCGPoint:CGPointMake((width/2) - kMenuBounceOffset, pos.y)]];
                } else {
                    [values addObject:[NSValue valueWithCGPoint:CGPointMake((width/2) + kMenuBounceOffset, pos.y)]];
                }
                
            }
            
            [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            
        }
        if (completion == DDMenuPanCompletionLeft) {
            [values addObject:[NSValue valueWithCGPoint:CGPointMake((width/2) + span, pos.y)]];
        } else if (completion == DDMenuPanCompletionRight) {
            [values addObject:[NSValue valueWithCGPoint:CGPointMake(-((width/2) - kMenuOverlayWidth), pos.y)]];
        } else {
            [values addObject:[NSValue valueWithCGPoint:CGPointMake(width/2, pos.y)]];
        }
        
        [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        [keyTimes addObject:[NSNumber numberWithFloat:1.0f]];
        
        animation.timingFunctions = timingFunctions;
        animation.keyTimes = keyTimes;
        animation.calculationMode = @"cubic";
        animation.values = values;
        animation.duration = duration;   
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        [self.view.layer addAnimation:animation forKey:nil];
        [CATransaction commit];   
    
    }    
    
}

- (void)tap:(UITapGestureRecognizer*)gesture {
    
    [gesture setEnabled:NO];
    [self showRootController:YES];
    
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {

    // Check for horizontal pan gesture
    if (gestureRecognizer == _pan) {

        UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer*)gestureRecognizer;
        CGPoint translation = [panGesture translationInView:self.view];

        if ([panGesture velocityInView:self.view].x < 600 && sqrt(translation.x * translation.x) / sqrt(translation.y * translation.y) > 1) {
            return YES;
        } 
        
        return NO;
    }

    return YES;
   
}


#pragma Internal Nav Handling 

- (void)showShadow:(BOOL)val {

    self.view.layer.shadowOpacity = val ? 0.8f : 0.0f;
    if (val) {
        self.view.layer.cornerRadius = 4.0f;
        self.view.layer.shadowOffset = CGSizeZero;
        self.view.layer.shadowRadius = 4.0f;
        self.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;
    }
    
}

- (void)showRootController:(BOOL)animated {
    
    [_tap setEnabled:NO];
    
    CGRect frame = self.view.frame;
    frame.origin.x = 0.0f;

    BOOL _enabled = [UIView areAnimationsEnabled];
    if (!animated) {
        [UIView setAnimationsEnabled:NO];
    }
    
    [UIView animateWithDuration:.3 animations:^{
        
        self.view.frame = frame;
        
    } completion:^(BOOL finished) {
        
        if (self.leftController && self.leftController.view.superview) {
            [self.leftController.view removeFromSuperview];
        }
        _menuFlags.showingLeftView = NO;

        [self showShadow:NO];
        
    }];
    
    if (!animated) {
        [UIView setAnimationsEnabled:_enabled];
    }
    
    if([[self.viewControllers objectAtIndex:0] class]==[CategoryRecentController class])
    {
        [(CategoryRecentController *)[self.viewControllers objectAtIndex:0] checkMarkets];
    }
    
}

- (void)showLeftController:(BOOL)animated {
    if (!_menuFlags.canShowLeft) return;
    
    if (_menuFlags.respondsToWillShowViewController) {
        [self.delegate menuController:self willShowViewController:self.leftController];
    }
    _menuFlags.showingLeftView = YES;
    [self showShadow:YES];

    UIView *view = self.leftController.view;
    view.frame = [[UIScreen mainScreen] applicationFrame];
    [self.view.superview insertSubview:view belowSubview:self.view];
    
    CGRect frame = self.view.frame;
    frame.origin.x = (CGRectGetMaxX(view.frame) - kMenuOverlayWidth);
    
    BOOL _enabled = [UIView areAnimationsEnabled];
    if (!animated) {
        [UIView setAnimationsEnabled:NO];
    }
    
    [UIView animateWithDuration:.3 animations:^{
        self.view.frame = frame;
    } completion:^(BOOL finished) {
        [_tap setEnabled:YES];
    }];
    
    if (!animated) {
        [UIView setAnimationsEnabled:_enabled];
    }
    
}


#pragma mark Setters

- (void)setDelegate:(id<DDMenuControllerDelegate>)val {
    [super setDelegate:(id<UINavigationControllerDelegate>)val];
    
    _menuFlags.respondsToWillShowViewController = [(id)self.delegate respondsToSelector:@selector(menuController:willShowViewController:)];
    
}


-(void)newpostcreate {
    
    NewPostsViewController *npvc = [[NewPostsViewController alloc] init];
    [self presentModalViewController:npvc animated:YES];
    
}


-(void)placeRightBarButtonItem {

    UIViewController *controller = [self.viewControllers objectAtIndex:0];
    
    if([self.viewControllers count]==2&&[[self.viewControllers objectAtIndex:1] class]==[PostDetailViewController class])
    {
        controller = [self.viewControllers objectAtIndex:1];
        UIView *x = [[UIView alloc] initWithFrame:CGRectMake(45, 1, 1, 26)];
        [x setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:0.7]];
        CALayer *lay;
        UIView *container = [[UIView alloc] initWithFrame:CGRectMake(-8, 0, 90, 28)];
        container.backgroundColor = [UIColor clearColor];
        
        UIButton *bi1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [bi1 setBackgroundImage:[UIImage imageNamed:@"uparrow.png"] forState:UIControlStateNormal];
        [bi1 addTarget:self action:@selector(donothing) forControlEvents:UIControlEventTouchUpInside];
        bi1.frame = CGRectMake(0, 0, 45, 28);
        [container addSubview:bi1];
        
        // Add button 2
        UIButton *bi2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [bi2 setBackgroundImage:[UIImage imageNamed:@"downarrow.png"] forState:UIControlStateNormal];
        [bi2 addTarget:self action:@selector(donothing) forControlEvents:UIControlEventTouchUpInside];
        [bi2 setFrame:CGRectMake(44, 0, 45, 28)];
        [container addSubview:bi2];
        
        lay = container.layer;
        
        [lay setBorderWidth:1.0];
        [lay setCornerRadius:5.0];
        [lay setBorderColor:[[UIColor colorWithWhite:0.3 alpha:0.7] CGColor]];
        [container addSubview:x];
        
        // Add toolbar to nav bar.
        UIBarButtonItem *twoButtons = [[UIBarButtonItem alloc] initWithCustomView:container];
        controller.navigationItem.rightBarButtonItem = twoButtons;
    }
    else if([self.viewControllers count]==3&&[[self.viewControllers objectAtIndex:2] class]==[PostDetailViewController class])
    {
        controller = [self.viewControllers objectAtIndex:2];
        UIView *x = [[UIView alloc] initWithFrame:CGRectMake(45, 1, 1, 26)];
        [x setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:0.7]];
        CALayer *lay;
        UIView *container = [[UIView alloc] initWithFrame:CGRectMake(-8, 0, 90, 28)];
        container.backgroundColor = [UIColor clearColor];
        
        UIButton *bi1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [bi1 setBackgroundImage:[UIImage imageNamed:@"uparrow.png"] forState:UIControlStateNormal];
        [bi1 addTarget:self action:@selector(donothing) forControlEvents:UIControlEventTouchUpInside];
        bi1.frame = CGRectMake(0, 0, 45, 28);
        [container addSubview:bi1];
        
        // Add button 2
        UIButton *bi2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [bi2 setBackgroundImage:[UIImage imageNamed:@"downarrow.png"] forState:UIControlStateNormal];
        [bi2 addTarget:self action:@selector(donothing) forControlEvents:UIControlEventTouchUpInside];
        [bi2 setFrame:CGRectMake(44, 0, 45, 28)];
        [container addSubview:bi2];
        
        lay = container.layer;
        
        [lay setBorderWidth:1.0];
        [lay setCornerRadius:5.0];
        [lay setBorderColor:[[UIColor colorWithWhite:0.3 alpha:0.7] CGColor]];
        [container addSubview:x];
        
        // Add toolbar to nav bar.
        UIBarButtonItem *twoButtons = [[UIBarButtonItem alloc] initWithCustomView:container];
        controller.navigationItem.rightBarButtonItem = twoButtons;
    }
    else if([self.viewControllers count]==2&&[[self.viewControllers objectAtIndex:1] class]==[CategoryPostsViewController class])
    {
        controller = [self.viewControllers objectAtIndex:1];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [button setBackgroundImage:[UIImage imageNamed:@"Refresh.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(newpostcreate) forControlEvents:UIControlEventTouchUpInside];
        controller.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    else if([controller class] == [CategoryRecentController class]){
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [button setBackgroundImage:[UIImage imageNamed:@"Refresh.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(newpostcreate) forControlEvents:UIControlEventTouchUpInside];
        controller.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    else if([controller class] == [MyPostController class])
    {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 28)];
        [button setBackgroundImage:[UIImage imageNamed:@"redbar.png"] forState:UIControlStateNormal];
        [button setTitle:@"Edit" forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:11]];
        [button addTarget:self action:@selector(editmodeactivate) forControlEvents:UIControlEventTouchUpInside];
        controller.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        [button.layer setBorderColor:[[UIColor colorWithWhite:0.4 alpha:0.6] CGColor]];
        [button.layer setBorderWidth:1.0];
        [button.layer setCornerRadius:5.0];
    }
    else
    {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [button setBackgroundImage:[UIImage imageNamed:@"Refresh.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(newpostcreate) forControlEvents:UIControlEventTouchUpInside];
        controller.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    
}

- (void)editmodeactivate
{
    [(MyPostController*)[self.viewControllers objectAtIndex:0] editpressed];
}

- (void)setLeftController:(UIViewController *)leftController {
    _left = leftController;
    
    NSAssert([self.viewControllers count] > 0, @"Must have a root controller set.");
    
    [self placeLeftBarButtonItem];
    [self placeCenterView];
    [self placeRightBarButtonItem];
}

-(void) placeCenterView {
    
    //WILL PROBABLY NEED TO CHANGE BUTTON BACKGROUNDS
    //CHANGE THEM TO MAKE THEM DIFFERENT FOR VARIOUS STATES
    //USING:[myButton setBackgroundImage:[UIImage imageNamed:@"normal.png"] forState:UIControlStateNormal];
    
    UIViewController *controller = [self.viewControllers objectAtIndex:0];
    if([controller class] == [CategoryRecentController class])
    {
        UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 7, 180, 30)];
        container.clipsToBounds = NO;
        container.backgroundColor = [UIColor clearColor];
        
        UIButton *bi1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [bi1.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:11]];
        [bi1 setBackgroundImage:[UIImage imageNamed:@"recent_button.png"] forState:UIControlStateNormal];
        [bi1 addTarget:self action:@selector(changetoRecent) forControlEvents:UIControlEventTouchUpInside];
        bi1.frame = CGRectMake(0, 0, 90, 30);
        [container addSubview:bi1];
        
        UIButton *bi2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [bi2.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:11]];
        [bi2 setBackgroundImage:[UIImage imageNamed:@"categories_button.png"] forState:UIControlStateNormal];  
        [bi2 addTarget:self action:@selector(changetoCategories) forControlEvents:UIControlEventTouchUpInside];
        [bi2 setFrame:CGRectMake(90, 0, 90, 30)];
        [container addSubview:bi2];
        
        controller.navigationItem.titleView = container;
    }
}

-(BOOL)showingleftviewornot {
    return _menuFlags.showingLeftView;
}

-(void)placeLeftBarButtonItem {

    
    UIViewController *controller = [self.viewControllers objectAtIndex:0];
    NSLog(@"helloWORLD1");
    
    if (_left&&[self.viewControllers count]==1) {
        NSLog(@"helloWORLD0");
        UIViewController *controller = [self.viewControllers objectAtIndex:0];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 38)];
        [button setBackgroundImage:[UIImage imageNamed:@"Sidebar.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(showLeft:) forControlEvents:UIControlEventTouchUpInside];
        controller.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        _menuFlags.canShowLeft = YES;

        
    } else if ([self.viewControllers count]==2) {
        
        NSLog(@"helloWORLD");
        controller = [self.viewControllers objectAtIndex:1];
        UIImage *buttonImage = [UIImage imageNamed:@"buttonbackground.png"];
        UIButton *backbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backbutton setBackgroundImage:buttonImage forState:UIControlStateNormal];
        [backbutton setTitle:@"Back" forState:UIControlStateNormal];
        [backbutton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:11]];
        [backbutton.titleLabel setTextAlignment:UITextAlignmentCenter];
        [backbutton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 1, 0)];
        backbutton.frame = CGRectMake(0, 20, 50, 50);
        [backbutton addTarget:self action:@selector(popDetailView) forControlEvents:UIControlEventTouchUpInside];
        controller.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backbutton];
        _menuFlags.canShowLeft = NO;
        
    } else if ([self.viewControllers count]==3) {
        
        NSLog(@"helloWORLD");
        controller = [self.viewControllers objectAtIndex:2];
        UIImage *buttonImage = [UIImage imageNamed:@"buttonbackground.png"];
        UIButton *backbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backbutton setBackgroundImage:buttonImage forState:UIControlStateNormal];
        [backbutton setTitle:@"Back" forState:UIControlStateNormal];
        [backbutton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:11]];
        [backbutton.titleLabel setTextAlignment:UITextAlignmentCenter];
        [backbutton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 1, 0)];
        backbutton.frame = CGRectMake(0, 20, 50, 50);
        [backbutton addTarget:self action:@selector(popDetailView) forControlEvents:UIControlEventTouchUpInside];
        controller.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backbutton];
        _menuFlags.canShowLeft = NO;
        
    } 
    else {
        NSLog(@"helloWORLD2");
        controller.navigationItem.leftBarButtonItem = nil;
        _menuFlags.canShowLeft = NO;

    }
    
    
}

- (void)popDetailView {
    
    UIViewController *v = [self.viewControllers objectAtIndex:1];
    if ([self.viewControllers count]==3)
    {
        v = [self.viewControllers objectAtIndex:2];
        [((PostDetailViewController*)v).navigationController popViewControllerAnimated:YES];
        return;
    }
    else if([v class] == [PostDetailViewController class])
        [((PostDetailViewController*)v).navigationController popViewControllerAnimated:YES];
    else if([v class] == [CategoryPostsViewController class])
        [((CategoryPostsViewController*)v).navigationController popViewControllerAnimated:YES];
    
    _menuFlags.canShowLeft = YES;
}

- (void)setRootController:(UIViewController *)controller animated:(BOOL)animated {
    
    //Following 2 lines push a new view controller
    //self.viewControllers = [self.viewControllers arrayByAddingObject:controller];
    //NSLog(@"%i", [self.viewControllers count]);
    if([controller class] == [NewPostsViewController class]) {
        [self presentModalViewController:controller animated:animated];
    } else {
        self.viewControllers = [NSArray arrayWithObject:controller];
        [self placeLeftBarButtonItem];
        [self placeCenterView];
        [self placeRightBarButtonItem];
    }
    [self showRootController:animated];

}


- (void)changetoRecent
{
    [(CategoryRecentController*)[self.viewControllers objectAtIndex:0] changetoRecent];
}

- (void)changetoCategories
{
    [(CategoryRecentController*)[self.viewControllers objectAtIndex:0] changetoCategories];
}


#pragma mark - Actions 

- (void)showLeft:(id)sender {
    
    [self showLeftController:YES];
    
}

- (void)donothing
{
    NSLog(@"Like my name says, I do nothing");
    //[(CategoryRecentController*)[self.viewControllers objectAtIndex:0] refreshpressed];
}

- (void)setupMarkets:(NSMutableArray *)bubbleschanged
{
    bubbleselected = bubbleschanged;
}


@end
