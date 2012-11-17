//
//  DataModel.h
//  findPlaces
//
//  Created by 孙延梁 on 12-10-24.
//  Copyright (c) 2012年 ios34-Sun YanLiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyEntity.h"

//在内存中交换数据用的数据模型.或曰内存中的数据中心
@interface DataModel : NSObject
{
    CLLocationManager *_locationManager;
    
    NSString *_detailName;
    CLLocation *_detailLocation;//某个地点的用于在详细视图上显示的定位,显示详细信息时必设
    NSString *_detailInfoText;
    NSString *_referenceText;
    NSString *_additionalText;
    UIImage *_smallImage;
    NSDate *_creatDate;
    
    NSIndexPath *_referenceSelectedIndexPath;

    CLLocation *_currentLocation;
    CLPlacemark *_currentPlacemark;
    
    //数组中每项都是一个字典,包含6个字典项:geometry icon id name reference vicinity,其中geometry是一个字典,含有一个字典项location,location也是一个字典(是coordinate2D),含有2项lat和lng
    NSArray *_nearbyPlaces;
    NSMutableArray *_myCollections;
}

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *detailLocation;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) NSArray *nearbyPlaces;
@property (strong, nonatomic) NSMutableArray *myCollections;
@property (strong, nonatomic) CLPlacemark *currentPlacemark;
@property (strong, nonatomic) NSString *detailInfoText;
@property (strong, nonatomic) NSString *referenceText;
@property (strong, nonatomic) NSString *additionalText;
@property (strong, nonatomic) NSString *detailName;
@property (strong, nonatomic) NSIndexPath *referenceSelectedIndexPath;
@property (strong, nonatomic) UIImage *smallImage;
@property (strong, nonatomic) NSDate *creatDate;
@property (strong, nonatomic) MyEntity *selectedEntity;

+ (DataModel *)defaultDataModel;
- (NSString *)directionFrom:(CLLocationCoordinate2D)srcLocation to:(CLLocationCoordinate2D)destLocation;
- (NSString *)directionFromSrcPoint:(CGPoint)srcPoint to:(CGPoint)destPoint;

@end
