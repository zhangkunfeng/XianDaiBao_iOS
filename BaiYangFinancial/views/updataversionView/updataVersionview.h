//
//  updataVersionview.h
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/9/25.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, VersionupdataStyle) {
    NOFORCEUPDATAVERSION = 0,//不强制更新
    FORCEUPDATAVERSION,//强制更新
};

@protocol versionUpdataviewDelegate <NSObject>

- (void)noUpdatabuttonAction;

- (void)updataButtonAction;

@end

@interface updataVersionview : UIView{
    id <versionUpdataviewDelegate> delegate;
}

- (id)initWithupdataVersionview:(VersionupdataStyle)VersionupdataStyle contentString:(NSString *)contentString theDelegate:(id<versionUpdataviewDelegate>) theDelegate;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonconstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftButtonwidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightButtonWidthConstraint;
@property (weak, nonatomic) IBOutlet UILabel *updataContentLable;
@property (weak, nonatomic) IBOutlet UIButton *cancleButton;
- (IBAction)cancelButtonaction:(id)sender;
- (IBAction)updataVersionButtonaction:(id)sender;



@end
