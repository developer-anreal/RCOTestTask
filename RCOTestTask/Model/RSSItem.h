//
//  RSSItem.h
//  RCOTestTask
//
//  Created by Anton Serov on 3/16/15.
//  Copyright (c) 2015 hexforge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface RSSItem : NSObject

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content;

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *content;
@property (nonatomic, strong) UIImage *sourceImage;
@property (nonatomic) BOOL extended;

@end
