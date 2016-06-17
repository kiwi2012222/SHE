//
//  HomePageViewModel.h
//  KWSHE
//
//  Created by kiwi on 16/5/3.
//  Copyright © 2016年 kiwi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ChannelModelForHomePageModel,ChannelItemModel,IssueModelForHomePageModel,IssueItemModel,BestModelForHomePageModel,BestItemModel;
@interface HomePageViewModel : NSObject
@property (nonatomic,strong)ChannelModelForHomePageModel *channelPageModel;
@property (nonatomic,strong)IssueModelForHomePageModel *issuePageModel;
@property (nonatomic,strong)BestModelForHomePageModel *bestPageModel;

//为表格填充获取相应实体
-(ChannelItemModel *)getChannelItemByIndexPath:(NSIndexPath *)indexPath;
-(IssueItemModel *)getIssueItemByIndexPath:(NSIndexPath *)indexPath;
-(BestItemModel *)getBestItemByIndexPath:(NSIndexPath *)indexPath;

-(void)getDataByRequestMode:(KWRequestMode)requestMode PageName:(NSString *)pageName completionHandler:(void(^)(NSError *error))completionHandler;

@end