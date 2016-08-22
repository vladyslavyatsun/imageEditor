//
//  CHShape.m
//  ImageEditor
//
//  Created by Владислав Яцун on 8/21/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import "CHShape.h"

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
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kCHElementDidUpdate object:self];
    }
    
}

- (void)dealloc
{
    [_color release];
    [super dealloc];
}
@end
