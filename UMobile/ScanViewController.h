//
//  ScanViewController.h
//  UMobile
//
//  Created by 陈 景云 on 14-11-8.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "RCViewController.h"
#import "ZBarSDK.h"
#import "SPGLViewController.h"
#import "XinZenDingDanViewController.h"
#import "XinZenHeaderViewController.h"

typedef enum{
    ScanView_Type_ScanProduct,
    ScanView_Type_SingleScan,
    ScanView_Type_MutileScan,
}ScanView_Type;

@interface ScanViewController : RCViewController<ZBarReaderViewDelegate,ZBarReaderDelegate>{
    ZBarReaderView *_readerView;
}
@property (retain, nonatomic) IBOutlet UIView *scanView;

@property (nonatomic,assign) NSMutableDictionary *headerInfo;
@property (nonatomic,assign) NSMutableArray *products;
@property (nonatomic) ScanView_Type scanType;
@property (nonatomic,retain) NSString *cusID;
@property (nonatomic,retain) NSString *stockID;

@end
