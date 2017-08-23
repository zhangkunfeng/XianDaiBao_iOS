//
//  RiskGradeListViewController.m
//  weidaiwang
//
//  Created by 艾运旺 on 15/9/11.
//  Copyright (c) 2015年 艾运旺. All rights reserved.
//

#import "RiskGradeListViewController.h"

@interface RiskGradeListViewController ()


@property (nonatomic, copy)NSArray *imageAndtiltleArray;

@end

@implementation RiskGradeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CustomMadeNavigationControllerView *RiskGradeListView = [[CustomMadeNavigationControllerView alloc] initWithTitle:@"安全等级" showBackButton:YES showRightButton:NO rightButtonTitle:nil target:self];
    [self.view addSubview:RiskGradeListView];
    
    
    _RiskGradeTableview.tableFooterView=[[UIView alloc]init];//关键语句，去掉多余的cell分割线
    
    //存放列表图片和标题
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"RiskGradeListplist" ofType:@"plist"];
    _imageAndtiltleArray = [[NSArray alloc] initWithContentsOfFile:plistPath];
}

#pragma mark - 返回按钮的事件处理
-(void)goBack{
    [self customPopViewController:0];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_imageAndtiltleArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *TableViewID = @"RiskGradeTableView";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableViewID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableViewID];
    }else{
        //删除cell的所有子视图
        while ([cell.contentView.subviews lastObject] != nil)
        {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    [self setCellSeperatorToLeft:cell];
    cell.imageView.image = [UIImage imageNamed:[_imageAndtiltleArray objectAtIndex:indexPath.row][@"image"]];
    cell.textLabel.text = [_imageAndtiltleArray objectAtIndex:indexPath.row][@"title"];
    return cell;
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
