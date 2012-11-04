//
//  TSCustomTweetCell.h
//  TwitterSearchMD
//
//  Created by Maxwell Elliott on 11/3/12.
//  Copyright (c) 2012 Maxwell Elliott. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSCustomTweetCell : UITableViewCell{
    IBOutlet UILabel *tweetText;
    IBOutlet UILabel *tweetAuthor;
}
@property (nonatomic,retain) IBOutlet UILabel *tweetText;
@property (nonatomic,retain) IBOutlet UILabel *tweetAuthor;

@end
