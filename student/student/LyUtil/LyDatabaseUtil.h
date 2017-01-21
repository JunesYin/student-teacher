//
//  LyDatabaseUtil.h
//  student
//
//  Created by MacMini on 2016/12/7.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface LyDatabaseUtil : NSObject

//打开数据库
+ (FMDatabase *)databaseWithDbName:(NSString *)dbName;

//删除数据库
+ (BOOL)deleteDatabase:(NSString *)dbName datebase:(FMDatabase *)database;

//判断表是否存在
+ (BOOL)isTableExisting:(FMDatabase *)database tableName:(NSString *)tableName;

//创建表
+ (BOOL)createTalbe:(FMDatabase *)database tableName:(NSString *)tableName arguments:(NSString *)arguments;

//删除表
+ (BOOL)deleteTable:(FMDatabase *)database tableName:(NSString *)tableName;

//截断表(新的记录id将从1开始)
+ (BOOL)truncateTable:(FMDatabase *)database tableName:(NSString *)tableName;

@end
