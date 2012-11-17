//
//  MyStore.m
//  findPlaces
//
//  Created by 孙延梁 on 12-10-27.
//  Copyright (c) 2012年 ios34-Sun YanLiang. All rights reserved.
//

#import "MyStore.h"
#import "DataModel.h"
#import "AppDelegate.h"

NSString *fileName = @"collection.plist";

@implementation MyStore

+ (NSManagedObjectContext *)sharedMOcontext
{
    AppDelegate *appDele = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    return [appDele managedObjectContext];
}

+ (void)DeleteOneCollection:(MyEntity *)entity
{
    [[self sharedMOcontext]deleteObject:entity];
    NSError *error = nil;
    BOOL savedOK = [[self sharedMOcontext]save:&error];//确认删除
    if(savedOK){
        //发通知,告诉别人文件改变了
        [[NSNotificationCenter defaultCenter]postNotificationName:persistentFileChanged object:nil];
    }else{
        NSLog(@"%@",[error localizedDescription]);
    }
}

+ (BOOL)SaveDetailToColloction
{
    return [self SaveDetailToColloctionUseCoreData];
}

//在类方法里,self指代本类;在实例方法里,self指代本类的实例.
//CoreData的读写都是受管理对象的上下文去操作
+ (BOOL)SaveDetailToColloctionUseCoreData
{
    DataModel *dataModel = [DataModel defaultDataModel];
    //在内存中插入一条MyEntity表的数据,显然这条数据是和MyEntity类的实例是相同的,可以转化为MyEntity类的实例.从而使得对实例对象的操作即是对内存中的表数据条的操作.NSManagedObjectContext想来应该是保持表字段和类的实例变量的对应的.
    MyEntity *entity = [NSEntityDescription insertNewObjectForEntityForName:@"Entity" inManagedObjectContext:[self sharedMOcontext]];
    //以下通过对实例对象的修改完成对表数据条的修改
    entity.detailName = dataModel.detailName;
    entity.detailLocation = dataModel.detailLocation;
    entity.detailInfoText = dataModel.detailInfoText;
    entity.referenceText = dataModel.referenceText;
    entity.additionalText = dataModel.additionalText;
    entity.smallImage = dataModel.smallImage;
    entity.creatDate = [NSDate date];
    NSError *error = nil;
    //if语句要将常态的放前面
    if ([[self sharedMOcontext] save:&error])
    {
        //发通知,告诉别人文件改变了
        [[NSNotificationCenter defaultCenter]postNotificationName:persistentFileChanged object:nil];
        return YES;
    }
    NSLog(@"save error = %@",[error localizedDescription]);
    return NO;
}

+ (BOOL)SaveDetailToColloctionNormal
{
    NSString *filePath = [self fileFullPathByName:fileName];
    NSMutableArray *fileArray = nil;
    //如果文件存在就读取生成可变数组,不存在就创建可变数组
    if ([[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
        fileArray = [[NSMutableArray alloc]initWithContentsOfFile:filePath];
    }
    else{
        fileArray = [NSMutableArray new];
    }
    //向可变数组中增加一个字典dataTmp.detailLocation,@"detailLocation",
    DataModel *dataTmp = [DataModel defaultDataModel];
    if([dataTmp.additionalText isEqualToString:@"添加点啥注释呢?"]){
        dataTmp.additionalText = nil;
    }
    NSDictionary *dicTmp = [NSDictionary dictionaryWithObjectsAndKeys:
                            dataTmp.detailName,@"detailName",
    [NSNumber numberWithFloat:dataTmp.detailLocation.coordinate.latitude],@"detailLocationLat",
    [NSNumber numberWithFloat:dataTmp.detailLocation.coordinate.longitude],@"detailLocationLng",
        dataTmp.detailInfoText,@"detailInfoText",
        dataTmp.referenceText,@"referenceText",
        dataTmp.additionalText,@"additionalText",
                            nil];
    [fileArray addObject:dicTmp];
    //写文件,并获取返回值
    if([fileArray writeToFile:filePath atomically:YES])
    {
        return YES;
    }
    return NO;
}

//通过日期来确认更新的数据条
+ (BOOL)updateOneColloction:(MyEntity *)entity
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"Entity"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"creatDate == %@",entity.creatDate];//NSDate用%@.
    NSError *error = nil;
    NSArray *resultArray = [[self sharedMOcontext]executeFetchRequest:fetchRequest error:&error];
    if(!error){
        MyEntity *originMo = [resultArray objectAtIndex:0];
        originMo.detailName = entity.detailName;
        originMo.detailLocation = entity.detailLocation;
        originMo.detailInfoText = entity.detailInfoText;
        originMo.referenceText = entity.referenceText;
        originMo.additionalText = entity.additionalText;
        originMo.smallImage = entity.smallImage;
        originMo.creatDate = [NSDate date];
        NSError *saveError = nil;
        BOOL savedOK = [[self sharedMOcontext]save:&saveError];
        if (savedOK) {
            return YES;
        }
        else{
            [NSException raise:@"更新时保存失败" format:@"Reason:%@",saveError.localizedDescription];
            return NO;
        }
    }
    else{
        [NSException raise:@"更新操作筛选获取时失败" format:@"Reason:%@",error.localizedDescription];
        return NO;
    }
}

+ (NSArray *)FetchAllColloctions
{
    return [self FetchAllColloctionsUseCoreData];
}

+ (NSArray *)FetchAllColloctionsUseCoreData
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"Entity"];
    NSError *error = nil;
    NSArray *resultArray = [[self sharedMOcontext]executeFetchRequest:fetchRequest error:&error];
    if(!error)
        return resultArray;
    NSLog(@"%@",[error localizedDescription]);
    return nil;
}

+ (NSArray *)FetchColloctionsNormal
{
    return [NSArray arrayWithContentsOfFile:[self fileFullPathByName:fileName]];
}

+ (NSString *)fileFullPathByName:(NSString *)fileName
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:fileName];
}

@end
