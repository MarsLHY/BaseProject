
//  TDCustomRefreshHeader.m
//  TDTableViewproject
//
//  Created by AndreaArlex on 16/12/17.
//  Copyright © 2016年 AndreaArlex. All rights reserved.
//

#import "TDWCustomRefreshHeader.h"

@interface TDWCustomRefreshHeader ()

@property (nonatomic, weak) UILabel *describLabel;

@property (nonatomic, weak) UIImageView *loadImageView;

@end

@implementation TDWCustomRefreshHeader

-(UILabel *)describLabel {

    if (!_describLabel) {
        
        UILabel *describLabel = [[UILabel alloc] init];
        describLabel.font = [UIFont boldSystemFontOfSize:13];
        describLabel.textColor = MJRefreshColor(153, 153, 153);
        describLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        describLabel.textAlignment = NSTextAlignmentLeft;
        describLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_describLabel = describLabel];
    }
    
    return _describLabel;
}

-(UIImageView *)loadImageView {

    if (!_loadImageView) {
        
        UIImageView *loadImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading_00"]];
        
        [self addSubview:_loadImageView = loadImageView];
        
        
        NSMutableArray *imageArray = [[NSMutableArray alloc] init];
        for (int i = 0; i<27; i++) {
            [imageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"loading_%02d",i]]];
        }
        _loadImageView.animationImages = imageArray;
        _loadImageView.animationDuration = 2;
    }
    
    return _loadImageView;
}

#pragma mark - 覆盖父类的方法
- (void)prepare {
    [super prepare];
}


- (void)placeSubviews {
    [super placeSubviews];
    
    CGFloat arrowCenterY = self.mj_h * 0.5;
//    CGFloat describWidth = self.describLabel.TD_textWith;
    CGFloat describWidth = 80;
    self.describLabel.mj_y = arrowCenterY;
    self.describLabel.mj_x = (self.mj_w - describWidth)/2.0 + 25;
    self.describLabel.mj_h = 15;
    self.describLabel.mj_w = describWidth;
    
    self.loadImageView.frame = CGRectMake(self.describLabel.mj_x - 40, self.describLabel.mj_y - 12, 41, 40);
}


- (void)setState:(MJRefreshState)state {

    MJRefreshCheckState
    switch (state) {
            
            /** 普通闲置状态 */
        case MJRefreshStateIdle:
        {
            self.describLabel.text = @"下拉可以刷新";
            [self.loadImageView stopAnimating];
        }
            break;
            
            /** 松开就可以进行刷新的状态 */
            case MJRefreshStatePulling:
        {
            self.describLabel.text = @"松开立即刷新";
        }
            break;
            
            /** 正在刷新中的状态 */
            case MJRefreshStateRefreshing:
        {
            self.describLabel.text = @"加载中...";
            [self.loadImageView startAnimating];
        }
            break;
            
            /** 即将刷新的状态 */
            case MJRefreshStateWillRefresh:
        {
            self.describLabel.text = @"加载中...";
        }
            break;
            
        default:
        {
            self.describLabel.text = @"";
        }
            break;
    }
}

@end
