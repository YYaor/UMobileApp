//
//  RCScrollView.h
//  mongoliaren
//
//  Created by  APPLE on 13/8/18.
//  Copyright (c) 2013年  APPLE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "UIImageView+Addition.h"

typedef enum{
    AlginLeft = 0,
    AlginCenter = 1,
    AlginRight = 2,
}PageControlAlgin;

@interface RCScrollView : UIView<UIScrollViewDelegate>{
    UIScrollView *scView;
    UIPageControl *pageController;
    CGFloat width;
    NSOperationQueue *queue;
    NSTimer *timer;
    
}

@property (nonatomic,retain) NSArray *links;
@property (nonatomic) PageControlAlgin pgAlgin;

@end
