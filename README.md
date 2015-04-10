# JLDrawerController v1.0.2

## Install

Copy below files into your project. 
```
JLDrawerController.h
JLDrawerController.m
```

## Sample Project

You can find a sample project in the repository.


## Usage

1. import header file `#import "JLDrawerController.h"`
2. set property `@property (strong, nonatomic) JLDrawerController *drawerController;`
3. create instance like below
```
self.drawerController = [[JLDrawerController alloc] initWithParentViewController:self
                                                             childViewController:vc
                                                                      swipeView:self.topSwipeView
                                                                revealDirection:JLDrawerRevealDirectionTopToBottom
                                                              allowSwipeToClose:YES];
```

* Parent View Controller : base view controller
* Child View Controller  : a view controller which will appear or disappear when user swipe.
* Swipe View            : a view which is on base view controller to detect pan gesture.
* Reveal Direction     : Bottom to Top, Top to Bottom, Left to Right, Right to Left
* Allow Swipe to Close : if NO, users cannot close the child view controller by swipe.


Also, you can manually open or close the child view controller by calling below methods
```
- (void)open;
- (void)openAnimated:(BOOL)animated;
- (void)openAnimated:(BOOL)animated completion:(void(^)(void))completion;
- (void)close;
- (void)closeAnimated:(BOOL)animated;
- (void)closeAnimated:(BOOL)animated completion:(void(^)(void))completion;
```


It is possible to receive the event about the child view controller changes.
```
self.myDrawerController.eventHandler = ^(JLDrawerEvent event) {
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
```


## Demo

[![](https://raw.github.com/buhikon/JLDrawerController/master/demo.gif)](https://raw.github.com/buhikon/JLDrawerController/master/demo.gif)


## Issues

Currently, it is NOT support rotation. You should not change the device orientation.


## License

Licensed under the MIT license. You can use the code in your commercial and non-commercial projects.
