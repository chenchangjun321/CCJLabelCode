//
//  CCJTextLabelVC.m
//  CCJLabelDemo
//
//  Created by 陈长军 on 2017/9/15.
//  Copyright © 2017年 陈长军. All rights reserved.
//

#import "CCJTextLabelVC.h"
#import "CCJAutoLabel.h"

//边距
static CGFloat const LEFT_MARGIN = 10;
static CGFloat const RIGHT_MARGIN = 10;
static CGFloat const TOP_MARGIN = 10;
static CGFloat const BUTTON_MARGIN = 10;



@interface CCJTextLabelVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIView *mBackLabelView;
@property (nonatomic,strong) CCJAutoLabel *mLabel;

@property (nonatomic,strong) UITableView *mTableView;

@property (nonatomic,strong) NSArray *dataArray;

@end

@implementation CCJTextLabelVC

-(NSArray *)dataArray
{
    if(!_dataArray){
        _dataArray = @[@"改变最大行数",@"字体修改",@"变为右边对齐",@"变为中间对齐",@"变为左边对齐",@"修改内容"];
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
        _mLabel.mText = @"123123";
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
        if(self.mLabel.mMaxNumberOfLines==0){
            self.mLabel.mMaxNumberOfLines = 3;
        }else{
            self.mLabel.mMaxNumberOfLines = 0;
        }
    }else if(indexPath.row ==1){
        if(self.mLabel.mFont.pointSize !=20){
            self.mLabel.mFont = [UIFont systemFontOfSize:20];
        }else{
            self.mLabel.mFont = [UIFont systemFontOfSize:15];
        }
    }else if(indexPath.row ==2){
        self.mLabel.mTextAlignment = NSTextAlignmentRight;
    }else if(indexPath.row ==3){
        self.mLabel.mTextAlignment = NSTextAlignmentCenter;
    }
    else if(indexPath.row ==4){
        self.mLabel.mTextAlignment = NSTextAlignmentLeft;
    }else if(indexPath.row ==5){
        self.mLabel.mText = @"fdskfjsklfjsljflsjflsdjfldsjflsjflsjflsjlsjfsjdfjldjfljfdskfjsklfjsljflsjflsdjfldsjflsjflsjflsjlsjfsjdfjldjfljfdskfjsklfjsljflsjflsdjfldsjflsjflsjflsjlsjfsjdfjldjflj";
    }
    self.mBackLabelView.height = self.mLabel.height;
    [self.mTableView reloadData];
    
}


@end
