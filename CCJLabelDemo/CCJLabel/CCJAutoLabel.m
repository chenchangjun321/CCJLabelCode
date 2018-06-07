//
//  CCJAutoLabel.m
//  CCJLabelDemo
//
//  Created by 陈长军 on 2017/9/15.
//  Copyright © 2017年 陈长军. All rights reserved.
//

#import "CCJAutoLabel.h"
#import<CoreText/CoreText.h>

static inline CGFLOAT_TYPE CGFloat_sqrt(CGFLOAT_TYPE cgfloat) {
#if CGFLOAT_IS_DOUBLE
    return sqrt(cgfloat);
#else
    return sqrtf(cgfloat);
#endif
}

static inline CGFLOAT_TYPE CGFloat_ceil(CGFLOAT_TYPE cgfloat) {
#if CGFLOAT_IS_DOUBLE
    return ceil(cgfloat);
#else
    return ceilf(cgfloat);
#endif
}


static inline CGFloat CJFlushFactorForTextAlignment(NSTextAlignment textAlignment) {
    switch (textAlignment) {
        case NSTextAlignmentCenter:
            return 0.5f;
        case NSTextAlignmentRight:
            return 1.0f;
        case NSTextAlignmentLeft:
        default:
            return 0.0f;
    }
}


typedef NS_ENUM(NSUInteger, XSAttributedType) {
    XSAttributedTypeColor,
    XSAttributedTypeFont,
    XSAttributedTypeParagraph,
    XSAttributedTypecharacterSpacing,
    XSUnderlineStyleAttributeName,
    XSUnderlineColorAttributeName,
    XSStrikethroughStyleAttributeName,
    XSStrikethroughColorAttributeName
};


@interface CCJAutoLabel ()

@property (nonatomic,assign) CGFloat mMaxWidth;
@property (nonatomic,assign) CGPoint mOrigin;
@property (nonatomic, strong)NSMutableAttributedString *mAttributeString;
@property (nonatomic,strong)void (^mLinkClick)(NSString *link);

@property(nonatomic, strong) NSArray* matches;


@end



@implementation CCJAutoLabel

