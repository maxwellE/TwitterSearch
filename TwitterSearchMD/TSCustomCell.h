//
//  TSCustomCell.h
//  TwitterSearchMD
//
//  Created by Maxwell Elliott on 11/5/12.
//  Copyright (c) 2012 Maxwell Elliott. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSCustomCell : UITableViewCell{
    IBOutlet UILabel *tweetLabel;
    IBOutlet UILabel *posterLabel;
}
@property (nonatomic,retain) UILabel *tweetLabel;
@property (nonatomic,retain) UILabel *posterLabel;

@end
