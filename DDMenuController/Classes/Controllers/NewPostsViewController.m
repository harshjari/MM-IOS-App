//
//  NewPostsViewController.m
//
//  Created by Harsh Jariwala on 8/26/11.
//  Copyright 2011 None. All rights reserved.
//

#import "NewPostsViewController.h"

@implementation NewPostsViewController
@synthesize v0, v1, v2, v3, categories, mapView, buttonx, text1, text2, text3, Title, Price, Description, NewPostDetail, ht, lasttag, imagechangefor, b1, b2, b3, b4, Buy, Sell, Sublet, postoption;

- (void)dealloc
{
}

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
    
    imagechangefor = -1;
    
    text1 = NO;
    text2 = NO;
    text3 = NO;
    ht = 100;
    lasttag = 1;
    
    postoption = 0;
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"post_detail_background.png"]]];
    
    [self setupTextViews];
    [self setupNavAndToolbarViews];
    
    self.categories = [NSMutableArray arrayWithObjects:@"Appliances",@"Books",@"Car Pool",@"Clothings & Accessories",@"Electronics",@"Events",@"Free Stuff",@"Furniture",@"Housing",@"Looking for",@"Lost & Found",@"Musical Instruments",@"Other",@"Vehicles",@"Work & Listings",nil];
    
    
}

