//
//  Tweet.m
//  TwitterSearchMD
//
//  Created by Maxwell Elliott on 11/5/12.
//  Copyright (c) 2012 Maxwell Elliott. All rights reserved.
//
static NSString *nexturl;
#import "Tweet.h"


@implementation Tweet

@synthesize tweetPoster;
@synthesize tweetPosterImageUrl;
@synthesize tweetText;
-(id)initWithPosterContentAndProfileURL:(NSString *)TweetPoster Content:(NSString *)TweetContent ProfileURL:(NSString*)ProfileURL{
    self  = [super init];
    if (self){
        self.tweetText = TweetContent;
        self.tweetPosterImageUrl = ProfileURL;
        self.tweetPoster = TweetPoster;
    }
    return self;
}
+(NSString *)getNextTwitterTweetLink{
    return nexturl;
}
+(void)setNextTwitterTweetLink:(NSString *)link{
    nexturl = link;
}
@end
