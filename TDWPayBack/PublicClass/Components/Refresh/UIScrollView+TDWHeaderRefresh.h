//
//  UIScrollView+TDWHeaderRefresh.h
//  TDWCashLoan
//
//  Created by ZhengRuSong on 2017/8/4.
//  Copyright © 2017年 com.tuandaiwang.www. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (TDWHeaderRefresh)

/** 增加下拉刷新的头部*/
- (void)tdw_addHeaderRefreshingBlock:(void(^)(void))refreshingBlock;

/** 停止头部刷新*/
- (void)tdw_endHeaderRefreshing;

/** 忽略多少scrollView的contentInset的top */
- (void)tdw_ignoredScrollViewContentInsetTop:(CGFloat)ignoreSpace;

@end
