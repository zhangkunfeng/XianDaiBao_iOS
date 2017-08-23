//
//  CalculatorView.h
//  BaiYangFinancial
//
//  Created by 无名小子 on 15/12/30.
//  Copyright (c) 2015年 无名小子. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CalculatorViewDelegate <NSObject>

- (void)initWithCalculatorCancelAction;


@end


@interface CalculatorView : UIView{
    id<CalculatorViewDelegate> delegate;
}



- (instancetype)initWithCalculatorView:(id<CalculatorViewDelegate>)theDelegate calculatorDict:(NSDictionary *)dataDict;

@end
