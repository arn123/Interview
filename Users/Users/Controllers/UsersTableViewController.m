//
//  UsersTableViewController.m
//  Users
//
//  Created by Archana Nadiger on 09/07/15.
//  Copyright (c) 2015 Archana Nadiger. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "UsersTableViewController.h"
#import "Account.h"
#import "ServerController.h"
#import "User.h"
#import "UserTableViewCell.h"
#import <SVProgressHUD/SVProgressHUD.h>

static void showAlertWithError(NSError *error)
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                                    message:[error localizedDescription]
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    [alert show];
}

@interface UsersTableViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation UsersTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.hidesBackButton = YES;
    self.title = @"Users";
}

- (void)setAccount:(Account *)account
{
    _account = account;
    [self fetchUsers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchUsers
{
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Loading...", nil)];
    [[ServerController sharedController] usersWithAccount:self.account completion:^(NSArray *users, NSError *error) {
    }];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:NO];
    fetchRequest.sortDescriptors = @[descriptor];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"self.account == %@", self.account];
    NSError *error = nil;
    
    // Setup fetched results
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:[[ServerController sharedController] mainQueueContext]
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    [self.fetchedResultsController setDelegate:self];
    BOOL fetchSuccessful = [self.fetchedResultsController performFetch:&error];
    
    if (! fetchSuccessful) {
        showAlertWithError(error);
    }
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController.sections objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell" forIndexPath:indexPath];
    
    // Configure the cell...
    User *user = [self.fetchedResultsController objectAtIndexPath:indexPath];
    UIImageView *imageView = cell.userImageView;
    imageView.layer.cornerRadius = CGRectGetHeight(imageView.bounds) * 0.5;
    imageView.layer.masksToBounds = YES;
    [imageView setImageWithURL:[NSURL URLWithString:user.imageUrl] placeholderImage:[UIImage imageNamed:@"user_placeholder"]];
    
    NSString *displayName = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
    cell.displayName.text = displayName;
    cell.emailId.text = user.emailId;
    
    return cell;
}

#pragma mark NSFetchedResultsControllerDelegate methods

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView reloadData];
    
    [SVProgressHUD dismiss];
}

@end
