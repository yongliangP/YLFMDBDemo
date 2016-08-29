//
//  DatabaseManager.h
//  YLFMDBDemo
//
//  Created by yongliangP on 16/8/29.
//  Copyright © 2016年 yongliangP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DatabaseManager : NSObject

/**单例对象*/
+ (instancetype)databaseManager;
/**插入数据*/
- (BOOL)insertObjectToDatabaseWithObject:(id)object;

/**查询所有的数据*/
- (NSArray *)queryAllObjectsFromDatabaseWithClass:(Class)cls;

/**删除指定表的数据*/
- (BOOL)deleteAllObjectsFromDatabaseWithClass:(Class)cls;

@end
