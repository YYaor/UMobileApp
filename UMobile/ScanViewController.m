//
//  ScanViewController.m
//  UMobile
//
//  Created by 陈 景云 on 14-11-8.
//  Copyright (c) 2014年  APPLE. All rights reserved.
//

#import "ScanViewController.h"

@interface ScanViewController ()

@end

@implementation ScanViewController

@synthesize scanType;

- (void)viewDidLoad {
    [super viewDidLoad];
    _readerView = [[ZBarReaderView alloc]init];
    _readerView.frame = self.view.frame;// CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 44);
    _readerView.readerDelegate = self;
    //关闭闪光灯
    _readerView.torchMode = 0;
    //扫描区域
    CGRect scanMaskRect = CGRectMake(0, 0, self.scanView.frame.size.width, self.scanView.frame.size.height);
    
    //处理模拟器
    if (TARGET_IPHONE_SIMULATOR) {
        ZBarCameraSimulator *cameraSimulator
        = [[ZBarCameraSimulator alloc]initWithViewController:self];
        cameraSimulator.readerView = _readerView;
    }
    [self.view addSubview:_readerView];
    //扫描区域计算
    _readerView.scanCrop = [self getScanCrop:scanMaskRect readerViewBounds:self.scanView.bounds];
    
    
    [self setLines];
    [self setAnimationLine];
    
    self.cusID = @"0";
    self.stockID = @"0";
    
    [self GetHeaderInfo];

//    [_readerView start];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [_readerView start];
}

-(void)setLines{
    CGRect rect = self.scanView.frame;
    CGFloat lon = 20.0;
    CGFloat wid = 2;
    UIView *view1 = [[[UIView alloc]initWithFrame:CGRectMake(rect.origin.x, rect.origin.y,lon,wid)]autorelease];
    UIView *view2 = [[[UIView alloc]initWithFrame:CGRectMake(rect.origin.x, rect.origin.y,wid,lon)]autorelease];
    
    UIView *view3 = [[[UIView alloc]initWithFrame:CGRectMake(rect.origin.x + rect.size.width - lon, rect.origin.y,lon,wid)]autorelease];
    UIView *view4 = [[[UIView alloc]initWithFrame:CGRectMake(rect.origin.x + rect.size.width, rect.origin.y,wid,lon)]autorelease];
    
    UIView *view5 = [[[UIView alloc]initWithFrame:CGRectMake(rect.origin.x, rect.origin.y + rect.size.height,lon,wid)]autorelease];
    UIView *view6 = [[[UIView alloc]initWithFrame:CGRectMake(rect.origin.x, rect.origin.y + rect.size.height - lon,wid,lon)]autorelease];
    
    UIView *view7 = [[[UIView alloc]initWithFrame:CGRectMake(rect.origin.x + rect.size.width - lon, rect.origin.y + rect.size.height,lon,wid)]autorelease];
    UIView *view8 = [[[UIView alloc]initWithFrame:CGRectMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height - lon,wid,lon)]autorelease];
    
    view1.backgroundColor = [UIColor redColor];
    view2.backgroundColor = [UIColor redColor];
    view3.backgroundColor = [UIColor redColor];
    view4.backgroundColor = [UIColor redColor];
    view5.backgroundColor = [UIColor redColor];
    view6.backgroundColor = [UIColor redColor];
    view7.backgroundColor = [UIColor redColor];
    view8.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:view1];
    [self.view addSubview:view2];
    [self.view addSubview:view3];
    [self.view addSubview:view4];
    [self.view addSubview:view5];
    [self.view addSubview:view6];
    [self.view addSubview:view7];
    [self.view addSubview:view8];
    

}

-(void)setAnimationLine{
    CGRect rect = self.scanView.frame;
    UIView *view =  [[[UIView alloc]initWithFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, 2)] autorelease];
    view.tag = 9999;
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    
    [view.layer addAnimation:[self moveAnimation] forKey:@"move-layer"];
}

-(CABasicAnimation *)moveAnimation{
    
    CGRect rect = self.scanView.frame;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    
    animation.duration = 2.5; // 动画持续时间
    animation.repeatCount = 9999; // 不重复
    animation.beginTime = CACurrentMediaTime() ; // 2秒后执行
    animation.autoreverses = YES; // 结束后执行逆动画
    
    // 动画先加速后减速
    animation.timingFunction =
    [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
    
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, rect.origin.y)]; // 起始点
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, rect.origin.y + rect.size.height)]; // 终了点
    return animation;
}