- (instancetype)initWithOrigin:(CGPoint)origin andMaxWith:(CGFloat)maxWidth
{
    self = [super initWithFrame:CGRectMake(origin.x, origin.y,maxWidth, 0)];
    if (self) {
        self.userInteractionEnabled = YES;
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
    [self getLinkArray];
    [self highlightLinksWithIndex:NSNotFound];

}

-(void)getLinkArray
{
//    NSError *error = NULL;
//    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:&error];
//    self.matches = [detector matchesInString:self.mText options:0 range:NSMakeRange(0, self.mText.length)];
    
    NSError *error = NULL;
    NSString *regulaStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSRegularExpression *detector = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                              options:NSRegularExpressionCaseInsensitive
                                                                                error:&error];
    self.matches = [detector matchesInString:self.mText options:0 range:NSMakeRange(0, self.mText.length)];

    
    NSLog(@"%@",self.matches);
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


-(NSString *)chenckString:(NSString *)text
{
    NSArray *tempArray = [text componentsSeparatedByString:@"."];
    NSString *newString = [tempArray componentsJoinedByString:@"\\."];
    
    NSArray *tempArray1 = [newString componentsSeparatedByString:@"$"];
    NSString *newString1 = [tempArray1 componentsJoinedByString:@"\\$"];
    
    NSArray *tempArray2 = [newString1 componentsSeparatedByString:@"*"];
    NSString *newString2 = [tempArray2 componentsJoinedByString:@"\\*"];
    return newString2;
}

-(void)setString:(NSString *)subText andColor:(UIColor *)color;
{
    if(subText == nil){
        return ;
    }
    NSString *stringText = self.mAttributeString.string;
    NSString *pater5 = [self chenckString:subText];
    NSRegularExpression *regex = [[NSRegularExpression alloc]initWithPattern:pater5 options:0 error:nil];
    NSArray *arry =    [regex matchesInString:stringText options:0 range:NSMakeRange(0, stringText.length)];
    for (NSTextCheckingResult *result in arry) {
        NSLog(@"%@  %@",NSStringFromRange(result.range),[stringText substringWithRange:result.range]);
        if(result.range.length<1){
            continue;
        }
        NSRange range = NSMakeRange(result.range.location, result.range.length);
        if(color){
            [self addAttributeType:XSAttributedTypeColor value:color range:range];
        }
    }
    [self renderAttribute];
}

-(void)setString:(NSString *)subText andFont:(UIFont *)font
{
    
    if(subText == nil){
        return ;
    }
    NSString *stringText = self.mAttributeString.string;
    NSString *pater5 = [self chenckString:subText];
    NSRegularExpression *regex = [[NSRegularExpression alloc]initWithPattern:pater5 options:0 error:nil];
    NSArray *arry =    [regex matchesInString:stringText options:0 range:NSMakeRange(0, stringText.length)];
    for (NSTextCheckingResult *result in arry) {
        NSLog(@"%@  %@",NSStringFromRange(result.range),[stringText substringWithRange:result.range]);
        if(result.range.length<1){
            continue;
        }
        NSRange range = NSMakeRange(result.range.location, result.range.length);
        if(font){
            [self addAttributeType:XSAttributedTypeFont value:font range:range];
        }
    }
    [self renderAttribute];
}


-(void)setAttributeTextCharacterSpacing:(CGFloat)wordSpace andRange:(NSRange)range;
{
    [self addAttributeType:XSAttributedTypecharacterSpacing value:[NSNumber numberWithFloat:wordSpace] range:range];
    [self renderAttribute];
}

/**
 @brief 行间距
 @discussion paragraphSpace 间距
 */
-(void)setAttributeTextParagraphSpace:(CGFloat)paragraphSpace 
{
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:paragraphSpace];//行间距
    [self addAttributeType:XSAttributedTypeParagraph value:paragraphStyle range:NSMakeRange(0, self.mAttributeString.length)];
    [self renderAttribute];
}

