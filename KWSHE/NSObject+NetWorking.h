//
//  NSObject+NetWorking.h
//  KWSHE
//
//  Created by kiwi on 16/5/12.
//  Copyright © 2016年 kiwi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
@interface NSObject (NetWorking)
+ (id)GET:(NSString *)path parameters:(id)parameters progress:(void(^)(NSProgress *downloadProgress))downloadProgress completionHandler:(void(^)(id respondObj,NSError *error))completionHandler;

+ (id)POST:(NSString *)path parameters:(id)parameters progress:(void(^)(NSProgress * downloadProgress))downloadProgress completionHandler:(void(^)(id responseObj,NSError *error))completionHandler;

@end
