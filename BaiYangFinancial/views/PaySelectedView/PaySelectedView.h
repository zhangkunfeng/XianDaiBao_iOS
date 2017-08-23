//
//  PaySelectedView.h
//  xrtz
//
//  Created by 洪徐 on 16/7/19.
//  Copyright © 2016年 艾运旺. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PaySelectedViewDelegate <NSObject>

-(void)sureTappend:(UIButton *)btn;
-(void)cancelTappend;

@end

@interface PaySelectedView : UIView

@property (weak, nonatomic) IBOutlet UITableView *selectViewTableView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

- (IBAction)cancelBtnClicked:(id)sender;
- (IBAction)sureBtnClicked:(id)sender;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *seclectedViewHeight;//normal 306

@property (nonatomic, weak) id<PaySelectedViewDelegate> delegate;

- (void)setSelectViewDataArray:(NSArray *)array;

@end
