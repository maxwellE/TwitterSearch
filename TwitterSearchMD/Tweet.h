//
//  Tweet.h
//  TwitterSearchMD
//
//  Created by Maxwell Elliott on 11/5/12.
//  Copyright (c) 2012 Maxwell Elliott. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tweet : NSObject

+ (NSString *)getNextTwitterTweetLink;
+(void)setNextTwitterTweetLink:(NSString *)link;

@property (nonatomic, retain) NSString * tweetPoster;
@property (nonatomic, retain) NSString * tweetPosterImageUrl;
@property (nonatomic, retain) NSString * tweetText;
-(id)initWithPosterContentAndProfileURL:(NSString *)TweetPoster Content:(NSString *)TweetContent ProfileURL:(NSString*)profileURL;
@end
