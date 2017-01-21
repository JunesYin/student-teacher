//
//  LyDatabaseUtil.m
//  student
//
//  Created by MacMini on 2016/12/7.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyDatabaseUtil.h"
#import "FMDatabase.h"

@implementation LyDatabaseUtil

//
+ (NSString *)getDatabasePath:(NSString *)dbName
{
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *dbPath = [docPath stringByAppendingString:dbName];
    
    return dbPath;
}

//打开数据库
+ (FMDatabase *)databaseWithDbName:(NSString *)dbName
{
    FMDatabase *db = [FMDatabase databaseWithPath:[LyDatabaseUtil getDatabasePath:dbName]];
    if ([db open])
    {
        [db close];
        
        NSAssert2(0, @"Failed to open database(%@) with message '%@'", dbName, [db lastErrorMessage]);
    }
    
    return db;
}

//删除数据库
+ (BOOL)deleteDatabase:(NSString *)dbName datebase:(FMDatabase *)database
{
    BOOL flag;
    NSError *error;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:dbName])
    {
        if (database && [database open])
        {
            [database close];
        }
        
        flag = [fileManager removeItemAtPath:dbName error:&error];
        
        if (!flag)
        {
            NSLog(@"Failed to delete database(%@) with message '%@'", dbName, error);
            return NO;
        }
        
        NSLog(@"Successed to delete database(%@)", dbName);
        return YES;
    }
    
    NSLog(@"database(%@) not exist", dbName);
    return YES;
}


//判断表是否存在
+ (BOOL)isTableExisting:(FMDatabase *)database tableName:(NSString *)tableName
{
    if (!database || ![database open])
    {
        return NO;
    }
    
    FMResultSet *rs = [database executeQuery:@"SELECT COUNT(*) AS 'count' FROM sqlite_master WHERE type = 'table' AND name = ?", tableName];
    while ([rs next])
    {
        int count = [rs intForColumn:@"count"];
        if (count > 0)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    return NO;
}


//创建表
+ (BOOL)createTalbe:(FMDatabase *)database tableName:(NSString *)tableName arguments:(NSString *)arguments
{
    if (!database || ![database open])
    {
        return NO;
    }
    
    NSString *sql = [[NSString alloc] initWithFormat:@"CREATE TABLE %@ (%@)", tableName, arguments];
    if (![database executeUpdate:sql])
    {
        NSLog(@"Failed to create table(%@) with message '%@'", tableName, database.lastErrorMessage);
        return NO;
    }
    
    
    return YES;
}


//删除表
+ (BOOL)deleteTable:(FMDatabase *)database tableName:(NSString *)tableName
{
    if (!database || ![database open])
    {
        return NO;
    }
    
    NSString *sql = [[NSString alloc] initWithFormat:@"DROP TABLE %@", tableName];
    if (![database executeUpdate:sql])
    {
        NSLog(@"Failed to delete table(%@) with message '%@'", tableName, [database lastErrorMessage]);
        return NO;
    }
    
    return YES;
}


//截断表(新的记录id将从1开始)
+ (BOOL)truncateTable:(FMDatabase *)database tableName:(NSString *)tableName
{
    if (!database || ![database open])
    {
        return NO;
    }
    
    NSString *sql = [[NSString alloc] initWithFormat:@"TRUNCATE %@", tableName];
    if (![database executeUpdate:sql])
    {
        NSLog(@"Failed to truncate table(%@) with message '%@'", tableName, [database lastErrorMessage]);
        return NO;
    }
    
    return YES;
}



@end
