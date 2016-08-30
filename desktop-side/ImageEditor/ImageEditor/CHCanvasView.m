//
//  CHCanvasView.m
//  ImageEditor
//
//  Created by Владислав Яцун on 8/19/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import "CHCanvasView.h"
#import "CHAbstractElementRepresentation.h"
#import "CHShapeRepresentation.h"

@interface CHCanvasView()
@property (atomic, assign) NSArray *elementsWithRepresentation;
@end

@implementation CHCanvasView

- (instancetype)initWithElementsRepresentation:(NSArray<CHAbstractElementRepresentation *> *)elementsWithRepresentation
{
    self = [super init];
    if (self)
    {
        _elementsWithRepresentation = elementsWithRepresentation;
        
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    [[NSColor whiteColor] set];
    
    NSRectFill(dirtyRect);
    
    for (CHAbstractElementRepresentation *element in self.elementsWithRepresentation)
    {
        if (NSIntersectsRect(element.rect, dirtyRect))
        {
            [element draw];
        }
    }
}

- (BOOL)acceptsFirstResponder
{
    return YES;
}

- (BOOL)isFlipped
{
    return YES;
}

- (void) dealloc
{
    [super dealloc];
}

@end
