//
//  ServerController.m
//  Users
//
//  Created by Archana Nadiger on 09/07/15.
//  Copyright (c) 2015 Archana Nadiger. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <RestKit/RestKit.h>
#import "ServerController.h"
#import "Account.h"
#import "User.h"

NSString * const BaseURL = @"http://surya-interview.appspot.com";

@implementation ServerController

+ (instancetype)sharedController
{
    static ServerController *sharedServerController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedServerController = [[self alloc] init];
    });
    return sharedServerController;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self setupRestKit];
        [self setupModels];
    }
    return self;
}

- (void)setupRestKit
{
    // Initialize RestKit
    NSURL *baseURL = [NSURL URLWithString:BaseURL];
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:baseURL];

    // Enable Activity Indicator Spinner
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    // Initialize managed object store
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    objectManager.managedObjectStore = managedObjectStore;
    objectManager.HTTPClient.parameterEncoding = AFJSONParameterEncoding;
    [objectManager setRequestSerializationMIMEType:RKMIMETypeJSON];
    
    /*
     Complete Core Data stack initialization
     */
    [managedObjectStore createPersistentStoreCoordinator];
    NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"Users.sqlite"];
    NSError *error;
    NSPersistentStore *persistentStore = [managedObjectStore addSQLitePersistentStoreAtPath:storePath fromSeedDatabaseAtPath:nil withConfiguration:nil options:nil error:&error];
    NSAssert(persistentStore, @"Failed to add persistent store with error: %@", error);
    
    // Create the managed object contexts
    [managedObjectStore createManagedObjectContexts];
    
    // Configure a managed object cache to ensure we do not create duplicate objects
    managedObjectStore.managedObjectCache = [[RKInMemoryManagedObjectCache alloc] initWithManagedObjectContext:managedObjectStore.persistentStoreManagedObjectContext];
}

- (void)setupModels
{
    RKLogConfigureByName("RestKit/Network*", RKLogLevelTrace);
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    // User
    RKEntityMapping *userMapping = [RKEntityMapping mappingForEntityForName:@"User" inManagedObjectStore:objectManager.managedObjectStore];
    userMapping.identificationAttributes = @[ @"emailId" ];
    [userMapping addAttributeMappingsFromDictionary:@{@"emailId":@"emailId", @"imageUrl":@"imageUrl", @"firstName":@"firstName", @"lastName":@"lastName"}];
    
    RKResponseDescriptor *responseDescriptor1 = [RKResponseDescriptor responseDescriptorWithMapping:userMapping
                                                                                            method:RKRequestMethodAny
                                                                                       pathPattern:nil
                                                                                           keyPath:nil
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [objectManager addResponseDescriptor:responseDescriptor1];
    
    
    RKObjectMapping *userRequestMapping = [RKObjectMapping requestMapping];
    [userRequestMapping addAttributeMappingsFromDictionary:@{@"emailId":@"emailId", @"imageUrl":@"imageUrl", @"firstName":@"firstName", @"lastName":@"lastName"}];
    
    RKRequestDescriptor* requestDesc1 = [RKRequestDescriptor requestDescriptorWithMapping:userRequestMapping objectClass:[User class] rootKeyPath:nil method:RKRequestMethodAny];
    [objectManager addRequestDescriptor:requestDesc1];
    
    
    // Account
    RKEntityMapping *accountMapping = [RKEntityMapping mappingForEntityForName:@"Account" inManagedObjectStore:objectManager.managedObjectStore];
    accountMapping.identificationAttributes = @[@"emailId"];
    [accountMapping addAttributeMappingsFromDictionary:@{@"emailId":@"emailId"}];
    [accountMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"users" toKeyPath:@"users" withMapping:userMapping]];
    
    RKResponseDescriptor *responseDescriptor2 = [RKResponseDescriptor responseDescriptorWithMapping:accountMapping
                                                                      method:RKRequestMethodAny
                                                                 pathPattern:nil
                                                                     keyPath:nil
                                                                 statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [objectManager addResponseDescriptor:responseDescriptor2];
    
    
    RKObjectMapping *accountRequestMapping = [RKObjectMapping requestMapping];
    [accountRequestMapping addAttributeMappingsFromDictionary:@{@"emailId":@"emailId"}];
    
    RKRequestDescriptor* requestDesc2 = [RKRequestDescriptor requestDescriptorWithMapping:accountRequestMapping objectClass:[Account class] rootKeyPath:nil method:RKRequestMethodAny];
    [objectManager addRequestDescriptor:requestDesc2];
    
}

- (NSManagedObjectContext *)mainQueueContext
{
    return [RKManagedObjectStore defaultStore].mainQueueManagedObjectContext;
}

- (void)usersWithAccount:(Account *)account completion:(void(^)(NSArray *users, NSError *error))block
{
    [[RKObjectManager sharedManager] postObject:nil path:@"list" parameters:@{@"emailId":account.emailId} success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        block(mappingResult.dictionary[@"items"], nil);
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        block(nil, error);
    }];
}

@end
