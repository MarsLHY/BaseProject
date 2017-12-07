//
//  TDCustomRefreshFooter.m
//  TDTableViewproject
//
//  Created by AndreaArlex on 16/12/18.
//  Copyright © 2016年 AndreaArlex. All rights reserved.
//

#import "TDWCustomRefreshFooter.h"

@interface TDWCustomRefreshFooter () {

    /** 显示刷新状态的label */
    __unsafe_unretained UILabel *_stateLabel;
}

@property (nonatomic, weak) UILabel *describLabel;

@property (weak, nonatomic) UIActivityIndicatorView *loadingView;

/** 所有状态对应的文字 */
@property (strong, nonatomic) NSMutableDictionary *stateTitles;



@end

@implementation TDWCustomRefreshFooter

- (NSMutableDictionary *)stateTitles
{
    if (!_stateTitles) {
        self.stateTitles = [NSMutableDictionary dictionary];
    }
    return _stateTitles;
}

- (UILabel *)stateLabel
{
    if (!_stateLabel) {
        [self addSubview:_stateLabel = [UILabel mj_label]];
    }
    return _stateLabel;
}

#pragma mark - 公共方法
- (void)setTitle:(NSString *)title forState:(MJRefreshState)state
{
    if (title == nil) return;
    self.stateTitles[@(state)] = title;
    self.stateLabel.text = self.stateTitles[@(self.state)];
}

-(UILabel *)describLabel {

    if (!_describLabel) {
        
        UILabel *describLabel = [[UILabel alloc] init];
        describLabel.font = [UIFont boldSystemFontOfSize:13];
        describLabel.textColor = MJRefreshLabelTextColor;
        describLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        describLabel.textAlignment = NSTextAlignmentCenter;
        describLabel.backgroundColor = [UIColor clearColor];
        describLabel.text = @"加载中...";
        [self addSubview:_describLabel = describLabel];
    }
    
    return _describLabel;
}

- (UIActivityIndicatorView *)loadingView {

    if (!_loadingView) {
        
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        loadingView.hidesWhenStopped = YES;
        [self addSubview:_loadingView = loadingView];
    }
    
    return _loadingView;
}

#pragma mark - 重写父类的方法
- (void)prepare
{
    [super prepare];

    // 初始化文字
    [self setTitle:@"上拉可以加载更多" forState:MJRefreshStateIdle];
    [self setTitle:@"松开立即加载更多" forState:MJRefreshStatePulling];
    [self setTitle:@"" forState:MJRefreshStateNoMoreData];
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    CGFloat centerY = self.mj_h * 0.5;
    CGFloat decribWidth = self.describLabel.mj_textWith;
    self.describLabel.mj_x = (self.mj_w - decribWidth) *0.5 + + 25 * 0.5;
    self.describLabel.mj_y = centerY;
    self.describLabel.mj_h = 15;
    self.describLabel.mj_w = decribWidth;
    
    self.loadingView.frame = CGRectMake(self.describLabel.mj_x - 25, self.describLabel.mj_y - 2, 20, 20);
    
    // 状态标签
    self.stateLabel.frame = self.bounds;
    
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    // 根据状态做事情
    if (state == MJRefreshStateNoMoreData || state == MJRefreshStateIdle) {
        [self.loadingView stopAnimating];
        self.loadingView.hidden = YES;
        self.describLabel.hidden = YES;
    } else if (state == MJRefreshStateRefreshing) {
        self.loadingView.hidden = NO;
        self.describLabel.hidden = NO;
        [self.loadingView startAnimating];
    }
    
    if (state == MJRefreshStateRefreshing) {
        self.stateLabel.text = nil;
    } else {
        self.stateLabel.text = self.stateTitles[@(state)];
    }
}

@end
