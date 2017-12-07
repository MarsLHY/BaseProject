//
//  TDPageTableView.h
//  TDTableViewproject
//
//  Created by AndreaArlex on 16/12/17.
//  Copyright © 2016年 AndreaArlex. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, TDRefreshStyle) {
    TDRefreshHeaderStyle = 1 << 0, //开启下拉刷新功能
    TDRefreshFooterStyle = 1 << 1, //开启上拉加载功能
};

@class TDWPageTableView;
@protocol TDTableViewDelegate <NSObject>

@optional

/**
 下拉刷新回调

 @param tableView Self
 @param pageIndex 请求索引页
 */
- (void)tableView:(TDWPageTableView *)tableView beginHeaderRefreshWithPageIndex:(NSInteger)pageIndex;


/**
 上拉加载

 @param tableView Self
 @param pageIndex 请求索引页
 */
- (void)tableView:(TDWPageTableView *)tableView beginFooterRefreshWithPageIndex:(NSInteger)pageIndex;

@end

@interface TDWPageTableView : UITableView


@property (nonatomic, assign) id<TDTableViewDelegate> refreshDelegate;

@property (nonatomic, assign) TDRefreshStyle refreshStyle;

/**
 当前分页
 */
@property (nonatomic, assign, readonly) NSInteger pageIndex;

/** 忽略多少scrollView的contentInset的top */
@property (assign, nonatomic) CGFloat ignoredScrollViewContentInsetTop;

/**
 增加一个请求成功的信号

 @param pageSize    一页的数据个数
 @param resultCount 当前结果获得的数据个数   如果当前结果数据个数小于一页的个数，那就说明，没有下一页了
 */
- (void)addAnSemaphoreSuccessedSignalWithPageSize:(NSInteger)pageSize resultCount:(NSInteger)resultCount;

/**
 发送一个请求失败的信号
 */
- (void)addAnSemaphoreFailed;

/**
 自动下拉刷新
 */
- (void)headerRefreshAuto;

/**
 重置页数（重新加载页面或者获取新的数据的时候使用）
 */
- (void)resetPageIndex;

@end
