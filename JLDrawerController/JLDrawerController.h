//
//  JLDrawerController.h
//
//  Version 1.0.2
//
//  Created by Joey L. on 4/8/15.
//  Copyright 2015 Joey L. All rights reserved.
//
//  https://github.com/buhikon/JLDrawerController
//

#import <UIKit/UIKit.h>


typedef enum {
    JLDrawerRevealDirectionBotoomToTop,
    JLDrawerRevealDirectionTopToBottom,
    JLDrawerRevealDirectionLeftToRight,
    JLDrawerRevealDirectionRightToLeft
} JLDrawerRevealDirection;

typedef enum {
    JLDrawerEventViewDidAppear,
    JLDrawerEventViewDidDisappear
} JLDrawerEvent;

typedef void(^JLDrawerEventHandler)(JLDrawerEvent event);


@interface JLDrawerController : NSObject

@property (weak, nonatomic) UIViewController *parentViewController;
@property (weak, nonatomic) UIViewController *childViewController;
@property (weak, nonatomic) UIView *swipeView;
@property (assign, nonatomic) JLDrawerRevealDirection revealDirection;
@property (assign, nonatomic) BOOL allowSwipeToClose;
@property (copy, nonatomic) JLDrawerEventHandler eventHandler;

- (instancetype)initWithParentViewController:(UIViewController *)parentViewController
                         childViewController:(UIViewController *)childViewController
                                   swipeView:(UIView *)swipeView
                             revealDirection:(JLDrawerRevealDirection)revealDirection
                           allowSwipeToClose:(BOOL)allowSwipeToClose;

- (void)open;
- (void)openAnimated:(BOOL)animated;
- (void)openAnimated:(BOOL)animated completion:(void(^)(void))completion;
- (void)close;
- (void)closeAnimated:(BOOL)animated;
- (void)closeAnimated:(BOOL)animated completion:(void(^)(void))completion;

@end
