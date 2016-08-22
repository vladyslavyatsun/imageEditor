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
@property (nonatomic, assign) NSMutableArray *elements;
@property (nonatomic, assign) CHAbstractElementRepresentation *selectedElement;
////@property (nonatomic, readwrite, retain) CHShapeRepresentation *anElement;
@end

@implementation CHCanvasView


- (instancetype) initWithElements:(NSArray *)elements
{
    self = [super init];
    if(self)
    {
        _elements = [[NSMutableArray alloc] init];
        [_elements addObjectsFromArray:elements];
    }
    return self;
}


- (void)addElementOnView:(CHAbstractElementRepresentation *)anElement
{
    if(anElement)
    {
        [self.elements addObject:anElement];
        
        [self setNeedsDisplayInRect:anElement.rect];
    }
}


- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    [[NSColor whiteColor] set];
    
    NSRectFill(dirtyRect);
    
    for (CHAbstractElementRepresentation *figure in self.elements)
    {
        [figure draw];
    }
}


#pragma mark - mouse events
- (void)mouseDown:(NSEvent *)event
{

    NSPoint locationInView = [self convertPoint:event.locationInWindow fromView:nil];
    
    self.selectedElement.select = NO;
    for (CHAbstractElementRepresentation *element in [self.elements reverseObjectEnumerator])
    {
        if([element hitTest:locationInView])
        {
            element.select = YES;
            self.selectedElement = element;
            break;
        }
    }
    
    
//    
//    if (self.anElement != nil)
//    {
//        
//        self.anElement.color = [NSColor redColor];
//        self.anElement.thickness = 4.0;
//        [self.elements addObject:self.anElement];
//    
//        [self.anElement release];
//    }
//    else
//    {
//        for (CHAbstractElement *element in self.elements)
//        {
//            BOOL containsInView = [element.path containsPoint:locationInView];
//            NSLog(@" >>>>> %d", containsInView);
//        }
//    }
    
    
    
    
    [self setNeedsDisplay:YES];
}

- (void)mouseDragged:(NSEvent *)event
{
   // NSPoint locationInView = [self convertPoint:event.locationInWindow fromView:nil];
    
    [self setNeedsDisplay:YES];
    
}

- (BOOL)isOpaque
{
    return YES;
}

- (BOOL)isFlipped
{
    return YES;
}

#warning - test method
- (NSMutableArray *)elements
{
    if(!_elements)
    {
        _elements = [[NSMutableArray alloc]init];
    }
    return _elements;
}

- (void) dealloc
{
 //   [_anElement release];
    [_elements release];
    [super dealloc];
}

@end
