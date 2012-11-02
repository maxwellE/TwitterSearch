//
//  TSTweet.m
//  TwitterSearch
//
//  Created by Maxwell Elliott on 10/27/12.
//  Copyright (c) 2012 Maxwell Elliott. All rights reserved.
//

#import "TSTweet.h"
static NSString *nexturl;
@implementation TSTweet
@synthesize content;
@synthesize poster;
@synthesize profile_url;
+(NSString *)getNextTwitterTweetLink{
    return nexturl;
}
+(void)setNextTwitterTweetLink:(NSString *)link{
    nexturl = link;
}
-(id)initWithPosterContentAndProfileURL:(NSString *)TweetPoster Content:(NSString *)TweetContent ProfileURL:(NSString*)profileURL{
    self  = [super init];
    if (self){
        self.content = TweetContent;
        self.poster = TweetPoster;
        self.profile_url = profileURL;
    }
    return self;
}


@end
