//
//  AlartView.h
//  BaiYangFinancial
//
//  Created by 民华 on 2017/7/13.
//  Copyright © 2017年 Hangzhou Futuo Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol theViewOenDelegate <NSObject>

- (void)center;


@end

@interface theViewOen : UIView{
    id <theViewOenDelegate> delegate;
}
- (id)initWiththeDelegate:(id<theViewOenDelegate>) theDelegate;

- (IBAction)centerBtn:(id)sender;

@end
