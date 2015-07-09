//
//  User.h
//  
//
//  Created by Archana Nadiger on 09/07/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Account;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * emailId;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) Account *account;

@end
