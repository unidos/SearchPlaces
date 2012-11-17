//
//  MyStore.h
//  findPlaces
//
//  Created by 孙延梁 on 12-10-27.
//  Copyright (c) 2012年 ios34-Sun YanLiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyEntity.h"

@interface MyStore : NSObject
//基本上只放一些存储方法
+ (BOOL)SaveDetailToColloction;//保存到我的搜藏,返回值代表写文件的成功与否
+ (NSArray *)FetchAllColloctions;//获取我的收藏的记录数据
+ (void)DeleteOneCollection:(MyEntity *)entity;
+ (BOOL)updateOneColloction:(MyEntity *)entity;

@end
