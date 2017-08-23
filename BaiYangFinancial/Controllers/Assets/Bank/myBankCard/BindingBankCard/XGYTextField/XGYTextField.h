//
//  XGYTextField.h
//  bijianhuzhu
//
//  Created by xgy on 2016/12/29.
//  Copyright © 2016年 com.bijianhuzhu.bjhzh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XGYTextFieldDelegate <NSObject>

- (void)textFieldFinished;

@end

@interface XGYTextField : UITextField
@property (nonatomic, weak)id<XGYTextFieldDelegate> delgate;
@end
