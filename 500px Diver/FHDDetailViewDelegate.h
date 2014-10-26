//
//  FHDDetailViewDelegate.h
//  500px Diver
//
//  Created by Jaime on 25/10/14.
//  Copyright (c) 2014 Jaime Aranaz. All rights reserved.
//

#import <Foundation/Foundation.h>

// This protocol is used by the View to send events to the Presenter
// Must be implemented by the Presenter
@protocol FHDDetailViewDelegate <NSObject>

/**
 * Called when user dismisses this View and backs
 */
- (void)userDidSelectBack;

@end
