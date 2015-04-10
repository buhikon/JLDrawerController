//
//  ViewController.m
//  DrawerDemo
//
//  Created by Joey L. on 4/8/15.
//  Copyright (c) 2015 Joey L. All rights reserved.
//

#import "ViewController.h"
#import "JLDrawerController.h"
#import "ChildViewController.h"

@interface ViewController ()

@property (strong, nonatomic) JLDrawerController *topDrawerController;
@property (strong, nonatomic) JLDrawerController *bottomDrawerController;
@property (strong, nonatomic) JLDrawerController *leftDrawerController;
@property (strong, nonatomic) JLDrawerController *rightDrawerController;
@property (weak, nonatomic) IBOutlet UIView *topSwipeView;
@property (weak, nonatomic) IBOutlet UIView *bottomSwipeView;
@property (weak, nonatomic) IBOutlet UIView *leftSwipeView;
@property (weak, nonatomic) IBOutlet UIView *rightSwipeView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    {
        ChildViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ChildViewController"];
        [vc view];
        vc.headerLabel.text = @"TOP";
        vc.block = ^(void){
            [self.topDrawerController closeAnimated:YES];
        };
        self.topDrawerController = [[JLDrawerController alloc] initWithParentViewController:self
                                                                        childViewController:vc
                                                                                  swipeView:self.topSwipeView
                                                                            revealDirection:JLDrawerRevealDirectionTopToBottom
                                                                          allowSwipeToClose:YES];
        self.topDrawerController.eventHandler = ^(JLDrawerEvent event) {
            switch (event) {
                case JLDrawerEventViewDidAppear:
                    NSLog(@"TOP: JLDrawerEventViewDidAppear");
                    break;
                case JLDrawerEventViewDidDisappear:
                    NSLog(@"TOP: JLDrawerEventViewDidDisappear");
                    break;
                default:
                    break;
            }
        };
    }
    {
        ChildViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ChildViewController"];
        [vc view];
        vc.headerLabel.text = @"BOTTOM";
        vc.block = ^(void){
            [self.bottomDrawerController closeAnimated:YES];
        };
        self.bottomDrawerController = [[JLDrawerController alloc] initWithParentViewController:self
                                                                           childViewController:vc
                                                                                     swipeView:self.bottomSwipeView
                                                                               revealDirection:JLDrawerRevealDirectionBotoomToTop
                                                                             allowSwipeToClose:YES];
    }
    {
        UINavigationController *vc  = [storyboard instantiateViewControllerWithIdentifier:@"MyNavigationController"];
        self.leftDrawerController = [[JLDrawerController alloc] initWithParentViewController:self
                                                                         childViewController:vc
                                                                                   swipeView:self.leftSwipeView
                                                                             revealDirection:JLDrawerRevealDirectionLeftToRight
                                                                           allowSwipeToClose:YES];
    }
    {
        ChildViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ChildViewController"];
        [vc view];
        vc.headerLabel.text = @"RIGHT";
        vc.block = ^(void){
            [self.rightDrawerController closeAnimated:YES];
        };
        self.rightDrawerController = [[JLDrawerController alloc] initWithParentViewController:self
                                                                          childViewController:vc
                                                                                    swipeView:self.rightSwipeView
                                                                              revealDirection:JLDrawerRevealDirectionRightToLeft
                                                                            allowSwipeToClose:YES];
    }
}

#pragma mark - IBAction

- (IBAction)leftArrowButtonTapped:(id)sender
{
    [self.rightDrawerController openAnimated:YES];
}
- (IBAction)rightArrowButtonTapped:(id)sender
{
    [self.leftDrawerController openAnimated:YES];
}
- (IBAction)upArrowButtonTapped:(id)sender
{
    [self.bottomDrawerController openAnimated:YES];
}
- (IBAction)downArrowButtonTapped:(id)sender
{
    [self.topDrawerController openAnimated:YES];
}

@end
