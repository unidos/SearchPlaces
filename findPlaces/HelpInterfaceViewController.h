//
//  HelpInterfaceViewController.h
//  findPlaces
//
//  Created by 孙延梁 on 12-10-22.
//  Copyright (c) 2012年 ios34-Sun YanLiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpInterfaceViewController : UIViewController<UIScrollViewDelegate>
{
 @private
    UIScrollView *_helpInterface;
    UIPageControl *_pageControl;
}
@end
