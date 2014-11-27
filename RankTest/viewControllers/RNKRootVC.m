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
        _rootNavigationController.delegate = navigationControllerDelegate;

        [self.view addSubview: _rootNavigationController.view];
    }

    return _rootNavigationController;
}

- (void) loadPictureCollection {

    RNKPicturesCollectionVC *picturesCollectionVC = [[RNKPicturesCollectionVC alloc] initWithNibName:@"RNKPicturesCollectionVC" bundle:nil];

    [self.rootNavigationController pushViewController: picturesCollectionVC animated: NO];
}


@end
