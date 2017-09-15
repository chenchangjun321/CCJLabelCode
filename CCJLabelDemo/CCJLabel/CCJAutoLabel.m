//
//  CCJAutoLabel.m
//  CCJLabelDemo
//
//  Created by 陈长军 on 2017/9/15.
//  Copyright © 2017年 陈长军. All rights reserved.
//

#import "CCJAutoLabel.h"

@interface CCJAutoLabel ()

@property (nonatomic,assign) CGFloat mMaxWidth;
@property (nonatomic,assign) CGPoint mOrigin;

@end



@implementation CCJAutoLabel

- (instancetype)initWithOrigin:(CGPoint)origin andMaxWith:(CGFloat)maxWidth
{
    self = [super initWithFrame:CGRectMake(origin.x, origin.y,maxWidth, 0)];
    if (self) {
        self.mOrigin = origin;
        self.mMaxWidth = maxWidth;
        self.mMaxNumberOfLines = 0;
        self.mTextAlignment = NSTextAlignmentLeft;
        self.mFont = [UIFont systemFontOfSize:15];
    }
    return self;
}


-(void)setMText:(NSString *)mText
{
    _mText = mText;
    self.text = _mText;
    [self changeSize];
    

}
-(void)setMMaxNumberOfLines:(NSInteger)mMaxNumberOfLines
{
    _mMaxNumberOfLines = mMaxNumberOfLines;
    self.numberOfLines = _mMaxNumberOfLines;
    [self changeSize];
}


-(void)setMTextAlignment:(NSTextAlignment)mTextAlignment
{
    _mTextAlignment = mTextAlignment;
    self.textAlignment = _mTextAlignment;
    [self changeSize];
}

-(void)setMFont:(UIFont *)mFont
{
    _mFont = mFont;
    self.font = mFont;
    [self changeSize];
}

-(void)changeSize
{
    CGSize sizeThatFit=[self sizeThatFits:CGSizeMake(self.mMaxWidth, 0)];//200表示最大宽度，高度没有意义（可以不设）
    if(self.mMaxWidth-sizeThatFit.width<self.font.pointSize){
        [self setSize:CGSizeMake(self.mMaxWidth, sizeThatFit.height)];
    }else{
        [self setSize:sizeThatFit];
    }
    if(self.textAlignment == NSTextAlignmentRight){
        self.right = self.mMaxWidth+self.mOrigin.x;
    }else if(self.textAlignment == NSTextAlignmentLeft){
        self.left = self.mOrigin.x;
    }else if(self.textAlignment == NSTextAlignmentCenter){
        self.left = self.mOrigin.x + (self.mMaxWidth-self.width)/2;
    }else{
        self.left = self.origin.x;
    }
}

@end
