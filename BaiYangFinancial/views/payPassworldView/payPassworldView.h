//
//  payPassworldView.h
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/8/26.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol payPassworldViewDelegate <NSObject>

- (void)payPassworldViewCancel;

- (void)payPassworldViewConfirm;

@end

@interface payPassworldView : UIView<UITextFieldDelegate>{
    id<payPassworldViewDelegate> delegate;
}

- (id)initWithpayPassworldView:(id<payPassworldViewDelegate>) theDelegate;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payPassWorldAlignmentYConstraint;
@property (weak, nonatomic) IBOutlet UITextField *payPassworldTF;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
- (IBAction)cancelButtonAction:(id)sender;
- (IBAction)ConfirmButtonAction:(id)sender;

@end
