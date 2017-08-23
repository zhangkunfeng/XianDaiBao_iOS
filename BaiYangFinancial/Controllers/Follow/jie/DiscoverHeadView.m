//
//  DiscoverHeadView.m
//  BaiYangFinancial
//
//  Created by 李艳楠 on 2017/6/28.
//  Copyright © 2017年 Hangzhou Futuo Financial Information Service Co., Ltd. All rights reserved.
//

#import "DiscoverHeadView.h"


@interface DiscoverHeadView ()
@property (weak, nonatomic) IBOutlet UIView *lineView;





@end



@implementation DiscoverHeadView
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


- (IBAction)redBaoAction:(UITapGestureRecognizer *)sender {
    [self.delegate meFriend];

    
    
}

- (IBAction)myFriend:(UITapGestureRecognizer *)sender {
    
    
    [self.delegate redBo];

}

- (IBAction)myFriendAction:(id)sender {
    [self.delegate meFriend];
}
- (IBAction)redBagAction:(id)sender {
    [self.delegate redBo];
}
- (IBAction)allBtnAction:(UIButton *)sender {
    [self selectChangeBtn:sender];
//    [self.scrollView setContentOffset:<#(CGPoint)#>]
    self.lineView.frame = CGRectMake(sender.frame.origin.x, self.lineView.frame.origin.y, sender.frame.size.width, self.lineView.frame.size.height);
}
- (IBAction)ingBtnAction:(UIButton *)sender {
   [self selectChangeBtn:sender];
    self.lineView.frame = CGRectMake(sender.frame.origin.x, self.lineView.frame.origin.y, sender.frame.size.width, self.lineView.frame.size.height);
    
    
    
}
- (IBAction)endAction:(UIButton *)sender {
    [self selectChangeBtn:sender];
    self.lineView.frame = CGRectMake(sender.frame.origin.x, self.lineView.frame.origin.y, sender.frame.size.width, self.lineView.frame.size.height);
}
- (void) selectChangeBtn:(UIButton *)btn{
    if (_selectBtn != btn) {
        [_selectBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _selectBtn = btn;
    }
    [btn setTitleColor:AppMianColor forState:UIControlStateNormal];
}



@end
