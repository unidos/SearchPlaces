//
//  MainViewController.h
//  findPlaces
//
//  Created by 孙延梁 on 12-10-22.
//  Copyright (c) 2012年 ios34-Sun YanLiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomFourItemsTabBarController.h"
#import "HelpInterfaceViewController.h"
#import "DataModel.h"
#import "MyStore.h"

@interface MainViewController : UIViewController
{
 @private
    MyStore *_myStore;
    DataModel *_dataModel;
    CustomFourItemsTabBarController *_custom4TabBarCtr;
    HelpInterfaceViewController *_helpInterfaceVC;
}

@property (strong, nonatomic) IBOutlet UILabel *collectionNumLabel;
@property (nonatomic, strong) CustomFourItemsTabBarController *custom4TabBarCtr;

- (IBAction)collectionButtonPressed:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)selfSelectedLocationPressed:(UIButton *)sender;
- (IBAction)currentLocationPressed:(UIButton *)sender;
- (IBAction)settingPressed:(UIButton *)sender;
- (IBAction)exitPressed:(id)sender;

@end
