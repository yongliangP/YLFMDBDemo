//
//  DatabaseManager.m
//  YLFMDBDemo
//
//  Created by yongliangP on 16/8/29.
//  Copyright © 2016年 yongliangP. All rights reserved.
//

#import "DatabaseManager.h"
#import "FMDB.h"
#import <objc/runtime.h>
@interface DatabaseManager ()

{
    //数据库对象
    FMDatabase *_database;
}
@end

@implementation DatabaseManager


- (instancetype)init
{
    self = [super init];
    if (self)
    {
        NSLog(@"%@",[self databasePath]);
        
        _database = [FMDatabase databaseWithPath:[self databasePath]];
    }
    return self;
}

+ (instancetype)databaseManager
{
    
    static DatabaseManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    
    return manager;
    
}

/**返回数据库的路径 */
- (NSString *)databasePath
{
    NSString *doucmentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    
    return [doucmentPath stringByAppendingPathComponent:@"data.db"];
}

/**判断指定表是否存在 */
- (BOOL)isExistTableInDatabaseWithTableName:(NSString *)tablename
{
    //sqlite_master是系统表
    NSString *sql = @"select name from sqlite_master where type='table' and name=?";
    //查询
    FMResultSet *results = [_database executeQuery:sql,tablename];
    
    return results.next;
    
}

/** 根据模型创建表 */
- (BOOL)createTableWithObject:(id)object
{
    //表名
    NSString *tbName = NSStringFromClass([object class]);
    
    NSMutableString *sql = [NSMutableString stringWithFormat:@"create table if not exists %@ (id integer primary key autoincrement",tbName];
    
    //获取字段名字
    NSArray *properties = [self propertiesFromClass:[object class]];
    
    for (NSString *property in properties)
    {
        [sql appendFormat:@",%@ text",property];
    }
    
    [sql appendString:@")"];
    
    //执行sql语句
    return [_database executeUpdate:sql];
    
}



- (BOOL)insertObjectToDatabaseWithObject:(id)object
{
    
    // 判断表是否创建，如果已经创建，直接插入数据。否则先创建表，在插入数据。
    //打开
    if (![_database open])
    {
        //数据库打开失败了
        return NO;
    }
    
    //表名   表名 = model名字
    NSString *tbName = NSStringFromClass([object class]);
    
    //如果表不存在就创建
    if (![self isExistTableInDatabaseWithTableName:tbName])
    {
        //创建表
        if (![self createTableWithObject:object])
        {
            //如果表创建失败，直接返回NO
            return NO;
        }
    }
    
    //插入数据
    NSMutableString *sql = [NSMutableString stringWithFormat:@"insert into %@(",tbName];
    
    //values (xx)
    NSMutableString *valueString = [NSMutableString stringWithString:@"values("];
    
    //获取所有的属性
    NSArray *properties = [self propertiesFromClass:[object class]];
    
    //遍历属性
    for (int i = 0; i < properties.count; i++)
    {
        if (i == properties.count - 1)
        {
            [sql appendFormat:@"%@)",properties[i]];
            [valueString appendFormat:@"'%@')",[object valueForKey:properties[i]]];
        }
        else
        {
            [sql appendFormat:@"%@,",properties[i]];
            [valueString appendFormat:@"'%@',",[object valueForKey:properties[i]]];
        }
    }
    
    [sql appendString:valueString];
    
    BOOL isFinish = [_database executeUpdate:sql];
    
    //关闭数据
    [_database close];
    
    return isFinish;
    
}

/**查询所有的数据 */
- (NSArray *)queryAllObjectsFromDatabaseWithClass:(Class)cls
{
    if (![_database open])
    {
        return nil;
    }
    
    //保存数据模型
    NSMutableArray *objects = [NSMutableArray array];
    
    NSString *sql = [NSString stringWithFormat:@"select * from %@",NSStringFromClass(cls)];
    
    //执行查询
    FMResultSet *results = [_database executeQuery:sql];
    
    //获取属性
    NSArray *properties = [self propertiesFromClass:cls];
    
    while (results.next)
    {
        id obj = [[cls alloc] init];
        
        //遍历所有属性通过KVC赋值
        for (NSString *property in properties)
        {
            [obj setValue:[results stringForColumn:property] forKey:property];
        }
        
        //添加到数组里面
        [objects addObject:obj];
    }
    
    //关闭数据库
    [_database close];
    
    return objects;
}

/**删除指定表的数据 */
- (BOOL)deleteAllObjectsFromDatabaseWithClass:(Class)cls
{
    if (![_database open])
    {
        return NO;
    }
    
    NSString *sql = [NSString stringWithFormat:@"delete from %@",NSStringFromClass(cls)];
    
    //执行sql
    BOOL isOK = [_database executeUpdate:sql];
    
    [_database close];
    
    return isOK;
}

/**返回指定类的所有属性 */
- (NSArray *)propertiesFromClass:(Class)cls
{
    //保存所有的属性名字
    NSMutableArray *array = [NSMutableArray array];
    
    //属性个数
    unsigned int outCount;
    //获取所有的属性    copy,retain,create都需要手动释放
    objc_property_t *properties = class_copyPropertyList(cls, &outCount);
    
    
    for (int i = 0; i < outCount; i++)
    {
        //每个属性的结构体
        objc_property_t property = properties[i];
        //获取属性名字
        const char *name = property_getName(property);
        
        [array addObject:[NSString stringWithUTF8String:name]];
    }
    
    //释放资源
    free(properties);
    
    return array;
}


@end
