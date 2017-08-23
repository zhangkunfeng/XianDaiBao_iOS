//
//  JCPagingView.h
//
//  上下、左右滚动视图
//
//  Created by Joy Chiang on 12-3-29.
//  Copyright (c) 2012年 DB-Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol JCPagingViewDelegate;

@interface JCPagingView : UIView {
    UIScrollView *_scrollView;
    
    id<JCPagingViewDelegate> _delegate;
    CGFloat _gapBetweenPages;
    NSInteger _pagesToPreload;
    
    NSInteger _pageCount;
    NSInteger _currentPageIndex;
    NSInteger _firstLoadedPageIndex;
    NSInteger _lastLoadedPageIndex;
    NSMutableSet *_recycledPages;
    NSMutableSet *_visiblePages;
    
    NSInteger _previousPageIndex;
    
    BOOL _rotationInProgress;
    BOOL _scrollViewIsMoving;
    BOOL _recyclingEnabled;
    BOOL _horizontal;
}

@property(nonatomic, assign) IBOutlet id<JCPagingViewDelegate> delegate;

@property(nonatomic, assign) CGFloat gapBetweenPages;
@property(nonatomic, assign) NSInteger pagesToPreload;
@property(nonatomic, readonly) NSInteger pageCount;
@property(nonatomic, readonly) UIScrollView *scrollView;

@property(nonatomic, assign) NSInteger currentPageIndex;
@property(nonatomic, assign, readonly) NSInteger previousPageIndex;
@property(nonatomic, assign, readonly) NSInteger firstVisiblePageIndex;
@property(nonatomic, assign, readonly) NSInteger lastVisiblePageIndex;
@property(nonatomic, assign, readonly) NSInteger firstLoadedPageIndex;
@property(nonatomic, assign, readonly) NSInteger lastLoadedPageIndex;

@property(nonatomic, assign, readonly) BOOL moving;
@property(nonatomic, assign) BOOL recyclingEnabled;
@property(nonatomic, assign) BOOL horizontal;

- (UIView *)dequeueReusablePage;
- (UIView *)viewForPageAtIndex:(NSUInteger)index;

- (void)didRotate;
- (void)reloadData;
- (void)willAnimateRotation;

@end

@protocol JCPagingViewDelegate <NSObject>

@required
- (NSInteger)numberOfPagesInPagingView:(JCPagingView *)pagingView;
- (UIView *)viewForPageInPagingView:(JCPagingView *)pagingView atIndex:(NSInteger)index;

@optional
- (void)currentPageDidChangeInPagingView:(JCPagingView *)pagingView;
- (void)pagesDidChangeInPagingView:(JCPagingView *)pagingView;
- (void)pagingViewWillBeginMoving:(JCPagingView *)pagingView;
- (void)pagingViewDidEndMoving:(JCPagingView *)pagingView;

@end

/////////////////////////////////////////////////////////////////////////////////////

@interface JCPagingViewController : UIViewController <JCPagingViewDelegate> {
    JCPagingView *_pagingView;
}

@property(nonatomic, retain) IBOutlet JCPagingView *pagingView;

@end