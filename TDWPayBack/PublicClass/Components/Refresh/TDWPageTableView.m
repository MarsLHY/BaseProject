//
//  TDPageTableView.m
//  TDTableViewproject
//
//  Created by AndreaArlex on 16/12/17.
//  Copyright © 2016年 AndreaArlex. All rights reserved.
//

#import "TDWPageTableView.h"
#import "TDWCustomRefreshFooter.h"
#import "TDWCustomRefreshHeader.h"
#import <MJRefresh/MJRefresh.h>

@interface TDWPageTableView ()

@property (nonatomic, assign) NSInteger oldPageIndex;
@property (nonatomic, assign) BOOL isHeaderRefresh;

@end

@implementation TDWPageTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {

    if (self = [super initWithFrame:frame style:style]) {
        
        //默认开始页数是第一页
        _pageIndex = 1;
        _oldPageIndex = 0;
    }
    return self;
}

#pragma mark- Getter And Setter

- (void)setRefreshStyle:(TDRefreshStyle)refreshStyle {

    _refreshStyle = refreshStyle;
    
    //下拉刷新
    if (refreshStyle & TDRefreshHeaderStyle) {
        
        [self addHeaderRefresh];
    }
}

- (void)setIgnoredScrollViewContentInsetTop:(CGFloat)ignoredScrollViewContentInsetTop {
    self.mj_header.ignoredScrollViewContentInsetTop = ignoredScrollViewContentInsetTop;
}

- (void)addHeaderRefresh {

    __weak typeof(self) weakSelf = self;
    self.mj_header = [TDWCustomRefreshHeader headerWithRefreshingBlock:^{
        
        weakSelf.isHeaderRefresh = YES;
        weakSelf.mj_footer = nil;
        //重置当前页
        _pageIndex = 1;
        if ([weakSelf.refreshDelegate respondsToSelector:@selector(tableView:beginHeaderRefreshWithPageIndex:)]) {
            
            [weakSelf.refreshDelegate tableView:weakSelf beginHeaderRefreshWithPageIndex:1];
        }
    }];
}

-(void)addFooterRefresh {

    __weak typeof(self) weakSelf = self;
    self.mj_footer = [TDWCustomRefreshFooter footerWithRefreshingBlock:^{
        
        weakSelf.isHeaderRefresh = NO;
        
        //NSAssert((weakSelf.pageIndex - weakSelf.oldPageIndex) == 1 , @"页数不对哦，请检查是否在成功的时候发送了成功的信号量");
        
        if ([weakSelf.refreshDelegate respondsToSelector:@selector(tableView:beginFooterRefreshWithPageIndex:)]) {
            
            [weakSelf.refreshDelegate tableView:weakSelf beginFooterRefreshWithPageIndex:self.pageIndex];
        }
        
    }];
}

- (void)addAnSemaphoreSuccessedSignalWithPageSize:(NSInteger)pageSize resultCount:(NSInteger)resultCount {
    
    if (self.pageIndex == 1) {
        self.isHeaderRefresh = YES;
    }

    self.oldPageIndex = self.pageIndex;
    _pageIndex ++;
    
    if (self.isHeaderRefresh) {
    
        [self.mj_header endRefreshing];
        
        if (self.refreshStyle & TDRefreshFooterStyle) {
            
            //上拉加载
            [self addFooterRefresh];
            
            if (resultCount < pageSize) {
                
                [self.mj_footer endRefreshingWithNoMoreData];
            }
        }
    }else {
    
        //如果当前结果数据个数小于一页的个数，那就说明，没有下一页了
        if (resultCount < pageSize) {
            [self.mj_footer endRefreshingWithNoMoreData];
        }else {
            [self.mj_footer endRefreshing];
        }
    }
}

- (void)addAnSemaphoreFailed {

    if (self.isHeaderRefresh) {
        [self.mj_header endRefreshing];
    }else {
        [self.mj_footer endRefreshing];
    }
}

/**
 自动下拉刷新
 */
- (void)headerRefreshAuto {

    if (self.refreshStyle & TDRefreshHeaderStyle) {
        
        [self.mj_header beginRefreshing];
    }
}

- (void)resetPageIndex {
    //默认开始页数是第一页
    _pageIndex = 1;
    _oldPageIndex = 0;
}

@end
