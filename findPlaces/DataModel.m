//
//  DataModel.m
//  findPlaces
//
//  Created by 孙延梁 on 12-10-24.
//  Copyright (c) 2012年 ios34-Sun YanLiang. All rights reserved.
//

#import "DataModel.h"

static DataModel *dataModel = nil;

@implementation DataModel

@synthesize locationManager = _locationManager;
@synthesize detailLocation = _detailLocation;
@synthesize currentLocation = _currentLocation;
@synthesize nearbyPlaces = _nearbyPlaces;
@synthesize myCollections = _myCollections;
@synthesize currentPlacemark = _currentPlacemark;
@synthesize detailInfoText = _detailInfoText;
@synthesize referenceText = _referenceText;
@synthesize additionalText = _additionalText;
@synthesize detailName = _detailName;
@synthesize referenceSelectedIndexPath = _referenceSelectedIndexPath;
@synthesize smallImage = _smallImage;
@synthesize creatDate = _creatDate;
@synthesize selectedEntity = _selectedEntity;

+ (id)allocWithZone:(NSZone *)zone
{
    return [self defaultDataModel];
}

+ (DataModel *)defaultDataModel//单例默认创建方法
{
    if (!dataModel) {
        dataModel = [[super allocWithZone:NULL]init];
    }
    return dataModel;
}
//数据模型仅仅是保存各个有用的指针,方便大家的调用,使得各控制器不再为找不到指针而烦恼.
//因此数据模型应该是单例,以保证指向同一个地方;
//数据模型自己不应该对自己进行操作,应该由控制器来操作
- (id)init
{
    if (dataModel) {
        return dataModel;
    }
    self = [super init];
//    _myCollections = [[MyStore FetchColloctions]mutableCopy];//数据模型不应该自己对自己操作
    return self;
}

//- (id)retain
//{
//    return self;
//}
//
//- (oneway void)release
//{
//    //do none
//}
//
//- (NSUInteger)retainCount
//{
//    return NSUIntegerMax;
//}
- (NSString *)directionFromSrcPoint:(CGPoint)srcPoint to:(CGPoint)destPoint
{
    //求得自正北向起顺时针弧度数.
    double radA = atan((destPoint.x - srcPoint.x)/(destPoint.y - srcPoint.y));
    radA = (destPoint.y > srcPoint.y) ? (M_PI - radA) : (2.0 * M_PI - radA) ;
    radA = radA < 2.0 * M_PI ? radA : radA - 2.0 * M_PI ;//保证在[0,2*PI)范围内
    //放大取整,是舍去法.
    int n = (int)(radA * 8.0/M_PI);
    switch(n)
    {
        case 0:case 15:
        {
            return @"北";
            break;
        }
        case 1:case 2:
        {
            return @"东北";
            break;
        }
        case 3:case 4:
        {
            return @"东";
            break;
        }
        case 5:case 6:
        {
            return @"东南";
            break;
        }
        case 7:case 8:
        {
            return @"南";
            break;
        }
        case 9:case 10:
        {
            return @"西南";
            break;
        }
        case 11:case 12:
        {
            return @"西";
            break;
        }
        case 13:case 14:
        {
            return @"西北";
            break;
        }
        default:
            return @"~方向计算有问题耶~";
    }
}

- (NSString *)directionFrom:(CLLocationCoordinate2D)srcCoordinate to:(CLLocationCoordinate2D)destCoordinate
{
    CLLocationCoordinate2D d = destCoordinate;
    CLLocationCoordinate2D s = srcCoordinate;
    //求得自正北向起顺时针弧度数.
    double radA = atan((d.longitude - s.longitude)/(d.latitude - s.latitude));
    radA = (d.latitude < s.latitude) ? (M_PI - radA) : (2.0 * M_PI + radA) ;
    radA = radA < 2.0 * M_PI ? radA : radA - 2.0 * M_PI ;//保证在[0,2*PI)范围内
    //放大取整,是舍去法.
    int n = (int)(radA * 8.0/M_PI);
    switch(n)
    {
        case 0:case 15:
        {
            return @"北";
            break;
        }
        case 1:case 2:
        {
            return @"东北";
            break;
        }
        case 3:case 4:
        {
            return @"东";
            break;
        }
        case 5:case 6:
        {
            return @"东南";
            break;
        }
        case 7:case 8:
        {
            return @"南";
            break;
        }
        case 9:case 10:
        {
            return @"西南";
            break;
        }
        case 11:case 12:
        {
            return @"西";
            break;
        }
        case 13:case 14:
        {
            return @"西北";
            break;
        }
        default:
            return @"~方向计算有问题耶~";
    }
}

@end
