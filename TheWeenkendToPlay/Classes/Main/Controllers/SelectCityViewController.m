//
//  SelectCityViewController.m
//  The weekend to play
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 秦俊珍. All rights reserved.
//

#import "SelectCityViewController.h"
#import "HeadCollectionReusableView.h"
//#import "FootCollectionReusableView.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "ProgressHUD.h"
#import <CoreLocation/CoreLocation.h>

static NSString *itemIntentfier = @"itemIdentifier";
static NSString *headIndentfier = @"headIndentfier";
//static NSString *footIndentfier = @"footIndentfier";

@interface SelectCityViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,CLLocationManagerDelegate>
{
    //创建定位所需的类的实例变量
    CLLocationManager *_locationManager;
    //创建地理编码对象1
    CLGeocoder *_geocode;
}
@property(nonatomic, retain) UICollectionView *collectionView;
@property(nonatomic, strong) NSMutableArray *citylistArray;
@property(nonatomic, strong) NSMutableArray *cityIdArray;
@end

@implementation SelectCityViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"切换城市";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:241/255.0 alpha:1.0];
    [self showBackButtonWithImage:@"cancle"];
    self.navigationController.navigationBar.barTintColor = MainColor;
    //请求网络数据
    [self loadData];
    [self.view addSubview:self.collectionView];

}
//
- (void)viewWillDisappear:(BOOL)animated{
    [super viewDidAppear:animated];
    [ProgressHUD dismiss];
}


- (void)loadData{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [sessionManager POST:[NSString stringWithFormat:@"%@",kSelectCity] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        QJZLog(@"uploadProgress = %@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"数据加载成功"];
        NSDictionary *dic = responseObject;
        NSInteger code = [dic[@"code"] integerValue];
        NSString *status = dic[@"status"];
        if (code == 0 && [status isEqualToString:@"success"]) {
            NSDictionary *successDic = dic[@"success"];
            NSArray *listArray = successDic[@"list"];
            for (NSDictionary *dict in listArray) {
                [self.citylistArray addObject:dict[@"cat_name"]];
                [self.cityIdArray addObject:dict[@"cat_id"]];
            }
            [self.collectionView reloadData];
            
        }else{
            QJZLog(@"responseObject = %@",responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD showError:@"加载失败"];
        QJZLog(@"error = %@",error);
    }];
}


- (void)reLocationAction:(UIButton *)btn{
    _locationManager = [[CLLocationManager alloc] init];
    _geocode = [[CLGeocoder alloc] init];
    if (![CLLocationManager locationServicesEnabled]) {
        QJZLog(@"用户位置服务不可用");
    }
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [_locationManager requestWhenInUseAuthorization];
        
    }else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse){
        
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        CLLocationDistance distance = 100.0;
        _locationManager.distanceFilter = distance;
        [_locationManager startUpdatingLocation];
        
        
        
    }
    
    
    
    
}
#pragma mark -------- UICollectionViewDataSource
//返回的是item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.citylistArray.count;
}
//返回3个分区
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"itemIdentifier" forIndexPath:indexPath];
    UILabel *cityLable = [[UILabel alloc] initWithFrame:cell.frame];
    cityLable.text = self.citylistArray[indexPath.row];
    cityLable.textAlignment = NSTextAlignmentCenter;
    cityLable.backgroundColor = [UIColor whiteColor];
    [self.collectionView addSubview:cityLable];
    return cell;
}

#pragma mark -------- 点击选择城市
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(getCityName:cityId:)]) {
        [self.delegate getCityName:self.citylistArray[indexPath.row] cityId:self.cityIdArray[indexPath.row]];
    }

    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }



- (void)selectItemAtIndexPath:(nullable NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UICollectionViewScrollPosition)scrollPosition{
    scrollPosition = UICollectionViewScrollPositionTop;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//    if (kind == UICollectionElementKindSectionHeader) {
        HeadCollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headIndentfier" forIndexPath:indexPath];
    //把“市”去掉
    NSString *city = [[NSUserDefaults standardUserDefaults] valueForKey:@"city"];
    //定位城市标签
    headView.nowLocationCityLable.text = city;
    
    
    //重新定位
    [headView.reLocationBtn addTarget:self action:@selector(reLocationAction:) forControlEvents:UIControlEventTouchUpInside];
        return headView;
//    }
//    FootCollectionReusableView *footView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"footIndentfier" forIndexPath:indexPath];
//    footView.backgroundColor = [UIColor cyanColor];
//    return footView;
}




/*
 常见的传值方式：
 1.属性传值
 2.代理
 3.block
 4.单例
 5.NSNotification
 6.KVO
 7.指针传值
 8.NSUserDefault/数据库
 */





#pragma mark --------- Custom Method
- (void)backButtonAction:(UIButton *)button{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ----------- lazy loading
- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        //创建一个layout布局类
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //设置布局方向（默认垂直方向）
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
//        //水平方向
//        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        //设置每一行间距
        layout.minimumLineSpacing = 5;
        //设置item间距
        layout.minimumInteritemSpacing = 1;
        //section的间距
        layout.sectionInset = UIEdgeInsetsMake(2, 0, 2, 0);
        
        //设置区头区尾大小
        layout.headerReferenceSize = CGSizeMake(kWidth, 160);
//        layout.footerReferenceSize = CGSizeMake(kWidth, 50);
        //设置每个item的大小
        layout.itemSize = CGSizeMake(120,70);
        //通过一个layout布局来创建一个collectionView
        self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
        self.collectionView.backgroundColor = [UIColor clearColor];
        //设置代理
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        //注册item类型
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"itemIdentifier"];
        
        //注册头部
        [self.collectionView registerNib:[UINib nibWithNibName:@"HeadCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headIndentfier];
        
//        //注册尾部
//        [self.collectionView registerClass:[FootCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footIndentfier"];
//        [self.view addSubview:self.collectionView];
        
    }
    return _collectionView;
}

- (NSMutableArray *)citylistArray{
    if (_citylistArray == nil) {
        self.citylistArray = [NSMutableArray new];
    }
    return _citylistArray;
}

- (NSMutableArray *)cityIdArray{
    if (_cityIdArray == nil) {
        self.cityIdArray = [NSMutableArray new];
    }
    return _cityIdArray;
}


- (void)btnAction{
    [self dismissViewControllerAnimated:YES completion:nil];
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
