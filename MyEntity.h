//
//  MyEntity.h
//  findPlaces
//
//  Created by 孙延梁 on 12-10-30.
//  Copyright (c) 2012年 ios34-Sun YanLiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MyEntity : NSManagedObject

@property (nonatomic, strong) NSString * additionalText;
@property (nonatomic, strong) NSString * detailInfoText;
@property (nonatomic, strong) id detailLocation;
@property (nonatomic, strong) NSString * detailName;
@property (nonatomic, strong) NSString * referenceText;
@property (nonatomic, strong) id smallImage;
@property (nonatomic, strong) NSDate * creatDate;

@end
