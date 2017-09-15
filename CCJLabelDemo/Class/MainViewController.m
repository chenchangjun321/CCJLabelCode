//
//  MainViewController.m
//  CCJLabelDemo
//
//  Created by 陈长军 on 2017/9/15.
//  Copyright © 2017年 陈长军. All rights reserved.
//

#import "MainViewController.h"
#import "CCJTextLabelVC.h"

@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *mTableView;
@property (nonatomic,strong) NSArray *dataArray;

@end

@implementation MainViewController

-(NSArray *)dataArray
{
    if(!_dataArray){
        _dataArray = @[@"text",@"attribteText"];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"分类";
    self.automaticallyAdjustsScrollViewInsets= NO;
    [self.view addSubview:self.mTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(UITableView *)mTableView
{
    
    if(!_mTableView){
        _mTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCWIDTH, SCHEIGHT) style:UITableViewStyleGrouped];
        [_mTableView setShowsVerticalScrollIndicator:NO];
        [_mTableView setShowsHorizontalScrollIndicator:NO];
        _mTableView.delegate = self;
        _mTableView.dataSource = self;
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return _mTableView;
}



#pragma mark ------------------------------- 关于TableView协议方法----------------------------------
/**
 secton 组数
 */

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
/**
 row 行数
 */
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

/**
 cell
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * cellID = @"test";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text =[self.dataArray objectAtIndex:indexPath.row];
    return cell;
    
}
/**
 row height --行高度
 */
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


/**
 *  给出cell的估计高度，主要目的是优化cell高度的计算次数
 */
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

//header
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

//footer
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0){
        [self.navigationController pushViewController:[CCJTextLabelVC new] animated:YES];
    }else if(indexPath.row ==1){
    
    }
}


@end
