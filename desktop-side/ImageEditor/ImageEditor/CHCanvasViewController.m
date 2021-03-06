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

NSString * const kCHCanvasViewControllerUndoManagerActionMoving = @"Moving";
CGFloat const kCHMoveElementStep = 3.0;
CGFloat const kCHFocusRingThikness = 5.0;
@interface CHCanvasViewController ()
@property (atomic, retain) NSMutableArray *elementsWithRepresentation;
@property (nonatomic, retain) CHCanvasView *canvasView;
@property (atomic, assign) CHAbstractElementRepresentation *selectedElement;
@property (nonatomic, assign) NSPoint elementLocationInViewOnMouseDrag;
@property (nonatomic, assign) NSPoint elmentLocationInViewOnMouseDown;
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
    self.elementLocationInViewOnMouseDrag = curentLocationInView;
    [self unselectElement];
    
    if (!self.drawTool)
    {
        for (CHAbstractElementRepresentation *element in [self.elementsWithRepresentation reverseObjectEnumerator])
        {
            if([element hitTest:curentLocationInView])
            {
                self.elmentLocationInViewOnMouseDown = curentLocationInView;
                [self selectElement:element];
                break;
            }
        }
    }
    else
    {
        [super mouseDown:event];
    }
    
}


- (void)mouseDragged:(NSEvent *)event
{
    NSPoint currentLocationInView = [self.canvasView convertPoint:event.locationInWindow fromView:nil];
    
    NSRect dirtyRect;
    
    if (!self.drawTool)
    {
        NSPoint toPoint = NSMakePoint(self.selectedElement.rect.origin.x + currentLocationInView.x - self.elementLocationInViewOnMouseDrag.x,
                                      self.selectedElement.rect.origin.y + currentLocationInView.y - self.elementLocationInViewOnMouseDrag.y);
        
        dirtyRect = NSInsetRect(self.selectedElement.rect, -kCHFocusRingThikness, -kCHFocusRingThikness);
        
        if (self.selectedElement)
        {
            [self.selectedElement moveToPoint:toPoint];
            
        }
        self.elementLocationInViewOnMouseDrag = currentLocationInView;
    }
    else
    {
        CHShapeRepresentation *shapeElement = [self.elementsWithRepresentation lastObject];
        dirtyRect = shapeElement.rect;
        [shapeElement addPoint:currentLocationInView];
    }
    
    [self.canvasView setNeedsDisplayInRect:dirtyRect];
    
}

- (void)mouseUp:(NSEvent *)theEvent
{
    NSPoint currentLocationInView = [self.canvasView convertPoint:theEvent.locationInWindow fromView:nil];
    
    NSPoint newPoint = NSMakePoint(self.selectedElement.rect.origin.x + currentLocationInView.x - self.elementLocationInViewOnMouseDrag.x,
                                   self.selectedElement.rect.origin.y + currentLocationInView.y - self.elementLocationInViewOnMouseDrag.y);
    
    if (self.selectedElement)
    {
        NSPoint oldPoint = NSMakePoint(self.selectedElement.rect.origin.x - currentLocationInView.x + self.elmentLocationInViewOnMouseDown.x,
                                       self.selectedElement.rect.origin.y - currentLocationInView.y + self.elmentLocationInViewOnMouseDown.y);

        [[self.undoManager prepareWithInvocationTarget:self] moveElement:self.selectedElement backFromPoint:newPoint toPoint:oldPoint];
    }
}

#pragma mark - key events


- (IBAction)moveUp:(id)sender
{
    [self.undoManager registerUndoWithTarget:self selector:@selector(moveDown:) object:nil];
    
    if (!self.undoManager.isUndoing)
    {
        [self.undoManager setActionName:kCHCanvasViewControllerUndoManagerActionMoving];
    }
    
    if (self.selectedElement)
    {
        NSPoint toPoint = NSMakePoint(self.selectedElement.rect.origin.x, self.selectedElement.rect.origin.y - kCHMoveElementStep);
        [self.selectedElement moveToPoint:toPoint];
    }
}

- (IBAction)moveDown:(id)sender
{
    [self.undoManager registerUndoWithTarget:self selector:@selector(moveUp:) object:nil];
    
    if (!self.undoManager.isUndoing)
    {
        [self.undoManager setActionName:kCHCanvasViewControllerUndoManagerActionMoving];
    }
    
    if (self.selectedElement)
    {
        NSPoint toPoint = NSMakePoint(self.selectedElement.rect.origin.x, self.selectedElement.rect.origin.y + kCHMoveElementStep);
        [self.selectedElement moveToPoint:toPoint];
    }
}

- (IBAction)moveLeft:(id)sender
{
    [self.undoManager registerUndoWithTarget:self selector:@selector(moveRight:) object:nil];
    
    if (!self.undoManager.isUndoing)
    {
        [self.undoManager setActionName:kCHCanvasViewControllerUndoManagerActionMoving];
    }
    
    if (self.selectedElement)
    {
        NSPoint toPoint = NSMakePoint(self.selectedElement.rect.origin.x - kCHMoveElementStep, self.selectedElement.rect.origin.y);
        [self.selectedElement moveToPoint:toPoint];
    }
}

- (IBAction)moveRight:(id)sender
{
    [self.undoManager registerUndoWithTarget:self selector:@selector(moveLeft:) object:nil];
    
    if (!self.undoManager.isUndoing)
    {
        [self.undoManager setActionName:kCHCanvasViewControllerUndoManagerActionMoving];
    }
    
    if (self.selectedElement)
    {
        NSPoint toPoint = NSMakePoint(self.selectedElement.rect.origin.x + kCHMoveElementStep, self.selectedElement.rect.origin.y);
        [self.selectedElement moveToPoint:toPoint];
    }
}

#pragma mark select element
- (void)selectElement:(CHAbstractElementRepresentation *)element
{
    element.select = YES;
    
    self.selectedElement = element;
    
     [self.canvasView setNeedsDisplayInRect:NSInsetRect(self.selectedElement.rect, -kCHFocusRingThikness, -kCHFocusRingThikness)];
    
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
    [self.canvasView setNeedsDisplay:YES];
}

#pragma mark undo/redo

- (void)moveElement:(CHAbstractElementRepresentation *)element backFromPoint:(NSPoint)from toPoint:(NSPoint)to
{
    [[self.undoManager prepareWithInvocationTarget:self] moveElement:element backFromPoint:to toPoint:from];
    
    if (!self.undoManager.isUndoing)
    {
        [self.undoManager setActionName:kCHCanvasViewControllerUndoManagerActionMoving];
    }
    
    [self.canvasView setNeedsDisplayInRect:NSInsetRect(element.rect, -kCHFocusRingThikness, -kCHFocusRingThikness)];
    
    [element moveToPoint:to];
}


- (NSUndoManager *)undoManager
{
    return [NSDocumentController sharedDocumentController].currentDocument.undoManager;
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
    [_elementsWithRepresentation release];
    [_canvasView release];
    [super dealloc];
}
@end
