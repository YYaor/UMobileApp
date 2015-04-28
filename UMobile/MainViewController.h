//
//  MainViewController.h
//  UMobile
//
//  Created by  APPLE on 2014/9/2.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "RCViewController.h"
#import "FRDLivelyButton.h"
#import "KxMenu.h"
#import "Toast+UIView.h"

@interface MainViewController : RCViewController<UIScrollViewDelegate>{

}

@property (nonatomic,retain) NSArray *buttons;
@property (retain, nonatomic) KxMenu *menu;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)addClick:(id)sender;

@end
