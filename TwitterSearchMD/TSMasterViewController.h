//
//  TSMasterViewController.h
//  TwitterSearchMD
//
//  Created by Maxwell Elliott on 10/27/12.
//  Copyright (c) 2012 Maxwell Elliott. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSTweet.h"

@interface TSMasterViewController : UITableViewController
{
    NSMutableArray *searchResults;
    NSString *savedSearchTerm;
    NSMutableData *data;
}
@property (nonatomic, retain) NSMutableArray *searchResults;
@property (nonatomic, retain) NSMutableData *data;
@property (nonatomic, copy) NSString *savedSearchTerm;


- (void)handleSearchForTerm:(NSString *)searchTerm;
+(NSString*)encodeURL:(NSString *)string;


@end
