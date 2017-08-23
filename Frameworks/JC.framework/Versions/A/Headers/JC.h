//
//  JC.h
//  Framework-iOS
//
//  Created by Joy Chiang on 12-3-20.
//  Copyright (c) 2012年 DB-Interactive. All rights reserved.
//

// UI
#import <JC/JCPopView.h>                // 带箭头弹出框
#import <JC/JCBadgeView.h>              // 通知栏数目视图
#import <JC/JCImageCache.h>             // 图片缓存：将图片缓存至本地
#import <JC/JCPagingView.h>             // UIScrollView扩展：可分栏显示自定义视图(水平和垂直方向，默认为水平方向)
#import <JC/JCImageButton.h>            // 可下载网络图片的UIButton
#import <JC/JCProgressHUD.h>            // 居中显示的提示框-常用语网络加载提示
#import <JC/JCPageControl.h>            // UIPageControl扩展-多种风格页码控制器
#import <JC/JCCoveringView.h>           //
#import <JC/JCProgressView.h>           // 进度条视图
#import <JC/JCToast+UIView.h>           // 模仿Android Toast功能
#import <JC/Toast.h>                    // 模仿Android Toast功能
#import <JC/JCAsyncImageView.h>         // 可加载网络图片的UIImageView视图(给定一个图片URL即可)
#import <JC/JCStatusBarOverlay.h>       // 自定义系统UIStatusBar
#import <JC/JCShadowPlainTableview.h>   // 为UITableView页眉和页脚增加阴影效果
#import <JC/JCSlidingViewController.h>  // 可左右滑动的UIViewController
#import <JC/JCLivelyTableView.h>        // 当滑动TableView时，提供多种UITableViewCell载入的动画方式

// Helper
#import <JC/JCUtility.h>                      // 常用工具类（角度弧度转换、颜色RBG转换、执行某delegate方法时判断该delegate是否有该方法、ios版本判断）
#import <JC/UIColor+Hex.h>
#import <JC/UIView+Size.h>
#import <JC/JCImageLoader.h>                  // 图片下载器
#import <JC/UIUtils+NSObject.h>
#import <JC/UIView+Animation.h>               // 动画管理类
#import <JC/UIAnimationManager.h>             // 动画管理类（可执行简单的动画：淡入淡出、视图以弹出的方式弹出、滑入滑出等效果）
#import <JC/UIView+InnerShadow.h>             // draw视图内部阴影
#import <JC/UIView+Positioning.h>             // 提供简单方法将视图局中、水平居中、垂直居中、显示等.
#import <JC/UIView+RoundedCorners.h>          // 处理视图圆角（通过UIRectCorner给定的视图四个角的某一角处理成圆角）
#import <JC/UIViewController+Loading.h>       // 模仿AppStore加载网络数据时在UIViewController视图中用UILabel的形式提示用户等待
#import <JC/NSString+BundleExtensions.h>      // 加载Resource中的txt文件
#import <JC/UINavigationController+Category.h>// 自定义UIViewController页面间跳转动画（视图翻转）

// Utils
#import <JC/DebugTool.h>
#import <JC/NSString+Crypto.h>
#import <JC/NSData+Crypto.h>
#import <JC/NSURL+Encoding.h>

// JCTabView——自定义UITabController、UITabBar（UITabBar自定义背景、每个Item支持自定义、选中的Item也支持自定义）
#import <JC/JCTabBar.h>
#import <JC/JCTabBarItem.h>
#import <JC/JCTabConstants.h>
#import <JC/JCSelectionView.h>
#import <JC/JCTabBarController.h>

// GMGridView——九宫格视图
#import <JC/GMGridView.h>
#import <JC/GMGridViewCell.h>
#import <JC/GMGridView-Constants.h>
#import <JC/GMGridViewLayoutStrategies.h>

// 2013.01.18
#import <JC/KTBase64.h>
#import <JC/CPTabBarController.h>

