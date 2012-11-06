//
//  TSCustomCell.m
//  TwitterSearchMD
//
//  Created by Maxwell Elliott on 11/5/12.
//  Copyright (c) 2012 Maxwell Elliott. All rights reserved.
//

#import "TSCustomCell.h"

@implementation TSCustomCell
@synthesize tweetLabel;
@synthesize posterLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