-(void)setAttributeTextUnderLineRange:(NSRange)range andLineColor:(UIColor*)lineColor
{
    [self addAttributeType:XSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
    [self addAttributeType:XSUnderlineColorAttributeName value:lineColor range:range];
    [self renderAttribute];
}

-(void)setAttributeTextStrikeThroughLineRange:(NSRange)range andLineColor:(UIColor*)lineColor;
{
    [self addAttributeType:XSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
    [self addAttributeType:XSStrikethroughColorAttributeName value:lineColor range:range];
    [self.mAttributeString addAttribute:NSBaselineOffsetAttributeName value:@0 range:range];
    [self renderAttribute];

}

- (void)addAttributeType:(XSAttributedType)xmAttributedType_ value:(id)value_ range:(NSRange)range_ {
    NSAssert(range_.length + range_.location <= self.mAttributeString.length, @"the range index is out of length ");
    if (xmAttributedType_ == XSAttributedTypeColor) {
        [self.mAttributeString addAttribute:NSForegroundColorAttributeName value:value_ range:range_];
    } else if (xmAttributedType_ == XSAttributedTypeFont) {
        [self.mAttributeString addAttribute:NSFontAttributeName value:value_ range:range_];
    } else if (xmAttributedType_ == XSAttributedTypeParagraph) {
        [self.mAttributeString addAttribute:NSParagraphStyleAttributeName value:value_ range:range_];
    } else if (xmAttributedType_ == XSAttributedTypecharacterSpacing) {
        [self.mAttributeString addAttribute:(id)kCTKernAttributeName value:value_ range:range_];
    } else if(xmAttributedType_ == XSUnderlineStyleAttributeName){
        [self.mAttributeString addAttribute:(id)NSUnderlineStyleAttributeName value:value_ range:range_];
    }else if(xmAttributedType_ == XSUnderlineColorAttributeName){
        [self.mAttributeString addAttribute:(id)NSUnderlineColorAttributeName value:value_ range:range_];
    }else if(xmAttributedType_ == XSStrikethroughStyleAttributeName){
        [self.mAttributeString addAttribute:(id)NSStrikethroughStyleAttributeName value:value_ range:range_];
    }else if(xmAttributedType_ == XSStrikethroughColorAttributeName){
        [self.mAttributeString addAttribute:NSStrikethroughColorAttributeName value:value_ range:range_];
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
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    UITouch * touch = touches.anyObject;
    //获取触摸点击当前view的坐标位置
    CGPoint location = [touch locationInView:self];
    //    NSLog(@"location %@",NSStringFromCGPoint(location));
    
    if(![self needResponseTouchLabel:location]) {
        [self.nextResponder touchesBegan:touches withEvent:event];
    }

}
- (BOOL)needResponseTouchLabel:(CGPoint)location {
    NSUInteger curIndex = (NSUInteger)[self characterIndexAtPoint1:location];
    if (!NSLocationInRange(curIndex, NSMakeRange(0, self.attributedText.length))) {
        return NO;
    }else{
        [self onCharacterAtIndex:curIndex];
        return YES;
    }
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    [self.nextResponder touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.nextResponder touchesEnded:touches withEvent:event];
}



-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.nextResponder touchesCancelled:touches withEvent:event];
    
}


- (CFIndex)characterIndexAtPoint:(CGPoint)p {
    CGRect bounds = self.bounds;
    if (!CGRectContainsPoint(bounds, p)) {
        return NSNotFound;
    }
    
    CGRect textRect = [self textRectForBounds:bounds limitedToNumberOfLines:self.numberOfLines];
    textRect.size = CGSizeMake(CGFloat_ceil(textRect.size.width), CGFloat_ceil(textRect.size.height));
    //textRect的height值存在误差，值需设大一点，不然不会包含最后一行lines
    CGRect pathRect = CGRectMake(textRect.origin.x, textRect.origin.y, textRect.size.width, textRect.size.height+ 100000);
    if (!CGRectContainsPoint(textRect, p)) {
        return NSNotFound;
    }
    
    // Offset tap coordinates by textRect origin to make them relative to the origin of frame
    p = CGPointMake(p.x - textRect.origin.x, p.y - textRect.origin.y);
    // Convert tap coordinates (start at top left) to CT coordinates (start at bottom left)
    // p.x-5 是因为测试发现x轴坐标有偏移误差
    p = CGPointMake(p.x-5, pathRect.size.height - p.y);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, pathRect);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self.attributedText);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, (CFIndex)[self.attributedText length]), path, NULL);
    
    if (frame == NULL) {
        CGPathRelease(path);
        return NSNotFound;
    }
    
    CFArrayRef lines = CTFrameGetLines(frame);
    NSInteger numberOfLines = self.numberOfLines > 0 ? MIN(self.numberOfLines, CFArrayGetCount(lines)) : CFArrayGetCount(lines);
    if (numberOfLines == 0) {
        CFRelease(frame);
        CGPathRelease(path);
        return NSNotFound;
    }
    
    CFIndex idx = NSNotFound;
    
    CGPoint lineOrigins[numberOfLines];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, numberOfLines), lineOrigins);
    
    for (CFIndex lineIndex = 0; lineIndex < numberOfLines; lineIndex++) {
        CGPoint lineOrigin = lineOrigins[lineIndex];
        CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
        
        // Get bounding information of line
        CGFloat ascent = 0.0f, descent = 0.0f, leading = 0.0f;
        CGFloat width = (CGFloat)CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        CGFloat yMin = (CGFloat)floor(lineOrigin.y - descent);
        CGFloat yMax = (CGFloat)ceil(lineOrigin.y + ascent);
        
        // Apply penOffset using flushFactor for horizontal alignment to set lineOrigin since this is the horizontal offset from drawFramesetter
        CGFloat flushFactor = CJFlushFactorForTextAlignment(self.textAlignment);
        CGFloat penOffset = (CGFloat)CTLineGetPenOffsetForFlush(line, flushFactor, textRect.size.width);
        lineOrigin.x = penOffset;
        
        // Check if we've already passed the line
        if (p.y > yMax) {
            break;
        }
        // Check if the point is within this line vertically
        if (p.y >= yMin) {
            // Check if the point is within this line horizontally
            if (p.x >= lineOrigin.x && p.x <= lineOrigin.x + width) {
                // Convert CT coordinates to line-relative coordinates
                CGPoint relativePoint = CGPointMake(p.x - lineOrigin.x, p.y - lineOrigin.y);
                idx = CTLineGetStringIndexForPosition(line, relativePoint);
                break;
            }
        }
    }
    
    CFRelease(frame);
    CGPathRelease(path);
        NSLog(@"点击第%ld个字符",idx);
    return idx;
}
- (CFIndex)characterIndexAtPoint1:(CGPoint)point {
    
    ////////
    
    NSMutableAttributedString* optimizedAttributedText = [self.attributedText mutableCopy];
    
    // use label's font and lineBreakMode properties in case the attributedText does not contain such attributes
    [self.attributedText enumerateAttributesInRange:NSMakeRange(0, [self.attributedText length]) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        
        if (!attrs[(NSString*)kCTFontAttributeName]) {
            [optimizedAttributedText addAttribute:(NSString*)kCTFontAttributeName value:self.font range:NSMakeRange(0, [self.attributedText length])];
        }
        if (!attrs[(NSString*)kCTParagraphStyleAttributeName]) {
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineBreakMode:self.lineBreakMode];
            
            [optimizedAttributedText addAttribute:(NSString*)kCTParagraphStyleAttributeName value:paragraphStyle range:range];
        }
    }];
    
    // modify kCTLineBreakByTruncatingTail lineBreakMode to kCTLineBreakByWordWrapping
    [optimizedAttributedText enumerateAttribute:(NSString*)kCTParagraphStyleAttributeName inRange:NSMakeRange(0, [optimizedAttributedText length]) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
        
        NSMutableParagraphStyle* paragraphStyle = [value mutableCopy];
        
        if ([paragraphStyle lineBreakMode] == kCTLineBreakByTruncatingTail) {
            [paragraphStyle setLineBreakMode:kCTLineBreakByTruncatingTail];
        }
        
        [optimizedAttributedText removeAttribute:(NSString*)kCTParagraphStyleAttributeName range:range];
        [optimizedAttributedText addAttribute:(NSString*)kCTParagraphStyleAttributeName value:paragraphStyle range:range];
    }];
    