- (void)setupNavAndToolbarViews {
    
    UIToolbar *toolbar = [self maketoolbar];
    v0 = [[UIView alloc] initWithFrame:CGRectMake(0, 245, 320, 220)];
    v1 = [[UIView alloc] initWithFrame:CGRectMake(0, 245, 320, 220)];
    v2 = [[UIView alloc] initWithFrame:CGRectMake(0, 245, 320, 220)];
    v3 = [[UITableView alloc] initWithFrame:CGRectMake(0, 245, 320, 220)];
    
    [v3 setDelegate:(id<UITableViewDelegate>)self];
    [v3 setDataSource:(id<UITableViewDataSource>)self];
    
    [v1 setBackgroundColor: [UIColor whiteColor]];
    [v0 setBackgroundColor: [UIColor whiteColor]];
    [v3 setBackgroundColor: [UIColor whiteColor]];
    
    UIPickerView *myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 162)];
    myPickerView.delegate = self;
    myPickerView.showsSelectionIndicator = YES;
    
    [v2 addSubview:myPickerView];
    mapView = [[MKMapView alloc] initWithFrame:CGRectMake(20, 20, 280, 140)];
	[v1 addSubview:mapView];
    buttonx = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonx addTarget:self 
                action:@selector(location)
      forControlEvents:UIControlEventTouchDown];
    [buttonx setTitle:@"Turn on Location" forState:UIControlStateNormal];
    buttonx.frame = CGRectMake(40.0, 174.0, 240.0, 30.0);
    
    b1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [b1 setImage:[UIImage imageNamed:@"deletebutton.png"] forState:UIControlStateNormal];
    [b1 addTarget:self action:@selector(deleteimage:) forControlEvents:UIControlEventTouchDown];
    [b1 setTag:1];
    
    b2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [b2 setImage:[UIImage imageNamed:@"deletebutton.png"] forState:UIControlStateNormal];
    [b2 addTarget:self action:@selector(deleteimage:) forControlEvents:UIControlEventTouchDown];
    [b2 setTag:2];
    
    b3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [b3 setImage:[UIImage imageNamed:@"deletebutton.png"] forState:UIControlStateNormal];
    [b3 addTarget:self action:@selector(deleteimage:) forControlEvents:UIControlEventTouchDown];
    [b3 setTag:3];
    
    b4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [b4 setImage:[UIImage imageNamed:@"deletebutton.png"] forState:UIControlStateNormal];
    [b4 addTarget:self action:@selector(deleteimage:) forControlEvents:UIControlEventTouchDown];
    [b4 setTag:4];
    
    UIImageView *pic1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 140, 85)];
    [pic1 setBackgroundColor:[UIColor redColor]];
    pic1.tag = 1;
    [pic1 setUserInteractionEnabled:YES];
    UITapGestureRecognizer *singleFingerTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapPic1)];
    [pic1 addGestureRecognizer:singleFingerTap1];
    
    UIImageView *pic2 = [[UIImageView alloc] initWithFrame:CGRectMake(170, 20, 140, 85)];
    [pic2 setBackgroundColor:[UIColor redColor]];
    pic2.tag = 2;
    [pic2 setUserInteractionEnabled:YES];
    UITapGestureRecognizer *singleFingerTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapPic2)];
    [pic2 addGestureRecognizer:singleFingerTap2];
    
    UIImageView *pic3 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 125, 140, 85)];
    [pic3 setBackgroundColor:[UIColor redColor]];
    pic3.tag = 3;
    [pic3 setUserInteractionEnabled:YES];
    UITapGestureRecognizer *singleFingerTap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapPic3)];
    [pic3 addGestureRecognizer:singleFingerTap3];
    
    UIImageView *pic4 = [[UIImageView alloc] initWithFrame:CGRectMake(170, 125, 140, 85)];
    [pic4 setBackgroundColor:[UIColor redColor]];
    pic4.tag = 4;
    [pic4 setUserInteractionEnabled:YES];
    UITapGestureRecognizer *singleFingerTap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapPic4)];
    [pic4 addGestureRecognizer:singleFingerTap4];
    
    [b1 setShowsTouchWhenHighlighted:YES];
    [b2 setShowsTouchWhenHighlighted:YES];
    [b3 setShowsTouchWhenHighlighted:YES];
    [b4 setShowsTouchWhenHighlighted:YES];
    
    b1.frame = CGRectMake(135, 5, 30, 30);
    b2.frame = CGRectMake(295, 5, 30, 30);
    b3.frame = CGRectMake(135, 110, 30, 30);
    b4.frame = CGRectMake(295, 110, 30, 30);
    
    [v0 addSubview: pic1];
    [v0 addSubview: pic2];
    [v0 addSubview: pic3];
    [v0 addSubview: pic4];
    
    UINavigationItem *newitem = [[UINavigationItem alloc] initWithTitle:@"New Post"];
    UIButton *cancelbutt = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [cancelbutt setBackgroundImage:[UIImage imageNamed:@"redbar.png"] forState:UIControlStateNormal];
    [cancelbutt addTarget:self action:@selector(dismissModalViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    [cancelbutt setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelbutt.layer setBorderColor:[[UIColor colorWithWhite:0.1 alpha:0.4] CGColor]];
    [cancelbutt.layer setBorderWidth:1.0];
    [cancelbutt.layer setCornerRadius:5.0];
    [cancelbutt.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:11]];
    newitem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelbutt];
    
    UIButton *postButt = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [postButt setBackgroundImage:[UIImage imageNamed:@"redbar.png"] forState:UIControlStateNormal];
    [postButt addTarget:self action:@selector(dismissModalViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    [postButt setTitle:@"Post" forState:UIControlStateNormal];
    [postButt.layer setBorderColor:[[UIColor colorWithWhite:0.1 alpha:0.4] CGColor]];
    [postButt.layer setBorderWidth:1.0];
    [postButt.layer setCornerRadius:5.0];
    [postButt.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:11]];
    newitem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:postButt];
    
    [v1 addSubview:buttonx];
    
    UINavigationBar *navbar = [[UINavigationBar alloc] initWithFrame: CGRectMake(0.0, 0.0, 320.0, 44.0)];
    [navbar setBackgroundImage:[UIImage imageNamed:@"redbar.png"] forBarMetrics:UIBarMetricsDefault];
    [navbar pushNavigationItem:newitem animated:YES];
    
    [self.view addSubview:NewPostDetail];
    [self.view addSubview:navbar];
    [self.view addSubview:toolbar];
    [self.view addSubview:v0];
    [self.view addSubview:v1];
    [self.view addSubview:v2];
    [self.view addSubview:v3];

}

- (void)setupPostButtons {
    Buy = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 106, 44)];
    Sell = [[UIButton alloc] initWithFrame:CGRectMake(106, 0, 108, 44)];
    Sublet = [[UIButton alloc] initWithFrame:CGRectMake(214, 0, 106, 44)];
    Buy.tag = 0;
    Sell.tag = 1;
    Sublet.tag = 2;
    
    [Buy setTitle:@"HELLO" forState:UIControlStateNormal];
    [Buy addTarget:self action:@selector(typepressed:) forControlEvents:UIControlEventTouchDown];
    [Buy setUserInteractionEnabled:YES];
    [Sell setTitle:@"HELLO" forState:UIControlStateNormal];
    [Sell addTarget:self action:@selector(typepressed:) forControlEvents:UIControlEventTouchDown];
    [Sell setUserInteractionEnabled:YES];
    [Sublet setTitle:@"HELLO" forState:UIControlStateNormal];
    [Sublet addTarget:self action:@selector(typepressed:) forControlEvents:UIControlEventTouchDown];
    [Sublet setUserInteractionEnabled:YES];
    
    [NewPostDetail addSubview:Buy];
    [NewPostDetail addSubview:Sell];
    [NewPostDetail addSubview:Sublet];
    
}

