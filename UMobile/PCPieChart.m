/**
 * Copyright (c) 2011 Muh Hon Cheng
 * Created by honcheng on 28/4/11.
 * 
 * Permission is hereby granted, free of charge, to any person obtaining 
 * a copy of this software and associated documentation files (the 
 * "Software"), to deal in the Software without restriction, including 
 * without limitation the rights to use, copy, modify, merge, publish, 
 * distribute, sublicense, and/or sell copies of the Software, and to 
 * permit persons to whom the Software is furnished to do so, subject 
 * to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be 
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT 
 * WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
 * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR 
 * PURPOSE AND NONINFRINGEMENT. IN NO EVENT 
 * SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE 
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR 
 * IN CONNECTION WITH THE SOFTWARE OR 
 * THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 * 
 * @author 		Muh Hon Cheng <honcheng@gmail.com>
 * @copyright	2011	Muh Hon Cheng
 * @version
 * 
 */

#import "PCPieChart.h"
#define LABEL_TOP_MARGIN 20
#define ARROW_HEAD_LENGTH 6
#define ARROW_HEAD_WIDTH 4


@implementation PCPieComponent
@synthesize value, title, colour, startDeg, endDeg;

- (id)initWithTitle:(NSString*)_title value:(double)_value
{
    self = [super init];
    if (self)
    {
        self.title = _title;
        self.value = _value;
        self.colour = PCColorDefault;
    }
    return self;
}

+ (id)pieComponentWithTitle:(NSString*)_title value:(double)_value
{
    return [[[super alloc] initWithTitle:_title value:_value] autorelease];
}

- (NSString*)description
{
    NSMutableString *text = [NSMutableString string];
    [text appendFormat:@"title: %@\n", self.title];
    [text appendFormat:@"value: %f\n", self.value];
    return text;
}

- (void)dealloc
{
    [colour release];
    [title release];
    [super dealloc];
}

@end

@implementation PCPieChart
@synthesize  components;
@synthesize diameter;
@synthesize titleFont, percentageFont;
@synthesize showArrow, sameColorLabel, showValue;

-(void)initialValue{
    [self setBackgroundColor:[UIColor clearColor]];

    self.titleFont = [UIFont fontWithName:@"GeezaPro" size:8];//[UIFont boldSystemFontOfSize:20];
    self.percentageFont = [UIFont fontWithName:@"HiraKakuProN-W6" size:9];//[UIFont boldSystemFontOfSize:14];
    self.showArrow = NO;
    self.sameColorLabel = NO;

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initialValue];
		
	}
    return self;
}



-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self initialValue];
    }
    return self;
}

-(void)drawLabels{
    
    float margin = 30;// self.myMargin == 0 ?30:self.myMargin;
    if (self.diameter==0)
    {
        diameter = MIN(self.frame.size.width, self.frame.size.height) - 2*margin;
    }
    float x = (self.frame.size.width - diameter)/2;
    float y = (self.frame.size.height - diameter)/2;
    float gap = 0;
    float inner_radius = diameter/2;
    float origin_x = x + diameter/2;
    float origin_y = y + diameter/2;
    
    // label stuff
    float left_label_y = LABEL_TOP_MARGIN;
    float right_label_y =  LABEL_TOP_MARGIN;
    UIScrollView *scrollView = [[[UIScrollView alloc]initWithFrame:CGRectMake(self.frame.size.width - 60, 0, 60, self.frame.size.height)] autorelease];
    [self addSubview:scrollView];
    
    if ([components count]>0)
    {
        
        float total = 0;
        float pieTotal = 0;
        for (PCPieComponent *component in components)
        {
            total +=  component.value;
            pieTotal += fabsf(component.value);
        }
        

        float offset = 0;
        for (int i = 0 ; i < [components count] ;  i ++){
            PCPieComponent *component = [components objectAtIndex:i];
            UILabel *lable = [[[UILabel alloc]initWithFrame:CGRectMake(0, offset, 60, 10)] autorelease];
//            lable.lineBreakMode = NSLineBreakByCharWrapping;
            lable.minimumScaleFactor = 0.5;
            offset = offset + 10;
            UILabel *lable2 = [[[UILabel alloc]initWithFrame:CGRectMake(0, offset, 60, 10)] autorelease];
            lable2.lineBreakMode = NSLineBreakByCharWrapping;
            lable.adjustsFontSizeToFitWidth = YES;
            lable2.minimumScaleFactor = 0.5;
            offset = offset + 10;
            lable.font = self.titleFont;
            lable.text = component.title;
            if (showValue){
                lable2.text = [NSString stringWithFormat:@"%.02f", component.value];
            }else{
                if (total == 0)
                    lable2.text = @"0%";
                else
                    lable2.text = [NSString stringWithFormat:@"%.02f%%", component.value/total*100];
            }
            lable2.adjustsFontSizeToFitWidth = YES;
            lable2.textColor = component.colour;
            lable2.font = self.titleFont;
            
            [scrollView addSubview:lable];
            [scrollView addSubview:lable2];
        }
        scrollView.contentSize = CGSizeMake(1, offset);
    }
    
}


