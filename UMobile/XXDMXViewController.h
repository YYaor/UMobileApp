//
//  XXDMXViewController.h
//  UMobile
//
//  Created by Rid on 15/1/25.
//  Copyright (c) 2015年  APPLE. All rights reserved.
//

#import "RCViewController.h"
#import "RCTableView.h"

@interface XXDMXViewController : RCViewController<RCTableViewDelegate>{
    NSInteger page;
    BOOL bNoID;//找不到ID，即前一项传过来时没有订单类型，不能用31接口查询数据
}
@property (retain, nonatomic) IBOutlet RCTableView *tableView;


@property (nonatomic,retain) NSString *strID;
@property (nonatomic,retain) NSString *invNo;
@property (nonatomic,retain) NSString *strDate;
@property (nonatomic,retain) NSMutableArray *result;


@end
