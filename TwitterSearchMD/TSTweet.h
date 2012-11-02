//
//  TSTweet.h
//  TwitterSearch
//
//  Created by Maxwell Elliott on 10/27/12.
//  Copyright (c) 2012 Maxwell Elliott. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSTweet : NSObject
{
    NSString *content;
    NSString *poster;
    NSString *profile_url;
}

@property (retain) NSString *content;
@property (retain) NSString *poster;
@property (retain) NSString *profile_url;
+ (NSString *)getNextTwitterTweetLink;
+(void)setNextTwitterTweetLink:(NSString *)link;
-(id)initWithPosterContentAndProfileURL:(NSString *)TweetPoster Content:(NSString *)TweetContent ProfileURL:(NSString*)profileURL;
@end
