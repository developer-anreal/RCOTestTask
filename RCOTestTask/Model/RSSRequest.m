//
//  RSSRequest.m
//  RCOTestTask
//
//  Created by Anton Serov on 3/16/15.
//  Copyright (c) 2015 hexforge. All rights reserved.
//

#import "RSSRequest.h"
#import "RSSItem.h"

@interface RSSRequest() <NSXMLParserDelegate>
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSXMLParser *xmlParser;
@property (nonatomic, strong) NSError *parseError;
@end

@implementation RSSRequest {
  BOOL _isItem;
  BOOL _isTitle;
  BOOL _isContent;
  BOOL _working;
  NSMutableString *_string;
  NSMutableData *_data;
  NSString *_itemTitle;
  NSString *_itemContent;
}

- (instancetype)initWithURL:(NSURL *)url {
  if (self = [super init]) {
    _url = url;
    _xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:_url];
    
    _string = [NSMutableString string];
    _data = [NSMutableData data];
  }
  
  return self;
}

- (BOOL)performing {
  return _working;
}

- (void)loadRSS {
  _working = YES;
  __weak typeof(self) weakSelf = self;
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
    weakSelf.xmlParser.delegate = self;
    [weakSelf.xmlParser parse];
  });
}

- (NSString *)createStringFromRetrievedElement {
  NSString *res = nil;
  if (_data.length > 0) {
    res = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
    _data = [NSMutableData data];
  } else if (_string.length > 0) {
    res = [NSString stringWithUTF8String:_string.UTF8String];
    _string = [NSMutableString string];
  }
  return res;
}

#pragma mark - NSXMLParserDelegate

- (void)parserDidStartDocument:(NSXMLParser *)parser {
  __weak typeof(self) weakSelf = self;
  dispatch_sync(dispatch_get_main_queue(), ^{
    [weakSelf.delegate RSSRequestDidStartRequest:self];
  });
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
  _working = NO;
  __weak typeof(self) weakSelf = self;
  dispatch_sync(dispatch_get_main_queue(), ^{
    [weakSelf.delegate RSSRequestDidEndRequest:self];
  });
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
  __weak typeof(self) weakSelf = self;
  dispatch_sync(dispatch_get_main_queue(), ^{
    [weakSelf.delegate RSSRequest:self didFailureWithError:parseError];
  });
}

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError {
  __weak typeof(self) weakSelf = self;
  dispatch_sync(dispatch_get_main_queue(), ^{
    [weakSelf.delegate RSSRequest:self didFailureWithError:validationError];
  });
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
  if ([elementName isEqualToString:@"item"]) {
    _string = [NSMutableString string];
    _data = [NSMutableData data];
    _isItem = YES;
  }
  if ([elementName isEqualToString:@"title"] && _isItem) {
    _isTitle = YES;
  }
  if ([elementName isEqualToString:@"description"] && _isItem) {
    _isContent = YES;
  }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
  if ([elementName isEqualToString:@"item"]) {
    _isItem = NO;
    if (_itemContent.length > 0 && _itemTitle.length > 0) {
      RSSItem *item = [[RSSItem alloc] initWithTitle:_itemTitle content:_itemContent];
      __weak typeof(self) weakSelf = self;
      dispatch_sync(dispatch_get_main_queue(), ^{
        [weakSelf.delegate RSSRequest:weakSelf didLoadItem:item];
      });
    }
  }
  if ([elementName isEqualToString:@"title"] && _isItem) {
    _isTitle = NO;
    _itemTitle = [self createStringFromRetrievedElement];
  }
  if ([elementName isEqualToString:@"description"] && _isItem) {
    _isContent = NO;
    _itemContent = [self createStringFromRetrievedElement];
  }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
  if (_isItem && (_isTitle || _isContent)) {
    [_string appendString:string];
  }
}

- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock {
  if (_isItem && (_isTitle || _isContent)) {
    [_data appendData:CDATABlock];
  }
}

@end
