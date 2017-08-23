//
//  ReceiveOrSendEnveloperTableViewCell.m
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2017/2/8.
//  Copyright © 2017年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "ReceiveOrSendEnveloperTableViewCell.h"

@implementation ReceiveOrSendEnveloperFirstTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (id)enveloperFirstTableViewCell {
    return [[[NSBundle mainBundle] loadNibNamed:@"ReceiveOrSendEnveloperTableViewCell" owner:self options:nil] firstObject];//首个
}

+ (NSString *)enveloperFirstTableViewCellID {
    return @"ReceiveOrSendEnveloperFirstTableViewCellID";
}

+ (CGFloat)enveloperFirstTableViewCellHeight {
    return 155;
}

- (id)loadViewFromNibNamed:(NSString *)name owner:(id)owner options:(NSDictionary *)options index:(NSInteger)index
{
    NSArray *nibs = nil;
    @try {
        nibs = [[NSBundle mainBundle] loadNibNamed:name owner:owner options:options];
    } @catch (NSException *exception) {
        NSLog(@"%@", exception.description);
    } @finally {
        //.
    }
    if([nibs count] > index){
        return [nibs objectAtIndex:index];
    }else
        return nil;
}

@end

@implementation ReceiveOrSendEnveloperSecondTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

+ (id)enveloperSecondTableViewCell {//objectAtIndex:
    return [[[NSBundle mainBundle] loadNibNamed:@"ReceiveOrSendEnveloperTableViewCell" owner:self options:nil] lastObject];//最后一个
}

+ (NSString *)enveloperSecondTableViewCellID {
    return @"ReceiveOrSendEnveloperSecondTableViewCellID";
}

+ (CGFloat)enveloperSecondTableViewCellHeight {
    return 65;
}

@end
