//
//  DetailViewController.m
//  findPlaces
//
//  Created by 孙延梁 on 12-10-24.
//  Copyright (c) 2012年 ios34-Sun YanLiang. All rights reserved.
//

#import "DetailSavedViewController.h"
#import "ReferenceViewController.h"
#import "MyStore.h"
#import <QuartzCore/QuartzCore.h>
#import "MyEntity.h"
#import "AnimationCustom.h"

#define toolbarH 40.0

@interface DetailSavedViewController ()

@end

@implementation DetailSavedViewController

@synthesize referenceBtn = _referenceBtn;
@synthesize saveOrEditBtn = _saveOrEditBtn;
@synthesize nameText = _nameText;
@synthesize smallMap = _smallMap;
@synthesize detailInfo = _detailInfo;
@synthesize additionalInfo = _additionalInfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataModel = [DataModel defaultDataModel];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置收藏标题
    _nameText.text = _dataModel.selectedEntity.detailName;
    
    //设置详细信息
    self.detailInfo.text = _dataModel.selectedEntity.detailInfoText;
    
    //设置注释
    self.additionalInfo.text = _dataModel.selectedEntity.additionalText;
    
    //地图范围设置
    CLLocation *loca = _dataModel.selectedEntity.detailLocation;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loca.coordinate, 300, 300);
    [self.smallMap setRegion:region animated:YES];
    self.smallMap.layer.borderWidth = 5.0;
    self.smallMap.layer.borderColor = [UIColor brownColor].CGColor;
    
    //添加当前坐标的注释
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
    annotation.coordinate = loca.coordinate;
    [self.smallMap addAnnotation:annotation];

    //注册键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    //增加关闭键盘按钮
    UIButton *keyboardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [keyboardButton addTarget:self action:@selector(hideKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    [keyboardButton setShowsTouchWhenHighlighted:YES];
    //keyboard.png尺寸=23*23
    [keyboardButton setImage:[UIImage imageNamed:@"keyboard.png"] forState:UIControlStateNormal];
    keyboardButton.frame = CGRectMake(320-30, 9, 23, 23);
    _toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 460, 320, toolbarH)];
    [_toolbar addSubview:keyboardButton];
    _toolbar.alpha = 0.7;
    [self.view addSubview:_toolbar];}

#pragma mark - Keyboard About

- (void)keyboardWillHide:(NSNotification *)keyboardNote
{
    //使self.view和收键盘按钮恢复原状
    [AnimationCustom ViewDowningToItsOrigin:self.view];
    [AnimationCustom ViewDowningToItsOrigin:_toolbar];
}

- (void)keyboardDidShow:(NSNotification *)note
{
    rKBEnd = [[note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [AnimationCustom View:_toolbar UpingForDistance:rKBEnd.size.height+toolbarH-_distance];
}

//收键盘按钮被按下//键盘按钮一直存在,初始化时被放在屏幕下方了
- (void)hideKeyboard:(UIButton *)keyboardBtn
{
    //取消编辑状态会引发键盘回收
    [self.view endEditing:YES];//[textView resignFirstResponder];
}

//非编辑区被按下
- (IBAction)controlPressed:(id)sender {
    //取消编辑状态会引发键盘回收
    [self.view endEditing:YES];
}

#pragma mark - UITextViewDelegate

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    _distance = [AnimationCustom View:self.view UpWithKeyboardFor:textView];
    [AnimationCustom View:_toolbar UpingForDistance:rKBEnd.size.height+toolbarH-_distance];
    
    if(textView == self.additionalInfo){
        if([textView.text isEqualToString:@"添加点啥注释呢?"]){
            self.additionalInfo.text = @"";
        }
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView == self.additionalInfo){
        if(![textView hasText]){
            textView.text = @"添加点啥注释呢?";
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidShowNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {

    [self setSmallMap:nil];
    [self setDetailInfo:nil];
    [self setAdditionalInfo:nil];
    [self setNameText:nil];
    [self setSaveOrEditBtn:nil];
    [self setReferenceBtn:nil];
    [super viewDidUnload];
}

#pragma mark - MKMapViewDelegate

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:nil];
    annotationView.pinColor = MKPinAnnotationColorPurple;
    return annotationView;
}

- (IBAction)refereceBtnPressed:(UIButton *)sender {
    //取消键盘
    [self.view endEditing:YES];//[textView resignFirstResponder];
    ReferenceViewController *referenceVC = [[ReferenceViewController alloc]init];
    [self.navigationController pushViewController:referenceVC animated:YES];
}

- (IBAction)saveBtn:(UIButton *)sender {
    if ([self.saveOrEditBtn.titleLabel.text isEqualToString:@"edit"]) {
        //按下编辑按钮后变成保存按钮
        [self.saveOrEditBtn setTitle:@"save" forState:UIControlStateNormal];
        [self.saveOrEditBtn setImage:[UIImage imageNamed:@"保存--一般.png"] forState:UIControlStateNormal];
        //变换三个textview为可编辑和颜色白,以及变参考按钮为可按下
        self.nameText.editable = self.detailInfo.editable = self.additionalInfo.editable = YES;
        self.nameText.textColor = self.detailInfo.textColor = self.additionalInfo.textColor = [UIColor blackColor];
        self.referenceBtn.userInteractionEnabled = YES;
    }
    else
    {
        //保存到数据模型
        _dataModel.selectedEntity.additionalText = self.additionalInfo.text;
        _dataModel.selectedEntity.detailName = self.nameText.text;
        _dataModel.selectedEntity.detailInfoText = self.detailInfo.text;
        
        //更新
        BOOL OK = [MyStore updateOneColloction:_dataModel.selectedEntity];
        NSString *alertStr = nil;
        if(OK){
            alertStr = @"更新成功";
        }
        else {
            alertStr = @"更新失败";
        }
        _alertView  = [[UIAlertView alloc]initWithTitle:nil message:alertStr delegate:self cancelButtonTitle:@"半秒后自动消失" otherButtonTitles:nil, nil];
        [_alertView show];
    }
}

#pragma mark - MFMessageComposeViewController

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result) {
        case MessageComposeResultCancelled:
            NSLog(@"取消发短信功能");
            break;
        case MessageComposeResultSent:
            NSLog(@"发送短信");
            break;
        case MessageComposeResultFailed:
            NSLog(@"发送失败");
            break;
        default:
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)sendBtn:(UIButton *)sender {
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *messageVC = [[MFMessageComposeViewController alloc] init];
        messageVC.messageComposeDelegate = self; //设置代理
        messageVC.body = @"test"; //设置短信内容
        messageVC.recipients = [NSArray arrayWithObject:@"136-0000-1234"]; //设置电话
        [self presentModalViewController:messageVC animated:YES];//打开短信发送视图
    }
    else
    {
        [NSException raise:@"不能发送短信" format:@"不能进行短信发送"];
    }
}

- (IBAction)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIAlertViewDelegate

-(void)didPresentAlertView:(UIAlertView *)alertView
{
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(alertViewDisappear) userInfo:nil repeats:NO];
}

- (void)alertViewDisappear
{
    [_alertView dismissWithClickedButtonIndex:[_alertView cancelButtonIndex] animated:YES];
}

@end
