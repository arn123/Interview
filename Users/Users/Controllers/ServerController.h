//
//  ServerController.h
//  Users
//
//  Created by Archana Nadiger on 09/07/15.
//  Copyright (c) 2015 Archana Nadiger. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Account;

@interface ServerController : NSObject

+ (instancetype)sharedController;
- (NSManagedObjectContext *)mainQueueContext;

- (void)usersWithAccount:(Account *)account completion:(void(^)(NSArray *users, NSError *error))block;

@end
