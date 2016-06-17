//
//  HomePageViewModel.m
//  KWSHE
//
//  Created by kiwi on 16/5/3.
//  Copyright © 2016年 kiwi. All rights reserved.
//

#import "HomePageViewModel.h"
#import "HomePageModel.h"
@implementation HomePageViewModel
-(ChannelItemModel *)getChannelItemByIndexPath:(NSIndexPath *)indexPath{
    return self.channelPageModel.list[indexPath.row];
}
-(IssueItemModel *)getIssueItemByIndexPath:(NSIndexPath *)indexPath{
    return self.issuePageModel.list[indexPath.row];
}
-(BestItemModel *)getBestItemByIndexPath:(NSIndexPath *)indexPath{
    return self.bestPageModel.list[indexPath.row];
}

-(void)getDataByRequestMode:(KWRequestMode)requestMode PageName:(NSString *)pageName completionHandler:(void (^)(NSError *))completionHandler{
    if (requestMode == KWRequestModeRefresh) {
        NSDictionary *para = @{@"device":@"iphone"};
        [NSObject POST:@"http://www.29cm.co.kr/app/v3/home/home01.asp" parameters:para progress:nil completionHandler:^(id respondObj, NSError *error) {
            if (!error) {
                HomePageModel *model = [HomePageModel ModelCreateWithJson:respondObj];
                self.channelPageModel = model.channel;
                self.issuePageModel = model.issue;
                self.bestPageModel = model.best;
            }
            completionHandler(error);
        }];
        return;
    }
    if (requestMode == KWRequestModeMore)
    {
        if ([pageName isEqualToString:@"Issue"]) {
            NSDictionary *para = @{@"limit":@"20",@"skip":[NSNumber numberWithLong: self.issuePageModel.list.count+1],@"device":@"iphone"};
            [NSObject POST:@"http://www.29cm.co.kr/app/v3/home/saleList.asp" parameters:para progress:nil completionHandler:^(id respondObj, NSError *error) {
                if (!error) {
                    IssueModelForHomePageModel *newIssueModel = [IssueModelForHomePageModel ModelCreateWithJson:respondObj];
                    NSMutableArray *tmpArray = [self.issuePageModel.list mutableCopy];
                    for (int i=0;i<newIssueModel.list.count;i++)
                    {
                        [tmpArray addObject:newIssueModel.list[i]];
                    }
                    self.issuePageModel.list = tmpArray;
                }
                completionHandler(error);
            }];
            return;
        }
        if ([pageName isEqualToString:@"Best"]) {
            NSDictionary *para = @{@"limit":@"30",@"skip":[NSNumber numberWithLong: self.bestPageModel.list.count+1],@"device":@"iphone"};
            [NSObject POST:@"http://www.29cm.co.kr/app/v3/home/shopList.asp" parameters:para progress:nil completionHandler:^(id respondObj, NSError *error) {
                if (!error) {
                    BestModelForHomePageModel *newBestModel = [BestModelForHomePageModel ModelCreateWithJson:respondObj];
                    NSMutableArray *tmpArray = [self.bestPageModel.list mutableCopy];
                    for (int i=0;i<newBestModel.list.count;i++)
                    {
                        [tmpArray addObject:newBestModel.list[i]];
                    }
                    self.bestPageModel.list = tmpArray;
                }
                completionHandler(error);
            }];
            return;
        }
    }
}
@end
