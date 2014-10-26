//
//  FHDPopularWireframe.m
//  500px Diver
//
//  Created by Jaime on 25/10/14.
//  Copyright (c) 2014 Jaime Aranaz. All rights reserved.
//

#import "FHDPopularWireframe.h"
#import "FHDPopularViewController.h"
#import "FHDPopularPresenter.h"

@interface FHDPopularWireframe()

@property (nonatomic, strong) FHDPopularViewController *popularViewController;

@end

@implementation FHDPopularWireframe

- (id)init
{
    self = [super init];
    if (self) {
        _popularViewController = [[FHDPopularViewController alloc] initWithNibName:@"FHDPopularViewController"
                                                                            bundle:[NSBundle mainBundle]];
    }
    
    return self;
}

- (void)setPopularPresenter:(FHDPopularPresenter *)popularPresenter
{
    _popularPresenter = popularPresenter;
    _popularViewController.viewDelegate = popularPresenter;
}

- (id<FHDPopularViewInterface>)getViewInterface
{
    return _popularViewController;
}

- (UIViewController *)getViewController
{
    return _popularViewController;
}

- (void)showDetailInterfaceWithIdentifier:(NSNumber *)identifier
{
    [_detailWireframe showDetailInterfaceInNavigationController:_popularViewController.navigationController
                                                        forItem:identifier];
}

@end
