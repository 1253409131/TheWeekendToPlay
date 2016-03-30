//
//  LoginViewController.m
//  TheWeenkendToPlay
//
//  Created by scjy on 16/1/15.
//  Copyright © 2016年 秦俊珍. All rights reserved.
//

#import "LoginViewController.h"
#import <BmobSDK/Bmob.h>
#import "ProgressHUD.h"

@interface LoginViewController ()<BmobEventDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showBackButtonWithImage:@"back"];
    self.navigationController.navigationBar.barTintColor = MainColor;

}

- (void)backButtonAction:(UIButton *)btn{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


//登录
- (IBAction)loginAction:(id)sender {
    [BmobUser loginWithUsernameInBackground:self.userNameText.text password:self.passWordText.text block:^(BmobUser *user, NSError *error) {
        if (user) {
            QJZLog(@"user = %@",user);
            [ProgressHUD showSuccess:@"登陆成功"];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            
        }else{
            [ProgressHUD showError:@"登录失败"];
        }
        
    }];

}

//点击右下角回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
//点击页面空白处回收键盘
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    
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
