//
//  TSMasterViewController.h
//  TwitterSearchMD
//
//  Created by Maxwell Elliott on 10/27/12.
//  Copyright (c) 2012 Maxwell Elliott. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TSDetailViewController;

@interface TSMasterViewController : UITableViewController

@property (strong, nonatomic) TSDetailViewController *detailViewController;

@end
