//
//  VersionViewController.m
//  findPlaces
//
//  Created by 孙延梁 on 12-10-31.
//  Copyright (c) 2012年 ios34-Sun YanLiang. All rights reserved.
//

#import "VersionViewController.h"

@interface VersionViewController ()

@end

@implementation VersionViewController

@synthesize scrollView = _scrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *imagePath = [[NSBundle mainBundle]pathForResource:@"VersionInfo7" ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    imageView.frame = CGRectMake(0, 0, 320, 833);
    [self.scrollView addSubview:imageView];
    self.scrollView.contentSize = CGSizeMake(320, 833);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    [super viewDidUnload];
}
- (IBAction)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
