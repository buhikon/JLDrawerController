//
//  JLDrawerController.m
//
//  Version 1.0.0
//
//  Created by Joey L. on 4/8/15.
//  Copyright 2015 Joey L. All rights reserved.
//
//  https://github.com/buhikon/JLDrawerController
//

#import "JLDrawerController.h"

@interface JLDrawerController ()
{
    CGPoint _startPointOfSwipeView;
    CGPoint _startPointOfChildView;
    
    CGPoint _originOfSwipeView;
    CGPoint _originOfChildView;
    
}
@end

@implementation JLDrawerController


- (instancetype)initWithParentViewController:(UIViewController *)parentViewController
                         childViewController:(UIViewController *)childViewController
                                   swipeView:(UIView *)swipeView
                             revealDirection:(JLDrawerRevealDirection)revealDirection
                           allowSwipeToClose:(BOOL)allowSwipeToClose
{
    self = [super init];
    if (self) {
        self.parentViewController = parentViewController;
        self.childViewController = childViewController;
        self.swipeView = swipeView;
        self.revealDirection = revealDirection;
        self.allowSwipeToClose = allowSwipeToClose;
        
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    // check error
    if(!self.parentViewController) {
        NSLog(@"error: property parentViewController is nil.");
        return;
    }
    if(!self.childViewController) {
        NSLog(@"error: property childViewController is nil.");
        return;
    }
    if(!self.swipeView) {
        NSLog(@"error: property swipeView is nil.");
        return;
    }
    {
        BOOL exist = NO;
        for(UIView *subview in self.parentViewController.view.subviews) {
            if(subview == self.swipeView) {
                exist = YES;
                break;
            }
        }
        if(!exist) {
            NSLog(@"error: swipeView must be the subview of parentViewController.view.");
            return;
        }
    }
    
    // add childViewController
    {
        BOOL exist = NO;
        for(UIViewController *vc in self.parentViewController.childViewControllers) {
            if(vc == self.childViewController) {
                exist = YES;
                break;
            }
        }
        if(!exist) {
            [self.parentViewController addChildViewController:self.childViewController];
        }
    }
    // add subview
    self.childViewController.view.frame = [self rectForInvisible];
    [self.parentViewController.view addSubview:self.childViewController.view];

    // add gesture recognizer
    UIPanGestureRecognizer *swipeViewPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipeViewDidReceiveGesture:)];
    [self.swipeView addGestureRecognizer:swipeViewPanGestureRecognizer];
    
    
    if(self.allowSwipeToClose) {
        UIPanGestureRecognizer *childViewPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(childViewDidReceiveGesture:)];
        [self.childViewController.view addGestureRecognizer:childViewPanGestureRecognizer];
    }
}


- (void)open
{
    [self openAnimated:NO];
}
- (void)openAnimated:(BOOL)animated
{
    [self openAnimated:animated completion:nil];
}
- (void)openAnimated:(BOOL)animated completion:(void(^)(void))completion
{
    [self moveViewAnimated:animated showState:YES completion:completion];
}
- (void)close
{
    [self closeAnimated:NO];
}
- (void)closeAnimated:(BOOL)animated
{
    [self closeAnimated:animated completion:nil];
}
- (void)closeAnimated:(BOOL)animated completion:(void(^)(void))completion
{
    [self moveViewAnimated:animated showState:NO completion:completion];
}


#pragma mark - private methods

- (CGRect)rectForInvisible
{
    CGFloat xPos = 0;
    CGFloat yPos = 0;
    CGFloat width = self.parentViewController.view.bounds.size.width;
    CGFloat height = self.parentViewController.view.bounds.size.height;
    
    switch (self.revealDirection) {
        case JLDrawerRevealDirectionBotoomToTop:
        {
            xPos = 0;
            yPos = height;
            break;
        }
        case JLDrawerRevealDirectionTopToBottom:
        {
            xPos = 0;
            yPos = -height;
            break;
        }
        case JLDrawerRevealDirectionLeftToRight:
        {
            xPos = -width;
            yPos = 0;
            break;
        }
        case JLDrawerRevealDirectionRightToLeft:
        {
            xPos = width;
            yPos = 0;
            break;
        }
        default:
            break;
    }
    return CGRectMake(xPos, yPos, width, height);
}

- (CGRect)rectForVisible
{
    CGFloat xPos = 0;
    CGFloat yPos = 0;
    CGFloat width = self.parentViewController.view.bounds.size.width;
    CGFloat height = self.parentViewController.view.bounds.size.height;
    
    return CGRectMake(xPos, yPos, width, height);
}

