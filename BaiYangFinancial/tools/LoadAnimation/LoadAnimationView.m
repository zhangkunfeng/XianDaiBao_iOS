//
//  LoadAnimationView.m
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/7/13.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "LoadAnimationView.h"

@implementation LoadAnimationView

- (id) initWithView:(UIView *)view{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 180, 180);
        self.center = view.center;
        self.hidden = YES;
        
        [self initCommon];
        [self initTitle];
        [self initWifiManHub];
    }
    return self;
}


- (void)initTitle{
    _loadLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 180, 30)];
    _loadLable.backgroundColor = [UIColor clearColor];
    _loadLable.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_loadLable];
}

- (void) initWifiManHub
{
    CGRect frame = CGRectMake(17, 3, 146, 150);
    UIImage *imageColored = [UIImage imageNamed:@"3"];
    
    _contentLayer = [CALayer layer];
    _contentLayer.frame = frame;
    _contentLayer.backgroundColor = [UIColor clearColor].CGColor;
    _contentLayer.contents = (id)imageColored.CGImage;
    [self.layer addSublayer:_contentLayer];
}

- (void) initCommon
{
    _isAnimate = NO;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8f];
    self.layer.cornerRadius = 10.0f;
    self.clipsToBounds = YES;
}

#pragma mark Action
- (void) show
{
    if (_isAnimate){
        return;
    }
    _isAnimate = YES;
    self.hidden = NO;
    _loadLable.text = _loadtext;
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    NSArray *times = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.25], [NSNumber numberWithFloat:0.5], [NSNumber numberWithFloat:0.75],[NSNumber numberWithFloat:1.0f], nil];
    [anim setKeyTimes:times];
    
    UIImage *image_1 = [UIImage imageNamed:@"袋鼠1"];
    UIImage *image_2 = [UIImage imageNamed:@"袋鼠2"];
    UIImage *image_3 = [UIImage imageNamed:@"袋鼠3"];
    UIImage *image_4 = [UIImage imageNamed:@"袋鼠1"];
    
    NSArray *values = @[(id)image_1.CGImage,(id)image_2.CGImage,(id)image_3.CGImage,(id)image_4.CGImage,(id)image_1.CGImage];
    
    [anim setValues:values];
    [anim setDuration:0.1f];
    [anim setKeyTimes:times];
    anim.repeatCount = MAXFLOAT;
    
    [_contentLayer addAnimation:anim forKey:@"content"];
    
}

- (void) dismiss
{
    if (!_isAnimate)
        return;

    [self removeFromSuperview];
    _isAnimate = NO;
}

- (void)setLoadText:(NSString *)text{
    if (text) {
        _loadtext = text;
    }
}
@end
