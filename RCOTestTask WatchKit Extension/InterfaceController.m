//
//  InterfaceController.m
//  RCOTestTask WatchKit Extension
//
//  Created by Anton Serov on 4/7/15.
//  Copyright (c) 2015 hexforge. All rights reserved.
//

#import "InterfaceController.h"
#import "MMWormhole.h"
#import "RSSItem.h"

@interface InterfaceController() {
  MMWormhole *_wormhole;
  NSArray *_news;
}
@end

static int NewsCount = 5;

@implementation InterfaceController

- (void)awakeWithContext:(id)context {
  [super awakeWithContext:context];
  // Configure interface objects here.
  void(^bakeNews)(NSArray *) = ^(NSArray *rawNews) {
    NSMutableArray *_t = [NSMutableArray arrayWithCapacity:NewsCount];
    NSMutableArray *_ids = [@[] mutableCopy];
    int i = 0;
    for (NSDictionary *n in rawNews) {
      if (i >= NewsCount) break;
      RSSItem *item = [[RSSItem alloc] initWithDict:n];
      [_t addObject:item];
      [_ids addObject:@"Item"];
      ++i;
    }
    _news = _t;
    [WKInterfaceController reloadRootControllersWithNames:_ids contexts:_news];
  };
  
  _wormhole = [[MMWormhole alloc] initWithApplicationGroupIdentifier:@"group.com.hexforge.news"
                                                   optionalDirectory:@"news"];
  NSArray *wormNews = [_wormhole messageWithIdentifier:@"news"];
  if (wormNews != nil) {
    bakeNews(wormNews);
  }
  [_wormhole listenForMessageWithIdentifier:@"news" listener:^(id messageObject) {
    bakeNews(messageObject);
  }];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