//    [self.attributedText enumerateAttribute:(NSString*)kCTFontAttributeName inRange:NSMakeRange(0, [self.attributedText length]) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
//        
//            [optimizedAttributedText addAttribute:(NSString*)kCTFontAttributeName value:value range:range];
//        
//    }];
//    
    
    
    
    ////////
    
    if (!CGRectContainsPoint(self.bounds, point)) {
        return NSNotFound;
    }
    
    CGRect textRect = [self textRect];
    
    if (!CGRectContainsPoint(textRect, point)) {
        return NSNotFound;
    }
    
    // Offset tap coordinates by textRect origin to make them relative to the origin of frame
    point = CGPointMake(point.x - textRect.origin.x, point.y - textRect.origin.y);
    // Convert tap coordinates (start at top left) to CT coordinates (start at bottom left)
    point = CGPointMake(point.x, textRect.size.height - point.y);
    
    //////
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)optimizedAttributedText);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, textRect);
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [self.attributedText length]), path, NULL);
    
    if (frame == NULL) {
        CFRelease(path);
        return NSNotFound;
    }
    
    CFArrayRef lines = CTFrameGetLines(frame);
    
    NSInteger numberOfLines = self.numberOfLines > 0 ? MIN(self.numberOfLines, CFArrayGetCount(lines)) : CFArrayGetCount(lines);
    
    //NSLog(@"num lines: %d", numberOfLines);
    
    if (numberOfLines == 0) {
        CFRelease(frame);
        CFRelease(path);
        return NSNotFound;
    }
    
    NSUInteger idx = NSNotFound;
    
    CGPoint lineOrigins[numberOfLines];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, numberOfLines), lineOrigins);
    
    for (CFIndex lineIndex = 0; lineIndex < numberOfLines; lineIndex++) {
        
        CGPoint lineOrigin = lineOrigins[lineIndex];
        CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
        
        // Get bounding information of line
        CGFloat ascent, descent, leading, width;
        width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        CGFloat yMin = floor(lineOrigin.y - descent);
        CGFloat yMax = ceil(lineOrigin.y + ascent);
        
        // Check if we've already passed the line
        if (point.y > yMax) {
            break;
        }
        
        // Check if the point is within this line vertically
        if (point.y >= yMin) {
            
            // Check if the point is within this line horizontally
            if (point.x >= lineOrigin.x && point.x <= lineOrigin.x + width) {
                
                // Convert CT coordinates to line-relative coordinates
                CGPoint relativePoint = CGPointMake(point.x - lineOrigin.x, point.y - lineOrigin.y);
                idx = CTLineGetStringIndexForPosition(line, relativePoint);
                
                break;
            }
        }
    }
    
    CFRelease(frame);
    CFRelease(path);
    
    return idx;
}