- (void)bringToFront
{
    [self.parentViewController.view bringSubviewToFront:self.swipeView];
    [self.parentViewController.view bringSubviewToFront:self.childViewController.view];
}

- (void)moveViewAnimated:(BOOL)animated
               showState:(BOOL)showState
              completion:(void(^)(void))completion
{
    [self bringToFront];
    
    CGRect swipeRect = self.swipeView.frame;
    CGRect childRect = self.childViewController.view.frame;
    
    CGRect finalChildRect = showState ? [self rectForVisible] : [self rectForInvisible];
    CGPoint diff = CGPointMake(finalChildRect.origin.x - childRect.origin.x, finalChildRect.origin.y - childRect.origin.y);
    
    swipeRect.origin.x += diff.x;
    swipeRect.origin.y += diff.y;
    childRect.origin.x += diff.x;
    childRect.origin.y += diff.y;
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.swipeView.frame = swipeRect;
                         self.childViewController.view.frame = childRect;
                     }
                     completion:^(BOOL finished) {
                         if(completion) {
                             completion();
                         }
                     }];
}

#pragma mark - Event

- (void)swipeViewDidReceiveGesture:(UIPanGestureRecognizer *)panGestureRecognizer
{
    CGPoint point = [panGestureRecognizer locationInView:self.parentViewController.view];
    
    switch (panGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            _startPointOfSwipeView = point;
            _originOfSwipeView = self.swipeView.frame.origin;
            _originOfChildView = self.childViewController.view.frame.origin;
            
            [self bringToFront];
            
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            CGPoint currentGesturePoint = point;
            CGRect frameOfSwipeView = self.swipeView.frame;
            CGRect frameOfChildView = self.childViewController.view.frame;

            if(self.revealDirection == JLDrawerRevealDirectionBotoomToTop || self.revealDirection == JLDrawerRevealDirectionTopToBottom) {
                CGFloat move = currentGesturePoint.y - _startPointOfSwipeView.y;
                frameOfSwipeView.origin.y = _originOfSwipeView.y + move;
                frameOfChildView.origin.y = _originOfChildView.y + move;
                
            }
            else if(self.revealDirection == JLDrawerRevealDirectionLeftToRight || self.revealDirection == JLDrawerRevealDirectionRightToLeft) {
                CGFloat move = currentGesturePoint.x - _startPointOfSwipeView.x;
                frameOfSwipeView.origin.x = _originOfSwipeView.x + move;
                frameOfChildView.origin.x = _originOfChildView.x + move;
                
            }
            self.swipeView.frame = frameOfSwipeView;
            self.childViewController.view.frame = frameOfChildView;
            
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            CGPoint velocity = [panGestureRecognizer velocityInView:self.parentViewController.view];

            if(self.revealDirection == JLDrawerRevealDirectionBotoomToTop || self.revealDirection == JLDrawerRevealDirectionTopToBottom) {
                velocity.x = 0.0;
            }
            else if(self.revealDirection == JLDrawerRevealDirectionLeftToRight || self.revealDirection == JLDrawerRevealDirectionRightToLeft) {
                velocity.y = 0.0;
            }
            
            CGPoint endPoint = CGPointMake(self.swipeView.frame.origin.x + velocity.x, self.swipeView.frame.origin.y + velocity.y);
            CGPoint endCenter = CGPointMake(endPoint.x + self.swipeView.frame.size.width * 0.5, endPoint.y + self.swipeView.frame.size.height * 0.5);
            
            BOOL shouldShow = NO;
            CGFloat halfWidth = self.parentViewController.view.bounds.size.width * 0.5;
            CGFloat halfHeight = self.parentViewController.view.bounds.size.height * 0.5;
            switch (self.revealDirection) {
                case JLDrawerRevealDirectionBotoomToTop:
                {
                    if(endCenter.y < halfHeight) shouldShow = YES;
                    break;
                }
                case JLDrawerRevealDirectionTopToBottom:
                {
                    if(endCenter.y > halfHeight) shouldShow = YES;
                    break;
                }
                case JLDrawerRevealDirectionLeftToRight:
                {
                    if(endCenter.x > halfWidth) shouldShow = YES;
                    break;
                }
                case JLDrawerRevealDirectionRightToLeft:
                {
                    if(endCenter.x < halfWidth) shouldShow = YES;
                    break;
                }
                default:
                    break;
            }
            
            if(shouldShow) {
                [self open];
            }
            else {
                [self close];
            }
            break;
        }
        default:
            break;
    }
}
- (void)childViewDidReceiveGesture:(UIPanGestureRecognizer *)panGestureRecognizer
{
    [self swipeViewDidReceiveGesture:panGestureRecognizer];
}
@end
