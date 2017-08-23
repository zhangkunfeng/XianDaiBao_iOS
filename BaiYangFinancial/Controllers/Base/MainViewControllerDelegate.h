//
//  MainViewControllerDelegate.h
//  cztvNewsiPhone
//
//  Created by 侯迪 on 4/30/15.
//  Copyright (c) 2015 letv. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    MenuSelectTypeDefault = 0,
    MenuSelectTypeUserSelect = 1
} MenuSelectType;

@protocol MainViewControllerDelegate <NSObject>

- (void) wasSelectedBySender:(UIViewController *) senderViewController selectType:(MenuSelectType) selectType;
- (void) wasUnselectedBySender:(UIViewController *)senderViewController;

@optional
- (void) mainMenuIndexFromTvToRadiobySender:(UIViewController *)senderViewController;
- (void) mainMenuIndexFromRadioToTvbySender:(UIViewController *)senderViewController;
@end