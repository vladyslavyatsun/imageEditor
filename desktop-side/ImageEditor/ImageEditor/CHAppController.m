//
//  AppDelegate.m
//  ImageEditor
//
//  Created by Владислав Яцун on 8/19/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import "CHAppController.h"
#import "CHInspectorPanelController.h"
#import "CHLibraryPanelController.h"
#import "CHInstrumentsPanelController.h"
#import "CHAbstractElementRepresentation.h"

NSString * const kCHSelectedElementPath = @"mainWindow.windowController.canvasViewController.selectedElement";
NSString * const kCHCurrentDocumentPath = @"mainWindow.windowController";

@interface CHAppController ()
@property (nonatomic, retain) CHLibraryPanelController *libraryPanelController;
@property (nonatomic, retain) CHInspectorPanelController *inspectorPanelController;
@property (nonatomic, retain) CHInstrumentsPanelController *instrumentsPanelController;
@end

@implementation CHAppController

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [NSApp activateIgnoringOtherApps:YES];
    
    [self.libraryPanelController showWindow:self];
    [self.inspectorPanelController showWindow:self];
    
    [NSApp addObserver:self
            forKeyPath:kCHSelectedElementPath
               options:NSKeyValueObservingOptionNew
               context:[CHAppController class]];
    
    [NSApp addObserver:self
            forKeyPath:kCHCurrentDocumentPath
               options:NSKeyValueObservingOptionNew
               context:[CHAppController class]];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == [CHAppController class])
    {
        if ([keyPath isEqualToString:kCHSelectedElementPath] && [self.inspectorPanelController.window isVisible])
        {
           [self.inspectorPanelController setSelectedElement:[NSApp valueForKeyPath:kCHSelectedElementPath]];
        }
        
        if ([keyPath isEqualToString:kCHCurrentDocumentPath])
        {
            [self.libraryPanelController setCurrentDocumentWindowController:[NSApp valueForKeyPath:kCHCurrentDocumentPath]];
            [self.instrumentsPanelController setCurrentDocumentWindowController:[NSApp valueForKeyPath:kCHCurrentDocumentPath]];
        }
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


#pragma mark panels manage
- (IBAction)clickOnLibraryPanel:(id)sender
{
    if ([self.libraryPanelController.window isVisible])
    {
        [self.libraryPanelController.window orderOut:self];
    }
    else
    {
        [self.libraryPanelController.window makeKeyAndOrderFront:self];
    }
}

- (IBAction)clickOnInstrumentsPanel:(id)sender
{
    if ([self.instrumentsPanelController.window isVisible])
    {
        [self.instrumentsPanelController.window orderOut:self];
    }
    else
    {
        [self.instrumentsPanelController.window makeKeyAndOrderFront:self];
    }
}

- (IBAction)clickOnInspectorPanel:(id)sender
{
    if ([self.inspectorPanelController.window isVisible])
    {
        [self.inspectorPanelController.window orderOut:self];
    }
    else
    {
        [self.inspectorPanelController.window makeKeyAndOrderFront:self];
    }
}

- (CHLibraryPanelController *)libraryPanelController
{
    if (!_libraryPanelController)
    {
        _libraryPanelController = [[CHLibraryPanelController alloc] init];
    }
    return _libraryPanelController;
}

- (CHInstrumentsPanelController *)instrumentsPanelController
{
    if (!_instrumentsPanelController)
    {
        _instrumentsPanelController = [[CHInstrumentsPanelController alloc] init];
    }
    return _instrumentsPanelController;
}

- (CHInspectorPanelController *)inspectorPanelController
{
    if (!_inspectorPanelController)
    {
        _inspectorPanelController = [[CHInspectorPanelController alloc] init];
    }
    return _inspectorPanelController;
}

- (void)dealloc
{
    [NSApp removeObserver:self forKeyPath:kCHSelectedElementPath context:[CHAppController class]];
    [NSApp removeObserver:self forKeyPath:kCHCurrentDocumentPath context:[CHAppController class]];
    [_libraryPanelController release];
    [_inspectorPanelController release];
    [_instrumentsPanelController release];
    [super dealloc];
}
@end
