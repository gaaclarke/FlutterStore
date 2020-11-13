//
//  ViewController.m
//  FlutterStore
//
//  Created by Aaron Clarke on 11/12/20.
//  Copyright © 2020 Aaron Clarke. All rights reserved.
//

#import "ViewController.h"
#import <Flutter/Flutter.h>

static NSString* const kIdentifier = @"FlutterCell";

@interface FlutterCell : UITableViewCell
@property(nonatomic, strong) FlutterViewController* flutterViewController;
@property(nonatomic, strong) FlutterMethodChannel* channel;
@end

@implementation FlutterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    _flutterViewController = [[FlutterViewController alloc] init];
    _flutterViewController.view.frame = self.contentView.bounds;
    _flutterViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.contentView addSubview:_flutterViewController.view];
    _channel = [[FlutterMethodChannel alloc] initWithName:@"cellToHost" binaryMessenger:_flutterViewController.engine.binaryMessenger codec:FlutterStandardMethodCodec.sharedInstance];
    [_channel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
      NSLog(@"buy: %@", call.arguments);
    }];
  }
  return self;
}

@end

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray* names;
@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.names = @[
    @"beans",
    @"ketchup",
    @"bbq sause",
    @"chicken",
    @"pork chops",
    @"chips",
    @"cookies",
  ];

  [_scroller registerClass:[FlutterCell class] forCellReuseIdentifier:kIdentifier];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  FlutterCell* cell = [_scroller dequeueReusableCellWithIdentifier:kIdentifier];
  NSString* name = _names[indexPath.item % _names.count];
  NSNumber* price = @((indexPath.item * 61 % 1000) + 100);
  [cell.channel invokeMethod:@"setItem" arguments:@[@(indexPath.item), name, price]];
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 100.0f;
}

@end
