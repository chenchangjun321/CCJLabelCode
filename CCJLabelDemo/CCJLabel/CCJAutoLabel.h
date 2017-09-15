//
//  CCJAutoLabel.h
//  CCJLabelDemo
//
//  Created by 陈长军 on 2017/9/15.
//  Copyright © 2017年 陈长军. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 @brief 版本说明
 @discussion v1.0.0
 1.根据字体，文字多少，自己修正Label的高度和宽度
 */

@interface CCJAutoLabel : UILabel

/**
 @brief 普通文字
 */
@property (nonatomic,strong) NSString               *mText;

/**
 @brief 最多显示行数
 @discussion 默认0，不限制行数
 */
@property (nonatomic,assign) NSInteger              mMaxNumberOfLines;

/**
 @brief 字体
 @discussion 默认15号
 */
@property (nonatomic,strong) UIFont                 *mFont;

/**
 @brief 文字对齐方式
 @discussion 默认左边对齐
 */
@property (nonatomic,assign) NSTextAlignment        mTextAlignment;

/**
 @brief 初始化方法
 @discussion 给出最大宽度和原点
 @param origin label的原点
 @param maxWidth 最大宽度
 */
- (instancetype)initWithOrigin:(CGPoint)origin andMaxWith:(CGFloat)maxWidth;


@end
