//
//  AnimationCustom.h
//  findPlaces
//
//  Created by 孙延梁 on 12-10-31.
//  Copyright (c) 2012年 ios34-Sun YanLiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnimationCustom : NSObject

//将view视图中的subView上移到键盘遮挡不住的地方,返回上移距离
+ (CGFloat)View:(UIView *)superView UpWithKeyboardFor:(UIView *)subView;
//用于自定义键盘回收按钮,使其随键盘上升
+ (void)View:(UIView *)view UpingForDistance:(CGFloat)distance;
//用于自定义键盘回收按钮,使其随键盘下降
+ (void)ViewDowningToItsOrigin:(UIView *)view;

@end
