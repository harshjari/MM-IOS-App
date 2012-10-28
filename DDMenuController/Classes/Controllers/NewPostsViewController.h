//
//  NewPostsViewController.h
//
//  Created by Harsh Jariwala on 8/26/11.
//  Copyright 2011 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import <MapKit/MKReverseGeocoder.h>
#import "tgmath.h"

@interface NewPostsViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPickerViewDelegate, UIScrollViewDelegate, UITextViewDelegate, UIActionSheetDelegate, UIScrollViewDelegate> {
    
    UIView *v0;
    UIView *v1;
    UIView *v2;
    UITableView *v3;
    NSMutableArray *categories;
    MKMapView *mapView;
    UIButton *buttonx;
    UIButton *Buy;
    UIButton *Sell;
    UIButton *Sublet;
    UITextView *Title;
    UITextView *Price;
    UITextView *Description;
    NSUInteger lasttag;
    NSUInteger postoption;
    
}


@property (nonatomic) BOOL text1;
@property (nonatomic) BOOL text2;
@property (nonatomic) BOOL text3;
@property (nonatomic) NSUInteger lasttag;
@property (nonatomic) CGFloat ht;
@property (nonatomic) NSUInteger imagechangefor;
@property (nonatomic, retain) UITextView *Price;
@property (nonatomic, retain) UITextView *Title;
@property (nonatomic, retain) UITextView *Description;
@property (nonatomic, retain) UIView *v0;
@property (nonatomic, retain) UIScrollView *NewPostDetail;
@property (nonatomic, retain) UIView *v1;
@property (nonatomic, retain) UIView *v2;
@property (nonatomic, retain) UITableView *v3;
@property (nonatomic, retain) NSMutableArray *categories;
@property (nonatomic, retain) MKMapView *mapView;
@property (nonatomic, retain) UIButton *buttonx;
@property (nonatomic, retain) UIButton *b1;
@property (nonatomic, retain) UIButton *b2;
@property (nonatomic, retain) UIButton *b3;
@property (nonatomic, retain) UIButton *b4;
@property (nonatomic, retain) UIButton *Buy;
@property (nonatomic, retain) UIButton *Sell;
@property (nonatomic, retain) UIButton *Sublet;
@property (nonatomic) NSUInteger postoption;

- (void)selectphoto;
- (void)setupTextViews;
- (void)setupNavAndToolbarViews;
- (void)selectlocation;
- (void)selectioncategory;
- (UIToolbar*)maketoolbar;
- (void)selectionform;
- (void)selectbubble;
- (void)handleSingleTapPic1;
- (void)handleSingleTapPic2;
- (void)handleSingleTapPic3;
- (void)handleSingleTapPic4;
- (void)setupPostButtons;

@end
