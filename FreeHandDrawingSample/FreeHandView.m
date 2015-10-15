//
//  FreeHandView.m
//  FreeHandDrawingSample
//
//  Created by Muthuraj M on 21/09/15.
//  Copyright (c) 2015 Muthuraj M. All rights reserved.
//

#import "FreeHandView.h"

@interface FreeHandView ()
{
    UIBezierPath *path; // (3)
    UIBezierPath *finalBuiltupPath;
}
@end

@implementation FreeHandView

- (id)initWithCoder:(NSCoder *)aDecoder // (1)
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setMultipleTouchEnabled:NO]; // (2)
        [self setBackgroundColor:[UIColor whiteColor]];
        [self createNewPath];
    }
    return self;
}

- (void)drawRect:(CGRect)rect // (5)
{
    [[UIColor blackColor] setStroke];
    [path stroke];
    [[UIColor greenColor] setStroke];
    [finalBuiltupPath stroke];
}

- (void)createNewPath
{
    path = [UIBezierPath bezierPath];
    [path setLineWidth:2.0];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self erase];
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    [path moveToPoint:p];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    [path addLineToPoint:p]; // (4)
    finalBuiltupPath = [UIBezierPath bezierPathWithRect:path.bounds];
    [finalBuiltupPath setLineWidth:2.0];
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesMoved:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}
- (void)erase
{
    path = nil;
    [self createNewPath];
    [self setNeedsDisplay];
}

@end
