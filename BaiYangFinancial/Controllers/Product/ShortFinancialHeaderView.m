//
//  ShortFinancialHeaderView.m
//  BaiYangFinancial
//
//  Created by ShinesZhao on 2016/11/17.
//  Copyright © 2016年 Hangzhou YunHou Services Information Co., Ltd. All rights reserved.
//

#import "ShortFinancialHeaderView.h"
#import "NewProductTableViewCell.h"
#import "ProductdetailsViewController.h"
#import "SDImageCache.h"

@interface ShortFinancialHeaderView ()
{
    NSDictionary * _dict;

    NSString * _descImageUrlKey;
    NSString * _descImagePathKey;
    NSString * _descImageTitleKey;
    
    BaseViewController *_viewController;
}
@end

@implementation ShortFinancialHeaderView
- (instancetype)initWithViewFram:(CGRect)viewFram viewController:(UIViewController *)viewController {
    if (![super init]) {
        return nil;
    }
    self = [[[NSBundle mainBundle] loadNibNamed:@"ShortFinancialHeaderView" owner:self options:nil] lastObject];
    _dict = [NSDictionary dictionary];
    _viewController = (BaseViewController *)viewController;
    _shortFinancialHeaderTableView.delegate = self;
    _shortFinancialHeaderTableView.dataSource = self;
    
    self.descImageView.userInteractionEnabled = YES;

    [self loadAdimage];
    
    return self;
}
- (void)loadAdimage{
    
    _descImageUrlKey = @"short-descImage.url";
    _descImagePathKey = @"short-descImage.path";
    _descImageTitleKey = @"short-descImage.title";
    
    NSString *imageURL = [[NSUserDefaults standardUserDefaults] objectForKey:_descImagePathKey];
    UIImage *descImage = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:imageURL];
    if (descImage) {
        self.descImageView.image = descImage;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shortDescImageViewTap:)];
        [self.descImageView addGestureRecognizer:tap];
    }else{
        self.descImageView.image = [UIImage imageNamed:@"活动条"];
    }
}

- (void)shortDescImageViewTap:(UITapGestureRecognizer *)tap
{
    //跳转页面
    NSString *urlLink = [[NSUserDefaults standardUserDefaults] objectForKey:_descImageUrlKey];
    NSLog(@"short - urlLink = %@",urlLink);
    if (urlLink) {
        [_viewController jumpToWebview:urlLink webViewTitle:[[NSUserDefaults standardUserDefaults] objectForKey:_descImageTitleKey]];
    }
    
}

