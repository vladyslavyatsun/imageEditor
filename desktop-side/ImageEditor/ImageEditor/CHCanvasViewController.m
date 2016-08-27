//
//  CHDocumentViewController.m
//  ImageEditor
//
//  Created by Владислав Яцун on 8/25/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import "CHCanvasViewController.h"
#import "CHCanvasView.h"
#import "CHAbstractElementRepresentation.h"
#import "CHAbstractElement.h"
#import "CHShapeRepresentation.h"

CGFloat const kCHMoveElementStep = 3.0;
CGFloat const kCHFocusRingThikness = 5.0;
@interface CHCanvasViewController ()
@property (atomic, retain) NSMutableArray *elementsWithRepresentation;
@property (nonatomic, assign) CHCanvasView *canvasView;
@property (atomic, assign) CHAbstractElementRepresentation *selectedElement;
@property (nonatomic, assign) NSPoint elementLocationInView;
@end

@implementation CHCanvasViewController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _elementsWithRepresentation = [[NSMutableArray alloc] init];
        
        _canvasView = [[CHCanvasView alloc] initWithElementsRepresentation:self.elementsWithRepresentation];
        
        self.view = self.canvasView;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}


#pragma mark - add remove elements
- (void)addElementOnView:(CHAbstractElement *)anElement
{
    if (anElement)
    {
        CHAbstractElementRepresentation *elementRepresentation = (CHAbstractElementRepresentation *)[CHAbstractElementRepresentation elementRepresentationWithModelElement:anElement];
        
        [self.elementsWithRepresentation addObject:elementRepresentation];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(redrawView:) name:kCHElementRepresentationDidUpdate object:elementRepresentation];
        
        [self unselectElement];
        
        [self.canvasView setNeedsDisplayInRect:elementRepresentation.rect];
    }
}

- (void)removeElementFromView:(CHAbstractElement *)anElement
{
    CHAbstractElementRepresentation *elementWillDelete = nil;
    
    if (anElement)
    {
        for (CHAbstractElementRepresentation *elementWithRepresentation in self.elementsWithRepresentation)
        {
            if(elementWithRepresentation.modelElement == anElement)
            {
                elementWillDelete = elementWithRepresentation;
                break;
            }
        }
        
        NSRect dirtyRect = elementWillDelete.rect;
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kCHElementRepresentationDidUpdate object:elementWillDelete];
        
        if (self.selectedElement == elementWillDelete)
        {
            [self unselectElement];
        }
        
        [self.elementsWithRepresentation removeObject:elementWillDelete];
        
        [self.canvasView setNeedsDisplayInRect:dirtyRect];

    }
}



#pragma mark - mouse events
- (void)mouseDown:(NSEvent *)event
{
    NSPoint curentLocationInView = [self.canvasView convertPoint:event.locationInWindow fromView:nil];
    
    [self unselectElement];
    
    if (!self.drawTool)
    {
        for (CHAbstractElementRepresentation *element in [self.elementsWithRepresentation reverseObjectEnumerator])
        {
            if([element hitTest:curentLocationInView])
            {
                self.elementLocationInView = curentLocationInView;
                [self selectElement:element];
                break;
            }
        }
    }
    else
    {
        [super mouseDown:event];
        self.elementLocationInView = curentLocationInView;
    }
    
}


- (void)mouseDragged:(NSEvent *)event
{
    NSPoint currentLocationInView = [self.canvasView convertPoint:event.locationInWindow fromView:nil];
    
    
    if (!self.drawTool)
    {
        NSPoint toPoint = NSMakePoint(self.selectedElement.rect.origin.x + currentLocationInView.x - self.elementLocationInView.x,
                                      self.selectedElement.rect.origin.y + currentLocationInView.y - self.elementLocationInView.y);
    
        if (self.selectedElement)
        {
            [self.selectedElement moveToPoint:toPoint];
        }
        self.elementLocationInView = currentLocationInView;
    }
    else
    {
        
        CHShapeRepresentation *shapeElement = [self.elementsWithRepresentation lastObject];
        [shapeElement addPoint:currentLocationInView];
    }
    
}


#pragma mark - key events


- (IBAction)moveUp:(id)sender
{
    if (self.selectedElement)
    {
        NSPoint toPoint = NSMakePoint(self.selectedElement.rect.origin.x, self.selectedElement.rect.origin.y - kCHMoveElementStep);
        [self.selectedElement moveToPoint:toPoint];
    }
}

- (IBAction)moveDown:(id)sender
{
    if (self.selectedElement)
    {
        NSPoint toPoint = NSMakePoint(self.selectedElement.rect.origin.x, self.selectedElement.rect.origin.y + kCHMoveElementStep);
        [self.selectedElement moveToPoint:toPoint];
    }
}

- (IBAction)moveLeft:(id)sender
{
    if (self.selectedElement)
    {
        NSPoint toPoint = NSMakePoint(self.selectedElement.rect.origin.x - kCHMoveElementStep, self.selectedElement.rect.origin.y);
        [self.selectedElement moveToPoint:toPoint];
    }
}

- (IBAction)moveRight:(id)sender
{
    if (self.selectedElement)
    {
        NSPoint toPoint = NSMakePoint(self.selectedElement.rect.origin.x + kCHMoveElementStep, self.selectedElement.rect.origin.y);
        [self.selectedElement moveToPoint:toPoint];
    }
}

#pragma mark select element
- (void)selectElement:(CHAbstractElementRepresentation *)element
{
    [self.canvasView setNeedsDisplayInRect:NSInsetRect(self.selectedElement.rect, -kCHFocusRingThikness, -kCHFocusRingThikness)];
    
    element.select = YES;
    
    self.selectedElement = element;
    
}

- (void)unselectElement
{
    if (self.selectedElement)
    {
        self.selectedElement.select = NO;
        
        [self.canvasView setNeedsDisplayInRect:NSInsetRect(self.selectedElement.rect, -kCHFocusRingThikness, -kCHFocusRingThikness)];
        
        self.selectedElement = nil;
        
    }
}

- (void)redrawView:(NSNotification *)notification
{
    //CHAbstractElementRepresentation *element = notification.object;
    [self.canvasView setNeedsDisplay:YES];
}

#pragma mark - representation view
- (NSBitmapImageRep *)viewToBitmapImageRepresentation
{
    CHAbstractElementRepresentation *element = self.selectedElement;
    
    [self unselectElement];
    
    [self.canvasView lockFocus];
    NSBitmapImageRep *imageRepresentation = [[[NSBitmapImageRep alloc] initWithFocusedViewRect:self.canvasView.bounds] autorelease];
    [self.canvasView cacheDisplayInRect:self.canvasView.bounds toBitmapImageRep:imageRepresentation];
    [self.canvasView unlockFocus];
    
    self.selectedElement = element;
    
    return imageRepresentation;
}

- (void)dealloc
{
    [_canvasView release];
    [super dealloc];
}
@end