- (void)typepressed:(UIButton*)butt {
    [butt setBackgroundColor:[UIColor blackColor]];
    [butt setEnabled:NO];
    
    if(postoption == 0) {
        [Buy setBackgroundColor:[UIColor clearColor]];
        [Buy setEnabled:YES];
    }
    else if(postoption == 1) {
        [Sell setBackgroundColor:[UIColor clearColor]];
        [Sell setEnabled:YES];
    }
    else if(postoption == 2) {
        [Sublet setBackgroundColor:[UIColor clearColor]];
        [Sublet setEnabled:YES];
    }
    
    postoption = butt.tag;
    
}

- (void)setupTextViews {
    NewPostDetail = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 320, 160)];
    [NewPostDetail setScrollEnabled:YES];
    [NewPostDetail setShowsVerticalScrollIndicator:YES];
    [NewPostDetail setBounces:NO];
    [NewPostDetail setContentSize:CGSizeMake(320, 206)];
    
    Title = [[UITextView alloc] initWithFrame:CGRectMake(0, 44, 220, 63)];
    Price = [[UITextView alloc] initWithFrame:CGRectMake(219, 44, 101, 63)];
    Description = [[UITextView alloc] initWithFrame:CGRectMake(0, 108, 320, 98)];
    
    [Title setBackgroundColor:[UIColor clearColor]];
    [Price setBackgroundColor:[UIColor clearColor]];
    [Description setBackgroundColor:[UIColor clearColor]];
    
    [Price setTextColor:[UIColor redColor]];
    [Description setTextColor:[UIColor lightGrayColor]];
    
    [Title setDelegate:self];
    [Price setDelegate:self];
    [Description setDelegate:self];
    
    [Title setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    [Price setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    [Description setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    
    [Title setAutocorrectionType:UITextAutocorrectionTypeNo];
    [Price setAutocorrectionType:UITextAutocorrectionTypeNo];
    [Description setAutocorrectionType:UITextAutocorrectionTypeNo];
    
    [Title.layer setBorderWidth:1.0];
    [Price.layer setBorderWidth:1.0];
    
    [Title.layer setBorderColor:[[UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1.0] CGColor]];
    [Price.layer setBorderColor:[[UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1.0] CGColor]];
    [Description.layer setBorderColor:[[UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1.0] CGColor]];
    
    [Title setTag:1];
    [Price setTag:2];
    [Description setTag:3];
    
    [Title setText:@"Title"];
    [Price setText:@"$ Price"];
    [Description setText:@"Description"];
    
    [NewPostDetail addSubview:Title];
    [NewPostDetail addSubview:Price];
    [NewPostDetail addSubview:Description];
    //[Title becomeFirstResponder];
    
    CGFloat topCorrect = ([Title bounds].size.height - [Title contentSize].height * [Title zoomScale])/2.0;
    topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
    Title.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
    
    topCorrect = ([Price bounds].size.height - [Price contentSize].height * [Price zoomScale])/2.0;
    topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
    Price.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
    
    [self setupPostButtons];
}

- (void)handleSingleTapPic1 {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Show Photo Library", @"Show Camera", nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    actionSheet.tag = 1;
    [actionSheet showInView:self.view];
}
- (void)handleSingleTapPic2 {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Show Photo Library", @"Show Camera", nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    actionSheet.tag = 2;
    [actionSheet showInView:self.view];
}
- (void)handleSingleTapPic3 {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Show Photo Library", @"Show Camera", nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    actionSheet.tag = 3;
    [actionSheet showInView:self.view];
}
- (void)handleSingleTapPic4 {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Show Photo Library", @"Show Camera", nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    actionSheet.tag = 4;
    [actionSheet showInView:self.view];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (UIToolbar *)maketoolbar
{
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 205, 320, 40)];
    //toolbar.barStyle = UIBarStyleBlackTranslucent;
    [toolbar setBackgroundImage:[UIImage imageNamed:@"toolbar.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    
    UIBarButtonItem *barb2 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"so2.png"] style:UIBarButtonItemStylePlain target:self action:@selector(selectioncategory)];
    
    UIBarButtonItem *barb3 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"so1.png"] style:UIBarButtonItemStylePlain target:self action:@selector(selectlocation)];
    
    UIBarButtonItem *barb4 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"camera-icon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(selectphoto)];
    
     UIBarButtonItem *barb5 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"so1.png"] style:UIBarButtonItemStylePlain target:self action:@selector(selectbubble)];
    
    float Insets = 2.0f;
    barb2.imageInsets = UIEdgeInsetsMake(Insets, 0.0f, -Insets, 0.0f);
    barb3.imageInsets = UIEdgeInsetsMake(Insets, 0.0f, -Insets, 0.0f);
    barb4.imageInsets = UIEdgeInsetsMake(Insets, 0.0f, -Insets, 0.0f);
    
    UIBarButtonItem *flexItem1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *flexItem2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *flexItem3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *flexItem4 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *flexItem5 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [toolbar setItems:[NSArray arrayWithObjects: flexItem1, barb2, flexItem2, barb3, flexItem3, barb4, flexItem4, barb5, flexItem5, nil]];
    
    return toolbar;

}

