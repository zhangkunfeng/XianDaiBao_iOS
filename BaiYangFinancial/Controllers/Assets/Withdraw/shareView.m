//
//  shareView.m
//  BaiYangFinancial
//
//  Created by 陆凤茜 on 15/11/13.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import "shareView.h"
#import "UIImageView+AFNetworking.h"
@implementation shareView

- (void)awakeFromNib
{
    [super awakeFromNib];
    NSString * str = @"邀请好友投资，即享50元现金红包";
    NSMutableAttributedString *strAtt_Temp = [[NSMutableAttributedString alloc] initWithString:str];
    [strAtt_Temp addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#FB9300"] range:NSMakeRange(9, 3)];
    [self.titleLabelText setAttributedText:strAtt_Temp];
}

- (id)initWithShareViewDelegate:(id<shareViewDelegate>)theDelegate{
    self = [[[NSBundle mainBundle] loadNibNamed:@"shareView" owner:self options:nil] lastObject];
    if (self) {
        
        /*需指定view大小*/
        CGRect viewFram = self.frame;
        viewFram.size.height = iPhoneHeight;
        viewFram.size.width = iPhoneWidth;
        self.frame = viewFram;
        
        self.shareView.clipsToBounds = YES;
        self.shareView.layer.cornerRadius = 5;
        [self.OKButton.layer setBorderWidth:1];
//        CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
//        CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){1,0,0,1});
        self.OKButton.layer.borderColor = AppBtnColor.CGColor;
//        [self.OKButton.layer setBorderColor:color];
//        CGColorSpaceRelease(colorSpaceRef);
//        CGColorRelease(color);
//        [self bringSubviewToFront:self.imageV];
        
        Sharedelegate = theDelegate;
        
        return self;
    }
    return nil;
}

//赋值
- (void)setDataWithShareView
{
    /**
     UIView *shareView;
     UIButton *OKButton;
     UIButton *shareButton;
     UIImageView *imageV;
     UILabel *titleLabelText;
     UILabel *descriptionLabelText;
     */
    NSDictionary * dict = getDictionaryFromUserDefaults(InvestmentSuccessDataDict);
    if ([self isLegalObject:dict[@"amount"]]) {//30
        
    }
    NSLog(@"投资成功分享视图数据 = %@",dict);
    
    /**
     label.text  = [NSString stringWithFormat:@"恭喜您成功获得 %@ 元红包",dict[@"AMOUNT"]];
     NSMutableAttributedString *strAtt_Temp = [[NSMutableAttributedString alloc] initWithString:label.text];
     [strAtt_Temp addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#FB9300"] range:NSMakeRange(8, 3)];
     [label setAttributedText:strAtt_Temp];
     */
    
    if ([self isLegalObject:dict[@"text1"]]) {//次文
        self.descriptionLabelText.text = [NSString stringWithFormat:@"%@",dict[@"text1"]];
    }
    
    if ([self isLegalObject:dict[@"text2"]]) {//标题  邀请好友投资,即享50元现金红包
        NSString * str = [NSString stringWithFormat:@"%@",dict[@"text2"]];
        NSMutableAttributedString *strAtt_Temp = [[NSMutableAttributedString alloc] initWithString:str];
        [strAtt_Temp addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#FB9300"] range:NSMakeRange(9, 3)];
        [self.titleLabelText setAttributedText:strAtt_Temp];
    }
}

- (BOOL)isLegalObject:(NSObject *)object {
    if (object == nil) {
        return NO;
    }
    if ([object isKindOfClass:[NSNull class]]) {
        return NO;
    }
    return YES;
}

- (IBAction)shareBtn:(id)sender {
    [Sharedelegate UMengShare];
}

- (IBAction)OKButton:(id)sender {
    [Sharedelegate dismissShareView];
}

@end