- (void)setData:(NSDictionary *)dict{
    _dict = dict;
    [_shortFinancialHeaderTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    NewProductTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[NewProductTableViewCell NewProductTableViewID]];
    if (cell == nil) {
        cell = [NewProductTableViewCell NewproductTableViewCell];
    }else {
        //删除cell的所有子视图
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *) [cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    [cell setSmalliPhoneConstant];
    cell.bidTitleLable.lineBreakMode = NSLineBreakByTruncatingMiddle;
    cell.progressView.progress =  0.0f;
    cell.PercentageDesc.text = @"0%";
    
        cell.bidTitleLable.text = [_viewController isLegalObject:_dict[@"title"]] ? _dict[@"title"] : @"";
        cell.bidTitleLable.tag = [_dict[@"id"] integerValue];
        //百分比 || 进度条 || 标的状态
        float BidProgress = 0.0;
        if ([_viewController isLegalObject:_dict[@"borrow_bpr"]]) {
            BidProgress = [_dict[@"borrow_bpr"] floatValue];
            if (BidProgress > 0) {
                cell.progressView.progress = BidProgress / 100;
                //进度 80%  没设置为0  上边初始化
                NSString *borrowedCompletionRateprogressNumber = [NSString stringWithFormat:@"%.2f", [_dict[@"borrow_bpr"] doubleValue]];
                cell.PercentageDesc.text = [NSString stringWithFormat:@"已售%@%@",borrowedCompletionRateprogressNumber,@"%"];
//                if ([borrowedCompletionRateprogressNumber rangeOfString:@"."].location != NSNotFound) {
//                    NSArray *progressNumberStringArray = [borrowedCompletionRateprogressNumber componentsSeparatedByString:@"."];
//                    if ([[progressNumberStringArray objectAtIndex:0] integerValue] == 0) {
//                        cell.PercentageDesc.text =  [NSString stringWithFormat:@"已售%@%@",borrowedCompletionRateprogressNumber,@"%"];
//                    }else{
//                        cell.PercentageDesc.text = [NSString stringWithFormat:@"已售%@%@", [progressNumberStringArray objectAtIndex:0],@"%"];
//                    }
                    //标的状态
                    if (BidProgress < 100) {
//                        cell.lineLabel.hidden = NO;
                        cell.BidStateImageView.hidden = YES;
                    } else {
//                        cell.lineLabel.hidden = YES;
                        cell.BidStateImageView.hidden = NO;
                        [cell.BidStateImageView setImage:[UIImage imageNamed:@"已售罄.png"]];
                    }
                }
            }
//        }
    
        //标的利率
        if (![_dict[@"borrow_apr"] isKindOfClass:[NSNull class]]) {
            NSString * bidRateString = [NSString stringWithFormat:@"%.1f%@", [_dict[@"borrow_apr"] doubleValue],@"%"];
            
            [_viewController AttributedString:bidRateString andTextColor:[UIColor colorWithHexString:@"ED702A"] andTextFontSize:15.0f AndRange:bidRateString.length-1 withlength:1 AndLabel:cell.bidRateLable];
        }
    
        //加送利率
        if ([_viewController isLegalObject:_dict[@"borrow_jiangli"]]) {
            if ([_dict[@"borrow_jiangli"] doubleValue] > 0) {
                cell.addBidRateLable.text = [NSString stringWithFormat:@"+%.1f%@", [_dict[@"borrow_jiangli"] doubleValue] * 100,@"%"];
            } else {
                cell.addBidRateLable.text = @"";
            }
        } else {
            cell.addBidRateLable.text = @"";
        }
    
        if (!(cell.addBidRateLable.text.length > 0) && (iPhone4||iPhone5)) {
            cell.lineLeading.constant = 18;
        }
    
        //标的总额
        if ([_viewController isLegalObject:_dict[@"account"]]) {
            float acount = [_dict[@"account"] floatValue]/10000;
            NSString * borrowAmoutString = acount<1?
            [NSString stringWithFormat:@"%.2f元",[_dict[@"account"] floatValue]]
            :[NSString stringWithFormat:@"%.2f万",acount];
            [_viewController AttributedString:borrowAmoutString andTextColor:[UIColor darkGrayColor] andTextFontSize:13.0f AndRange:borrowAmoutString.length-1 withlength:1 AndLabel:cell.borrowAmountLable];
        }
    
        //标最小购买值
        if ([_viewController isLegalObject:_dict[@"tender_account_min"]]) {
            NSString * tenderMinAmoutString = [NSString stringWithFormat:@"%d元", [_dict[@"tender_account_min"] intValue]];
            [_viewController AttributedString:tenderMinAmoutString andTextColor:[UIColor darkGrayColor] andTextFontSize:13.0f AndRange:tenderMinAmoutString.length-1 withlength:1 AndLabel:cell.tenderMinAmountLable];
        }
    
        // 即使是月标 有的走天数   borrowDeadlineLable
        NSString * borrowDeadlineLableString;
    if ([_viewController isLegalObject:_dict[@"monthDay"]]) {
        if ([_dict[@"monthDay"] integerValue] > 31) {
            borrowDeadlineLableString = [NSString stringWithFormat:@"%zd天", [_dict[@"monthDay"] integerValue]];
        }else{
            if ([_viewController isLegalObject:_dict[@"period_time_unit"]] && [_viewController isLegalObject:_dict[@"borrow_period"]]) {
                if ([_dict[@"period_time_unit"] intValue] == 0) {
                    borrowDeadlineLableString = [NSString stringWithFormat:@"%@天", _dict[@"borrow_period"]];
                } else {
                    borrowDeadlineLableString = [NSString stringWithFormat:@"%@月", _dict[@"borrow_period"]];
                }
            }
        }
    }else{
        if ([_viewController isLegalObject:_dict[@"period_time_unit"]] && [_viewController isLegalObject:_dict[@"borrow_period"]]) {
            if ([_dict[@"period_time_unit"] intValue] == 0) {
                borrowDeadlineLableString = [NSString stringWithFormat:@"%@天", _dict[@"borrow_period"]];
            } else {
                borrowDeadlineLableString = [NSString stringWithFormat:@"%@月", _dict[@"borrow_period"]];
            }
        }
    }
        //期限天数 cell.borrowDeadlineLable
        [_viewController AttributedString:borrowDeadlineLableString andTextColor:[UIColor darkGrayColor] andTextFontSize:13.0f AndRange:borrowDeadlineLableString.length-1 withlength:1 AndLabel:cell.borrowDeadlineLable];
        
        return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [NewProductTableViewCell NewProductTableViewCellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"dict = %@",_dict);
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
        ProductdetailsViewController *ProductdetailsView = [[ProductdetailsViewController alloc] initWithNibName:@"ProductdetailsViewController" bundle:nil];
        ProductdetailsView.productBid = [NSString stringWithFormat:@"%zd", [[_dict objectForKey:@"bid"] integerValue]];
        ProductdetailsView.bidNameString = _dict[@"title"];
        [_viewController customPushViewController:ProductdetailsView customNum:0];
        //点击过后的标题变灰色
        UILabel *titleLable = (UILabel *) [_viewController.view viewWithTag:[_dict[@"bid"] integerValue]];
        titleLable.textColor = [UIColor darkGrayColor];
}

@end
