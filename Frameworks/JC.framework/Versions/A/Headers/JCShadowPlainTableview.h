//
//  JCShadowPlainTableview.h
//  Framework-iOS
//
//  Created by Joy Chiang on 12-4-20.
//  Copyright (c) 2012年 DB-Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    JCShadowPlainTableviewPositionHeader = 0,
    JCShadowPlainTableviewPositionFooter
} JCShadowPlainTableviewPosition;

/** JCShadowPlainTableview
        为Plain类型的UITableView绘制页眉和页脚阴影效果。
        调用 setUpTableView: 则完成对UITableView的阴影设置。
 */
@interface JCShadowPlainTableview : UIView {
@private
    JCShadowPlainTableviewPosition _position;
}

/** 根据position返回一个自动释放JCShadowPlainTableview实例。
 
    Position只能为:
        - JCShadowPlainTableviewPositionHeader: tableView's header.
        - JCShadowPlainTableviewPositionFooter: tableView's footer.
 */
+ (id)shadowForPosition:(JCShadowPlainTableviewPosition)position;

// 配置给予的tableView页眉和页脚阴影。tableView contentInset则会根据阴影的高度而改变。
+ (void)setUpTableView:(UITableView *)tableView;

+ (float)height;

@end