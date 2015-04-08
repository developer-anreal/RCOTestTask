//
//  NewsListInterfaceController.m
//  RCOTestTask
//
//  Created by Anton Serov on 4/9/15.
//  Copyright (c) 2015 hexforge. All rights reserved.
//

#import "ItemInterfaceController.h"
#import "RSSItem.h"

@interface ItemInterfaceController ()

@property (nonatomic, weak) IBOutlet WKInterfaceLabel *tileLabel;

@end

@implementation ItemInterfaceController

- (void)awakeWithContext:(id)context {
  [self.tileLabel setText:((RSSItem *)context).title];
}

@end