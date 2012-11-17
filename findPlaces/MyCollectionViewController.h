//
//  MyCollectionViewController.h
//  findPlaces
//
//  Created by 孙延梁 on 12-10-21.
//  Copyright (c) 2012年 ios34-Sun YanLiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"
#import "MyStore.h"

@interface MyCollectionViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    DataModel *_dataModel;
    MyStore *_myStore;
    NSMutableArray *_collections;//tableView的数据源
    NSIndexPath *_selectedIndexPath;
    BOOL _canDelete;
    BOOL _didDelete;
    UIAlertView *_alertView;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;
@property (strong, nonatomic) NSMutableArray *collections;


- (IBAction)addBtnPressed:(id)sender;
- (IBAction)deletePressed:(UIButton *)sender;
- (IBAction)backPressed:(id)sender;

@end
