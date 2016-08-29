//
//  CHAutorizationtWindowController.m
//  ImageEditor
//
//  Created by Владислав Яцун on 8/28/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import "CHAutorizationtWindowController.h"
#import "CHServerConnector.h"

@interface CHAutorizationtWindowController ()
@property (nonatomic, assign) CHServerConnector *serverConnector;
@end

@implementation CHAutorizationtWindowController

- (instancetype)initWithServerConnector:(CHServerConnector *)serverConnector
{
    self = [super initWithWindowNibName:@"CHAutorizationtWindowController"];
    if (self)
    {
        self.serverConnector = serverConnector;
    }
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}



@end
