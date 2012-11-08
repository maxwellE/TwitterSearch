//
//  FMDBDataAccess.m
//  TwitterSearchMD
//
//  Created by Maxwell Elliott on 11/7/12.
//  Copyright (c) 2012 Maxwell Elliott. All rights reserved.
//

#import "FMDBDataAccess.h"


@implementation FMDBDataAccess

-(NSMutableArray *) getTweets
{
    NSString *databaseName = @"Tweets.db";
    NSString *documentsFolder          = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *databaseFullDocumentPath = [documentsFolder stringByAppendingPathComponent:databaseName];
    NSString *databaseFullBundlePath   = [[NSBundle mainBundle] pathForResource:databaseName ofType:@""];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:databaseFullDocumentPath])
    {
        NSAssert([fileManager fileExistsAtPath:databaseFullBundlePath], @"Database not found in bundle");
        
        NSError *error;
        if (![fileManager copyItemAtPath:databaseFullBundlePath toPath:databaseFullDocumentPath error:&error])
            NSLog(@"Unable to copy database from '%@' to '%@': error = %@", databaseFullBundlePath, databaseFullDocumentPath, error);
    }
    NSMutableArray *tweets = [[NSMutableArray alloc]init];
    FMDatabase *db = [FMDatabase databaseWithPath:databaseFullDocumentPath];
    
    [db open];
    NSLog(@"IN GET");
    FMResultSet *results = [db executeQuery:@"SELECT * FROM tweets"];
    while([results next])
    {
        Tweet *tweet = [[Tweet alloc] init];
        
        tweet.tweetText = [results stringForColumn:@"tweetText"];
        tweet.tweetPoster = [results stringForColumn:@"tweetPoster"];
        tweet.tweetPosterImageUrl = [results stringForColumn:@"tweetProfileURL"];
        [tweets addObject:tweet];
        
    }
    
    [db close];
    NSLog(@"count: %d", [tweets count]);
    return tweets;
}
-(BOOL) insertTweet:(Tweet *)tweet
{
    NSString *databaseName = @"Tweets.db";
    NSString *documentsFolder          = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *databaseFullDocumentPath = [documentsFolder stringByAppendingPathComponent:databaseName];
    NSString *databaseFullBundlePath   = [[NSBundle mainBundle] pathForResource:databaseName ofType:@""];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:databaseFullDocumentPath])
    {
        NSAssert([fileManager fileExistsAtPath:databaseFullBundlePath], @"Database not found in bundle");
        
        NSError *error;
        if (![fileManager copyItemAtPath:databaseFullBundlePath toPath:databaseFullDocumentPath error:&error])
            NSLog(@"Unable to copy database from '%@' to '%@': error = %@", databaseFullBundlePath, databaseFullDocumentPath, error);
    }
    FMDatabase *db = [FMDatabase databaseWithPath:databaseFullDocumentPath];

    [db open];
    
    BOOL success =  [db executeUpdate:@"INSERT INTO tweets VALUES (?,?,?)",
                     tweet.tweetText,tweet.tweetPoster,tweet.tweetPosterImageUrl, nil];
    
    [db close];
    NSLog(@"COUNT: %d",[[self getTweets] count]);
    
    return success;
    
}
-(void) destroyTweets{
    NSString *databaseName = @"Tweets.db";
    NSString *documentsFolder          = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *databaseFullDocumentPath = [documentsFolder stringByAppendingPathComponent:databaseName];
    NSString *databaseFullBundlePath   = [[NSBundle mainBundle] pathForResource:databaseName ofType:@""];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:databaseFullDocumentPath])
    {
        NSAssert([fileManager fileExistsAtPath:databaseFullBundlePath], @"Database not found in bundle");
        
        NSError *error;
        if (![fileManager copyItemAtPath:databaseFullBundlePath toPath:databaseFullDocumentPath error:&error])
            NSLog(@"Unable to copy database from '%@' to '%@': error = %@", databaseFullBundlePath, databaseFullDocumentPath, error);
    }
    FMDatabase *db = [FMDatabase databaseWithPath:databaseFullDocumentPath];
    
    [db open];
    
    [db executeUpdate:@"DELETE FROM tweets"];
    
    [db close];
}
@end
