//
//  FHDPopularPresenter.m
//  500px Diver
//
//  Created by Jaime on 24/10/14.
//  Copyright (c) 2014 Jaime Aranaz. All rights reserved.
//

#import "FHDPopularPresenter.h"
#import "FHDPopularItem.h"

@interface FHDPopularPresenter()

@property (nonatomic) NSInteger page;

@end
 
@implementation FHDPopularPresenter

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.page = 1;
    }
    
    return self;
}

- (void)configureViewInterface
{
    [_popularInteractor getPopularFromPage:_page
                           completionBlock:^(NSArray *items) {
                                  
                                  // No items
                                  if ((items == nil) || (items.count == 0)) {
                                      // TODO: no items or error in request
                                      
                                  // Items available, update views
                                  } else {
                                      _page++;
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [_viewInterface showPopularItems:items];
                                      });
                                  }
                              }];
}

#pragma mark - FHDPopularViewDelegate

// Called when user selects an item in View
// Shows new View with details
- (void)popularDidSelectItem:(FHDPopularItem *)item
{
    [_popularWireframe showDetailInterfaceWithIdentifier:item.identifier];
}

// Called when user reaches the end of collection view
// Requests for more data and sends it to the View
- (void)popularDidEndScroll
{
    [self configureViewInterface];
}

@end
