//
//  RCScrollView.m
//  mongoliaren
//
//  Created by  APPLE on 13/8/18.
//  Copyright (c) 2013年  APPLE. All rights reserved.
//

#import "RCScrollView.h"

#define Margin 20
#define PGC_Height 20

@implementation RCScrollView

@synthesize links = _links;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self= [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor clearColor];
        width = self.frame.size.width;
        scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)] ;
        scView.backgroundColor = [UIColor clearColor];
        scView.delegate = self;
        scView.pagingEnabled = YES;
        scView.showsHorizontalScrollIndicator = NO;
        scView.showsVerticalScrollIndicator = NO;
        pageController = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.frame.size.height - PGC_Height, self.frame.size.width, PGC_Height)];
        
        [self addSubview:scView];
        [self addSubview:pageController];
        
//        queue = [[NSOperationQueue alloc]init];
//        [queue setMaxConcurrentOperationCount:3];
        
        self.pgAlgin = AlginRight;

//
        //
    }
    return self;
}

-(void)autoScrollImage{
//    NSLog(@"scrolling image");
    CGRect rect = CGRectZero;
    rect.size = self.frame.size;
    if ( pageController.currentPage < pageController.numberOfPages -1)
        rect.origin = CGPointMake(rect.size.width * (pageController.currentPage + 1),0);
    else
        rect.origin = CGPointMake(0, 0);
    [scView scrollRectToVisible:rect animated:YES];
}

-(void)SetImage{
    for (int i = 0; i<[_links count]; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(width * i, 0, width, self.frame.size.height)] ;
        [scView addSubview:imageView];
        NSString *link = [_links objectAtIndex:i];
        
        [imageView setImageWithURL:[NSURL URLWithString:link] placeholderImage:[UIImage imageNamed:@"def"]];
        [imageView addDetailShow];
//        NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:link]];
//        
//        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response,NSData *data,NSError *connetionError){
//            UIImage *image = [UIImage imageWithData:data];
//            [imageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:YES];
//        }];
    }
    
    [self performSelectorOnMainThread:@selector(runTimer) withObject:nil waitUntilDone:YES];
}

-(void)runTimer{
    timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(autoScrollImage) userInfo:nil repeats:YES];
}

-(void)SetPageControlAlgin{
    if (self.pgAlgin != AlginCenter) {
        CGRect rect = [pageController frame];
        CGSize size = [pageController sizeForNumberOfPages:[_links count]];
        if (self.pgAlgin == AlginLeft) {
            pageController.frame = CGRectMake(rect.origin.x + Margin, rect.origin.y, size.width, PGC_Height);
        }else{
            pageController.frame = CGRectMake(rect.size.width - Margin - size.width, rect.origin.y, size.width, PGC_Height);
        }
    }
}

-(void)setLinks:(NSArray *)links{

    _links = links ;
    pageController.numberOfPages = [_links count];
    [self SetPageControlAlgin];
    scView.contentSize = CGSizeMake(width * [_links count], 1);
    [self SetImage];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    pageController.currentPage = [[NSString stringWithFormat:@"%f",scView.contentOffset.x / scView.frame.size.width] integerValue];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

}

-(void)dealloc{
    [timer invalidate];
    [timer release];
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
