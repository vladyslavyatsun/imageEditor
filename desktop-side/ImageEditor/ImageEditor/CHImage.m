//
//  CHImage.m
//  ImageEditor
//
//  Created by Владислав Яцун on 8/20/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import "CHImage.h"

NSString * const kCHKeyElementImage = @"element image";
@implementation CHImage
- (instancetype)initWithStartPoint:(NSPoint)startPoint endPoint:(NSPoint)endPoint image:(NSImage *)image
{
    self = [super initWithStartPoint:startPoint endPoint:endPoint];
    
    if (self)
    {
        _image = [image copy];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.image forKey:kCHKeyElementImage];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        _image = [[aDecoder decodeObjectForKey:kCHKeyElementImage] copy];
    }
    return self;
}

- (void)dealloc
{
    [_image release];
    [super dealloc];
}
@end
