//
//  NearPlacesTableViewController.h
//  findPlaces
//
//  Created by 孙延梁 on 12-10-24.
//  Copyright (c) 2012年 ios34-Sun YanLiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"

@interface NearPlacesTableViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    DataModel *_dataModel;
    UITableView *_tableView;
}
@property (strong, nonatomic) UITableView *tableView;

@end
