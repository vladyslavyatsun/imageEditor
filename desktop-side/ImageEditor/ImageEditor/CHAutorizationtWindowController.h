//
//  CHAutorizationtWindowController.h
//  ImageEditor
//
//  Created by Владислав Яцун on 8/28/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class CHServerConnector;

@interface CHAutorizationtWindowController : NSWindowController
- (instancetype)initWithServerConnector:(CHServerConnector *)serverConnector;
@end
