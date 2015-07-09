//
//  UserTableViewCell.h
//  Users
//
//  Created by Archana Nadiger on 09/07/15.
//  Copyright (c) 2015 Archana Nadiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *displayName;
@property (weak, nonatomic) IBOutlet UILabel *emailId;

@end
