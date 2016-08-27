//
//  CHShape.m
//  ImageEditor
//
//  Created by Владислав Яцун on 8/21/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import "CHShape.h"

NSString * const kCHKeyElementColor = @"element image";
@implementation CHShape

- (instancetype)initWithStartPoint:(NSPoint)startPoint endPoint:(NSPoint)endPoint color:(NSColor *)color
{
    self = [super initWithStartPoint:startPoint endPoint:endPoint];
    if(self)
    {
        _color = [color retain];
    }
    
    return self;
}

- (void)setColor:(NSColor *)color
{
    if(_color != color)
    {
        [_color release];
        _color = [color retain];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kCHAbstractElementDidUpdate object:self];
    }
    
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.color forKey:kCHKeyElementColor];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        _color = [[aDecoder decodeObjectForKey:kCHKeyElementColor] copy];
    }
    return self;
}


- (void)dealloc
{
    [_color release];
    [super dealloc];
}
@end
