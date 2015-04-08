//
//  ChildViewController.h
//  DrawerDemo
//
//  Created by Joey L. on 4/8/15.
//  Copyright (c) 2015 Joey L. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChildViewControllerBlock)(void);

@interface ChildViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (copy, nonatomic) ChildViewControllerBlock block;

@end
