//
//  payLoadview.h
//  weidaiwang
//
//  Created by 艾运旺 on 15/8/11.
//  Copyright (c) 2015年 艾运旺. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface payLoadview : UIView

@property (weak, nonatomic) IBOutlet UIImageView *payLoadImageView;

-(id)initWithPayloadView;

-(void)stratImageAnimating;

-(void)stopImageAnimating;

@end
