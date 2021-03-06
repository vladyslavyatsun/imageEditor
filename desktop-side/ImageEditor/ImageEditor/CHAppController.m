//
//  AppDelegate.m
//  ImageEditor
//
//  Created by Владислав Яцун on 8/19/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import "CHAppController.h"
#import "CHInspectorWindowController.h"
#import "CHLibraryWindowController.h"
#import "CHInstrumentsWindowController.h"
#import "CHAbstractElementRepresentation.h"
#import "CHAutorizationtWindowController.h"
#import "CHServerConnector.h"
#import "CHServerDocumentsWindowController.h"

NSString * const kCHSelectedElementPath = @"mainWindow.windowController.canvasViewController.selectedElement";
NSString * const kCHCurrentDocumentPath = @"mainWindow.windowController";

@interface CHAppController ()
@property (nonatomic, retain) CHServerConnector *serverConnector;
@property (nonatomic, retain) CHLibraryWindowController *libraryPanelController;
@property (nonatomic, retain) CHInspectorWindowController *inspectorPanelController;
@property (nonatomic, retain) CHInstrumentsWindowController *instrumentsPanelController;
@property (nonatomic, retain) CHAutorizationtWindowController *autorizationWindowController;
@property (nonatomic, retain) CHServerDocumentsWindowController *serverDocumentsWindowController;


@end

@implementation CHAppController

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.serverConnector = [[[CHServerConnector alloc] init] autorelease];
    
    [NSApp activateIgnoringOtherApps:YES];
    
    [self.libraryPanelController showWindow:self];
    [self.inspectorPanelController showWindow:self];
    [self.instrumentsPanelController showWindow:self];
    
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

#pragma mark account manage
- (IBAction)clickOnAccountLogIn:(id)sender
{
    if ([self.autorizationWindowController.window isVisible])
    {
        [self.autorizationWindowController.window orderOut:self];
    }
    else
    {
        [self.autorizationWindowController.window makeKeyAndOrderFront:self];
    }

}

- (IBAction)clickOnAccountLogOut:(id)sender
{
    [self.serverConnector logOut];
}

- (IBAction)clickOnAccountDocuments:(id)sender
{
    if ([self.serverDocumentsWindowController.window isVisible])
    {
        [self.serverDocumentsWindowController.window orderOut:self];
    }
    else
    {
        [self.serverDocumentsWindowController.window makeKeyAndOrderFront:self];
    }
}

#pragma mark getters
- (CHLibraryWindowController *)libraryPanelController
{
    if (!_libraryPanelController)
    {
        _libraryPanelController = [[CHLibraryWindowController alloc] init];
    }
    return _libraryPanelController;
}

- (CHInstrumentsWindowController *)instrumentsPanelController
{
    if (!_instrumentsPanelController)
    {
        _instrumentsPanelController = [[CHInstrumentsWindowController alloc] init];
    }
    return _instrumentsPanelController;
}

- (CHInspectorWindowController *)inspectorPanelController
{
    if (!_inspectorPanelController)
    {
        _inspectorPanelController = [[CHInspectorWindowController alloc] init];
    }
    return _inspectorPanelController;
}

- (CHAutorizationtWindowController *)autorizationWindowController
{
    if (!_autorizationWindowController)
    {
        _autorizationWindowController = [[CHAutorizationtWindowController alloc] initWithServerConnector:self.serverConnector];
        [_autorizationWindowController.window orderOut:self];
    }
    return _autorizationWindowController;
}

- (CHServerDocumentsWindowController *)serverDocumentsWindowController
{
    if (!_serverDocumentsWindowController)
    {
        _serverDocumentsWindowController = [[CHServerDocumentsWindowController alloc] initWithServerConnector:self.serverConnector];
        [_serverDocumentsWindowController.window orderOut:self];
    }
    return _serverDocumentsWindowController;
}

- (void)dealloc
{
    [NSApp removeObserver:self forKeyPath:kCHSelectedElementPath context:[CHAppController class]];
    [NSApp removeObserver:self forKeyPath:kCHCurrentDocumentPath context:[CHAppController class]];
    [_serverConnector release];
    [_libraryPanelController release];
    [_inspectorPanelController release];
    [_instrumentsPanelController release];
    [_autorizationWindowController release];
    [_serverDocumentsWindowController release];
    [super dealloc];
}
@end
