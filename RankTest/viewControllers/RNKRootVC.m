//
//  RNKRootVC.m
//  RankTest
//
//  Created by Rafael Bartolome on 26/11/14.
//  Copyright (c) 2014 www.rafaelbartolome.es. All rights reserved.
//

#import "RNKRootVC.h"
#import "RNKPicturesCollectionVC.h"
#import "RNKNavigationControllerDelegate.h"
#import "RNKConstants.h"

@interface RNKRootVC () <UINavigationControllerDelegate> {

    RNKNavigationControllerDelegate *navigationControllerDelegate;

}

@property (strong, nonatomic) UINavigationController *rootNavigationController;

@end

@implementation RNKRootVC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor redColor];

    [self loadPictureCollection];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UINavigationController*) rootNavigationController {

    if (!_rootNavigationController) {

        UIViewController *rootNavigationViewController = [[UIViewController alloc] init];
        _rootNavigationController = [[UINavigationController alloc] initWithRootViewController: rootNavigationViewController];
        _rootNavigationController.navigationBar.hidden = YES;

        if (!navigationControllerDelegate) {
            navigationControllerDelegate = [[RNKNavigationControllerDelegate alloc] init];
        }
        _rootNavigationController.delegate = self;

        [self.view addSubview: _rootNavigationController.view];
    }

    return _rootNavigationController;
}

- (void) loadPictureCollection {

    RNKPicturesCollectionVC *picturesCollectionVC = [[RNKPicturesCollectionVC alloc] initWithNibName:@"RNKPicturesCollectionVC" bundle:nil];

    //TODO: Init collection

    [self.rootNavigationController pushViewController: picturesCollectionVC animated: NO];


}





#pragma mark UINavigationControllerDelegate methods

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {


    //TODO:

    if (operation == UINavigationControllerOperationPush) {
        DLog(@"Push");

    }

    if (operation == UINavigationControllerOperationPop) {
        DLog(@"Pop");

    }
    
    
    return nil;
}


@end
