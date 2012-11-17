//
//  MoreViewController.h
//  findPlaces
//
//  Created by 孙延梁 on 12-10-21.
//  Copyright (c) 2012年 ios34-Sun YanLiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelpInterfaceViewController.h"

@interface MoreViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_titleArray;
    HelpInterfaceViewController *_helpInterfaceVC;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)backPressed:(id)sender;
@end
