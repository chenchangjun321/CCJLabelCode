//
//  CCJAutoLabel.m
//  CCJLabelDemo
//
//  Created by 陈长军 on 2017/9/15.
//  Copyright © 2017年 陈长军. All rights reserved.
//

#import "CCJAutoLabel.h"
#import<CoreText/CoreText.h>

typedef NS_ENUM(NSUInteger, XSAttributedType) {
    XSAttributedTypeColor,
    XSAttributedTypeFont,
    XSAttributedTypeParagraph,
    XSAttributedTypecharacterSpacing,
};


@interface CCJAutoLabel ()

@property (nonatomic,assign) CGFloat mMaxWidth;
@property (nonatomic,assign) CGPoint mOrigin;
@property (nonatomic, strong)NSMutableAttributedString *mAttributeString;

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

-(void)setMAttributeString:(NSMutableAttributedString *)mAttributeString
{
    _mAttributeString = mAttributeString;
    self.attributedText = _mAttributeString;
    [self renderAttribute];
}
-(void)setMAttributeText:(NSString *)mAttributeText
{
    _mAttributeText = mAttributeText;
    self.mText = _mAttributeText;
    self.mAttributeString = [[NSMutableAttributedString alloc]initWithString:_mAttributeText];
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

- (void)renderAttribute {
    self.attributedText = self.mAttributeString;
    [self changeSize];
}



-(void)setAttributeTextFont:(UIFont*)font andRange:(NSRange)range
{
    if(font){
        [self addAttributeType:XSAttributedTypeFont value:font range:range];
    }
    [self renderAttribute];
}
-(void)setAttributeTextColor:(UIColor *)color andRange:(NSRange)range
{
    if(color){
        [self addAttributeType:XSAttributedTypeColor value:color range:range];
    }
    [self renderAttribute];
}


- (void)addAttributeType:(XSAttributedType)xmAttributedType_ value:(id)value_ range:(NSRange)range_ {
    NSAssert((xmAttributedType_ == XSAttributedTypeColor || xmAttributedType_ == XSAttributedTypeFont || xmAttributedType_ == XSAttributedTypeParagraph || xmAttributedType_ == XSAttributedTypecharacterSpacing), @"type is wrong");
    NSAssert(range_.length + range_.location <= self.mAttributeString.length, @"the range index is out of length ");
    if (xmAttributedType_ == XSAttributedTypeColor) {
        [self.mAttributeString addAttribute:NSForegroundColorAttributeName value:value_ range:range_];
    } else if (xmAttributedType_ == XSAttributedTypeFont) {
        [self.mAttributeString addAttribute:NSFontAttributeName value:value_ range:range_];
    } else if (xmAttributedType_ == XSAttributedTypeParagraph) {
        [self.mAttributeString addAttribute:NSParagraphStyleAttributeName value:value_ range:range_];
    } else if (xmAttributedType_ == XSAttributedTypecharacterSpacing) {
        [self.mAttributeString addAttribute:(id)kCTKernAttributeName value:value_ range:range_];
    }
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
