//
//  ChildViewController.m
//  DrawerDemo
//
//  Created by Joey L. on 4/8/15.
//  Copyright (c) 2015 Joey L. All rights reserved.
//

#import "ChildViewController.h"

@interface ChildViewController ()

@end

@implementation ChildViewController

- (IBAction)closeButtonTapped:(id)sender {
    if(self.block) {
        self.block();
    }
}

@end
