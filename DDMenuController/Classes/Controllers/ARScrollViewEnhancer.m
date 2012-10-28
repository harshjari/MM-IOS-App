//
//  ARScrollViewEnhancer.m
//

#import "ARScrollViewEnhancer.h"

@implementation ARScrollViewEnhancer

@synthesize scrollView;

#pragma mark -
#pragma mark Construction & Destruction

- (void)dealloc {
}

- (void)layoutSubviews {
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 0, 280, 280)];

    [self addSubview:scrollView];
    
    NSLog(@"SUP");
    [scrollView setBackgroundColor:[UIColor clearColor]];
	scrollView.clipsToBounds = NO;
	scrollView.pagingEnabled = YES;
	scrollView.showsHorizontalScrollIndicator = NO;
	
	CGFloat contentOffset = 0.0f;
    
	for (int i = 0;i<4;i++) {
		CGRect imageViewFrame = CGRectMake(contentOffset, 0.0f, scrollView.frame.size.width, scrollView.frame.size.height);
        CGRect imageViewFrameOntop = CGRectMake(17, 15, scrollView.frame.size.width-34, scrollView.frame.size.height-38);
        
        UIImageView *Ontop = [[UIImageView alloc] initWithFrame:imageViewFrameOntop];
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageViewFrame];
        
        [Ontop setImage:[UIImage imageNamed:@"temp3.png"]];
		Ontop.contentMode = UIViewContentModeScaleAspectFit;
		[imageView setImage:[UIImage imageNamed:@"image_frame.png"]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [imageView addSubview:Ontop];
		[scrollView addSubview:imageView];
        
		contentOffset += imageView.frame.size.width;
		scrollView.contentSize = CGSizeMake(contentOffset, scrollView.frame.size.height);
	}
    
}


#pragma mark -
#pragma mark UIView methods

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
	if ([self pointInside:point withEvent:event]) {
		return scrollView;
	}
	return nil;
}

@end
