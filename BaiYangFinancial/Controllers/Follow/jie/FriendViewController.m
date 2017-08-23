//
//  FriendViewController.m
//  BaiYangFinancial
//
//  Created by 李艳楠 on 2017/6/28.
//  Copyright © 2017年 Hangzhou Futuo Financial Information Service Co., Ltd. All rights reserved.
//

#import "FriendViewController.h"
#import "FriendTableViewCell.h"
@interface FriendViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic,strong)UISearchBar *searchBar;
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation FriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    [self configSearchBar];
    [self configTableView];
}
- (void)configSearchBar {
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(10, 74, self.view.bounds.size.width - 20, 25)];
    _searchBar.placeholder = @"输入要搜索的好友和名称";
    [self.view addSubview:_searchBar];
    _searchBar.layer.cornerRadius = 5;
    _searchBar.layer.masksToBounds = YES;
    UIImage* searchBarBg = [self GetImageWithColor:[UIColor lightGrayColor] andHeight:25.0f];
    //设置背景图片
    [_searchBar setBackgroundImage:searchBarBg];
    //设置背景色
    [_searchBar setBackgroundColor:[UIColor clearColor]];
    //设置文本框背景
    [_searchBar setSearchFieldBackgroundImage:searchBarBg forState:UIControlStateNormal];
    
}
- (void)configTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_searchBar.frame) + 10, self.view.bounds.size.width, self.view.bounds.size.height - CGRectGetMaxY(_searchBar.frame) - 10) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"FriendTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        return 10;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (indexPath.section == 0) {
        cell.name.text = @"添加好友";
        cell.nextImg.hidden = NO;
//        cell.nextImg.image
    }else if (indexPath.section == 1){
        cell.name.text = @"邀请好友";
        cell.nextImg.hidden = NO;
    }else{
        cell.nextImg.hidden = YES;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1 || section == 2) {
        return 0.0001;
    }
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
        view.backgroundColor = [UIColor lightGrayColor];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, 30)];
        label.text = @"我的好友";
        label.font = [UIFont systemFontOfSize:15];
        CGPoint center = label.center;
        center.y = 20;
        label.center = center;
        label.textColor = [UIColor blueColor];
        [view addSubview:label];
        return view;
    }
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    {
        if (section == 2) {
            return 40;
        }
        return 0.0001;
    }
}
- (UIImage*) GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height
{
    CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

@end
