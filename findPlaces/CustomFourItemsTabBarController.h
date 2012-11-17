//
//  Custom4ItemsTabBarController.h
//  findPlaces
//
//  Created by 孙延梁 on 12-10-21.
//  Copyright (c) 2012年 ios34-Sun YanLiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CustomFourItemsTabBarController : UITabBarController
{
 @private
    NSMutableArray *_buttonArray;//私用,标签项数组
    NSUInteger _selectedIndexCTB;//存放已选中的按钮的tag值
    NSArray *_titles;
    UIColor *_brightColor;
    UIColor *_darkColor;
    NSArray *_brightImage;
    NSArray *_darkImage;
}
@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, assign) NSUInteger selectedIndexCTB;
//以下五个属性是必须设置的,能且只能有四个标签项
@property (nonatomic, copy) NSArray *titles;//各个标签项的文字
@property (nonatomic, strong) UIColor *brightColor;//标签项字体的亮颜色
@property (nonatomic, strong) UIColor *darkColor;//标签项字体的按颜色
@property (nonatomic, copy) NSArray *brightImage;//标签项第一项到第四项的亮图片
@property (nonatomic, copy) NSArray *darkImage;//标签项第一项到第四项的暗图片

@end
