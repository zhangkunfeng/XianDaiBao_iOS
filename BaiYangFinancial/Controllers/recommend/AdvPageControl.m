//
//  AdvPageControl.m
//  掌上泉商
//
//  Created by apple on 13-9-13.
//  Copyright (c) 2013年 com.jushang. All rights reserved.
//

#import "AdvPageControl.h"

@implementation AdvPageControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        imgNormal = [[UIImage imageNamed:IMG_HomePageNormal] retain];
        imgSelected = [[UIImage imageNamed:IMG_HomePageHighlight] retain];
        // Initialization code
    }
    return self;
}

-(void) updateDots
{
    for (int i = 0; i < [self.subviews count]; i++)
    {
        UIImageView* dot = (UIImageView *)[self.subviews objectAtIndex:i];
//        NSLog(@"dot   frame %f",dot.frame.origin.x);
        if (i == self.currentPage)
        {
            if(i==0)
            {
                dot.layer.backgroundColor = [UIColor clearColor]. CGColor;
                dot.layer.contents = (id)[UIImage imageNamed:IMG_HomePageNormal].CGImage;
            }
            else
            {
                dot.layer.backgroundColor = [UIColor clearColor]. CGColor;
                dot.layer.contents = (id)[UIImage imageNamed:IMG_HomePageNormal].CGImage;
            }
        }
        else
        {
            if(i==0)
            {
                dot.layer.backgroundColor = [UIColor clearColor]. CGColor;
                dot.layer.contents = (id)[UIImage imageNamed:IMG_HomePageHighlight].CGImage;
            }
            else
            {
                dot.layer.backgroundColor = [UIColor clearColor]. CGColor;
                dot.layer.contents = (id)[UIImage imageNamed:IMG_HomePageHighlight].CGImage;
            }
        }

    }
    
}

-(void) setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    [self updateDots];
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
