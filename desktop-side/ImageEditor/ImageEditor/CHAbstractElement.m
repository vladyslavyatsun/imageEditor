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

NSString * const kCHElementDidUpdate = @"element updated";
@implementation CHAbstractElement

- (instancetype)initWithStartPoint:(NSPoint)startPoint endPoint:(NSPoint)endPoint
{
    self = [super init];
    if (self)
    {
        _startPoint = startPoint;
        _endPoint = endPoint;
    }
    return self;
}


+ (CHLine *)lineWithStartPoint:(NSPoint)startPoint endPoint:(NSPoint)endPoint color:(NSColor *)color
{
    return [[[CHLine alloc] initWithStartPoint:startPoint endPoint:endPoint color:color] autorelease];
}
+ (CHRectangle *)rectangleWithStartPoint:(NSPoint)startPoint endPoint:(NSPoint)endPoint color:(NSColor *)color
{
    return [[[CHRectangle alloc] initWithStartPoint:startPoint endPoint:endPoint color:color] autorelease];
}
+ (CHEllipse *)ellipseWithStartPoint:(NSPoint)startPoint endPoint:(NSPoint)endPoint color:(NSColor *)color
{
    return [[[CHEllipse alloc] initWithStartPoint:startPoint endPoint:endPoint color:color] autorelease];
}
+ (CHImage *)imageWithStartPoint:(NSPoint)startPoint endPoint:(NSPoint)endPoint image:(NSImage *)image
{
    return [[[CHImage alloc] initWithStartPoint:startPoint endPoint:endPoint image:image] autorelease];
}

- (void)setStartPoint:(NSPoint)startPoint
{
    _startPoint = startPoint;
    [[NSNotificationCenter defaultCenter] postNotificationName:kCHElementDidUpdate object:self];
}

- (void)setEndPoint:(NSPoint)endPoint
{
    _endPoint = endPoint;
    [[NSNotificationCenter defaultCenter] postNotificationName:kCHElementDidUpdate object:self];
}

- (void)dealloc
{
    [super dealloc];
}
@end