- (CGRect)textRect {
    
    CGRect textRect = [self textRectForBounds:self.bounds limitedToNumberOfLines:self.numberOfLines];
    textRect.origin.y = (self.bounds.size.height - textRect.size.height)/2;
    
    if (self.textAlignment == NSTextAlignmentCenter) {
        textRect.origin.x = (self.bounds.size.width - textRect.size.width)/2;
    }
    if (self.textAlignment == NSTextAlignmentRight) {
        textRect.origin.x = self.bounds.size.width - textRect.size.width;
    }
    
    return textRect;
}



- (void)onCharacterAtIndex:(NSUInteger)charIndex
{
    for (NSTextCheckingResult *match in self.matches) {
            NSRange matchRange = [match range];
            if ([self isIndex:charIndex inRange:matchRange]) {
                NSString *url = [self.mText substringWithRange:matchRange];
                if(self.mLinkClick){
                    self.mLinkClick(url);
                }
                break;
            }
    }
    
}


- (void)highlightLinksWithIndex:(CFIndex)index {
    for (NSTextCheckingResult *match in self.matches) {
        //        if ([match resultType] == NSTextCheckingTypeLink) {
            NSRange matchRange = [match range];
            if ([self isIndex:index inRange:matchRange]) {
                [self.mAttributeString addAttribute:NSBackgroundColorAttributeName value:[UIColor redColor] range:matchRange];
            }
            else {
                if(self.mLinkBackColor){
                    [self.mAttributeString addAttribute:NSBackgroundColorAttributeName value:self.mLinkBackColor range:matchRange];
                }else{
                    [self.mAttributeString addAttribute:NSBackgroundColorAttributeName value:self.backgroundColor range:matchRange];
                }
            }
//        }
    }
    [self renderAttribute];
}

-(void)setMLinkBackColor:(UIColor *)mLinkBackColor
{
    _mLinkBackColor = mLinkBackColor;
    [self highlightLinksWithIndex:NSNotFound];
}

#pragma mark -

- (BOOL)isIndex:(NSInteger)index inRange:(NSRange)range {
    return index > range.location && index < range.location+range.length;
}

-(void)setLinkClickBlock:(void (^)(NSString *link))linkClickBlock
{
    self.mLinkClick = linkClickBlock;
}

@end
