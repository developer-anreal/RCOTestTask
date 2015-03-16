//
//  ViewController.m
//  RCOTestTask
//
//  Created by Anton Serov on 3/16/15.
//  Copyright (c) 2015 hexforge. All rights reserved.
//

#import "RSSFeedViewController.h"
#import "RSSRequest.h"
#import "RSSItem.h"
#import "RSSFeedCell.h"

@interface RSSFeedViewController () <RSSRequestDelegate> {
  NSMutableArray *_feed;
  RSSRequest *_gazetaRequest;
  RSSRequest *_lentaRequest;
  UIImage *_lentaPic;
  UIImage *_gazetaPic;
}

@end

@implementation RSSFeedViewController

static NSString *title = @"RSS Feed";
static NSString *loadTitle = @"Loading...";

- (void)viewDidLoad {
  [super viewDidLoad];
  _lentaPic = [UIImage imageNamed:@"lentaicon"];
  _gazetaPic = [UIImage imageNamed:@"gazetaicon"];
  self.title = title;
  self.tableView.estimatedRowHeight = 44.0;
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  _feed = [NSMutableArray array];
  _gazetaRequest =
    [[RSSRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.gazeta.ru/export/rss/lenta.xml"]];
  _gazetaRequest.delegate = self;
  [_gazetaRequest loadRSS];
  
  _lentaRequest =
    [[RSSRequest alloc] initWithURL:[NSURL URLWithString:@"http://lenta.ru/rss"]];
  _lentaRequest.delegate = self;
  [_lentaRequest loadRSS];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - RSSRequestDelegate impl

- (void)RSSRequest:(RSSRequest *)rssRequest didLoadItem:(RSSItem *)item {
  if ([rssRequest isEqual:_lentaRequest]) {
    item.sourceImage = _lentaPic;
  } else {
    item.sourceImage = _gazetaPic;
  }
  [_feed addObject:item];
  [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_feed.count - 1 inSection:0]]
    withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)RSSRequest:(RSSRequest *)rssRequest didFailureWithError:(NSError *)error {
  NSLog(@"Request failed with error: %@", error);
  self.title = title;
  [[[UIAlertView alloc] initWithTitle:@"" message:@"Could not load RSS feed.\nPlease try again later"
    delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (void)RSSRequestDidEndRequest:(RSSRequest *)rssRequest {
  self.title = title;
}

- (void)RSSRequestDidStartRequest:(RSSRequest *)rssRequest {
  self.title = loadTitle;
}

- (void)configureCell:(RSSFeedCell *)cell atIndexPath:(NSIndexPath *)indexPath {
  RSSItem *item = (RSSItem *)_feed[indexPath.row];
  cell.label.text = item.extended ? item.content : item.title;
  cell.sourceImageView.image = item.sourceImage;
}

#pragma mark - UITableViewDataSource impl

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return _feed.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  RSSFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RSSCellId"];
  [self configureCell:cell atIndexPath:indexPath];
  return cell;
}

#pragma mark - UITableViewDelegate impl

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  ((RSSItem *)_feed[indexPath.row]).extended ^= YES;
  [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
