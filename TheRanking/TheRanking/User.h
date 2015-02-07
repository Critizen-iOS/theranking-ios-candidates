//
//  User.h
//  TheRanking
//
//  Created by Jesús Emilio Fernández de Frutos on 07/02/15.
//  Copyright (c) 2015 Jesús Emilio Fernández de Frutos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * fullname;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * userpic_https_url;
@property (nonatomic, retain) NSManagedObject *photo;

@end
