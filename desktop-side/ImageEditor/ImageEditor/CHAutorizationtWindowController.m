//
//  CHAutorizationtWindowController.m
//  ImageEditor
//
//  Created by Владислав Яцун on 8/28/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//

#import "CHAutorizationtWindowController.h"
#import "CHServerConnector.h"

NSString * const kCHAuthorizationWindowControllerTryAgainMessage = @"try again";
@interface CHAutorizationtWindowController ()
@property (nonatomic, assign) CHServerConnector *serverConnector;
@property (assign) IBOutlet NSTextField *nameField;
@property (assign) IBOutlet NSSecureTextField *passwordField;
@property (assign) IBOutlet NSTextField *statusLabel;
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

- (void)windowDidLoad
{
    [super windowDidLoad];
}

- (IBAction)onClickLogInButton:(NSButton *)sender
{
    [self.serverConnector logInWithName:self.nameField.stringValue password:self.passwordField.stringValue callback:^(BOOL response)
    {
         if (response)
         {
             self.statusLabel.stringValue = @"";
             [self.window close];
         }
        else
        {
            self.statusLabel.stringValue = kCHAuthorizationWindowControllerTryAgainMessage;
        }
    }];
}

- (IBAction)onClickSignIn:(NSButton *)sender
{
    [self.serverConnector signUpWithName:self.nameField.stringValue password:self.passwordField.stringValue callback:^(BOOL response)
     {
         if (response)
        {
            self.statusLabel.stringValue = @"";
            [self.window close];
        }
         else
         {
             self.statusLabel.stringValue = kCHAuthorizationWindowControllerTryAgainMessage;
         }
     }];
}


@end
