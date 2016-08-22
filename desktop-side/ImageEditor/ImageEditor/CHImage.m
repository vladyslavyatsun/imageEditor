//
//  CHImage.m
//  ImageEditor
//
//  Created by Владислав Яцун on 8/20/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import "CHImage.h"

@implementation CHImage
- (instancetype)initWithStartPoint:(NSPoint)startPoint endPoint:(NSPoint)endPoint image:(NSImage *)image
{
    self = [super initWithStartPoint:startPoint endPoint:endPoint];
    
    if (self)
    {
        _image = [image retain];
    }
    
    return self;
}

- (void)dealloc
{
    [_image release];
    [super dealloc];
}
@end
