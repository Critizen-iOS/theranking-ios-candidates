//
//  RNKPicturePushAnimationController.m
//  RankTest
//
//  Created by Rafael Bartolome on 27/11/14.
//  Copyright (c) 2014 www.rafaelbartolome.es. All rights reserved.
//

#import "RNKPicturePushAnimationController.h"
#import "RNKPicturesCollectionVC.h"

@implementation RNKPicturePushAnimationController

- (NSTimeInterval)transitionDuration: (id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {

    //Prepare views
    UIView* containerView = [transitionContext containerView];

    UIViewController *collectionVC = [transitionContext viewControllerForKey: UITransitionContextFromViewControllerKey];
    UIView *collectionView =[ collectionVC.view snapshotViewAfterScreenUpdates: NO];

    UIViewController *pictureVC = [transitionContext viewControllerForKey: UITransitionContextToViewControllerKey];
    UIView *pictureView = [pictureVC.view snapshotViewAfterScreenUpdates: YES];

    UIImageView *fondoCarbono = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"fondoCarbono"]];

    //frames
    CGRect initialFrame = [transitionContext initialFrameForViewController:collectionVC];
    collectionView.frame = initialFrame;

    fondoCarbono.frame = initialFrame;

    CGRect cellFrame = CGRectZero;

    if ( [collectionVC isKindOfClass: [RNKPicturesCollectionVC class]] ) {

        NSIndexPath *indexCell = [(RNKPicturesCollectionVC*)collectionVC selectedIndexPath];

        UICollectionViewCell *collectionViewCell = [[(RNKPicturesCollectionVC*)collectionVC collectionView] cellForItemAtIndexPath: indexCell];

        cellFrame = CGRectOffset( collectionViewCell.frame, 0, [(RNKPicturesCollectionVC*)collectionVC collectionView].frame.origin.y-[(RNKPicturesCollectionVC*)collectionVC collectionView].contentOffset.y );

    }

    float newWidth= collectionView.frame.size.width * initialFrame.size.width / cellFrame.size.width;
    float newHeight = 400 * initialFrame.size.height / cellFrame.size.height;

    CGPoint newOrigin;

    float scalaX = newWidth / collectionView.frame.size.width ;
    float scalaY = newHeight / collectionView.frame.size.height ;

    newOrigin.x = cellFrame.origin.x * scalaX;
    newOrigin.y = (cellFrame.origin.y * scalaY) - 100;

    newOrigin.x = collectionView.frame.origin.x - newOrigin.x;
    newOrigin.y = collectionView.frame.origin.y - newOrigin.y;

    CGRect newFrame = CGRectMake(newOrigin.x, newOrigin.y, newWidth, newHeight);

    pictureView.frame = cellFrame;
    pictureView.alpha = 0;

    [containerView addSubview: collectionView];
    collectionVC.view.hidden = TRUE;
    [containerView insertSubview: pictureView aboveSubview: collectionView];
    [containerView insertSubview: fondoCarbono belowSubview: collectionView];


    NSTimeInterval duration = [self transitionDuration:transitionContext];

    [UIView animateWithDuration: duration
                     animations:^{

                         // from
                         collectionView.alpha = 1;
                         collectionView.frame = newFrame;
                         // to
                         pictureView.frame = initialFrame;
                         pictureView.alpha = 1;


                     } completion:^(BOOL finished) {
                         // Clean up
                         if (transitionContext.transitionWasCancelled) {
                             //DLog(@"Finish canceled");
                             collectionVC.view.hidden = NO;
                             pictureVC.view.hidden = YES;
                         } else {
                             //DLog(@"Finish completed");
                             collectionVC.view.hidden = NO;
                             pictureVC.view.hidden = NO;
                         }
                         [collectionView removeFromSuperview];
                         [pictureView removeFromSuperview];
                         [fondoCarbono removeFromSuperview];

                         [containerView addSubview: pictureVC.view];
                         
                         // Declare that we've finished
                         [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                     }
     ];
    
    
}


@end
