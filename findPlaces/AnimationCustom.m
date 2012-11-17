//
//  AnimationCustom.m
//  findPlaces
//
//  Created by 孙延梁 on 12-10-31.
//  Copyright (c) 2012年 ios34-Sun YanLiang. All rights reserved.
//

#import "AnimationCustom.h"

//键盘上移时间就是0.25秒,在键盘通知的userInfo里有
#define KEYBOARD_DURATION 0.25
#define KEYBOARD_HEIGHT 250.0
#define SCREEN_HEIGHT_WITHOUT_STATUSBAR 460.0

@implementation AnimationCustom

+ (CGFloat)View:(UIView *)superView UpWithKeyboardFor:(UIView *)subView
{
    CGFloat height = 0.0;
    /*
    [子视图 convertRect:子视图.bounds toView:父视图]
    就是 [(from)子视图 convertRect:子视图.bounds toView:父视图];
    [父视图 convertRect:子视图.bounds fromView:子视图]
    就是[(to)父视图 convertRect:子视图.bounds fromView:子视图].
    这2个是一个意思,就是方便敲代码.晕死
     ***注意:Rect不要用frame,要用bounds.frame是相对于父视图的边框
     */
    //坐标系的转换需要好好看看,frame是对于父视图的,bounds是对应自己视图的
//    CGRect destRect = [subView convertRect:subView.bounds toView:superView];
    CGRect destRect = [superView convertRect:subView.bounds fromView:subView];
    if (destRect.origin.y < SCREEN_HEIGHT_WITHOUT_STATUSBAR - KEYBOARD_HEIGHT - subView.frame.size.height) {
        height = 0.0;
    }else{
        height = destRect.origin.y - (SCREEN_HEIGHT_WITHOUT_STATUSBAR - KEYBOARD_HEIGHT - subView.frame.size.height);
    }
    height += 50;//最小偏移量再加50
    [UIView beginAnimations:@"View:UpWithKeyboardFor:" context:nil];
    [UIView setAnimationDuration:KEYBOARD_DURATION];
    [UIView setAnimationDelegate:nil];
    [UIView setAnimationDidStopSelector:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    superView.transform = CGAffineTransformMakeTranslation(0.0, - height);
    [UIView commitAnimations];
    return height;
}

+ (void)View:(UIView *)view UpingForDistance:(CGFloat)distance
{
    [UIView beginAnimations:@"View:UpingForDistance:" context:nil];
    [UIView setAnimationDuration:KEYBOARD_DURATION];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    view.transform = CGAffineTransformMakeTranslation(0, -distance);//此变换是从"最初的"原始点变换
    [UIView commitAnimations];
}

+ (void)ViewDowningToItsOrigin:(UIView *)view
{
    [UIView beginAnimations:@"ViewDowningFollowKeyboard:" context:nil];
    [UIView setAnimationDuration:KEYBOARD_DURATION];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    view.transform = CGAffineTransformIdentity;
    [UIView commitAnimations];
}

@end
