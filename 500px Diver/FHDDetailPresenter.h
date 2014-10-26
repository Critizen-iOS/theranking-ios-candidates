//
//  FHDDetailPresenter.h
//  500px Diver
//
//  Created by Jaime on 25/10/14.
//  Copyright (c) 2014 Jaime Aranaz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FHDDetailViewInterface.h"
#import "FHDDetailInteractor.h"
#import "FHDDetailViewDelegate.h"

// This class represents the Presenter for the use case "Show item details"
// Gets curated data from Interactor and shows it in the View using the Wireframe
// Implements the FHDDetailViewDelegate protocol to receive events from the View
// Uses the FHDDetailViewInterface protocol to send data to the View
@interface FHDDetailPresenter : NSObject <FHDDetailViewDelegate>

@property (nonatomic, strong) FHDDetailInteractor *detailInteractor;
@property (nonatomic, strong) id<FHDDetailViewInterface> viewInterface;

- (void)configureDetailInterfaceForItem:(NSNumber *)identifier;


@end
