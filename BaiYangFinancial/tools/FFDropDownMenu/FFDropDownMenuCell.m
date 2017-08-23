//
//  FFDropDownMenuCell.m
//  FFDropDownMenuDemo
//
//  Created by mac on 16/7/31.
//  Copyright © 2016年 chenfanfang. All rights reserved.
//

#import "FFDropDownMenuCell.h"

//model
#import "FFDropDownMenuModel.h"

//other
#import "FFDropDownMenu.h"

@interface FFDropDownMenuCell ()

/** 图片 */
@property (weak, nonatomic) UIImageView *customImageView;

/** 标题 */
@property (weak, nonatomic) UILabel *customTitleLabel;

/** 底部分割线 */
@property (nonatomic, weak) UIView *separaterView;

/** 圆心 */ /*后加*/
@property (nonatomic, weak) UILabel *roundLabel;

@end

@implementation FFDropDownMenuCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //初始化子控件
        UIImageView *customImageView = [[UIImageView alloc] init];
        customImageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:customImageView];
        self.customImageView = customImageView;
        
        UILabel *customTitleLabel = [[UILabel alloc] init];
        customTitleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:customTitleLabel];
        self.customTitleLabel = customTitleLabel;
        
        UIView *separaterView = [[UIView alloc] init];
        separaterView.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:240 / 255.0 blue:240 / 255.0 alpha:.3];
        [self addSubview:separaterView];
        self.separaterView = separaterView;
        
        //后加
        UILabel * roundLabel = [[UILabel alloc] init];
        roundLabel.backgroundColor = [UIColor whiteColor];
        roundLabel.textColor = [UIColor redColor];
        roundLabel.font = [UIFont systemFontOfSize:12];
        roundLabel.textAlignment = NSTextAlignmentCenter;
        roundLabel.hidden = YES;
        [self addSubview:roundLabel];
        self.roundLabel = roundLabel;
        
        //消息
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isShowMessageTotal:) name:isHidenFollowAddMessageRedDot object:nil];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //frame的赋值
    CGFloat separaterHeight = .5; //底部分割线高度
    
    //图片 customImageView
    CGFloat imageViewMargin = 9;/*之前3*/
    CGFloat imageViewH = self.frame.size.height - 2 * imageViewMargin;
    self.customImageView.frame = CGRectMake(12/*10*/, imageViewMargin, imageViewH, imageViewH);
    
    //标题
    CGFloat labelX = CGRectGetMaxX(self.customImageView.frame) + 12;/*10*/
    self.customTitleLabel.frame = CGRectMake(labelX, 0, self.frame.size.width - labelX, self.frame.size.height - separaterHeight);
    self.customTitleLabel.textColor = [UIColor whiteColor];
    
    //分割线
    self.separaterView.frame = CGRectMake(10, self.frame.size.height - separaterHeight, self.frame.size.width-20, separaterHeight);

    //圆心  后加
    CGFloat labelViewY = (self.frame.size.height - 16) / 2 - 1;
    self.roundLabel.frame = CGRectMake(self.frame.size.width-28, labelViewY, 16, 16);
    self.roundLabel.layer.masksToBounds = YES;
    self.roundLabel.layer.cornerRadius = 16/2;
}

- (void)setMenuModel:(id)menuModel {
    _menuModel = menuModel;
    
    FFDropDownMenuModel *realMenuModel = (FFDropDownMenuModel *)menuModel;
    self.customTitleLabel.text = realMenuModel.menuItemTitle;
    
    //给imageView赋值
    if (realMenuModel.menuItemIconName.length) {
        self.customImageView.image = [UIImage imageNamed:realMenuModel.menuItemIconName];
        
    } else {
        FFLog(@"您传入的图片为空图片,框架内部默认不做任何处理。若您的确不想传入图片，则请忽略此处打印");
    }
}
//隐藏线条
- (void)setLineLabelHidden{
    self.separaterView.hidden = YES;
}

- (void)setRoundLabelValues
{
    //后加
    if ([self.customTitleLabel.text isEqualToString:@"查看消息"]) {
        self.roundLabel.text = self.menuTotal;
        //必须判断  进来就走
        self.roundLabel.hidden = [self.menuTotal floatValue]>0?NO:YES;
    }
}

//后加
- (void)isShowMessageTotal:(NSNotification*)notify
{
    if ([self.customTitleLabel.text isEqualToString:@"查看消息"]) {
        self.roundLabel.text = notify.object;
        //无需 通知有数据才过来
        self.roundLabel.hidden = [notify.object floatValue]>0?NO:YES;
    }
}

@end
