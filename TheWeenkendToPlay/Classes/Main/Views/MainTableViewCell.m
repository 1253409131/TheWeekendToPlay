//
//  MainTableViewCell.m
//  The weekend to play
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 秦俊珍. All rights reserved.
//

#import "MainTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <CoreLocation/CoreLocation.h>
@interface MainTableViewCell ()
//活动图片
@property (weak, nonatomic) IBOutlet UIImageView *activityImageView;
//活动名字
@property (weak, nonatomic) IBOutlet UILabel *activityNameLable;
//活动价格
@property (weak, nonatomic) IBOutlet UILabel *activityPriceLable;
//活动距离
@property (weak, nonatomic) IBOutlet UIButton *activityDistanceBtn;




@end

@implementation MainTableViewCell

- (void)setMainModel:(MainModel *)mainModel{
    [self.activityImageView sd_setImageWithURL:[NSURL URLWithString:mainModel.image_big] placeholderImage:nil];//网上获取图片
    self.activityNameLable.text = mainModel.title;
//    NSLog(@"mainModel.title = %@",mainModel.title);
    self.activityPriceLable.text = mainModel.price;
//    NSLog(@"mainModel.price = %@",mainModel.price);
    
    //计算两个经纬度之间的距离
    double origlat = [[[NSUserDefaults standardUserDefaults] valueForKey:@"lat"] doubleValue];
    double origlng = [[[NSUserDefaults standardUserDefaults] valueForKey:@"lng"] doubleValue];
    CLLocation *origLoc = [[CLLocation alloc] initWithLatitude:origlat longitude:origlng];
    CLLocation *disLoc = [[CLLocation alloc] initWithLatitude:mainModel.lat longitude:mainModel.lng];
    double distance = [origLoc distanceFromLocation:disLoc] / 1000;
    [self.activityDistanceBtn setTitle:[NSString stringWithFormat:@"%.2f",distance] forState:UIControlStateNormal];
    
    
    

    if ([mainModel.type intValue]== 0) {
        self.activityPriceLable.hidden = YES;
        self.activityDistanceBtn.hidden  = YES;
        self.activityNameLable.hidden  = YES;
        
        
    }else{
        self.activityPriceLable.hidden = NO;
        self.activityDistanceBtn.hidden  = NO;
        self.activityNameLable.hidden  = NO;
    }

}









- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
