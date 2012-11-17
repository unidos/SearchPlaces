//
//  SuggestionViewController.m
//  findPlaces
//
//  Created by 孙延梁 on 12-10-30.
//  Copyright (c) 2012年 ios34-Sun YanLiang. All rights reserved.
//

#import "SuggestionViewController.h"
#import "AnimationCustom.h"

#define maxNum 500
#define toolbarH 40.0

@interface SuggestionViewController ()

@end

@implementation SuggestionViewController

@synthesize charNumLable = _charNumLable;
@synthesize suggestionText = _suggestionText;
@synthesize mailText = _mailText;

- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _restCharNum = maxNum;
        //注册键盘回收通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    [self.view addSubview:_toolbar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)commitPressed:(UIButton *)sender {
    //邮箱格式判断
    NSString *mailAddr = self.mailText.text;
    if (![mailAddr isEqualToString:@""]) {
        NSRange dotRange = [mailAddr rangeOfString:@"." options:NSBackwardsSearch];
        NSRange atRange = [mailAddr rangeOfString:@"@" options:NSBackwardsSearch];
        if (dotRange.length > 0 && atRange.length > 0 && atRange.location < dotRange.location) {
            //邮箱格式正确,可以发送邮件
            if([MFMailComposeViewController canSendMail]){
                //创建邮件视图控制器
				MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
				[mailVC setSubject:@"找地儿邮件"];  //设置主题
				[mailVC setToRecipients:[NSArray arrayWithObject:self.mailText.text]]; //设置收件人
				[mailVC setCcRecipients:[NSArray arrayWithObject:@"bokan@126.com"]];//设置抄送对象
				[mailVC setBccRecipients:[NSArray arrayWithObject:@"bokan@126.com"]];//添加密送
				// 添加附件
				NSString *path = [[NSBundle mainBundle] pathForResource:@"rainy" ofType:@"png"];
				NSData *myData = [NSData dataWithContentsOfFile:path];
				[mailVC addAttachmentData:myData mimeType:@"image/png" fileName:@"rainy"]; //mimetype描述资源的媒体类型，用于让浏览器能区分不同类型的资源
				[mailVC setMessageBody:[NSString stringWithFormat:@"<html><body><font>%@</font></body></html>",self.suggestionText.text] isHTML:YES]; //设置内容
				[mailVC setMailComposeDelegate:self];//设置代理
				[self presentModalViewController:mailVC animated:YES];
            }else{
                NSLog(@"无法发送邮件");
            }
        }else{
//            self.mailText.text = @"";
            _alert = [[UIAlertView alloc]initWithTitle:@"邮箱格式错误" message:@"请重新输入邮箱" delegate:self cancelButtonTitle:@"本提示半秒后结束" otherButtonTitles:nil, nil];
            [_alert show];
        }

    }else{
        _alert = [[UIAlertView alloc]initWithTitle:@"给谁发送?" message:@"您还没输入邮箱呢" delegate:self cancelButtonTitle:@"本提示半秒后结束" otherButtonTitles:nil, nil];
        [_alert show];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissModalViewControllerAnimated:YES];//关闭邮件发送窗口
    NSString *msg;
    switch (result) {
        case MFMailComposeResultCancelled:
            msg = @"用户取消编辑邮件";
            break;
        case MFMailComposeResultSent:
            msg = @"用户点击发送，将邮件放到队列中，还没发送";
            break;
        case MFMailComposeResultFailed:
            msg = @"用户试图保存或者发送邮件失败";
            break;
        case MFMailComposeResultSaved:
            msg = @"用户成功保存邮件";
            break;
        default:
            break;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil ];
    [alert show];
}


-(void)didPresentAlertView:(UIAlertView *)alertView
{
    if (alertView == _alert) {
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(dismissAlert) userInfo:nil repeats:NO];
    }
}

-(void)dismissAlert
{
    [_alert dismissWithClickedButtonIndex:[_alert cancelButtonIndex] animated:YES];
}

- (IBAction)backPressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)controlPressed:(UIControl *)sender {
    [self.view endEditing:YES];
}

- (void)hideKeyboard:(UIButton *)btn
{
    [self.view endEditing:YES];
}

- (void)keyboardWillHide:(NSNotification *)note
{
    [AnimationCustom ViewDowningToItsOrigin:self.view];
    [AnimationCustom ViewDowningToItsOrigin:_toolbar];
}

- (void)keyboardDidShow:(NSNotification *)note
{
    rKBEnd = [[note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [AnimationCustom View:_toolbar UpingForDistance:rKBEnd.size.height+toolbarH-_distance];
}

#pragma mark -UITextViewDelegate

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    _distance = [AnimationCustom View:self.view UpWithKeyboardFor:textView];
    [AnimationCustom View:_toolbar UpingForDistance:rKBEnd.size.height+toolbarH-_distance];
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView == self.suggestionText) {
        if (textView.text.length > maxNum) {
            textView.text = [textView.text substringToIndex:maxNum];
        }
        _restCharNum = maxNum - textView.text.length;
        self.charNumLable.text = [NSString stringWithFormat:@"还可以输入%d字",_restCharNum];
    }
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.keyboardType = UIKeyboardTypeEmailAddress;
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    _distance = [AnimationCustom View:self.view UpWithKeyboardFor:textField];
    [AnimationCustom View:_toolbar UpingForDistance:rKBEnd.size.height+toolbarH-_distance];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
