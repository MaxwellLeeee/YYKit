//
//  YERootViewController.m
//  YYKitExample
//
//  Created by ibireme on 14-10-13.
//  Copyright (c) 2014 ibireme. All rights reserved.
//

#import "YYRootViewController.h"
#import "YYKit.h"
#import "LCLRUManager.h"

@interface YYRootViewController ()
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *classNames;
@property (nonatomic, strong) LCLRUManager *circleLinkListManager;
@property (nonatomic, strong) YYMemoryCache *yyManager;

@end

@implementation YYRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"YYKit Example";
    self.titles = @[].mutableCopy;
    self.classNames = @[].mutableCopy;
    [self addCell:@"Model" class:@"YYModelExample"];
    [self addCell:@"Image" class:@"YYImageExample"];
    [self addCell:@"Text" class:@"YYTextExample"];
//    [self addCell:@"Utility" class:@"YYUtilityExample"];
    [self addCell:@"Feed List Demo" class:@"YYFeedListExample"];
    [self.tableView reloadData];
    
    //[self log];
}

- (void)log {
    printf("all:%.2f MB   used:%.2f MB   free:%.2f MB   active:%.2f MB  inactive:%.2f MB  wird:%.2f MB  purgable:%.2f MB\n",
           [UIDevice currentDevice].memoryTotal / 1024.0 / 1024.0,
           [UIDevice currentDevice].memoryUsed / 1024.0 / 1024.0,
           [UIDevice currentDevice].memoryFree / 1024.0 / 1024.0,
           [UIDevice currentDevice].memoryActive / 1024.0 / 1024.0,
           [UIDevice currentDevice].memoryInactive / 1024.0 / 1024.0,
           [UIDevice currentDevice].memoryWired / 1024.0 / 1024.0,
           [UIDevice currentDevice].memoryPurgable / 1024.0 / 1024.0);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self log];
    });
}

- (void)addCell:(NSString *)title class:(NSString *)className {
    [self.titles addObject:title];
    [self.classNames addObject:className];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YY"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YY"];
    }
    cell.textLabel.text = _titles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self testYYLinkListMap];
    }else if(indexPath.row == 1){
        [self testCircleLinkList];
    }
    return;
    NSString *className = self.classNames[indexPath.row];
    Class class = NSClassFromString(className);
    if (class) {
        UIViewController *ctrl = class.new;
        ctrl.title = _titles[indexPath.row];
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)testYYLinkListMap
{
    NSTimeInterval start = [[NSDate date] timeIntervalSince1970];
    NSString *data = @"iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii";
    for (int i = 0; i < 100000; i ++) {
        NSString *key = @(i).stringValue;
        [self.yyManager setObject:data forKey:key withCost:data.length * 2];
    }
    NSTimeInterval end = [[NSDate date] timeIntervalSince1970];
    NSLog(@"YYLinkListMap cost = %f", (end - start));
}

-(void)testCircleLinkList
{
    NSTimeInterval start = [[NSDate date] timeIntervalSince1970];
    NSString *data = @"iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii";
    for (int i = 0; i < 100000; i ++) {
        NSString *key = @(i).stringValue;
        [self.circleLinkListManager setObject:data forKey:key withCost:data.length * 2];
    }
    NSTimeInterval end = [[NSDate date] timeIntervalSince1970];
    NSLog(@"CircleLinkList cost = %f", (end - start));
}

#pragma mark - getters

-(LCLRUManager *)circleLinkListManager
{
    if (!_circleLinkListManager) {
        _circleLinkListManager = [[LCLRUManager alloc] init];
        _circleLinkListManager.countLimit = 10;
        _circleLinkListManager.sizeLimit = 10 * 1024 * 1024;
        _circleLinkListManager.autoTrimInterval = 5;
    }
    return _circleLinkListManager;
}

-(YYMemoryCache *)yyManager
{
    if (!_yyManager) {
        _yyManager = [[YYMemoryCache alloc] init];
    }
    return _yyManager;
}

@end
