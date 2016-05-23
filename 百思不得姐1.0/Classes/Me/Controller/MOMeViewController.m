//
//  MOMeViewController.m
//  百思不得姐
//
//  Created by Andy_Lin on 16/4/14.
//  Copyright © 2016年 Andy_Lin. All rights reserved.
//

#import "MOMeViewController.h"
#import "MOMeCell.h"
#import "MOMeFooterView.h"

@interface MOMeViewController () 

@end

@implementation MOMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    [self setupTableView];
    
    // Do any additional setup after loading the view.
}


#pragma mark - -----设置导航栏
- (void)setupNav{
    
    self.navigationItem.title = @"我的";
    
    //设置导航栏右边的按钮
    UIBarButtonItem *settingItem = [UIBarButtonItem itemWithImage:@"mine-setting-icon" highImage:@"mine-setting-icon-click" target:self  action:@selector(settingClick)];
    
    UIBarButtonItem *moonItem = [UIBarButtonItem itemWithImage:@"mine-moon-icon" highImage:@"mine-moon-icon-click"  target: self action:@selector(moonClick)];
    //特别点的，一次两
    self.navigationItem.rightBarButtonItems = @[settingItem,moonItem];
    
    
}

- (void)setupTableView{
    // 设置背景色
    self.tableView.backgroundColor = MOGlobalBg;
    
    //注册上面的小cell--
    [self.tableView registerClass: [MOMeCell class] forCellReuseIdentifier:MOMeID];
    //并设置以section为单位的cell之间的间距
    self.tableView.sectionHeaderHeight =  0;
    self.tableView.sectionFooterHeight = MOTopicCellMargin;
    self.tableView.contentInset = UIEdgeInsetsMake(MOTopicCellMargin - 35, 0, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //设置下面的大cell -->footerView
    self.tableView.tableFooterView = [[MOMeFooterView alloc]init];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 1000, 0);
    
}

#pragma mark - tableView数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
static NSString * const MOMeID = @"me";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MOMeCell *cell = [tableView dequeueReusableCellWithIdentifier:MOMeID];
    if (indexPath.section == 0) {
        cell.imageView.image = [UIImage imageNamed:@"cellFollowClickIcon"];
        cell.textLabel.text = @"登录/注册";
    }else if (indexPath.section == 1 ){
    cell.textLabel.text = @"离线下载";
    }
    return cell;
}

#pragma mark - --写控制器内的控件方法

- (void)settingClick
{
    MOLogFunc;
}

- (void)moonClick
{
    MOLogFunc;
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
