//
//  RNKPicturePopAnimationController.m
//  RankTest
//
//  Created by Rafael Bartolome on 27/11/14.
//  Copyright (c) 2014 www.rafaelbartolome.es. All rights reserved.
//

#import "RNKPicturePopAnimationController.h"
#import "RNKPicturesCollectionVC.h"

@implementation RNKPicturePopAnimationController


- (NSTimeInterval)transitionDuration: (id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {

    //Prepare views
    UIView* containerView = [transitionContext containerView];

    UIViewController *pictureVC = [transitionContext viewControllerForKey: UITransitionContextFromViewControllerKey];
    UIView *pictureView = [pictureVC.view snapshotViewAfterScreenUpdates: NO];
    pictureVC.view.hidden = true;

    UIViewController *collectionVC = [transitionContext viewControllerForKey: UITransitionContextToViewControllerKey];
    UIView *collectionView = [collectionVC.view snapshotViewAfterScreenUpdates: YES];
    collectionView.alpha = 1.0;

    //frames
    CGRect initialFrame = [transitionContext initialFrameForViewController:pictureVC];

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
    newOrigin.y = (cellFrame.origin.y * scalaY)-100;

    newOrigin.x = collectionView.frame.origin.x - newOrigin.x;
    newOrigin.y = collectionView.frame.origin.y - newOrigin.y;

    CGRect newFrame = CGRectMake(newOrigin.x, newOrigin.y, newWidth, newHeight);

    collectionView.frame = newFrame;
    collectionView.alpha = 1;

    pictureView.frame = initialFrame;
    pictureView.alpha = 1;


    [containerView addSubview: collectionView];
    [containerView insertSubview: pictureView aboveSubview: collectionView];


    // 6. Animate
    NSTimeInterval duration = [self transitionDuration:transitionContext];

    [UIView animateWithDuration: duration
                     animations:^{
                         // from
                         pictureView.frame = cellFrame;
                         pictureView.alpha = 0;

                         // to
                         collectionView.alpha = 1;
                         collectionView.frame = initialFrame;

                     } completion:^(BOOL finished) {
                         // Clean up
                         if (transitionContext.transitionWasCancelled) {
                             //DLog(@"Finish canceled");
                             pictureVC.view.hidden = NO;
                             collectionVC.view.hidden = YES;
                         } else {
                             //DLog(@"Finish completed");
                             pictureVC.view.hidden = YES;
                             collectionVC.view.hidden = NO;
                         }
                         [collectionView removeFromSuperview];
                         [pictureView removeFromSuperview];
                         [containerView addSubview: collectionVC.view];
                         // Declare that we've finished
                         [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                     }
     ];
    
}


@end
