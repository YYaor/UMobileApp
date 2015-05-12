//
//  YWDJDetailViewController.m
//  UMobile
//
//  Created by yunyao on 15/5/7.
//  Copyright (c) 2015年  APPLE. All rights reserved.
//

#import "YWDJDetailViewController.h"
#import "YWDJMainDetailViewController.h"
#import "YWDJProcutDetailViewController.h"
#import "YeWuDanJuXinZenViewController.h"

@interface YWDJDetailViewController ()

@end

@implementation YWDJDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataCopyButton.layer.cornerRadius = 2;
    self.printButton.layer.cornerRadius = 2;
    self.deleteButton.layer.cornerRadius = 2;
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"SecondaryStoryboard" bundle:nil];
    
    YWDJProcutDetailViewController *productDetail = [storyBoard instantiateViewControllerWithIdentifier:@"YWDJProcutDetailViewController"];
    productDetail.parentVC = self;
    productDetail.array = self.array;
    
    YWDJMainDetailViewController *mainDetail = [storyBoard instantiateViewControllerWithIdentifier:@"YWDJMainDetailViewController"];
    mainDetail.parentVC = self;
    mainDetail.array = self.array;
    self.mutliView.titles = @[@"商品明细",@"主单据"];
    self.mutliView.viewControllers = @[productDetail,mainDetail];
    self.mutliView.selectIndex = 1;
    

}
- (IBAction)copyButtonClicked:(UIButton *)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    YeWuDanJuXinZenViewController *vc = [sb instantiateViewControllerWithIdentifier:@"YeWuDanJuXinZenViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)printButtonClicked:(UIButton *)sender {
    NSMutableString *stringToPrint = [[NSMutableString alloc] initWithString:@""];
    for(int i = 0;i<[self.array count];i++)
    {
        [stringToPrint appendFormat:@"%@",[self.array objectAtIndex:i]];
        
        [stringToPrint appendFormat:@"\n"];
        
    }
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
    
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.jobName = @"业务主单据";
    pic.printInfo = printInfo;
    
    UISimpleTextPrintFormatter *textFormatter = [[UISimpleTextPrintFormatter alloc]
                                                 initWithText:stringToPrint];
    textFormatter.startPage = 0;
    textFormatter.contentInsets = UIEdgeInsetsMake(72.0, 72.0, 72.0, 72.0); // 1 inch margins
    textFormatter.maximumContentWidth = 6 * 72.0;
    pic.printFormatter = textFormatter;
    pic.showsPageRange = YES;
    
    void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
    ^(UIPrintInteractionController *printController, BOOL completed, NSError *error)
    {
        if (!completed && error)
        {
            NSLog(@"Printing could not complete because of error: %@", error);
        }
    };
    
    [pic presentAnimated:YES completionHandler:completionHandler];
}
- (IBAction)deleteButtonClicked:(UIButton *)sender {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [_mutliView release];
    [_printButton release];
    [_dataCopyButton release];
    [_deleteButton release];
    [super dealloc];
}
@end
