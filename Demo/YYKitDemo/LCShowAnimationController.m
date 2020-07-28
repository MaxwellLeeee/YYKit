//
//  LCShowAnimationController.m
//  YYKitDemo
//
//  Created by 李畅 on 2020/7/27.
//  Copyright © 2020 ibireme. All rights reserved.
//

#import "LCShowAnimationController.h"

#define kCubeSize (30.0)
#define kCubeGap (20.0)
#define kCubeMargin (40.0)
#define kLineHeight (1.0)


@interface LCShowAnimationController ()


@property (nonatomic, strong) NSMutableArray *lineArr;
@property (nonatomic, strong) NSMutableArray *viewArr;

@property (nonatomic, strong) UILabel *checkLabel;
@property (nonatomic, strong) UILabel *searchLabel;

@property (nonatomic, strong) UIButton *insertButton;
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) UIButton *deleteButton;

@end

@implementation LCShowAnimationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    for (int i = 0; i < 4; i++) {
        UIView *view = [self randomView];
        [view setFrame:CGRectMake(kCubeMargin + i * (kCubeGap + kCubeSize), 100, kCubeSize, kCubeSize)];
        [self.view addSubview:view];
        [self.viewArr addObject:view];
    }
    [self drawSingleLine];
//    [self drawTwoLines];
    [self makeActionButtons];
    // Do any additional setup after loading the view.
}

-(void)makeActionButtons
{
    NSMutableArray *buttonArr = [[NSMutableArray alloc] initWithCapacity:0];
    [buttonArr addObject:self.insertButton];
    [buttonArr addObject:self.searchButton];
    [buttonArr addObject:self.deleteButton];
    CGFloat width = [UIScreen mainScreen].bounds.size.width / buttonArr.count;
    CGFloat height = 40;
    for (int i = 0; i < buttonArr.count; i ++) {
        UIButton *button = [buttonArr objectAtIndex:i];
        [button setFrame:CGRectMake(width * i, [UIScreen mainScreen].bounds.size.height - 40, width, height)];
        [self.view addSubview:button];
    }
}

-(UIView *)randomView
{
    UIView *view = [UIView new];
    view.backgroundColor = [self randomColor];
    return view;
}

-(UIColor *)randomColor
{
    return [UIColor colorWithRed:(arc4random()%255) / 255.0 green:(arc4random()%255) / 255.0 blue:(arc4random()%255) / 255.0 alpha:1];
}

-(void)drawSingleLine
{
    CGPoint lastViewCenter = CGPointZero;
    for (UIView *view in self.viewArr) {
        CGPoint endPoint = view.center;
        if (!CGPointEqualToPoint(lastViewCenter, CGPointZero)) {
            [self drawLineFromPoint:CGPointMake(lastViewCenter.x + view.bounds.size.width / 2, lastViewCenter.y) toPoint:CGPointMake(endPoint.x - view.bounds.size.width / 2, endPoint.y)];
        }
        lastViewCenter = endPoint;
    }
}

-(void)drawTwoLines
{
    CGPoint lastViewTopAnchor = CGPointZero;
    CGPoint lastViewBottomAnchor = CGPointZero;
    for (UIView *view in self.viewArr) {
        CGPoint firstPoint = CGPointMake(view.center.x, view.frame.origin.y + view.bounds.size.height / 3);
        CGPoint secondPoint = CGPointMake(view.center.x, view.frame.origin.y + view.bounds.size.height * 2 / 3);
        if (!CGPointEqualToPoint(lastViewTopAnchor, CGPointZero)) {
            [self drawLineFromPoint:CGPointMake(lastViewTopAnchor.x + view.bounds.size.width / 2, lastViewTopAnchor.y) toPoint:CGPointMake(firstPoint.x - view.bounds.size.width / 2, firstPoint.y)];
        }
        if (!CGPointEqualToPoint(lastViewBottomAnchor, CGPointZero)) {
            [self drawLineFromPoint:CGPointMake(lastViewBottomAnchor.x + view.bounds.size.width / 2, lastViewBottomAnchor.y) toPoint:CGPointMake(secondPoint.x - view.bounds.size.width / 2, secondPoint.y)];
        }
        lastViewTopAnchor = firstPoint;
        lastViewBottomAnchor = secondPoint;
    }
}

