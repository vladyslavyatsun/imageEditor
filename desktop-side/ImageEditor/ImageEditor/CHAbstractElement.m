//
//  CHAbstractFigure.m
//  ImageEditor
//
//  Created by Владислав Яцун on 8/19/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import "CHAbstractElement.h"
#import "CHLine.h"
#import "CHRectangle.h"
#import "CHEllipse.h"
#import "CHImage.h"

@implementation CHAbstractElement


- (instancetype)initWithInitialPoint:(NSPoint)initialPoint
{
    self = [super init];
    if (self)
        
    {
        _initialPoint = initialPoint;
        _path = [NSBezierPath bezierPath];
        [_path moveToPoint:initialPoint];
    }
    return self;
}

+ (CHLine *)lineWithInitialPoint:(NSPoint)initialPoint
{
    return [[[CHLine alloc] initWithInitialPoint:initialPoint] autorelease];
}

+ (CHRectangle *)rectangleWithInitialPoint:(NSPoint)initialPoint
{
    return [[[CHRectangle alloc] initWithInitialPoint:initialPoint] autorelease];
}

+ (CHEllipse *)ellipseWithInitialPoint:(NSPoint)initialPoint
{
    return [[[CHEllipse alloc] initWithInitialPoint:initialPoint] autorelease];
}

+ (CHImage *)imageWithInitialPoint:(NSPoint)initialPoint imagePath:(NSString *)imagePath
{
    return [[CHImage alloc] initWithInitialPoint:initialPoint imagePath:imagePath];
}


- (void)addPoint:(NSPoint)point
{
    NSLog(@"You must override %@ in a subclass", NSStringFromSelector(_cmd));
}

- (void)draw
{    
    [self.color set];
    [self.path setLineWidth:self.thickness];
    [self.path stroke];
}

- (void)dealloc
{
    [_path release];
    [_color release];
    [super dealloc];
}
@end
