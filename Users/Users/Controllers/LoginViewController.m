//
//  LoginViewController.m
//  Users
//
//  Created by Archana Nadiger on 09/07/15.
//  Copyright (c) 2015 Archana Nadiger. All rights reserved.
//

#import "LoginViewController.h"
#import "TextFieldValidator.h"
#import "Account.h"
#import "ServerController.h"
#import "UsersTableViewController.h"

#define REGEX_EMAIL @"[A-Z0-9a-z._%+-]{3,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"

@interface LoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet TextFieldValidator *emailIDTF;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.emailIDTF addRegx:REGEX_EMAIL withMsg:@"Enter valid email."];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.emailIDTF validate])
    {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Account"];
        request.predicate = [NSPredicate predicateWithFormat:@"emailId ==[cd] %@", self.emailIDTF.text];
        
        NSError *error = nil;
        NSManagedObjectContext *context = [[ServerController sharedController] mainQueueContext];
        NSArray *objects = [context executeFetchRequest:request error:&error];
        
        if (objects.count)
        {
            Account *existingAccount = objects.firstObject;
            [context deleteObject:existingAccount];
        }
        
        Account *account = [[Account alloc] initWithEmailID:self.emailIDTF.text context:[[ServerController sharedController] mainQueueContext]];
        
        UsersTableViewController *usersVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UsersVC"];
        usersVC.account = account;
        [self.navigationController pushViewController:usersVC animated:YES];
        
    }
    return YES;
}

@end