-(void)drawLineFromIndex:(NSInteger)startIndex toIndex:(NSInteger)endIndex
{
    UIView *startView = [self.viewArr objectAtIndex:startIndex];
    UIView *endView = [self.viewArr objectAtIndex:endIndex];
    [self drawLineFromPoint:CGPointMake(startView.center.x + startView.bounds.size.width / 2, startView.center.y) toPoint:CGPointMake(endView.center.x - endView.bounds.size.width / 2, endView.center.y)];
}

-(void)drawLineFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint
{
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor lightGrayColor];
    CGFloat x = startPoint.x;
    CGFloat y = startPoint.y - kLineHeight / 2;
    CGFloat width = endPoint.x - startPoint.x;
    CGFloat height = kLineHeight;
    [line setFrame:CGRectMake(x, y, width, height)];
    [self.view addSubview:line];
    [self.lineArr addObject:line];
}

-(void)insertViewAtHeader:(UIView *)insertView
{
    UIView *firstView = self.viewArr.firstObject;
    CGRect targetRect = firstView.frame;
    for (UIView *view in self.viewArr) {
        [UIView animateWithDuration:0.3 animations:^{
            [view setFrame:CGRectMake(view.frame.origin.x + kCubeSize + kCubeGap, view.frame.origin.y, view.frame.size.width, view.frame.size.height)];
        } completion:nil];
    }
    for (UIView *view in self.lineArr) {
        [UIView animateWithDuration:0.3 animations:^{
            [view setFrame:CGRectMake(view.frame.origin.x + kCubeSize + kCubeGap, view.frame.origin.y, view.frame.size.width, view.frame.size.height)];
        } completion:nil];
    }
    [UIView animateWithDuration:0.3 animations:^{
        [insertView setFrame:targetRect];
    } completion:^(BOOL finished) {
        [insertView setFrame:targetRect];
        [self drawLineFromPoint:CGPointMake(insertView.center.x + insertView.bounds.size.width / 2, insertView.center.y) toPoint:CGPointMake(firstView.center.x - firstView.bounds.size.width / 2, firstView.center.y)];
    }];
}

-(void)deleteTrailViewWithLabel:(UILabel *)label
{
    UIView *lastView = self.viewArr.lastObject;
    UIView *line = self.lineArr.lastObject;
    [lastView removeFromSuperview];
    [line removeFromSuperview];
    [self.viewArr removeObject:lastView];
    [self.lineArr removeObject:line];
    [UIView animateWithDuration:0.3 animations:^{
        [self moveCheckLabelToLastView];
        self.checkLabel.textColor = [UIColor blackColor];
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.checkLabel.textColor = [UIColor greenColor];
        });
    }];
}

-(void)moveCheckLabelToLastView
{
    UIView *lastView = self.viewArr.lastObject;
    CGRect frame = self.checkLabel.frame;
    frame.origin.x = lastView.frame.origin.x;
    frame.origin.y = CGRectGetMaxY(lastView.frame) + 20;
    self.checkLabel.frame = frame;
}

-(void)moveSearchLabelToIndex:(NSInteger)index
{
    UIView *cube = [self.viewArr objectAtIndex:index];
    CGRect frame = self.searchLabel.frame;
    frame.origin.x = cube.frame.origin.x;
    frame.origin.y = CGRectGetMaxY(cube.frame) + 20;
    self.searchLabel.frame = frame;
}

-(void)bringViewToHead:(UIView *)cube
{
    NSInteger index = [self.viewArr indexOfObject:cube];
    UIView *preLine = [self.lineArr objectAtIndex:index - 1];
    UIView *nextLine = [self.lineArr objectAtIndex:index];
    
    [preLine removeFromSuperview];
    [nextLine removeFromSuperview];
    
    CGRect frame = cube.frame;
    [UIView animateWithDuration:0.5 animations:^{
        [cube setFrame:CGRectMake(frame.origin.x, frame.origin.y + kCubeSize + 20, frame.size.width, frame.size.height)];
    } completion:^(BOOL finished) {
        UIView *firstView = self.viewArr.firstObject;
        CGRect firstRect = firstView.frame;
        for (int i = 0; i < index; i ++) {
            UIView *tempView = self.viewArr[i];
            CGRect tempFrame = tempView.frame;
            [UIView animateWithDuration:0.5 animations:^{
                [tempView setFrame:CGRectMake(tempFrame.origin.x + kCubeSize + kCubeGap, tempFrame.origin.y, tempFrame.size.width, tempFrame.size.height)];
            } completion:^(BOOL finished) {
                
            }];
            UIView *lineView = self.lineArr[i];
            CGRect lineFrame = lineView.frame;
            [UIView animateWithDuration:0.5 animations:^{
                [lineView setFrame:CGRectMake(lineFrame.origin.x + kCubeSize + kCubeGap, lineFrame.origin.y, lineFrame.size.width, lineFrame.size.height)];
            } completion:^(BOOL finished) {
                
            }];
        }
        [UIView animateWithDuration:0.5 animations:^{
            [cube setFrame:CGRectMake(firstRect.origin.x, firstRect.origin.y + kCubeSize + 20, frame.size.width, frame.size.height)];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                [cube setFrame:CGRectMake(firstRect.origin.x, firstRect.origin.y, frame.size.width, frame.size.height)];
            } completion:^(BOOL finished) {
                [self.viewArr removeObject:cube];
                [self.viewArr insertObject:cube atIndex:0];
                [self drawLineFromIndex:0 toIndex:1];
                [self drawLineFromIndex:index toIndex:index + 1];
            }];
        }];
    }];
}