- (void)selectbubble
{
    [Price resignFirstResponder];
    [Title resignFirstResponder];
    [Description resignFirstResponder];
    [self.view bringSubviewToFront:v3];
}

- (void)selectionform
{
    if(lasttag==1)
    {
        [Title becomeFirstResponder];
    }
    else if(lasttag == 2)
    {
        [Price becomeFirstResponder];
    }
    else if(lasttag == 3)
    {
        [Description becomeFirstResponder];
    }
}
- (void)location
{
    mapView.showsUserLocation = !(mapView.showsUserLocation);
    if(mapView.showsUserLocation)
        [buttonx setTitle:@"Turn off Location" forState:UIControlStateNormal];
    else
        [buttonx setTitle:@"Turn on Location" forState:UIControlStateNormal];
}

- (void)selectphoto
{
    [Price resignFirstResponder];
    [Title resignFirstResponder];
    [Description resignFirstResponder];
    [self.view bringSubviewToFront:v0];
}

- (void)selectlocation
{
    [Price resignFirstResponder];
    [Title resignFirstResponder];
    [Description resignFirstResponder];
    [self.view bringSubviewToFront:v1];
}

- (void)selectioncategory
{
    [Price resignFirstResponder];
    [Title resignFirstResponder];
    [Description resignFirstResponder];
    [self.view bringSubviewToFront:v2];
}

- (void) addimage:(UIImage *)image
{   
    for(UIImageView *x in v0.subviews)
    {
        if(x.tag == imagechangefor && [x class]==[UIImageView class])
        {
            BOOL doaddcancel = YES;
            if(x.image!=nil)
            {
                doaddcancel = NO;
            }
            [x setImage:image];
            if(doaddcancel) {
                if(imagechangefor == 1) {
                    [v0 addSubview:b1];
                }
                else if(imagechangefor == 2) {
                    [v0 addSubview:b2];
                }
                else if(imagechangefor == 3) {
                    [v0 addSubview:b3];
                }
                else if(imagechangefor == 4) {
                    [v0 addSubview:b4];
                }
            }
            break;
        }
    }
}

- (void) deleteimage:(UIButton *)sender
{
    for(UIImageView *x in v0.subviews)
    {
        if(sender.tag == x.tag && [x class]==[UIImageView class])
        {
            x.image = nil;
            [sender removeFromSuperview];
            break;
        }
    }
}

- (void)loadimage
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentModalViewController:picker animated:YES];
    }
}

- (void)loadcamera
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.allowsEditing = YES;
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentModalViewController:picker animated:YES];
    }
}

#pragma mark - imagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary*) dict
{
    UIImage *x= [dict valueForKey:UIImagePickerControllerEditedImage];
    NSData *dat = UIImageJPEGRepresentation(x, 1);
    UIImage *y = [UIImage imageWithData:dat];
    [self addimage:y];
    [picker dismissModalViewControllerAnimated:YES];
    NSLog(@"%i", dat.length);
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
    CGFloat topCorrect = ([Title bounds].size.height - [Title contentSize].height * [Title zoomScale])/2.0;
    topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
    Title.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
    
    topCorrect = ([Price bounds].size.height - [Price contentSize].height * [Price zoomScale])/2.0;
    topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
    Price.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
}

