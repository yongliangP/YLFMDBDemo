//
//  HttpRequestTool.m
//  YLFMDBDemo
//
//  Created by yongliangP on 16/8/29.
//  Copyright © 2016年 yongliangP. All rights reserved.
//

#import "HttpRequestTool.h"
#import "AFNetworking.h"
@implementation HttpRequestTool

static HttpRequestTool *httpTool = nil;

+ (instancetype)shareTool
{
    if (httpTool == nil)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            httpTool = [[HttpRequestTool alloc] init];
            httpTool.manager = [AFHTTPSessionManager manager];
            httpTool.manager.requestSerializer.timeoutInterval = 10;
        });
    }
    
    return httpTool;
}

- (void)getWihtUrl:(NSString*)url
            params:(NSDictionary*)params
           success:(void (^)(NSDictionary *response))success
           failure:(void (^)(NSError* err))failure
{
//    if (![url containsString:@"http"])
//    {
//        url = [NSString stringWithFormat:@"%@%@",kBaseUrl,url];
//    }
//    NSLog(@"%@ = %@",url,params);

    
    [[HttpRequestTool shareTool].manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         if (success)
         {
            success(responseObject);
    
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         if (failure)
         {
             NSLog(@"error == %@",error);
             failure(error);
         }
         
     }];
}

- (void)postWihtUrl:(NSString*)url
             params:(NSDictionary*)params
            success:(void (^)(NSDictionary *response))success
            failure:(void (^)(NSError* err))failure
{
//    if (![url containsString:@"http"])
//    {
//        url = [NSString stringWithFormat:@"%@%@",kBaseUrl,url];
//    }
//    NSLog(@"%@ = %@",url,params);
    
    [[HttpRequestTool shareTool].manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress)
     {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         if (success)
         {
             success(responseObject);
             
         }
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         if (failure)
         {
             NSLog(@"error == %@",error);
             failure(error);
         }
         
     }];
    
    
}

+(BOOL)isNetWorkReachability
{

    if ([AFNetworkReachabilityManager manager].isReachable)
    {
        return YES;
        
    }else
    {
    
        return NO;
    }
}


@end
