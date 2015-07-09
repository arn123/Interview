//
//  Account.m
//  
//
//  Created by Archana Nadiger on 09/07/15.
//
//

#import "Account.h"
#import "User.h"


@implementation Account

@dynamic emailId;
@dynamic users;

- (instancetype)initWithEmailID:(NSString *)emailID context:(NSManagedObjectContext *)context
{
    if (emailID.length && context)
    {
        self = [super initWithEntity:[NSEntityDescription entityForName:@"Account" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
        
        if (self)
        {
            self.emailId = emailID;
            [context save:nil];
        }
        
        return self;
    }
    return nil;
}

@end
