//
//  Account.h
//  
//
//  Created by Archana Nadiger on 09/07/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Account : NSManagedObject

@property (nonatomic, retain) NSString * emailId;
@property (nonatomic, retain) NSSet *users;

- (instancetype)initWithEmailID:(NSString *)emailID context:(NSManagedObjectContext *)context;

@end
