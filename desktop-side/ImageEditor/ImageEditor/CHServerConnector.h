//
//  CHServerConnector.h
//  ImageEditor
//
//  Created by Владислав Яцун on 8/28/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface CHServerConnector : NSObject
@property (nonatomic, assign) BOOL connection;

- (void)logInWithName:(NSString *)name password:(NSString *)password;
- (void)signInWithLogin:(NSString *)name password:(NSString *)password;
- (void)logOut;
- (void)indexesOfDocumentsCallback:(void (^)(NSArray<NSNumber *> *))callback;
- (void)previewDataWithIndex:(NSUInteger)index callback:(void (^)(NSImage *))callback;
- (void)downloadDocumentWithIndex:(NSUInteger)index;
- (void)removeDocumentWithIndex:(NSUInteger)index callback:(void (^)(BOOL))callback;
- (void)uploadDocument:(NSData *)document documentPreview:(NSImage *)documentPreview;

@end
