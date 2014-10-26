//
//  User.h
//  TheRanking
//
//  Created by Jesús Emilio Fernández de Frutos on 26/10/14.
//  Copyright (c) 2014 Jesús Emilio Fernández de Frutos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * fullname;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * userpic_https_url;
@property (nonatomic, retain) Photo *photo;

@end
