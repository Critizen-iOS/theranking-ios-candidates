//
//  FHDAppInitializer.m
//  500px Diver
//
//  Created by Jaime on 25/10/14.
//  Copyright (c) 2014 Jaime Aranaz. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FHDAppInitializer.h"
#import "FHDPopularInteractor.h"
#import "FHDPopularDataManager.h"
#import "FHDPopularPresenter.h"
#import "FHDPopularWireframe.h"
#import "FHDWebService.h"
#import "FHDPersistantStore.h"
#import "FHDDataConnectionAvailability.h"
#import "FHDDetailDataManager.h"
#import "FHDDetailInteractor.h"
#import "FHDDetailPresenter.h"
#import "FHDDetailWireframe.h"

@interface FHDAppInitializer()

@property (nonatomic, strong) FHDPopularWireframe *popularWireframe;

@end

@implementation FHDAppInitializer

- (id)init
{
    if ((self = [super init]))
    {
        [self initializeApp];
    }
    
    return self;
}

- (void)installRootViewControllerIntoWindow:(UIWindow *)window
{
    UINavigationController *nav = [[UINavigationController alloc] init];
    window.rootViewController = nav;
}

// Initializes and connects all the actors for VIPER pattern design
- (void)initializeApp
{
    // "Show popular items"
    
    FHDWebService *webService = [[FHDWebService alloc] init];
    FHDPopularDataManager *popularDataManager = [[FHDPopularDataManager alloc] init];
    FHDPopularInteractor *popularInteractor = [[FHDPopularInteractor alloc] init];
    FHDPopularPresenter *popularPresenter = [[FHDPopularPresenter alloc] init];
    _popularWireframe = [[FHDPopularWireframe alloc] init];
    FHDPersistantStore *persistantStore = [[FHDPersistantStore alloc] init];
    
    if ([FHDDataConnectionAvailability isDataSourceAvailable]) {
        [persistantStore deleteAll];
    }
    popularDataManager.webService = webService;
    popularDataManager.persistantStore = persistantStore;
    
    popularInteractor.dataManager = popularDataManager;
    
    popularPresenter.popularInteractor = popularInteractor;
    popularPresenter.popularWireframe = _popularWireframe;
    popularPresenter.viewInterface = [_popularWireframe getViewInterface];

    [_popularWireframe setPopularPresenter:popularPresenter];
    
    // "Show item details"
    
    FHDDetailDataManager *detailDataManager = [[FHDDetailDataManager alloc] init];
    FHDDetailInteractor *detailInteractor = [[FHDDetailInteractor alloc] init];
    FHDDetailPresenter *detailPresenter = [[FHDDetailPresenter alloc] init];
    FHDDetailWireframe *detailWireframe = [[FHDDetailWireframe alloc] init];
    
    detailDataManager.webService = webService;
    detailDataManager.persistantStore = persistantStore;
    
    detailInteractor.dataManager = detailDataManager;
    
    detailPresenter.detailInteractor = detailInteractor;
    detailPresenter.viewInterface = [detailWireframe getViewInterface];
    
    detailWireframe.detailPresenter = detailPresenter;
    _popularWireframe.detailWireframe = detailWireframe;
    
    [popularPresenter configureViewInterface];
}

- (UIViewController *)getRootViewController
{
    return [_popularWireframe getViewController];
}

@end
