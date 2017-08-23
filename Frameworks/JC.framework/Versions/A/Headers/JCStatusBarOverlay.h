//
//  JCStatusBarOverlay.m
//
//  Created by Matthias Tretter on 27.09.10.
//  Copyright (c) 2009-2011  Matthias Tretter, @myell0w. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),
// to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
// Credits go to:
// -------------------------------
// @reederapp for inspiration
// -------------------------------

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

// Animation that happens, when the user touches the status bar overlay
typedef enum JCStatusBarOverlayAnimation {
	JCStatusBarOverlayAnimationNone,      // nothing happens
	JCStatusBarOverlayAnimationShrink,    // the status bar shrinks to the right side and only shows the activity indicator
	JCStatusBarOverlayAnimationFallDown   // the status bar falls down and displays more information
} JCStatusBarOverlayAnimation;

// Mode of the detail view
typedef enum JCDetailViewMode {
	JCDetailViewModeHistory,			// History of messages is recorded and displayed in detailView
	JCDetailViewModeDetailText,			// a text can be displayed easily
	JCDetailViewModeCustom				// the detailView can be customized in the way the developer wants
} JCDetailViewMode;

// indicates the type of a message
typedef enum JCMessageType {
	JCMessageTypeActivity,				// shows actvity indicator
	JCMessageTypeFinish,				// shows checkmark
	JCMessageTypeError					// shows error-mark
} JCMessageType;

// keys used in the dictionary-representation of a status message
#define kJCStatusBarOverlayMessageKey			@"MessageText"
#define kJCStatusBarOverlayMessageTypeKey		@"MessageType"
#define kJCStatusBarOverlayDurationKey			@"MessageDuration"
#define kJCStatusBarOverlayAnimationKey			@"MessageAnimation"
#define kJCStatusBarOverlayImmediateKey			@"MessageImmediate"

// keys used for saving state to NSUserDefaults
#define kJCStatusBarOverlayStateShrinked        @"kJCStatusBarOverlayStateShrinked"


@protocol JCStatusBarOverlayDelegate;

//===========================================================
#pragma mark -
#pragma mark JCStatusBarOverlay Interface
//===========================================================
@interface JCStatusBarOverlay : UIWindow <UITableViewDataSource> 

@property(nonatomic, retain) UIView *backgroundView;
@property(nonatomic, retain) UIView *detailView;
@property(nonatomic, assign) double progress;
@property(nonatomic, assign) CGRect smallFrame;
@property(nonatomic, assign) JCStatusBarOverlayAnimation animation;
@property(nonatomic, retain) UILabel *finishedLabel;
@property(nonatomic, assign) BOOL hidesActivity;
@property(nonatomic, retain) UIImage *defaultStatusBarImage;
@property(nonatomic, retain) UIImage *defaultStatusBarImageShrinked;
@property(nonatomic, readonly, getter=isShrinked) BOOL shrinked;
@property(nonatomic, readonly, getter=isDetailViewHidden) BOOL detailViewHidden;
@property(nonatomic, retain, readonly) NSMutableArray *messageHistory;
@property(nonatomic, assign, getter=isHistoryEnabled) BOOL historyEnabled;
@property(nonatomic, copy) NSString *lastPostedMessage;
@property(nonatomic, assign) BOOL canRemoveImmediateMessagesFromQueue;
@property(nonatomic, assign) JCDetailViewMode detailViewMode;
@property(nonatomic, copy) NSString *detailText;
@property(nonatomic, assign) id<JCStatusBarOverlayDelegate> delegate;

//===========================================================
#pragma mark -
#pragma mark Class Methods
//===========================================================
// Singleton Instance
+ (JCStatusBarOverlay *)sharedInstance;
+ (JCStatusBarOverlay *)sharedOverlay;

//===========================================================
#pragma mark -
#pragma mark Instance Methods
//===========================================================

// for customizing appearance, automatically disabled userInteractionEnabled on view
- (void)addSubviewToBackgroundView:(UIView *)view;
- (void)addSubviewToBackgroundView:(UIView *)view atIndex:(NSInteger)index;

// Method to re-post a cleared message
- (void)postMessageDictionary:(NSDictionary *)messageDictionary;

// shows an activity indicator and the given message
- (void)postMessage:(NSString *)message;
- (void)postMessage:(NSString *)message duration:(NSTimeInterval)duration;
- (void)postMessage:(NSString *)message duration:(NSTimeInterval)duration animated:(BOOL)animated;
- (void)postMessage:(NSString *)message animated:(BOOL)animated;
// clears the message queue and shows this message instantly
- (void)postImmediateMessage:(NSString *)message animated:(BOOL)animated;
- (void)postImmediateMessage:(NSString *)message duration:(NSTimeInterval)duration;
- (void)postImmediateMessage:(NSString *)message duration:(NSTimeInterval)duration animated:(BOOL)animated;

// shows a checkmark instead of the activity indicator and hides the status bar after the specified duration
- (void)postFinishMessage:(NSString *)message duration:(NSTimeInterval)duration;
- (void)postFinishMessage:(NSString *)message duration:(NSTimeInterval)duration animated:(BOOL)animated;
// clears the message queue and shows this message instantly
- (void)postImmediateFinishMessage:(NSString *)message duration:(NSTimeInterval)duration animated:(BOOL)animated;

// shows a error-sign instead of the activity indicator and hides the status bar after the specified duration
- (void)postErrorMessage:(NSString *)message duration:(NSTimeInterval)duration;
- (void)postErrorMessage:(NSString *)message duration:(NSTimeInterval)duration animated:(BOOL)animated;
// clears the message queue and shows this message instantly
- (void)postImmediateErrorMessage:(NSString *)message duration:(NSTimeInterval)duration animated:(BOOL)animated;

// hides the status bar overlay and resets it
- (void)hide;
// hides the status bar overlay but doesn't reset it's values
// this is useful if e.g. you have a screen where you don't have
// a status bar, but the other screens have one
// then you can hide it temporary and show it again afterwards
- (void)hideTemporary;
// this shows the status bar overlay, if there is text to show
- (void)show;

// saves the state in NSUserDefaults and synchronizes them
- (void)saveState;
- (void)saveStateSynchronized:(BOOL)synchronizeAtEnd;
// restores the state from NSUserDefaults
- (void)restoreState;

@end


//===========================================================
#pragma mark -
#pragma mark Delegate Protocol
//===========================================================
@protocol JCStatusBarOverlayDelegate <NSObject>
@optional
// is called, when a gesture on the overlay is recognized
- (void)statusBarOverlayDidRecognizeGesture:(UIGestureRecognizer *)gestureRecognizer;
// is called when the status bar overlay gets hidden
- (void)statusBarOverlayDidHide;
// is called, when the status bar overlay changed it's displayed message from one message to another
- (void)statusBarOverlayDidSwitchFromOldMessage:(NSString *)oldMessage toNewMessage:(NSString *)newMessage;
// is called when an immediate message gets posted and therefore messages in the queue get lost
// it tells the delegate the lost messages and the delegate can then enqueue the messages again
- (void)statusBarOverlayDidClearMessageQueue:(NSArray *)messageQueue;
@end
