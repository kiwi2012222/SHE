//
//  UIScrollView+Refresh.m
//  KWSHE
//
//  Created by kiwi on 16/5/11.
//  Copyright © 2016年 kiwi. All rights reserved.
//

#import "UIScrollView+Refresh.h"

@implementation UIScrollView (Refresh)

- (void)addHeaderRefresh:(MJRefreshComponentRefreshingBlock)block{
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:block];
}
- (void)beginHeaderRefresh{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mj_header beginRefreshing];
    });
}
- (void)endHeaderRefresh{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mj_header endRefreshing];
    });
}

- (void)addAutoFooterRefresh:(MJRefreshComponentRefreshingBlock)block{
    self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:block];
}
- (void)addBackFooterRefresh:(MJRefreshComponentRefreshingBlock)block{
    self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:block];
}

- (void)addGifFooterRefresh:(MJRefreshComponentRefreshingBlock)block andImagesforGif:(NSArray<UIImage *> *)images{
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:block];
    footer.refreshingTitleHidden = YES;
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor colorWithHexString:@"C1FFC2"];
    [footer addSubview:view];
    
    CABasicAnimation *anim = [CABasicAnimation animation];
    CABasicAnimation *anim1 = [CABasicAnimation animation];
    anim.keyPath = @"transform.scale";
    anim.toValue = @2;
    anim.duration = 0.7;
    
    anim1.keyPath = @"opacity";
    anim1.toValue = @0.6;
    anim1.duration = 0.7;
    anim.repeatCount = MAXFLOAT;
    anim1.repeatCount = MAXFLOAT;
    
    view.layer.cornerRadius = 5;
    [view.layer addAnimation:anim forKey:nil];
    [view.layer addAnimation:anim1 forKey:nil];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.height.width.mas_equalTo(10);
    }];
    self.mj_footer = footer;
}
- (void)beginFooterRefresh{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mj_footer beginRefreshing];
    });
}
- (void)endFooterRefresh{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mj_footer endRefreshing];
    });
}


@end
