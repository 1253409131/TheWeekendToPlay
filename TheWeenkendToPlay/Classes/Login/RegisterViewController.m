//
//  RegisterViewController.m
//  TheWeenkendToPlay
//
//  Created by scjy on 16/3/2.
//  Copyright © 2016年 秦俊珍. All rights reserved.
//

#import "RegisterViewController.h"
#import <BmobSDK/BmobUser.h>
#import "ProgressHUD.h"
@interface RegisterViewController ()<UITextFieldDelegate>

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showBackButtonWithImage:@"back"];
    self.title = @"注册";
    //密码密文显示
    self.passWordText.secureTextEntry = YES;
    self.passWordAgainText.secureTextEntry = YES;
    //默认Switch关闭，密码不显示
//    self.passWordSwitch.on = NO;
    
}

#pragma mark ------------ UITextFieldDelegate
//点击右下角回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
//点击空白处回收键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


- (IBAction)passWordSwitchAction:(id)sender {
    UISwitch *passWordSwitch = sender;
    if (passWordSwitch.on) {
        self.passWordText.secureTextEntry = NO;
        self.passWordAgainText.secureTextEntry = NO;
    }else{
    self.passWordText.secureTextEntry = YES;
    self.passWordAgainText.secureTextEntry = YES;
    }
}


//点击注册执行的方法
- (IBAction)RegisterAction:(id)sender {
    [ProgressHUD show:@"正在为您注册"];
    BmobUser *bUser = [[BmobUser alloc] init];
    
    [bUser setUsername:self.userNameText.text];
    [bUser setPassword:self.passWordText.text];
    [bUser signUpInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            [ProgressHUD showSuccess:@"注册成功"];
            QJZLog(@"注册成功");
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"恭喜你" message:@"注册成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                QJZLog(@"确定");
            }];
            UIAlertAction *candel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                QJZLog(@"取消");
            }];
            [alert addAction:action];
            [alert addAction:candel];
            [self presentViewController:alert animated:YES completion:nil];
            
            
            
        }else{
            
            [ProgressHUD showError:@"注册失败"];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"很遗憾" message:@"注册失败" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                QJZLog(@"确定");
            }];
            UIAlertAction *candel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                QJZLog(@"取消");
            }];
            [alert addAction:action];
            [alert addAction:candel];
            [self presentViewController:alert animated:YES completion:nil];
            
            QJZLog(@"注册失败");
        }
    }];
    
}

//注册之前需要判断
- (BOOL)checkout{
    //用户名不能为空且不能为空格
    if (self.userNameText.text.length <= 0 || [self.userNameText.text stringByReplacingOccurrencesOfString:@" " withString:@""].length <= 0) {
        //alert提示框
        return NO;
    }
    
    //两次输入密码一致
    if ([self.passWordText.text isEqualToString:self.passWordAgainText.text]) {
        //alert提示框
        
        return NO;
    
    }
    
    
    //输入的密码不能为空
    if (self.passWordText.text.length <= 0 || [self.passWordText.text stringByReplacingOccurrencesOfString:@" " withString:@""] <= 0) {
        //alert密码不能为空
        return NO;
    }
    
    //用正则表达式判断
    //1.判断输入是否有效的手机号
    
    //2.判断输入邮箱是否正确
    
    
    
    return YES;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
