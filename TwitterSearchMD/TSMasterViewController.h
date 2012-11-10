//
//  TSMasterViewController.h
//  TwitterSearchMD
//
//  Created by Maxwell Elliott on 10/27/12.
//  Copyright (c) 2012 Maxwell Elliott. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "FMDBDataAccess.h"
#import "TSCustomCell.h"
@interface TSMasterViewController : UITableViewController {
    NSMutableArray *searchResults;
    NSMutableData *data;
}
@property (nonatomic, retain) NSMutableArray *searchResults;
@property (nonatomic, retain) NSMutableData *data;


- (void)handleSearchForTerm:(NSString *)searchTerm;
+(NSString*)encodeURL:(NSString *)string;

@end
