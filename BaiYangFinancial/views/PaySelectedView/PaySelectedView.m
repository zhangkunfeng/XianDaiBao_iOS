//
//  PaySelectedView.m
//  xrtz
//
//  Created by 洪徐 on 16/7/19.
//  Copyright © 2016年 艾运旺. All rights reserved.
//

#import "PaySelectedView.h"
#import "Masonry.h"
#import "QRadioButton.h"
@interface PaySelectedView () <QRadioButtonDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSArray * _selectViewDataArray;
}
@end
@implementation PaySelectedView 


- (instancetype)init {
    self = [[[NSBundle mainBundle] loadNibNamed:@"PaySelectedView" owner:self options:nil] lastObject];
    if (self) {
        CGRect viewFram = self.frame;
        viewFram.size.height = iPhoneHeight;
        viewFram.size.width = iPhoneWidth;
        self.frame = viewFram;
        
        [self settingView];
        return self;
    }
    return nil;
}
-(void)settingView
{
    self.selectViewTableView.delegate = self;
    self.selectViewTableView.dataSource = self;
}
-(void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId
{
    self.sureBtn.tag = radio.tag;
}

- (IBAction)cancelBtnClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(cancelTappend)]) {
        [self.delegate cancelTappend];
    }
    NSLog(@"点击了取消");
}

- (IBAction)sureBtnClicked:(id)sender {

    if ([self.delegate respondsToSelector:@selector(sureTappend:)]) {
         sender = self.sureBtn;
        [self.delegate sureTappend:sender];
    }
    NSLog(@"点击了确定");
}

-(void)setSelectViewDataArray:(NSArray *)array
{
    if (array.count > 0) {
        self.seclectedViewHeight.constant = 126+55*array.count;
        _selectViewDataArray = [NSArray arrayWithArray:array];
        [_selectViewTableView reloadData];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _selectViewDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    NSString * cellID = @"paySelectedViewCellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    NSDictionary * dict = [_selectViewDataArray objectAtIndex:indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:![self isBlankString:dict[@"payCode"]]?[NSString stringWithFormat:@"%@Pay",dict[@"payCode"]]:@"normal"];
    cell.textLabel.text = ![self isBlankString:dict[@"payName"]]?dict[@"payName"]:@"";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    QRadioButton *radio = [[QRadioButton alloc]initWithDelegate:self groupId:@"remaind"];
    radio.frame = CGRectMake(self.selectViewTableView.frame.size.width-45, 0, 55, 55);
    [radio setTitle:@"" forState:UIControlStateNormal];
    radio.tag = indexPath.row;
    indexPath.row==0?[radio setChecked:YES]:@"";
    cell.contentView.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:radio];

    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


- (BOOL)isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return YES;
    }
    return NO;
}

@end
