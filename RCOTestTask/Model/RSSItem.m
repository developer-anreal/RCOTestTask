//
//  RSSItem.m
//  RCOTestTask
//
//  Created by Anton Serov on 3/16/15.
//  Copyright (c) 2015 hexforge. All rights reserved.
//

#import "RSSItem.h"

@implementation RSSItem {
  NSString *_title;
  NSString *_content;
}

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content {
  if (self = [super init]) {
    _title = [title copy];
    _content = [content copy];
    _extended = NO;
  }
  
  return self;
}

- (instancetype)initWithDict:(NSDictionary *)dict {
  if (self = [super init]) {
    _title = dict[@"title"];
    _content = dict[@"content"];
  }
  
  return self;
}

- (NSString *)title {
  return _title;
}

- (NSString *)content {
  return _content;
}

- (NSDictionary *)dictionaryRepresentation {
  return @{@"title": _title, @"content": _content};
}

@end
