//
//  FMDBDataAccess.h
//  TwitterSearchMD
//
//  Created by Maxwell Elliott on 11/7/12.
//  Copyright (c) 2012 Maxwell Elliott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "Tweet.h"
#import "TSAppDelegate.h"
@interface FMDBDataAccess : NSObject
-(NSMutableArray *) getTweets;
-(BOOL) insertTweet:(Tweet *) tweet;
-(void) destroyTweets;
@end
