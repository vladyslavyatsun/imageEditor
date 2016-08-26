//
//  Document.m
//  ImageEditor
//
//  Created by Владислав Яцун on 8/19/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import "CHDocument.h"
#import "CHAbstractElement.h"
#import "CHDocumentWindowController.h"
#import "CHDocumentModelController.h"
@interface CHDocument ()
@property (nonatomic, retain) CHDocumentModelController *modelController;
@end

@implementation CHDocument

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _modelController = [[CHDocumentModelController alloc] init];
    }
    return self;
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    return [NSKeyedArchiver archivedDataWithRootObject:self.modelController.elementsArray];
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    BOOL readSuccess = NO;
    
    NSArray *modelElements = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if (modelElements)
    {
        readSuccess = YES;
        
        for (CHAbstractElement *modelElement in modelElements)
        {
            [self.modelController addElement:modelElement];
        }
    }
    
    return readSuccess;
}

- (IBAction)exportDocumentToPNG:(id)sender
{
    [self exportDocument:self.displayName toType:kUTTypePNG];
}

- (IBAction)exportDocumentToTIFF:(id)sender
{
    [self exportDocument:self.displayName toType:kUTTypeTIFF];
}

- (IBAction)exportDocumentToJPEG:(id)sender
{
    [self exportDocument:self.displayName toType:kUTTypeJPEG];
}

- (void)exportDocument:(NSString *)name toType:(CFStringRef)type
{
    NSWindow *window = self.windowControllers.firstObject.window;
    
    CFStringRef newExtension = UTTypeCopyPreferredTagWithClass(type, kUTTagClassFilenameExtension);
    NSString* newName = [[name stringByDeletingPathExtension] stringByAppendingPathExtension:(NSString*)newExtension];
    
    CFRelease(newExtension);
    
    NSSavePanel *panel = [NSSavePanel savePanel];
    [panel setNameFieldStringValue:newName];
    
    [panel beginSheetModalForWindow:window completionHandler:^(NSInteger result)
    {
        if (result == NSFileHandlingPanelOKButton)
        {
            NSURL *theFile = [panel URL];
            NSData *data = [self.windowControllers.firstObject documentViewRepresentationWithType:type];
            
            if (data)
            {
                [data writeToURL:theFile atomically:YES];
            }
        }
    }];
}

- (void)makeWindowControllers
{
    NSArray *myControllers = [self windowControllers];
    if ([myControllers count] == 0)
    {
        [self addWindowController:[[[CHDocumentWindowController alloc] initWithNibName:@"CHDocument" modelContoller:self.modelController] autorelease]];
    }
}

- (void)dealloc
{
    [_modelController release];
    [super dealloc];
}

@end
