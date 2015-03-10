//
//  LoadPictureDetailsInteractor.h
//  theranking-ios-candidates
//
//  Created by ANTONIO JIMÉNEZ MARTÍNEZ on 10/3/15.
//  Copyright (c) 2015 antjimar. All rights reserved.
//

#import "BaseInteractor.h"
@class PictureEntity;

@interface LoadPictureDetailsInteractor : BaseInteractor
- (void)showDetailsForPicture:(PictureEntity *)picture withCompletionBlock:(void(^)(PictureEntity *pictureWithDetails))completion;
@end