#pragma mark - pickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    // Handle the selection
    NSLog(@"row - %d, component - %d", row, component);
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [categories count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [categories objectAtIndex:row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 290;
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)aView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if((aView.tag!=3)&&([text length]>1||[text isEqualToString:@"\n"]))
        return NO;
    if(aView.tag == 1) {
        NSUInteger newLength = [aView.text length] + [text length] - range.length;
        return (newLength > 74) ? NO : YES;
    }
    else if(aView.tag == 2) {
        
        if (range.location<2){
            aView.selectedRange = NSMakeRange(2, 0);
            return NO;
        }
        
        NSUInteger newLength = [aView.text length] + [text length] - range.length;
        return ((newLength > 8)||(newLength < 2)) ? NO : YES;
    }
    else if(aView.tag == 3) {
        
        NSUInteger newLength = [aView.text length] + [text length] - range.length;
        return (newLength > 400) ? NO : YES;
    }
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if(textView.tag == 1) {
        if(text1 == NO) {
            [textView setText:@""];
            text1 = YES;
        }
    }
    else if(textView.tag == 2) {
        if(text2 == NO) {
            [textView setText:@"$ "];
            text2 = YES;
        }
    }
    else if(textView.tag == 3) {
        if(text3 == NO) {
            [textView setText:@""];
            [textView setTextColor:[UIColor darkGrayColor]];
            text3 = YES;
        }
    }
    lasttag = textView.tag;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.tag == 1) {
        if(textView.text.length==0) {
            [textView setText:@"Title"];
            text1 = NO;
        }
    }
    else if(textView.tag == 2) {
        if(textView.text.length<3) {
            [textView setText:@"$ Price"];
            text2 = NO;
        }
    }
    else if(textView.tag == 3) {
        if(textView.text.length==0) {
            [textView setText:@"Description"];
            [textView setTextColor:[UIColor lightGrayColor]];
            text3 = NO;
        }
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if(textView.tag == 3)
    {
        if(textView.contentSize.height > ht && textView.contentSize.height>100) {
            ht = textView.contentSize.height;
            [NewPostDetail setContentSize:CGSizeMake(320, 108+ht)];
            [textView setFrame:CGRectMake(0, 108, 320, ht)];
            CGPoint bottomOffset = CGPointMake(0, NewPostDetail.contentSize.height - 10 - NewPostDetail.frame.size.height);
            [NewPostDetail setContentOffset:bottomOffset animated:YES];
        }
        else if(textView.contentSize.height < ht && textView.contentSize.height<100){
            ht = 100;
            [NewPostDetail setContentSize:CGSizeMake(320, 212)];
            [textView setFrame:CGRectMake(0, 108, 320, ht)];
            CGPoint bottomOffset = CGPointMake(0, NewPostDetail.contentSize.height - NewPostDetail.frame.size.height);
            [NewPostDetail setContentOffset:bottomOffset animated:YES];
        }
        
        return;
    } 
    
    CGFloat topCorrect = ([textView bounds].size.height - [textView contentSize].height * [textView zoomScale])/2.0;
    topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
    textView.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
    
    if(textView.tag == 2) {
        if(textView.text.length<3) {
            [textView setText:@"$ "];
        }
    }
}

#pragma UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 76;

}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"BubbleIdent";
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
    //[title setBackgroundColor:[UIColor blueColor]];
    UILabel *bubble = [[UILabel alloc] initWithFrame:CGRectMake(88, 33, 160, 16)];
    
    [title setText:[[NSString alloc] initWithString:@"Mint Like new thingy"]];
    //else
    //    [title setText:[[NSString alloc] initWithString:@"Mint Like thingy"]];
    [title setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
    //title.font
    [bubble setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [bubble setText:@"BUBBLY BUBBLES"];
    [bubble setTextColor:[UIColor grayColor]];
    
    UIImageView *i1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Refresh.png"]];
    [i1 setFrame:CGRectMake(260, 15, 44, 44)];
    
    [cell addSubview:i];
    [cell addSubview:i1];
    [cell addSubview:title];
    [cell addSubview:bubble];
    
    return cell;

}

#pragma mark UIScrollViewDelegate
-(void) scrollViewDidScroll:(UIScrollView *)sc {
    CGPoint x = sc.contentOffset;
    NSLog(@"HELLO!");
    if(x.y < 44)
        NSLog(@"haah!");
}

#pragma actionsheetdelegate

-(void) actionSheet:(UIActionSheet*)action clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    imagechangefor = action.tag;
    if(buttonIndex == 0)
    {
        [self loadimage];
    }
    else if(buttonIndex == 1)
    {
        [self loadcamera];
    }
    
}

@end