- (void)drawRect:(CGRect)rect
{
    // Drawing code
    NSLog(@"%@",NSStringFromCGRect(rect));
    float margin = 30;// self.myMargin == 0 ?30:self.myMargin;
    if (self.diameter==0)
    {
        diameter = MIN(rect.size.width, rect.size.height) - 2*margin;
    }
    float x = (rect.size.width - diameter)/2;
    float y = (rect.size.height - diameter)/2;
    float gap = 0;
    float inner_radius = diameter/2;
    float origin_x = x + diameter/2;
    float origin_y = y + diameter/2;
    
    // label stuff
    float left_label_y = LABEL_TOP_MARGIN;
    float right_label_y = LABEL_TOP_MARGIN;
    
    
    if ([components count]>0)
    {
        
        float total = 0;
        float pieTotal = 0;
        for (PCPieComponent *component in components)
        {
            total +=  component.value;
            pieTotal += fabsf(component.value);
        }
        
        
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        if (total != 0) {
            
        
            UIGraphicsPushContext(ctx);
            CGContextSetRGBFillColor(ctx, 1.0f, 1.0f, 1.0f, 1.0f);  // white color
            CGContextSetShadow(ctx, CGSizeMake(0.0f, 0.0f), margin);
            CGContextFillEllipseInRect(ctx, CGRectMake(x, y, diameter, diameter));  // a white filled circle with a diameter of 100 pixels, centered in (60, 60)
            UIGraphicsPopContext();
            CGContextSetShadow(ctx, CGSizeMake(0.0f, 0.0f), 0);
        }
		float nextStartDeg = 0;
		float endDeg = 0;
		NSMutableArray *tmpComponents = [NSMutableArray array];
		int last_insert = -1;
		for (int i=0; i<[components count]; i++)
		{
			PCPieComponent *component  = [components objectAtIndex:i];
			float perc = fabs([component value])/pieTotal;
			endDeg = nextStartDeg+perc*360;
            if (total != 0){
                CGContextSetFillColorWithColor(ctx, [component.colour CGColor]);
                CGContextMoveToPoint(ctx, origin_x, origin_y);
                CGContextAddArc(ctx, origin_x, origin_y, inner_radius, (nextStartDeg-90)*M_PI/180.0, (endDeg-90)*M_PI/180.0, 0);
                CGContextClosePath(ctx);
                CGContextFillPath(ctx);
                
                CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);
                CGContextSetLineWidth(ctx, gap);
                CGContextMoveToPoint(ctx, origin_x, origin_y);
                CGContextAddArc(ctx, origin_x, origin_y, inner_radius, (nextStartDeg-90)*M_PI/180.0, (endDeg-90)*M_PI/180.0, 0);
                CGContextClosePath(ctx);
                CGContextStrokePath(ctx);
            }
			[component setStartDeg:nextStartDeg];
			[component setEndDeg:endDeg];
			if (nextStartDeg<180)
			{
				[tmpComponents addObject:component];
			}
			else
			{
				if (last_insert==-1)
				{
					last_insert = i;
					[tmpComponents addObject:component];
				}
				else
				{
					[tmpComponents insertObject:component atIndex:last_insert];
				}
			}
			
			nextStartDeg = endDeg;
		}
		
		nextStartDeg = 0;
		endDeg = 0;
		float max_text_width = x -  5;
//		for (int i=0; i<[tmpComponents count]; i++)//显示label
//		{
//			PCPieComponent *component  = [tmpComponents objectAtIndex:i];
//			nextStartDeg = component.startDeg;
//			endDeg = component.endDeg;
//			
//			if (nextStartDeg > 180 ||  (nextStartDeg < 180 && endDeg> 270) )
//			{
//				// left
//				
//				// display percentage label
//				if (self.sameColorLabel)
//				{
//					CGContextSetFillColorWithColor(ctx, [component.colour CGColor]);
//				}
//				else 
//				{
//					CGContextSetRGBFillColor(ctx, 0.1f, 0.1f, 0.1f, 1.0f);
//				}
//				//CGContextSetRGBStrokeColor(ctx, 1.0f, 1.0f, 1.0f, 1.0f);
//				//CGContextSetRGBFillColor(ctx, 1.0f, 1.0f, 1.0f, 1.0f);
//				CGContextSetShadow(ctx, CGSizeMake(0.0f, 0.0f), 3);
//				
//				//float text_x = x + 10;
//                NSString *percentageText = @"";
//                if (showValue){
//                    percentageText = [NSString stringWithFormat:@"%.02f", component.value];
//                }else{
//                    if (total == 0)
//                        percentageText = @"0%";//[NSString stringWithFormat:@"%.02f%%", component.value/total*100];
//                    else
//                        percentageText = [NSString stringWithFormat:@"%.02f%%", component.value/total*100];
//                }
//				CGSize optimumSize = [percentageText sizeWithFont:self.percentageFont constrainedToSize:CGSizeMake(max_text_width,100)];
//				CGRect percFrame = CGRectMake(5, left_label_y,  max_text_width, optimumSize.height);
//				[percentageText drawInRect:percFrame withFont:self.percentageFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentRight];
//				
//				if (self.showArrow)
//				{
//					// draw line to point to chart
//					CGContextSetRGBStrokeColor(ctx, 0.2f, 0.2f, 0.2f, 1);
//					CGContextSetRGBFillColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);
//					//CGContextSetRGBStrokeColor(ctx, 1.0f, 1.0f, 1.0f, 1.0f);
//					//CGContextSetRGBFillColor(ctx, 1.0f, 1.0f, 1.0f, 1.0f);
//					//CGContextSetShadow(ctx, CGSizeMake(0.0f, 0.0f), 5);
//					
//					
//					int x1 = inner_radius/4*3*cos((nextStartDeg+component.value/total*360/2-90)*M_PI/180.0)+origin_x; 
//					int y1 = inner_radius/4*3*sin((nextStartDeg+component.value/total*360/2-90)*M_PI/180.0)+origin_y;
//					CGContextSetLineWidth(ctx, 1);
//					if (left_label_y + optimumSize.height/2 < y)//(left_label_y==LABEL_TOP_MARGIN)
//					{
//						
//						CGContextMoveToPoint(ctx, 5 + max_text_width, left_label_y + optimumSize.height/2);
//						CGContextAddLineToPoint(ctx, x1, left_label_y + optimumSize.height/2);
//						CGContextAddLineToPoint(ctx, x1, y1);
//						CGContextStrokePath(ctx);
//						
//						//CGContextSetRGBFillColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);
//						CGContextMoveToPoint(ctx, x1-ARROW_HEAD_WIDTH/2, y1);
//						CGContextAddLineToPoint(ctx, x1, y1+ARROW_HEAD_LENGTH);
//						CGContextAddLineToPoint(ctx, x1+ARROW_HEAD_WIDTH/2, y1);
//						CGContextClosePath(ctx);
//						CGContextFillPath(ctx);
//						
//					}
//					else
//					{
//						
//						CGContextMoveToPoint(ctx, 5 + max_text_width, left_label_y + optimumSize.height/2);
//						if (left_label_y + optimumSize.height/2 > y + diameter)
//						{
//							CGContextAddLineToPoint(ctx, x1, left_label_y + optimumSize.height/2);
//							CGContextAddLineToPoint(ctx, x1, y1);
//							CGContextStrokePath(ctx);
//							
//							//CGContextSetRGBFillColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);
//							CGContextMoveToPoint(ctx, x1-ARROW_HEAD_WIDTH/2, y1);
//							CGContextAddLineToPoint(ctx, x1, y1-ARROW_HEAD_LENGTH);
//							CGContextAddLineToPoint(ctx, x1+ARROW_HEAD_WIDTH/2, y1);
//							CGContextClosePath(ctx);
//							CGContextFillPath(ctx);
//						}
//						else
//						{
//							float y_diff = y1 - (left_label_y + optimumSize.height/2);
//							if ( (y_diff < 2*ARROW_HEAD_LENGTH && y_diff>0) || (-1*y_diff < 2*ARROW_HEAD_LENGTH && y_diff<0))
//							{
//								
//								// straight arrow
//								y1 = left_label_y + optimumSize.height/2;
//								
//								CGContextAddLineToPoint(ctx, x1, y1);
//								CGContextStrokePath(ctx);
//								
//								//CGContextSetRGBFillColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);
//								CGContextMoveToPoint(ctx, x1, y1-ARROW_HEAD_WIDTH/2);
//								CGContextAddLineToPoint(ctx, x1+ARROW_HEAD_LENGTH, y1);
//								CGContextAddLineToPoint(ctx, x1, y1+ARROW_HEAD_WIDTH/2);
//								CGContextClosePath(ctx);
//								CGContextFillPath(ctx);
//							}
//							else if (left_label_y + optimumSize.height/2<y1)
//							{
//								// arrow point down
//								
//								y1 -= ARROW_HEAD_LENGTH;
//								CGContextAddLineToPoint(ctx, x1, left_label_y + optimumSize.height/2);
//								CGContextAddLineToPoint(ctx, x1, y1);
//								CGContextStrokePath(ctx);
//								
//								//CGContextSetRGBFillColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);
//								CGContextMoveToPoint(ctx, x1-ARROW_HEAD_WIDTH/2, y1);
//								CGContextAddLineToPoint(ctx, x1, y1+ARROW_HEAD_LENGTH);
//								CGContextAddLineToPoint(ctx, x1+ARROW_HEAD_WIDTH/2, y1);
//								CGContextClosePath(ctx);
//								CGContextFillPath(ctx);
//							} 
//							else
//							{
//								// arrow point up
//								
//								y1 += ARROW_HEAD_LENGTH;
//								CGContextAddLineToPoint(ctx, x1, left_label_y + optimumSize.height/2);
//								CGContextAddLineToPoint(ctx, x1, y1);
//								CGContextStrokePath(ctx);
//								
//								//CGContextSetRGBFillColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);
//								CGContextMoveToPoint(ctx, x1-ARROW_HEAD_WIDTH/2, y1);
//								CGContextAddLineToPoint(ctx, x1, y1-ARROW_HEAD_LENGTH);
//								CGContextAddLineToPoint(ctx, x1+ARROW_HEAD_WIDTH/2, y1);
//								CGContextClosePath(ctx);
//								CGContextFillPath(ctx);
//							}
//						}
//					}
//					
//				}
//				// display title on the left
//				CGContextSetRGBFillColor(ctx, 0.4f, 0.4f, 0.4f, 1.0f);
//				left_label_y += optimumSize.height - 4;
//				optimumSize = [component.title sizeWithFont:self.titleFont constrainedToSize:CGSizeMake(max_text_width,100)];
//				CGRect titleFrame = CGRectMake(5, left_label_y + 5, max_text_width, optimumSize.height);
//				[component.title drawInRect:titleFrame withFont:self.titleFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentRight];
//				left_label_y += optimumSize.height + 10;
//			}
//			else 
//			{
//				// right
//				
//				// display percentage label
//				if (self.sameColorLabel)
//				{
//					CGContextSetFillColorWithColor(ctx, [component.colour CGColor]);
//					//CGContextSetRGBStrokeColor(ctx, 1.0f, 1.0f, 1.0f, 0.5);
//					//CGContextSetTextDrawingMode(ctx, kCGTextFillStroke);
//				}
//				else 
//				{
//					CGContextSetRGBFillColor(ctx, 0.1f, 0.1f, 0.1f, 1.0f);
//				}
//				//CGContextSetRGBStrokeColor(ctx, 1.0f, 1.0f, 1.0f, 1.0f);
//				//CGContextSetRGBFillColor(ctx, 1.0f, 1.0f, 1.0f, 1.0f);
//				CGContextSetShadow(ctx, CGSizeMake(0.0f, 0.0f), 2);
//				
//				float text_x = x + diameter + 10;
//                NSString *percentageText = @"";
//                if (showValue){
//                    percentageText = [NSString stringWithFormat:@"%.02f", component.value];
//                }else{
//                    if (total == 0)
//                        percentageText = @"0%";//[NSString stringWithFormat:@"%.02f%%", component.value/total*100];
//                    else
//                        percentageText = [NSString stringWithFormat:@"%.02f%%", component.value/total*100];
//                }
//				
//				CGSize optimumSize = [percentageText sizeWithFont:self.percentageFont constrainedToSize:CGSizeMake(max_text_width,100)];
//				CGRect percFrame = CGRectMake(text_x, right_label_y, optimumSize.width, optimumSize.height);
//				[percentageText drawInRect:percFrame withFont:self.percentageFont];
//				
//				if (self.showArrow)
//				{
//					// draw line to point to chart
//					CGContextSetRGBStrokeColor(ctx, 0.2f, 0.2f, 0.2f, 1);
//                    CGContextSetRGBFillColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);
//					//CGContextSetRGBStrokeColor(ctx, 1.0f, 1.0f, 1.0f, 1.0f);
//					//CGContextSetRGBFillColor(ctx, 1.0f, 1.0f, 1.0f, 1.0f);
//					//CGContextSetShadow(ctx, CGSizeMake(0.0f, 0.0f), 5);
//					
//					CGContextSetLineWidth(ctx, 1);
//					int x1 = inner_radius/4*3*cos((nextStartDeg+component.value/total*360/2-90)*M_PI/180.0)+origin_x; 
//					int y1 = inner_radius/4*3*sin((nextStartDeg+component.value/total*360/2-90)*M_PI/180.0)+origin_y;
//					
//					
//					if (right_label_y + optimumSize.height/2 < y)//(right_label_y==LABEL_TOP_MARGIN)
//					{
//						
//						CGContextMoveToPoint(ctx, text_x - 3, right_label_y + optimumSize.height/2);
//						CGContextAddLineToPoint(ctx, x1, right_label_y + optimumSize.height/2);
//						CGContextAddLineToPoint(ctx, x1, y1);
//						CGContextStrokePath(ctx);
//						
//						//CGContextSetRGBFillColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);
//						CGContextMoveToPoint(ctx, x1-ARROW_HEAD_WIDTH/2, y1);
//						CGContextAddLineToPoint(ctx, x1, y1+ARROW_HEAD_LENGTH);
//						CGContextAddLineToPoint(ctx, x1+ARROW_HEAD_WIDTH/2, y1);
//						CGContextClosePath(ctx);
//						CGContextFillPath(ctx);
//					}
//					else
//					{
//						float y_diff = y1 - (right_label_y + optimumSize.height/2);
//						if ( (y_diff < 2*ARROW_HEAD_LENGTH && y_diff>0) || (-1*y_diff < 2*ARROW_HEAD_LENGTH && y_diff<0))
//						{
//							// straight arrow
//							y1 = right_label_y + optimumSize.height/2;
//							
//							CGContextMoveToPoint(ctx, text_x, right_label_y + optimumSize.height/2);
//							CGContextAddLineToPoint(ctx, x1, y1);
//							CGContextStrokePath(ctx);
//							
//							//CGContextSetRGBFillColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);
//							CGContextMoveToPoint(ctx, x1, y1-ARROW_HEAD_WIDTH/2);
//							CGContextAddLineToPoint(ctx, x1-ARROW_HEAD_LENGTH, y1);
//							CGContextAddLineToPoint(ctx, x1, y1+ARROW_HEAD_WIDTH/2);
//							CGContextClosePath(ctx);
//							CGContextFillPath(ctx);
//						}
//						else if (right_label_y + optimumSize.height/2<y1)
//						{
//							// arrow point down
//							
//							y1 -= ARROW_HEAD_LENGTH;
//							
//							CGContextMoveToPoint(ctx, text_x, right_label_y + optimumSize.height/2);
//							CGContextAddLineToPoint(ctx, x1, right_label_y + optimumSize.height/2);
//							//CGContextAddLineToPoint(ctx, x1+5, y1);
//							CGContextAddLineToPoint(ctx, x1, y1);
//							CGContextStrokePath(ctx); 
//							
//							//CGContextSetRGBFillColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);
//							CGContextMoveToPoint(ctx, x1+ARROW_HEAD_WIDTH/2, y1);
//							CGContextAddLineToPoint(ctx, x1, y1+ARROW_HEAD_LENGTH);
//							CGContextAddLineToPoint(ctx, x1-ARROW_HEAD_WIDTH/2, y1);
//							CGContextClosePath(ctx);
//							CGContextFillPath(ctx);
//						} 
//						else //if (nextStartDeg<180 && endDeg>180)
//						{
//							// arrow point up
//							y1 += ARROW_HEAD_LENGTH;
//							
//							CGContextMoveToPoint(ctx, text_x, right_label_y + optimumSize.height/2);
//							CGContextAddLineToPoint(ctx, x1, right_label_y + optimumSize.height/2);
//							CGContextAddLineToPoint(ctx, x1, y1);
//							CGContextStrokePath(ctx);
//							
//							//CGContextSetRGBFillColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);
//							CGContextMoveToPoint(ctx, x1+ARROW_HEAD_WIDTH/2, y1);
//							CGContextAddLineToPoint(ctx, x1, y1-ARROW_HEAD_LENGTH);
//							CGContextAddLineToPoint(ctx, x1-ARROW_HEAD_WIDTH/2, y1);
//							CGContextClosePath(ctx);
//							CGContextFillPath(ctx);
//						}
//					}
//				}
//				
//				// display title on the left
//				CGContextSetRGBFillColor(ctx, 0.4f, 0.4f, 0.4f, 1.0f);
//				right_label_y += optimumSize.height - 4;
//				optimumSize = [component.title sizeWithFont:self.titleFont constrainedToSize:CGSizeMake(max_text_width,100)];
//				CGRect titleFrame = CGRectMake(text_x, right_label_y + 5, optimumSize.width, optimumSize.height);
//				[component.title drawInRect:titleFrame withFont:self.titleFont];
//				right_label_y += optimumSize.height + 10;
//			}
//			
//			
//			nextStartDeg = endDeg;
//		}
    }
    [self drawLabels];
	
	
}

- (void)dealloc
{
	[self.titleFont release];
	[self.percentageFont release];
    [self.components release];
    [super dealloc];
}


@end
