//
//  CHImageRepresentation.m
//  ImageEditor
//
//  Created by Владислав Яцун on 8/22/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import "CHImageRepresentation.h"
#import "CHImage.h"

@interface CHImageRepresentation ()
@property (nonatomic, retain) NSImage *image;
@end

@implementation CHImageRepresentation
- (instancetype)initWithModelElement:(CHAbstractElement *)modelElement
{
    self = [super initWithModelElement:modelElement];
    
    if (self)
    {
        _image = ((CHImage *)modelElement).image;
    }
    return self;
}

- (void)draw
{
    if ([self isSelected])
    {
        [NSGraphicsContext saveGraphicsState];
        NSSetFocusRingStyle(NSFocusRingAbove);
        [self.image drawInRect:self.rect];
        [NSGraphicsContext restoreGraphicsState];
    }
    else
    {
        [self.image drawInRect:self.rect];
    }
}

- (void)dealloc
{
    [_image release];
    [super dealloc];
}

@end
