//
//  LCCircleListViewController.m
//  YYKitDemo
//
//  Created by 李畅 on 2020/7/30.
//  Copyright © 2020 ibireme. All rights reserved.
//

#import "LCCircleListViewController.h"
#import "CircleView.h"
#import "DragImageView.h"
#import "YYKit.h"

@interface LCCircleListViewController ()

@property (nonatomic, strong) CircleView *circleView;
@property (nonatomic, strong) UILabel *headNode;
@property (nonatomic, strong) UILabel *trailNode;

@end

@implementation LCCircleListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.circleView];
    [self.circleView loadView];
    [self.view addSubview:self.headNode];
    [self.view addSubview:self.trailNode];
    // Do any additional setup after loading the view.
}


-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    CGFloat viewWidth = self.view.frame.size.width;

    [self.circleView setFrame:CGRectMake((viewWidth - self.circleView.frame.size.width) / 2 , 20, self.circleView.frame.size.width, self.circleView.frame.size.height)];
    
    [self.headNode setFrame:CGRectMake(self.circleView.center.x - self.headNode.width / 2, self.circleView.bottom + 10, self.headNode.width, self.headNode.height)];
    
    [self.trailNode setFrame:CGRectMake(self.circleView.center.x + 48, self.circleView.bottom, self.trailNode.width, self.trailNode.height)];

}

-(UIColor *)randomColor
{
    return [UIColor colorWithRed:(arc4random()%255) / 255.0 green:(arc4random()%255) / 255.0 blue:(arc4random()%255) / 255.0 alpha:1];
}

-(CircleView *)circleView
{
    if (!_circleView) {
        _circleView = [[CircleView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        _circleView.backgroundColor = [UIColor whiteColor];
        NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:0];
        for (int i = 0; i < 10; i ++) {
            DragImageView *view = [[DragImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
//            [view setImage:[UIImage imageNamed:@"dribbble64_imageio"]];
            view.backgroundColor = [self randomColor];
            [arr addObject:view];
        }
        _circleView.arrImages = arr;
    }
    return _circleView;;
}

-(UILabel *)headNode
{
    if (!_headNode) {
        _headNode = [UILabel new];
        _headNode.numberOfLines = 0;
        _headNode.font = [UIFont systemFontOfSize:14];
        _headNode.text = @"头\n结\n点";
        [_headNode sizeToFit];
    }
    return _headNode;
}

-(UILabel *)trailNode
{
    if (!_trailNode) {
        _trailNode = [UILabel new];
        _trailNode.numberOfLines = 0;
        _trailNode.font = [UIFont systemFontOfSize:14];
        _trailNode.text = @"尾\n结\n点";
        [_trailNode sizeToFit];
    }
    return _trailNode;
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
