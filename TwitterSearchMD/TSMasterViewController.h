//
//  TSMasterViewController.h
//  TwitterSearchMD
//
//  Created by Maxwell Elliott on 10/27/12.
//  Copyright (c) 2012 Maxwell Elliott. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import <CoreData/CoreData.h>

@interface TSMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>
{
    NSMutableArray *searchResults;
    NSString *savedSearchTerm;
    NSMutableData *data;
    NSString *last_page;
}
@property (nonatomic, retain) NSMutableArray *searchResults;
@property (nonatomic, retain) NSMutableData *data;
@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic, retain) NSString *last_page;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
- (void)handleSearchForTerm:(NSString *)searchTerm;
+(NSString*)encodeURL:(NSString *)string;

@end
