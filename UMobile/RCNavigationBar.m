//
//  RCNavigationBar.m
//  PILOT
//
//  Created by  APPLE on 12/11/16.
//
//

#import "RCNavigationBar.h"

@implementation RCNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

        
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
//        [self setBackgroundImage:[UIImage imageNamed:@"nav_bar_bg_ios7"] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
//        //    [[UINavigationBar appearanceWhenContainedIn:[RCLeftNavigationController class],[RCNavigationController class], nil] setBackgroundImage:[UIImage imageNamed:@"nav_bar_bg_ios7"] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
//        //[[UINavigationBar appearance] setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
//        
//        
//        [self setBarTintColor:[UIColor whiteColor]];
//        [self setTintColor:[UIColor whiteColor]];
//        
//        
//        NSShadow *shadow = [[NSShadow alloc] init];
//        shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
//        shadow.shadowOffset = CGSizeMake(0, 1);
//        [self setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
//                                       [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
//                                       shadow, NSShadowAttributeName,
//                                       [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:17.0], NSFontAttributeName, nil]];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)drawRect:(CGRect)rect {
    UIImage *image = [UIImage imageNamed: @"nav_bar_bg_ios7"];
    [image drawInRect:CGRectMake(0, -20, self.frame.size.width, self.frame.size.height)];
}


@end
