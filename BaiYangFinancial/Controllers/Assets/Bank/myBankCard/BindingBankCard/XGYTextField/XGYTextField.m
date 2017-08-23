

//
//  XGYTextField.m
//  bijianhuzhu
//
//  Created by xgy on 2016/12/29.
//  Copyright © 2016年 com.bijianhuzhu.bjhzh. All rights reserved.
//

#import "XGYTextField.h"

@implementation XGYTextField

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    UIToolbar *bar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0, Screen_Width,44)];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(Screen_Width - 60, 7,50, 30)];
    [button setTitle:@"完成"forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    button.layer.borderColor = [UIColor redColor].CGColor;
//    button.layer.borderWidth =1;
//    button.layer.cornerRadius =3;
    [bar addSubview:button];
    self.inputAccessoryView = bar;
    
    [button addTarget:self action:@selector(finishClick)forControlEvents:UIControlEventTouchUpInside];
}

- (void) finishClick {
    
    if ([self.delgate respondsToSelector:@selector(textFieldFinished)]) {
        [self.delgate textFieldFinished];
    }
}

@end
