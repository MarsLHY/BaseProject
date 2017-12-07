//
//  TDBaseTableView.m
//  TuanDaiV4
//
//  Created by ZhengRuSong on 17/1/13.
//  Copyright © 2017年 Dee. All rights reserved.
//

#import "TDWBaseTableView.h"
#import <MJRefresh/MJRefresh.h>
#import "TDWCustomRefreshHeader.h"


@implementation TDWBaseTableView

- (void)addHeaderRefreshWithCallBack:(void(^)(void))callBack {
    
    self.mj_header = [TDWCustomRefreshHeader headerWithRefreshingBlock:^{
        
        if (callBack) {
            callBack();
        }
        
    }];
}

- (BOOL)isRefreshing {
    
    return self.mj_header.isRefreshing;
}


- (void)beginRefresh {
    
    if (self.mj_header) {
        
        [self.mj_header beginRefreshing];
    }
}

-(void)endRefresh {
    
    if (self.mj_header) {
        
        [self.mj_header endRefreshing];
    }
}



@end
