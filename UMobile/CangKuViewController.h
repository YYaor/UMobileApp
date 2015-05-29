//
//  CangKuViewController.h
//  UMobile
//
//  Created by  APPLE on 2014/9/23.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "RCViewController.h"

@protocol cangkuControllerDelegate <NSObject>

-(void)FHCKSelectedWithckId:(NSInteger)ckId ckName:(NSString *) ckName;
-(void)DHCKSelectedWihtckId:(NSInteger)ckId ckName:(NSString *) ckName;

@end

typedef enum:NSInteger{
    ChooseCkType_FHCK = 1,
    ChooseCkType_DHCK = 2,
}ChooseCkType;

@interface CangKuViewController : RCViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>


@property (nonatomic,assign) NSMutableArray *info;
@property (nonatomic,retain) NSArray *result;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,retain) NSString *title;
@property (nonatomic,retain) NSString *link;
@property (nonatomic) NSUInteger showIndex;

@property (nonatomic , assign) ChooseCkType chooseType;
@property (nonatomic , assign) id<cangkuControllerDelegate> delegate;

@end
