//
//  UserTableViewCell.m
//  Users
//
//  Created by Archana Nadiger on 09/07/15.
//  Copyright (c) 2015 Archana Nadiger. All rights reserved.
//

#import "UserTableViewCell.h"

@implementation UserTableViewCell

- (void)awakeFromNib
{
    self.userImageView.layer.cornerRadius = CGRectGetHeight(self.userImageView.bounds) * 0.5;
    self.userImageView.layer.masksToBounds = YES;
}

@end
