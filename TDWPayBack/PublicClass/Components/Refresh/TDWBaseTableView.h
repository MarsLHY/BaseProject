//
//  TDBaseTableView.h
//  TuanDaiV4
//
//  Created by ZhengRuSong on 17/1/13.
//  Copyright © 2017年 Dee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDWBaseTableView : UITableView


@property (assign ,nonatomic) BOOL isRefreshing;

- (void)addHeaderRefreshWithCallBack:(void(^)(void))callBack;

- (void)beginRefresh;

-(void)endRefresh;

@end
