//
//  CHDocumentWindowController.m
//  ImageEditor
//
//  Created by Владислав Яцун on 8/21/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import "CHDocumentWindowController.h"
#import "CHCanvasViewController.h"
#import "CHAbstractElementRepresentation.h"
#import "CHAbstractElement.h"
#import "CHDocumentModelController.h"
#import "CHShape.h"

#warning rename that
NSString *const kIECanvasViewControllerUndoManagerActionAdding = @"Adding";
NSString *const kIECanvasViewControllerUndoManagerActionRemoving = @"Removing";
NSString *const kIECanvasViewControllerUndoManagerActionCopying = @"Copying";

@interface CHDocumentWindowController ()
@property (nonatomic, retain) CHCanvasViewController *canvasViewController;
@property (nonatomic, assign) CHDocumentModelController *modelController;
@property (nonatomic, assign) CHAbstractElementRepresentation *selectedElement;
@end

@implementation CHDocumentWindowController

- (instancetype)initWithNibName:(NSString *)nibName modelContoller:(CHDocumentModelController *)modelContoller
{
    self = [super initWithWindowNibName:nibName];
    
    if (self)
    {
        _modelController = modelContoller;
        _canvasViewController = [[CHCanvasViewController alloc] init];
        _selectedDrawTool = kCHPointerTool;
 
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [self.window registerForDraggedTypes:[NSArray arrayWithObjects:NSTIFFPboardType, NSURLPboardType, NSFilenamesPboardType, nil]];
    
    [self.window setContentView:self.canvasViewController.view];
    
    for (CHAbstractElement *element in self.modelController.elementsArray) {
        if([element isKindOfClass:[CHAbstractElement class]])
        {
            [self.canvasViewController addElementOnView:element];
        }
    }
    
    [_canvasViewController addObserver:self
                            forKeyPath:@"selectedElement"
                               options:NSKeyValueObservingOptionNew
                               context:[CHDocumentWindowController class]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addNewElementOnView:)
                                                 name:kCHDocumentModelControllerDidAddElement
                                               object:_modelController];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(removeElementFromView:)
                                                 name:kCHDocumentModelControllerDidRemoveElememt
                                               object:_modelController];

    
}

#pragma mark observe selected element
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == [CHDocumentWindowController class])
    {
        if ([keyPath isEqualToString:@"selectedElement"])
        {
            self.selectedElement = [self.canvasViewController valueForKey:@"selectedElement"];
        }
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}



- (void)addImageOnViewWithInitialPoint:(NSPoint)aPoint path:(NSString *)aPath
{
    NSImage *image = [[[NSImage alloc] initWithContentsOfFile:aPath] autorelease];
    
    NSPoint endPoint = NSMakePoint(image.size.width + aPoint.x, image.size.height + aPoint.y);
    
    CHAbstractElement *element = (CHAbstractElement *)[CHAbstractElement imageWithStartPoint:aPoint endPoint:endPoint image:image];
    
    [self.modelController addElement:element];
}

#pragma mark manage canvas view

- (void)removeElementFromView:(NSNotification *)notification
{
    CHAbstractElement *element = notification.userInfo[kCHKeyOfDocumentModelControllerNotificationsUserInfo];
    
    [self.canvasViewController removeElementFromView:element];
}


- (void)addNewElementOnView:(NSNotification *)notification
{
    id element = [notification.userInfo objectForKey:kCHKeyOfDocumentModelControllerNotificationsUserInfo];
    
    if([element isKindOfClass:[CHAbstractElement class]])
    {
        [self.canvasViewController addElementOnView:element];
    }
}

- (void)setToolForDrawOnCanvas:(CHDrawTool)drawTool
{
    self.selectedDrawTool = drawTool;
    if (drawTool == kCHPointerTool)
    {
        self.canvasViewController.drawTool = NO;
    }
    else
    {
        self.canvasViewController.drawTool = YES;
    }
}

#pragma mark drag & drope
- (NSDragOperation)draggingEntered:(id)sender
{
    NSPasteboard *pboard;
    NSDragOperation sourceDragMask;
    
    sourceDragMask = [sender draggingSourceOperationMask];
    pboard = [sender draggingPasteboard];
    
    if ([[pboard types] containsObject:NSTIFFPboardType])
    {
        if (sourceDragMask & NSDragOperationMove)
        {
            return NSDragOperationCopy;
        }
    }
    
    if ([[pboard types] containsObject:NSURLPboardType] || [[pboard types] containsObject:NSFilenamesPboardType])
    {
        if (sourceDragMask & NSDragOperationLink)
        {
            return NSDragOperationLink;
        }
    }
    
    return NSDragOperationNone;
}

- (BOOL)prepareForDragOperation:(id)sender
{
    NSPasteboard *pboard = [sender draggingPasteboard];
    
    BOOL result = NO;
    
    if ([NSImage canInitWithPasteboard:pboard])
    {
        result = YES;
    }
    return result;
}


- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender
{
    NSPasteboard *pboard = sender.draggingPasteboard;
    
    NSMutableArray<NSImage *> *images = [[NSMutableArray alloc] init];
    
    if ([[pboard types] containsObject:NSTIFFPboardType])
    {
        NSData *data = [pboard dataForType:NSTIFFPboardType];
        NSImage *image = [[NSImage alloc] initWithData:data];
        [images addObject:image];
        [image release];
    }
    else if ([[pboard types] containsObject:NSFilenamesPboardType])
    {
        NSArray *pathes = [pboard propertyListForType:NSFilenamesPboardType];
        
        for (NSString *path in pathes)
        {
            NSImage *image = [[NSImage alloc] initWithContentsOfFile:path];
            [images addObject:image];
            [image release];
        }
    }
    else if ([[pboard types] containsObject:NSURLPboardType])
    {
        NSArray<NSURL *> *urls = [pboard propertyListForType:NSURLPboardType];
        
        for (NSURL *url in urls)
        {
            NSImage *image = [[NSImage alloc] initWithContentsOfURL:url];
            [images addObject:image];
            [image release];
        }
    }
    
    for (NSImage *image in images)
    {
        
        NSPoint startPoint = NSMakePoint([sender draggingLocation].x - image.size.width/2,  self.canvasViewController.view.frame.size.height - [sender draggingLocation].y - image.size.height / 2);
        
        NSPoint endPoint = NSMakePoint(startPoint.x + image.size.width, startPoint.y + image.size.height);
        
        CHAbstractElement *newImage = (CHAbstractElement *)[CHAbstractElement imageWithStartPoint:startPoint endPoint:endPoint image:image];
        
        [self.modelController addElement:newImage];
    }
    
    [images release];
    
    return YES;
}


#pragma mark key events
- (IBAction)delete:(id)sender
{
    if (self.selectedElement)
    {
        CHAbstractElement *modelElement = self.selectedElement.modelElement;
        
        [self.modelController removeElement:modelElement];
    }
}

- (BOOL)canReadFromPasteboard:(NSPasteboard *)aBoard
{
    BOOL result = [NSImage canInitWithPasteboard:aBoard];
    
    if (!result)
    {
        NSURL *url = [NSURL URLFromPasteboard:aBoard];
        
        if (url)
        {
            result = !![[[NSImage alloc] initWithContentsOfURL:url] autorelease];
        }
    }
    
    return result;
}

- (IBAction)copy:(id)sender
{
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    NSPasteboardItem *pasteboardItem = [[NSPasteboardItem alloc] init];

    [pasteboard clearContents];
    
    if (self.selectedElement)
    {
        BOOL ok = [pasteboardItem setDataProvider:self.selectedElement forTypes:[NSArray arrayWithObject:(NSString *)kUTTypeImage]];
        
        if (ok)
        {
            [pasteboard writeObjects:[NSArray arrayWithObject:pasteboardItem]];
        }
    }
    
    [pasteboardItem release];
}

- (IBAction)paste:(id)sender
{
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    NSArray *classes = [NSArray arrayWithObject:[NSPasteboardItem class]];
    
    NSArray<NSPasteboardItem *> *copiedItems = [pasteboard readObjectsForClasses:classes options:nil];
    
    if (copiedItems)
    {
        NSData *data = [copiedItems.firstObject dataForType:(NSString *)kUTTypeImage];
        
        if (data)
        {
            CHAbstractElement *item = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            
            if (item)
            {
                [self.modelController addElement:item];
            }
        }
    }
}

#pragma mark mouse events

- (void)mouseDown:(NSEvent *)theEvent
{
    CHAbstractElement *shapeElement;
    
     NSPoint currentLocationInView = [self.canvasViewController.view convertPoint:theEvent.locationInWindow fromView:nil];
    
    switch (self.selectedDrawTool)
    {
        case kCHLineTool:
        {
            shapeElement = (CHAbstractElement *)[CHAbstractElement lineWithStartPoint:currentLocationInView endPoint:currentLocationInView color:[NSColor redColor]];
            [self.modelController addElement:shapeElement];
        }
            break;
        case kCHEllipseTool:
        {
            shapeElement = (CHAbstractElement *)[CHAbstractElement ellipseWithStartPoint:currentLocationInView endPoint:currentLocationInView color:[NSColor redColor]];
            [self.modelController addElement:shapeElement];
        }
            break;
        case kCHRectangleTool:
        {
            shapeElement = (CHAbstractElement *)[CHAbstractElement rectangleWithStartPoint:currentLocationInView endPoint:currentLocationInView color:[NSColor redColor]];
            [self.modelController addElement:shapeElement];
        }
            break;
        default:
            break;
    }
    
}


- (void)addAbstractElement:(CHAbstractElement *)element withUndoManagerAction:(NSString *)action
{
    if (element)
    {
        [[self.undoManager prepareWithInvocationTarget:self] removeAbstractElement:element withUndoManagerAction:kIECanvasViewControllerUndoManagerActionRemoving];
        [self.modelController addElement:element];
        
        if (!self.undoManager.isUndoing)
        {
            [self.undoManager setActionName:action];
        }
    }
}

- (void)removeAbstractElement:(CHAbstractElement *)element withUndoManagerAction:(NSString *)action
{
    if (element)
    {
        if (element == self.selectedElement.modelElement)
        {
            self.selectedElement = nil;
        }
        
        [[self.undoManager prepareWithInvocationTarget:self] addAbstractElement:element withUndoManagerAction:kIECanvasViewControllerUndoManagerActionAdding];
        [self.modelController removeElement:element];
        
        if (!self.undoManager.isUndoing)
        {
            [self.undoManager setActionName:action];
        }
    }
}


#pragma mark document representation
- (NSData *)documentViewRepresentationWithType:(CFStringRef)type
{
    NSData *data = nil;
    if (CFEqual(type, kUTTypePNG))
    {
        data = [[self.canvasViewController viewToBitmapImageRepresentation] representationUsingType:NSPNGFileType properties:@{}];
    }
    if (CFEqual(type, kUTTypeJPEG))
    {
        data = [[self.canvasViewController viewToBitmapImageRepresentation] representationUsingType:NSJPEGFileType properties:@{}];
    }
    if (CFEqual(type, kUTTypeTIFF))
    {
        data = [[self.canvasViewController viewToBitmapImageRepresentation] representationUsingType:NSTIFFFileType properties:@{}];
    }
    return data;
}

- (void)dealloc
{
    [_canvasViewController removeObserver:self forKeyPath:@"selectedElement"];
    [_canvasViewController release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

@end
