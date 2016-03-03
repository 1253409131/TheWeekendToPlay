//
//  SelectCityViewController.h
//  The weekend to play
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 秦俊珍. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SelectCityDelegate <NSObject>

- (void)getCityName:(NSString *)cityName cityId:(NSString *)cityId;

@end

@interface SelectCityViewController : UIViewController

@property(nonatomic, assign) id<SelectCityDelegate>delegate;

@end
