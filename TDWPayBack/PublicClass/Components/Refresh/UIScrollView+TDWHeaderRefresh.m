//
//  UIScrollView+TDWHeaderRefresh.m
//  TDWCashLoan
//
//  Created by ZhengRuSong on 2017/8/4.
//  Copyright © 2017年 com.tuandaiwang.www. All rights reserved.
//

#import "UIScrollView+TDWHeaderRefresh.h"
#import <MJRefresh/MJRefresh.h>
#import "TDWCustomRefreshHeader.h"

@implementation UIScrollView (TDWHeaderRefresh)

- (void)tdw_addHeaderRefreshingBlock:(void(^)(void))refreshingBlock {
    self.mj_header = [TDWCustomRefreshHeader headerWithRefreshingBlock:refreshingBlock];
}

- (void)tdw_endHeaderRefreshing {
    [self.mj_header endRefreshing];
}

- (void)tdw_ignoredScrollViewContentInsetTop:(CGFloat)ignoreSpace {
    self.mj_header.ignoredScrollViewContentInsetTop = ignoreSpace;
}
@end
