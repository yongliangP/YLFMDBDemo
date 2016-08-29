//
//  Book.m
//  YLFMDBDemo
//
//  Created by yongliangP on 16/8/29.
//  Copyright © 2016年 yongliangP. All rights reserved.
//

#import "Book.h"

@implementation Book

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"images"])
    {
        self.large = [value valueForKey:@"large"];
    }
    else
    {
        [super setValue:value forKey:key];
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
    
}

//valueForKey:如果key存在会触发这个方法
- (id)valueForUndefinedKey:(NSString *)key
{
    return nil;
}

@end
