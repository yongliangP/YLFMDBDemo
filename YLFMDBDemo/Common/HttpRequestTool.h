//
//  HttpRequestTool.h
//  YLFMDBDemo
//
//  Created by yongliangP on 16/8/29.
//  Copyright © 2016年 yongliangP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
@interface HttpRequestTool : NSObject

@property (nonatomic, strong) AFHTTPSessionManager *manager;

+(instancetype)shareTool;
/** GET请求 */
- (void)getWihtUrl:(NSString*)url
            params:(NSDictionary*)params
           success:(void (^)(NSDictionary *response))success
           failure:(void (^)(NSError* err))failure;

/** POST请求 */
- (void)postWihtUrl:(NSString*)url
             params:(NSDictionary*)params
            success:(void (^)(NSDictionary *response))success
            failure:(void (^)(NSError* err))failure;


+(BOOL)isNetWorkReachability;

@end
