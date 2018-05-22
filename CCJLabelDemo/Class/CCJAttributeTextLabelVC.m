//
//  CCJAttributeTextLabelVC.m
//  CCJLabelDemo
//
//  Created by 陈长军 on 2017/9/15.
//  Copyright © 2017年 陈长军. All rights reserved.
//

#import "CCJAttributeTextLabelVC.h"
#import "CCJAutoLabel.h"

//边距
static CGFloat const LEFT_MARGIN = 10;
static CGFloat const RIGHT_MARGIN = 10;
static CGFloat const TOP_MARGIN = 10;
static CGFloat const BUTTON_MARGIN = 10;



@interface CCJAttributeTextLabelVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIView *mBackLabelView;
@property (nonatomic,strong) CCJAutoLabel *mLabel;

@property (nonatomic,strong) UITableView *mTableView;

@property (nonatomic,strong) NSArray *dataArray;

@end

@implementation CCJAttributeTextLabelVC

-(NSArray *)dataArray
{
    if(!_dataArray){
        _dataArray = @[@"改变部分字体",@"改变部分字色",@"修改字间距",@"修改行间距",@"添加下划线",@"添加中划线"];
    }
    return _dataArray;
}

-(UIView *)mBackLabelView
{
    if(!_mBackLabelView){
        _mBackLabelView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCWIDTH, 0)];
        _mBackLabelView.backgroundColor = [UIColor greenColor];
        [_mBackLabelView addSubview:self.mLabel];
        _mBackLabelView.height = self.mLabel.height;
    }
    return _mBackLabelView;
}
-(CCJAutoLabel *)mLabel
{
    if(!_mLabel){
        _mLabel = [[CCJAutoLabel alloc]initWithOrigin:CGPointMake(LEFT_MARGIN, 0) andMaxWith:SCWIDTH-LEFT_MARGIN-RIGHT_MARGIN];
        _mLabel.backgroundColor = [UIColor yellowColor];
        _mLabel.mAttributeText = @"12345678901234567890https://www.baidu.com1234567890123456789012345678901234567890123456789012345678901234567890哈哈asds哈哈哈http://www.sohu.com";
    }
    return _mLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets= NO;
    self.navigationItem.title = @"text";
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
        _mTableView.tableHeaderView = self.mBackLabelView;
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
        [self.mLabel setAttributeTextFont:[UIFont systemFontOfSize:20] andRange:NSMakeRange(0, 3)];
    }else if(indexPath.row ==1){
        [self.mLabel setAttributeTextColor:[UIColor redColor] andRange:NSMakeRange(3, 2)];
    }else if(indexPath.row == 2){
        [self.mLabel setAttributeTextCharacterSpacing:20 andRange:NSMakeRange(0, 10)];
    }else if(indexPath.row ==3){
        [self.mLabel setAttributeTextParagraphSpace:25];
    }else if(indexPath.row ==4){
        [self.mLabel setAttributeTextUnderLineRange:NSMakeRange(0, 3) andLineColor:[UIColor redColor]];
    }else{
        [self.mLabel setAttributeTextStrikeThroughLineRange:NSMakeRange(4, 3) andLineColor:[UIColor greenColor]];
    }
    self.mBackLabelView.height = self.mLabel.height;
    [self.mTableView reloadData];
}

@end
