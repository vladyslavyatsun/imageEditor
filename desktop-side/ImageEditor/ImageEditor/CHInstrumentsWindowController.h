//
//  CHInstrumentsPanel.h
//  ImageEditor
//
//  Created by Владислав Яцун on 8/20/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class CHDocumentWindowController;

@interface CHInstrumentsWindowController : NSWindowController
@property (nonatomic, assign) CHDocumentWindowController *currentDocumentWindowController;
@end