-(void)setAnimationLineMove:(BOOL)b{
    UIView *view = [self.view viewWithTag:9999];
    if (b) {
        [view.layer addAnimation:[self moveAnimation] forKey:@"move-layer"];
    }else{
        [view.layer removeAnimationForKey:@"move-layer"];
    }
}



-(CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds
{
    CGFloat x,y,width,height;
    
    x = rect.origin.x / readerViewBounds.size.width;
    y = rect.origin.y / readerViewBounds.size.height;
    width = rect.size.width / readerViewBounds.size.width;
    height = rect.size.height / readerViewBounds.size.height;
    
    return CGRectMake(x, y, width, height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image{

    for (ZBarSymbol *symbol in symbols) {
        
        if (self.parentVC){
            if (self.scanType == ScanView_Type_ScanProduct) {
                SPGLViewController *vc = (SPGLViewController *)self.parentVC;
                vc.searchCode = symbol.data;
                [vc loadData];
                [self dismiss];
            }else if(self.scanType ==  ScanView_Type_SingleScan){
//                if ([self.parentVC respondsToSelector:@selector(searchProductWithBarcode:)]) {
//                    [self.parentVC performSelector:@selector(searchProductWithBarcode:) withObject:symbol.data];
//                }
//                [self dismiss];
//                NSString *param = [NSString stringWithFormat:@"'%@',0,0,0,0,0,0,1,1",[symbol.data stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//                NSString *link =  [self GetLinkWithFunction:60 andParam:param];
                
                NSString *param = [NSString stringWithFormat:@"'%@',%@,%@,0,0,%@",[symbol.data stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],self.cusID,self.stockID,[self GetUserID]];
                NSString *link =  [self GetLinkWithFunction:80 andParam:param];
                __block ScanViewController *tempSelf = self;
//                __block ZBarReaderView *rview = readerView;
                [self StartQuery:link completeBlock:^(id obj) {
                    NSArray *rs =  [[obj objectFromJSONString] objectForKey:@"D_Data"];
                    if ([rs count] > 0) {
                        [tempSelf.products addObject:[self setProduct:[rs objectAtIndex:0]]];
                        [tempSelf.parentVC loadData];
                        [tempSelf dismiss];
                    }else{
                        [tempSelf.view makeToast:@"当前没有可显示数据"];
                    }
                    
                } lock:YES];
            }else{
//                NSString *param = [NSString stringWithFormat:@"'%@',0,0,0,0,0,0,1,1",[symbol.data stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//                NSString *link =  [self GetLinkWithFunction:60 andParam:param];
                NSString *param = [NSString stringWithFormat:@"'%@',%@,%@,0,0,%@",[symbol.data stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],self.cusID,self.stockID,[self GetUserID]];
                NSString *link =  [self GetLinkWithFunction:80 andParam:param];
                __block ScanViewController *tempSelf = self;
                __block ZBarReaderView *rview = readerView;
                [self StartQuery:link completeBlock:^(id obj) {
                    NSArray *rs =  [[obj objectFromJSONString] objectForKey:@"D_Data"];
                    if ([rs count] > 0) {
                        [tempSelf.products addObject:[self setProduct:[rs objectAtIndex:0]]];
                        [tempSelf.parentVC loadData];
                        [rview start];
                        [tempSelf setAnimationLineMove:YES];
                    }else{
                        [tempSelf.view makeToast:@"当前没有可显示数据"];
                    }
                    
                } lock:YES];
            }

        }else{
            SPGLViewController *vc = (SPGLViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"SPGLViewController"];
            vc.searchCode = symbol.data;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        break;
    }
    
    [self setAnimationLineMove:NO];
    [readerView stop];
}

-(NSMutableDictionary *)GetHeaderInfo{
    XinZenDingDanViewController *vc = (XinZenDingDanViewController *)self.parentVC.parentVC;
    XinZenHeaderViewController *vh = [vc.mutileView.viewControllers firstObject];
    if (vh) {
        
        if ([self.setting intForKey:@"ISBS"] == 1) {
            if ([(NSArray *)[vh.allInfo objectForKey:@"3"] count] > 0) {
                self.cusID = [[vh.allInfo objectForKey:@"3"] objectAtIndex:0];
            }
            
            if ([(NSArray *)[vh.allInfo objectForKey:@"6"] count] > 0) {
                self.stockID = [[vh.allInfo objectForKey:@"6"] objectAtIndex:0];
            }
        }else{
            if ([(NSArray *)[vh.allInfo objectForKey:@"5"] count] > 0) {
                self.cusID = [[vh.allInfo objectForKey:@"5"] objectAtIndex:0];
            }
            
            if ([(NSArray *)[vh.allInfo objectForKey:@"7"] count] > 0) {
                self.stockID = [[vh.allInfo objectForKey:@"7"] objectAtIndex:0];
            }
        }
        
        return vh.allInfo;
    }


    return nil;
}

-(NSMutableArray *)setProduct:(NSArray *)arr{
    NSMutableDictionary *P = [NSMutableDictionary dictionary];
    
    NSArray *keys = nil;
    if ([self.setting intForKey:@"ISBS"] == 0) {
        keys = @[@"商品ID",@"可用数量",@"库存数量",@"商品编码",
                 @"名称",@"规格",@"型号",@"最近进价",@"单位ID",
                 @"单位名称",@"儿子数",@"条码",@"预设入库售价",
                 @"预设出库售价",@"预设入库售价比率",@"预设出库售价比率"];
    }else{
        keys = @[@"rownum1",@"商品ID",@"可用数量",@"库存数量",@"商品编码",
                @"名称",@"规格",@"型号",@"最近进价",@"单位ID",
                @"单位名称",@"儿子数",@"条码",@"预设入库售价",
                @"预设出库售价",@"预设入库售价比率",@"预设出库售价比率"];
    }
    
    for (int i = 0 ; i < [keys count] ; i ++){
        [P setObject:[arr objectAtIndex:i] forKey:[keys objectAtIndex:i]];
    }
    
    NSString *type = @"";
    //判断 是否选择了 往来单位
    BOOL bSelectCompany = NO;
    if([self.setting intForKey:@"ISBS"] == 1){   //区分BS帐套
        bSelectCompany = [[[self GetHeaderInfo] objectForKey:@"4"] firstObject] != nil;
    }else{
        bSelectCompany = [[[self GetHeaderInfo] objectForKey:@"5"] firstObject] != nil;
    }
    
    if (bSelectCompany) {//选择了往来单位才取 出库或入库价
        if ([[[[self GetHeaderInfo] objectForKey:@"0"] firstObject] integerValue] == 5) {
            type = @"预设入库售价";
        }else{
            type = @"预设出库售价";
        }
    }
    
    NSString *price = [P strForKey:type];//未选择往来 单位时 type =@"",则没有价钱
    
    
    [P setObject:@"" forKey:@"明细ID"];
    [P setObject:@"" forKey:@"单据ID"];
    [P setObject:@"" forKey:@"仓库ID"];
    //    [P setObject:[arr objectAtIndex:0] forKey:@"商品ID"];
    //    [P setObject:[arr objectAtIndex:8] forKey:@"商品单位ID"];
    [P setObject:@"" forKey:@"批号"];
    [P setObject:@"" forKey:@"出厂日期"];
    [P setObject:@"1" forKey:@"数量"];
    [P setObject:price forKey:@"单价"];
    [P setObject:price forKey:@"金额"];
    [P setObject:@"1" forKey:@"单位换算率"];
    [P setObject:@"1" forKey:@"基本单位数量"];
    
    [P setObject:@"100" forKey:@"折扣"];
    [P setObject:price forKey:@"折后单价"];
    [P setObject:price forKey:@"折后金额"];
    [P setObject:@"0" forKey:@"折扣金额"];
    
    [P setObject:@"0" forKey:@"税率"];
    [P setObject:price forKey:@"含税单价"];
    
    [P setObject:price forKey:@"含税金额"];
    [P setObject:@"0" forKey:@"税额"];
    [P setObject:@"0" forKey:@"赠品"];
    [P setObject:@"" forKey:@"备注"];
    
    
    //    [np addObject:@"1"];//数量 17
    //    [np addObject:@"100"];//折扣 18
    //    [np addObject:[arr objectAtIndex:16]]; 19
    //    [np addObject:[arr objectAtIndex:16]]; 20
    //    [np addObject:@""]; 21
    //    [np addObject:@"0"];//赠品 22
    return P;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    self.stockID = nil;
    self.cusID = nil;
    [_readerView release];
    [_scanView release];
    [super dealloc];
}
@end
