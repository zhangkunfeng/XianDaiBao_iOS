//
//  DiscoverHeadView.m
//  BaiYangFinancial
//
//  Created by 李艳楠 on 2017/6/28.
//  Copyright © 2017年 Hangzhou Futuo Financial Information Service Co., Ltd. All rights reserved.
//

#import "DiscoverHeadViewOne.h"


@interface DiscoverHeadViewOne ()
@property (weak, nonatomic) IBOutlet UIView *lineView;



@end



@implementation DiscoverHeadViewOne
{
    UIButton *_selectBtn;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    self.scrollView.contentSize = CGSizeMake(self.bounds.size.width * 3, 0);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.scrollEnabled = NO;
    _selectBtn = self.allBtn;
}


- (IBAction)redBagAction:(id)sender {
    
}
- (IBAction)allBtnAction:(UIButton *)sender {
    [self selectChangeBtn:sender];
//    [self.scrollView setContentOffset:<#(CGPoint)#>]
    
    CGFloat scrollX = sender.frame.origin.x
                     +sender.frame.size.width/2
                     -43/2;
    self.lineView.frame = CGRectMake(scrollX, self.lineView.frame.origin.y, self.lineView.frame.size.width, self.lineView.frame.size.height);
}
- (IBAction)ingBtnAction:(UIButton *)sender {
   [self selectChangeBtn:sender];
    CGFloat scrollX = sender.frame.origin.x
    +sender.frame.size.width/2
    -43/2;
    
    self.lineView.frame = CGRectMake(scrollX, self.lineView.frame.origin.y, self.lineView.frame.size.width, self.lineView.frame.size.height);
}
- (IBAction)endAction:(UIButton *)sender {
    [self selectChangeBtn:sender];
    self.lineView.frame = CGRectMake(sender.frame.origin.x, self.lineView.frame.origin.y, self.lineView.frame.size.width, self.lineView.frame.size.height);
}
- (void) selectChangeBtn:(UIButton *)btn{
    if (_selectBtn != btn) {
        [_selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _selectBtn = btn;
    }
    [btn setTitleColor:[UIColor colorWithHex:@"#60B8D3"] forState:UIControlStateNormal];
}
@end
