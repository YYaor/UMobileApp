//
//  AccountViewController.h
//  UMobile
//
//  Created by Rid on 15/1/14.
//  Copyright (c) 2015年  APPLE. All rights reserved.
//

#import "RCViewController.h"

@protocol accountViewControllerDelegate <NSObject>

-(void) FKaccountChoosedId:(NSInteger) accountId accountName:(NSString *) accountName;
-(void) CKaccountChoosedId:(NSInteger) accountId accountName:(NSString *) accountName;

@end

typedef enum : NSInteger{
    ChooseAccountType_CKAccount = 1,
    ChooseAccountType_FKAccount = 2,
}ChooseAccountType;

@interface AccountViewController : RCViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>


@property (nonatomic,assign) NSMutableArray *info;
@property (nonatomic,retain) NSArray *result;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,retain) NSString *title;
@property (nonatomic,retain) NSString *link;
@property (nonatomic) NSUInteger showIndex;

@property(nonatomic , assign) ChooseAccountType chooseType;
@property(nonatomic , assign) id<accountViewControllerDelegate> delegate;

@end
