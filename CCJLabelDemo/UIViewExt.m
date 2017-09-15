/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

#import "UIViewExt.h"


#define AUTOSIZEIPHONE5(i)                 ceil(((([UIScreen mainScreen].bounds).size.width*2) / 640) * i) //根据屏幕宽度调整尺寸(以iPhone5尺寸为基准 640)


CGPoint CGRectGetCenter(CGRect rect) {
    CGPoint pt;
    pt.x = CGRectGetMidX(rect);
    pt.y = CGRectGetMidY(rect);
    return pt;
}

CGRect CGRectMoveToCenter(CGRect rect, CGPoint center) {
    CGRect newrect = CGRectZero;
    newrect.origin.x = center.x-CGRectGetMidX(rect);
    newrect.origin.y = center.y-CGRectGetMidY(rect);
    newrect.size = rect.size;
    return newrect;
}

@implementation UIView (ViewGeometry)

// Retrieve and set the origin
- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)aPoint_ {
    CGRect newframe = self.frame;
    newframe.origin = aPoint_;
    self.frame = newframe;
}


// Retrieve and set the size
- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)aSize_ {
    CGRect newframe = self.frame;
    newframe.size = aSize_;
    self.frame = newframe;
}

// Query other frame locations
- (CGPoint)bottomRight {
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}

- (CGPoint)bottomLeft {
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}

- (CGPoint)topRight {
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y;
    return CGPointMake(x, y);
}


// Retrieve and set height, width, top, bottom, left, right
- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)newHeight_ {
    CGRect newframe = self.frame;
    newframe.size.height = newHeight_;
    self.frame = newframe;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)newWidth_ {
    CGRect newframe = self.frame;
    newframe.size.width = newWidth_;
    self.frame = newframe;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)newTop_ {
    CGRect newframe = self.frame;
    newframe.origin.y = newTop_;
    self.frame = newframe;
}

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)newLeft_ {
    CGRect newframe = self.frame;
    newframe.origin.x = newLeft_;
    self.frame = newframe;
}

-(CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)newBottom_ {
    CGRect newframe = self.frame;
    newframe.origin.y = newBottom_ - self.frame.size.height;
    self.frame = newframe;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)newRight_ {
    CGFloat delta = newRight_ - (self.frame.origin.x + self.frame.size.width);
    CGRect newframe = self.frame;
    newframe.origin.x += delta ;
    self.frame = newframe;
}

- (void)setScaleFrame:(CGRect)rect_ {
    [self setFrame:CGRectMake(rect_.origin.x, rect_.origin.y, AUTOSIZEIPHONE5(rect_.size.width), AUTOSIZEIPHONE5(rect_.size.height))];
}

// Move via offset
- (void)moveBy:(CGPoint)delta_ {
    CGPoint newcenter = self.center;
    newcenter.x += delta_.x;
    newcenter.y += delta_.y;
    self.center = newcenter;
}

// Scaling
- (void) scaleBy:(CGFloat)scaleFactor_ {
    CGRect newframe = self.frame;
    newframe.size.width *= scaleFactor_;
    newframe.size.height *= scaleFactor_;
    self.frame = newframe;
}

// Ensure that both dimensions fit within the given size by scaling down
- (void)fitInSize:(CGSize)aSize_ {
    CGFloat scale;
    CGRect newframe = self.frame;
    
    if (newframe.size.height && (newframe.size.height > aSize_.height)) {
        scale = aSize_.height / newframe.size.height;
        newframe.size.width *= scale;
        newframe.size.height *= scale;
    }
    
    if (newframe.size.width && (newframe.size.width >= aSize_.width)) {
        scale = aSize_.width / newframe.size.width;
        newframe.size.width *= scale;
        newframe.size.height *= scale;
    }
    
    self.frame = newframe;
}
@end
