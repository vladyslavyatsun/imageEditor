//
//  CHDocumentsWindowController.m
//  ImageEditor
//
//  Created by Владислав Яцун on 8/28/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import "CHServerDocumentsWindowController.h"
#import "CHServerConnector.h"
#import "CHDocumentWindowController.h"
#import "CHDocument.h"

NSString * const kCHServerDocumentControllerKeyImage = @"image";
NSString * const kCHServerDocumentControllerKeyDownload = @"download";
NSString * const kCHServerDocumentControllerKeyDelete = @"delete";
NSString * const kCHServerDocumentControllerFileExtention = @"chi";

@interface CHServerDocumentsWindowController ()<NSTableViewDelegate, NSTableViewDataSource>
@property (nonatomic, assign) CHServerConnector *serverConnector;
@property (nonatomic, retain) NSMutableArray<NSNumber *> *indexesOfDocuments;
@property (assign) IBOutlet NSTableView *documentsTable;
@end

@implementation CHServerDocumentsWindowController

- (instancetype)initWithServerConnector:(CHServerConnector *)serverConnector
{
    self = [super initWithWindowNibName:@"CHServerDocumentsWindowController"];
    
    if (self)
    {
        _serverConnector = serverConnector;
        _indexesOfDocuments = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)windowDidLoad
{
    [self updateIndexesOfDocuments];
    [super windowDidLoad];
}

- (void)updateIndexesOfDocuments
{
    [self.indexesOfDocuments removeAllObjects];
    [self.serverConnector indexesOfDocumentsCallback:^(NSArray<NSNumber *> *indexes)
     {
         [self.indexesOfDocuments addObjectsFromArray:indexes];
         [self.documentsTable reloadData];
     }];

}

#pragma mark fill table
- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSTableCellView *result = nil;
    
    if ([tableColumn.identifier isEqualToString:kCHServerDocumentControllerKeyImage])
    {
        result = [tableView makeViewWithIdentifier:kCHServerDocumentControllerKeyImage owner:self];
        [self.serverConnector previewDataWithIndex:[self.indexesOfDocuments[row] integerValue] callback:^(NSImage *image)
        {
            result.imageView.image = image;
        }];
    }
    if ([tableColumn.identifier isEqualToString:kCHServerDocumentControllerKeyDownload])
    {
        result = [tableView makeViewWithIdentifier:kCHServerDocumentControllerKeyDownload owner:self];
    }
    
    if ([tableColumn.identifier isEqualToString:kCHServerDocumentControllerKeyDelete])
    {
        result = [tableView makeViewWithIdentifier:kCHServerDocumentControllerKeyDelete owner:self];
    }
    return result;
}

- (IBAction)onClickDownloadButton:(NSButton *)sender
{
    NSInteger index = [self.documentsTable rowForView:sender];
    [self.serverConnector downloadDocumentWithIndex:self.indexesOfDocuments[index].integerValue];
}

- (IBAction)onClickDeleteButton:(NSButton *)sender
{
    NSInteger index = [self.documentsTable rowForView:sender];
    [self.serverConnector removeDocumentWithIndex:self.indexesOfDocuments[index].integerValue callback:^(BOOL response)
    {
       if (response)
       {
           [self updateIndexesOfDocuments];
       }
    }];
}

- (IBAction)onClickUploadDocument:(NSButton *)sender
{
    CHDocument *document = [NSDocumentController sharedDocumentController].currentDocument;
    CHDocumentWindowController *windowController = (CHDocumentWindowController *)document.windowControllers.lastObject;
    
    if (windowController)
    {
        NSError *error;
        NSData *data = [document dataOfType:kCHServerDocumentControllerFileExtention error:&error];
        NSImage *image = [[NSImage alloc] initWithData:[windowController documentViewRepresentationWithType:kUTTypePNG]];
        
        [self.serverConnector uploadDocument:data documentPreview:image callback:^(BOOL response)
         {
             if (response)
             {
                 [self updateIndexesOfDocuments];
             }
         }];
        [image release];
    }
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.indexesOfDocuments.count;
}

- (void)dealloc
{
    [_indexesOfDocuments release];
    [super dealloc];
}


@end
