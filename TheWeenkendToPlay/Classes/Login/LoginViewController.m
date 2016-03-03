//
//  LoginViewController.m
//  TheWeenkendToPlay
//
//  Created by scjy on 16/1/15.
//  Copyright © 2016年 秦俊珍. All rights reserved.
//

#import "LoginViewController.h"
#import <BmobSDK/Bmob.h>

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
            QJZLog(@"%@",user);
        }
    }];
    
    
    
    
    
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
