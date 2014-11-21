//
//  CZPhotoThumb.h
//  CritizenTest
//
//  Created by Juan Pedro Catalán on 20/11/14.
//  Copyright (c) 2014 Juanpe Catalán. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CZPhotoThumb : NSObject

@property (nonatomic, strong) NSNumber * id;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * url;
@property (nonatomic, strong) NSNumber * rating;

- (id) initWithJSONData:(NSDictionary *) jsonData;

@end