#pragma mark - events

-(void)insertButtonClick:(UIButton *)button
{
    UIView *view = [self randomView];
    UIView *firstView = self.viewArr.firstObject;
    [view setFrame:CGRectMake(firstView.frame.origin.x, CGRectGetMaxY(firstView.frame) + 20, kCubeSize, kCubeSize)];
    [self.view addSubview:view];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self insertViewAtHeader:view];
    });
}

-(void)searchButtonClick:(UIButton *)button
{
    [self.view addSubview:self.searchLabel];
    [self moveSearchLabelToIndex:0];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.searchLabel.text = @"不是";
        self.searchLabel.textColor = [UIColor redColor];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.searchLabel.text = @"查找";
        self.searchLabel.textColor = [UIColor blackColor];
        [UIView animateWithDuration:0.5 animations:^{
            [self moveSearchLabelToIndex:1];
        } completion:^(BOOL finished) {
            
        }];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.searchLabel.text = @"不是";
        self.searchLabel.textColor = [UIColor redColor];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.searchLabel.text = @"查找";
        self.searchLabel.textColor = [UIColor blackColor];
        [UIView animateWithDuration:0.5 animations:^{
            [self moveSearchLabelToIndex:2];
        } completion:^(BOOL finished) {
            
        }];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.searchLabel.text = @"是";
        self.searchLabel.textColor = [UIColor greenColor];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.searchLabel removeFromSuperview];
        [self bringViewToHead:self.viewArr[2]];
      });
}

-(void)deleteButtonClick:(UIButton *)button
{
    [self.view addSubview:self.checkLabel];
    [self moveCheckLabelToLastView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.checkLabel.textColor = [UIColor redColor];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self deleteTrailViewWithLabel:self.checkLabel];
    });
}

#pragma mark - getters

-(UILabel *)checkLabel
{
    if (!_checkLabel) {
        _checkLabel = [UILabel new];
        _checkLabel.textColor = [UIColor blackColor];
        _checkLabel.numberOfLines = 0;
        _checkLabel.text = @"检查尾节点\n更新时间\n总数量\n总大小";
        _checkLabel.font = [UIFont systemFontOfSize:14];
        [_checkLabel sizeToFit];
    }
    return _checkLabel;
}

-(NSMutableArray *)lineArr
{
    if (!_lineArr) {
        _lineArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _lineArr;
}

-(NSMutableArray *)viewArr
{
    if (!_viewArr) {
        _viewArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _viewArr;
}

-(UIButton *)insertButton
{
    if (!_insertButton) {
        _insertButton = [UIButton new];
        _insertButton.backgroundColor = [self randomColor];
        [_insertButton setTitle:@"增加" forState:UIControlStateNormal];
        [_insertButton addTarget:self action:@selector(insertButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _insertButton;;
}

-(UIButton *)searchButton
{
    if (!_searchButton) {
        _searchButton = [UIButton new];
        _searchButton.backgroundColor = [self randomColor];
        [_searchButton setTitle:@"查找" forState:UIControlStateNormal];
        [_searchButton addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchButton;
}

-(UIButton *)deleteButton
{
    if (!_deleteButton) {
        _deleteButton = [UIButton new];
        _deleteButton.backgroundColor = [self randomColor];
        [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

-(UILabel *)searchLabel
{
    if (!_searchLabel) {
        _searchLabel = [UILabel new];
        _searchLabel.textColor = [UIColor blackColor];
        _searchLabel.numberOfLines = 0;
        _searchLabel.text = @"查找";
        _searchLabel.font = [UIFont systemFontOfSize:14];
        [_searchLabel sizeToFit];
    }
    return _searchLabel;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
