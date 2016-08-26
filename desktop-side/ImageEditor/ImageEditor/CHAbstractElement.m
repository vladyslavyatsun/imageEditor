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

static NSString * const kCHAbstractElementKeyStartPoint = @"start point";
static NSString * const kCHAbstractElementKeyEndPoint = @"end point";
static NSString * const kCHAbstractElementDidUpdate = @"element updated";
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
    [[NSNotificationCenter defaultCenter] postNotificationName:kCHAbstractElementDidUpdate object:self];
}

- (void)setEndPoint:(NSPoint)endPoint
{
    _endPoint = endPoint;
    [[NSNotificationCenter defaultCenter] postNotificationName:kCHAbstractElementDidUpdate object:self];
}

#pragma mark - encode & decode
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodePoint:self.startPoint forKey:kCHAbstractElementKeyStartPoint];
    [aCoder encodePoint:self.endPoint forKey:kCHAbstractElementKeyEndPoint];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        _startPoint = [aDecoder decodePointForKey:kCHAbstractElementKeyStartPoint];
        _endPoint = [aDecoder decodePointForKey:kCHAbstractElementKeyEndPoint];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}
@end
