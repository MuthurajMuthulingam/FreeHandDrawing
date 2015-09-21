//
//  CacheFreeHandView.m
//  FreeHandDrawingSample
//
//  Created by Muthuraj M on 21/09/15.
//  Copyright (c) 2015 Muthuraj M. All rights reserved.
//

#import "CacheFreeHandView.h"


@interface CacheFreeHandView ()
{
    UIBezierPath *path;
    UIImage *incrementalImage; // (1)
}
@end

@implementation CacheFreeHandView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setMultipleTouchEnabled:NO];
        [self setBackgroundColor:[UIColor whiteColor]];
        path = [UIBezierPath bezierPath];
        [path setLineWidth:2.0];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [incrementalImage drawInRect:rect]; // (3)
    [path stroke];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    [path moveToPoint:p];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    [path addLineToPoint:p];
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event // (2)
{
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    [path addLineToPoint:p];
    [self drawBitmap]; // (3)
    [self setNeedsDisplay];
    [path removeAllPoints]; //(4)
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

- (void)drawBitmap // (3)
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0.0);
    [[UIColor blackColor] setStroke];
    if (!incrementalImage) // first draw; paint background white by ...
    {
        UIBezierPath *rectpath = [UIBezierPath bezierPathWithRect:self.bounds]; // enclosing bitmap by a rectangle defined by another UIBezierPath object
        [[UIColor whiteColor] setFill];
        [rectpath fill]; // filling it with white
    }
    [incrementalImage drawAtPoint:CGPointZero];
    [path stroke];
    incrementalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}
@end
