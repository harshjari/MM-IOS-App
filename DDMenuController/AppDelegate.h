//
//  AppDelegate.h
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"

@class DDMenuController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) DDMenuController *menuController;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LoginViewController *x;

- (void)presentLogin;

@end
