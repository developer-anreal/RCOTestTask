//
//  RSSRequest.h
//  RCOTestTask
//
//  Created by Anton Serov on 3/16/15.
//  Copyright (c) 2015 hexforge. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RSSRequestDelegate;
@class RSSItem;

@interface RSSRequest : NSObject

@property (nonatomic, assign) id<RSSRequestDelegate> delegate;
@property (nonatomic, readonly) BOOL performing;

- (instancetype)initWithURL:(NSURL *)url;

- (void)loadRSS;

@end

@protocol RSSRequestDelegate <NSObject>
@optional
- (void)RSSRequest:(RSSRequest *)rssRequest didLoadItem:(RSSItem *)item;
- (void)RSSRequest:(RSSRequest *)rssRequest didFailureWithError:(NSError *)error;
- (void)RSSRequestDidEndRequest:(RSSRequest *)rssRequest;
- (void)RSSRequestDidStartRequest:(RSSRequest *)rssRequest;

@end
