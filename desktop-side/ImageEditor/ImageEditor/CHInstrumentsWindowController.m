//
//  CHInstrumentsPanel.m
//  ImageEditor
//
//  Created by Владислав Яцун on 8/20/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import "CHInstrumentsWindowController.h"
#import "CHDocumentWindowController.h"

@interface CHInstrumentsWindowController ()
@property (assign) IBOutlet NSButton *pointerButton;
@property (assign) IBOutlet NSButton *ellipseButton;
@property (assign) IBOutlet NSButton *lineButton;
@property (assign) IBOutlet NSButton *rectangleButton;
@property (assign) NSButton *selectedInstrument;
@end

@implementation CHInstrumentsWindowController

- (instancetype) init
{
    return [super initWithWindowNibName:@"CHInstrumentsWindowController"];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
}

- (IBAction)selectPointer:(id)sender
{
    [self.currentDocumentWindowController setToolForDrawOnCanvas:kCHPointerTool];
    [self selectInstrument:kCHPointerTool];
}

- (IBAction)selectLine:(id)sender
{
    [self.currentDocumentWindowController setToolForDrawOnCanvas:kCHLineTool];
    [self selectInstrument:kCHLineTool];
}

- (IBAction)selectRectangle:(id)sender
{
    [self.currentDocumentWindowController setToolForDrawOnCanvas:kCHRectangleTool];
    [self selectInstrument:kCHRectangleTool];
}

- (IBAction)selectEllipse:(id)sender
{
    [self.currentDocumentWindowController setToolForDrawOnCanvas:kCHEllipseTool];
    [self selectInstrument:kCHEllipseTool];
}

- (void)setCurrentDocumentWindowController:(CHDocumentWindowController *)currentDocumentWindowController
{
    _currentDocumentWindowController = currentDocumentWindowController;
    [self selectInstrument:currentDocumentWindowController.selectedDrawTool];
}


- (void)selectInstrument:(CHDrawTool)drawTool
{
    self.selectedInstrument.state = 0;
    
    switch (drawTool)
    {
        case kCHPointerTool:
        {
            self.selectedInstrument = self.pointerButton;
            self.pointerButton.state = 1;
        }
            break;
        case kCHLineTool:
        {
            self.selectedInstrument = self.lineButton;
            self.lineButton.state = 1;
        }
            break;
        case kCHEllipseTool:
        {
            self.selectedInstrument = self.ellipseButton;
            self.ellipseButton.state = 1;
        }
            break;
        case kCHRectangleTool:
        {
            self.selectedInstrument = self.rectangleButton;
            self.rectangleButton.state = 1;
        }
            break;
        default:
            break;
    }
}
@end
