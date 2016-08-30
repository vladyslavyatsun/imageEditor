//
//  CHServerConnector.m
//  ImageEditor
//
//  Created by Владислав Яцун on 8/28/16.
//  Copyright © 2016 Владислав Яцун. All rights reserved.
//


#import <Cocoa/Cocoa.h>
#import "CHServerConnector.h"

NSString * const kCHServerConnectorAuthorizationHeader = @"Authorization";
NSString * const kCHServerConnectorLogInURL = @"http://10.55.33.13:8000/api/login";
NSString * const kCHServerConnectorSignInURL =  @"http://10.55.33.13:8000/api/register";
NSString * const kCHServerConnectorIndexesOfDocumentURL = @"http://10.55.33.13:8000/api/documents";
NSString * const kCHServerConnectorDocumentsURL= @"http://10.55.33.13:8000/api/documents/";
NSString * const kCHServerConnectorPreviewURL = @"/preview";
NSString * const kCHServerConnectorDocumentURL = @"/document";
NSString * const kCHServerConnectorTryAgainMessage = @"Try again!";
NSString * const kCHServerConnectorHeaderContentType = @"Content-Type";
NSString * const kCHServerConnectorName = @"name";
NSString * const kCHServerConnectorPassword = @"password";
NSString * const kCHServerConnectorPasswordConfirmation = @"password_confirmation";
NSString * const kCHServerConnectorCustomFileExtention = @"chi";

@interface CHServerConnector()
@property (nonatomic, copy) NSString *accessToken;
@end

@implementation CHServerConnector
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _accessToken = [[NSString alloc] init];
    }
    return self;
}

- (void)logInWithName:(NSString *)name password:(NSString *)password callback:(void (^)(BOOL))callback
{
    NSError *error = nil;
    NSDictionary *bodyDictionary = @{kCHServerConnectorName:name,
                                     kCHServerConnectorPassword:password};
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:bodyDictionary options:0 error:&error];
    
    NSURL *url = [NSURL URLWithString:kCHServerConnectorLogInURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:kCHServerConnectorHeaderContentType];
    [request setHTTPBody:bodyData];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^
                                  (NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                  {
                                      if (error != nil)
                                      {
                                          NSLog(@"error: %@", error);
                        
                                      }
                                      else
                                      {
                                          id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                          
                                          if ([json isKindOfClass:[NSDictionary class]])
                                          {
                                              NSDictionary *responseData = (NSDictionary *)json;
                                              
                                              if ([responseData objectForKey:@"token"])
                                              {
                                                  self.accessToken = [responseData objectForKey:@"token"];
                                                  self.connection = YES;
                                                  dispatch_async(dispatch_get_main_queue(), ^
                                                                 {
                                                                     callback(YES);
                                                                 });
                                              }

                                          }
                                          else
                                          {
                                              dispatch_async(dispatch_get_main_queue(), ^
                                                             {
                                                                 callback(NO);
                                                             });
                                          }
                                      }
                                  }];
    
    [task resume];
    [session finishTasksAndInvalidate];

}
- (void)signUpWithName:(NSString *)name password:(NSString *)password callback:(void (^)(BOOL))callback
{
    NSError *error = nil;
    NSDictionary *bodyDictionary = @{kCHServerConnectorName:name,
                                     kCHServerConnectorPassword:password,
                                     kCHServerConnectorPasswordConfirmation:password};
    
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:bodyDictionary options:0 error:&error];
    
    NSURL *url = [NSURL URLWithString:kCHServerConnectorSignInURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:kCHServerConnectorHeaderContentType];
    [request setHTTPBody:bodyData];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^
                                  (NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                  {
                                      if (error != nil)
                                      {
                                          NSLog(@"ERROR: %@", error);
                                      }
                                      else
                                      {
                                          id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                          
                                          if ([json isKindOfClass:[NSDictionary class]])
                                          {
                                              NSDictionary *responseData = (NSDictionary *)json;
                                              
                                              if ([responseData objectForKey:@"token"] != nil)
                                              {
                                                  self.accessToken = [responseData objectForKey:@"token"];
                                                  self.connection = YES;
                                                  dispatch_async(dispatch_get_main_queue(), ^
                                                                 {
                                                                     callback(YES);
                                                                 });
                                              }
                                          }
                                          else
                                          {
                                              dispatch_async(dispatch_get_main_queue(), ^
                                                             {
                                                                 callback(NO);
                                                             });
                                          }

                                      }
                                  }];
    
    [task resume];
    [session finishTasksAndInvalidate];
}


- (void)logOut;
{
    self.connection = NO;
    self.accessToken = nil;
}


- (void)indexesOfDocumentsCallback:(void (^)(NSArray<NSNumber *> *))callback;
{
    NSURL *url = [NSURL URLWithString:kCHServerConnectorIndexesOfDocumentURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:self.accessToken forHTTPHeaderField:kCHServerConnectorAuthorizationHeader];

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^
                                  (NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                  {
                                      if (error != nil)
                                      {
                                          NSLog(@"ERROR: %@", error);
                                          
                                      }
                                      else
                                      {
                                          NSMutableArray *indexes = [[NSMutableArray alloc] init];
                                          id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                          if ([json isKindOfClass:[NSArray class]])
                                          {
                                              NSDictionary *responseData = (NSDictionary *)json;
                                              NSString *key = [[NSString alloc] initWithString:@"document_id"];
                                              
                                              for (NSDictionary *documentData in responseData)
                                              {
                                                  [indexes addObject:[documentData objectForKey:key]];
                                              }
                                              [key release];
                                              
                                              dispatch_async(dispatch_get_main_queue(), ^
                                                             {
                                                                 callback(indexes);
                                                             });
                        
                                          }
                                          [indexes release];
                                      }
                                  }];
    
    [task resume];
    [session finishTasksAndInvalidate];
}

- (void)previewDataWithIndex:(NSUInteger)index callback:(void (^)(NSImage *))callback
{
    NSString *urlString = [NSString stringWithFormat:@"%@%lu%@", kCHServerConnectorDocumentsURL, index, kCHServerConnectorPreviewURL];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:self.accessToken forHTTPHeaderField:kCHServerConnectorAuthorizationHeader];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:
                                      ^(NSURL *location, NSURLResponse *response, NSError *error)
                                      {
                                          if (error != nil)
                                          {
                                              NSLog(@"ERROR: %@", error);
                                          
                                          }
                                          else
                                          {
                                              NSImage *image = [[[NSImage alloc] initWithContentsOfURL:location] autorelease];
                                              dispatch_async(dispatch_get_main_queue(), ^
                                                             {
                                                                 callback(image);
                                                             });
                                          }
                                  }];
    
    [task resume];
    [session finishTasksAndInvalidate];
}



- (void)downloadDocumentWithIndex:(NSUInteger)index
{
    NSString *urlString = [NSString stringWithFormat:@"%@%lu%@", kCHServerConnectorDocumentsURL, index, kCHServerConnectorDocumentURL];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:self.accessToken forHTTPHeaderField:kCHServerConnectorAuthorizationHeader];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:
                                      ^(NSURL *location, NSURLResponse *response, NSError *error)
                                      {
                                          if (error != nil)
                                          {
                                              NSLog(@"ERROR: %@", error);
                                          }
                                          else
                                          {
                                              NSFileManager *fileManager = [NSFileManager defaultManager];
                                              NSArray *urls = [fileManager URLsForDirectory:NSDownloadsDirectory inDomains:NSUserDomainMask];
                                              NSURL *documentsDirectory = [urls objectAtIndex:0];
                                              NSURL *destinationUrl = [documentsDirectory URLByAppendingPathComponent:[[[location URLByDeletingPathExtension] lastPathComponent] stringByAppendingPathExtension:kCHServerConnectorCustomFileExtention]];
                                              NSError *fileManagerError;
                                              [fileManager removeItemAtURL:destinationUrl error:NULL];
                                              [fileManager copyItemAtURL:location toURL:destinationUrl error:&fileManagerError];
                                          }
                                      }];
    
    [task resume];
    [session finishTasksAndInvalidate];
}

- (void)removeDocumentWithIndex:(NSUInteger)index callback:(void (^)(BOOL))callback
{
    NSString *urlString = [NSString stringWithFormat:@"%@%lu", kCHServerConnectorDocumentsURL, index];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"DELETE"];
    [request setValue:self.accessToken forHTTPHeaderField:kCHServerConnectorAuthorizationHeader];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^
                                  (NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                      {
                                          if (error != nil)
                                          {
                                              NSLog(@"ERROR: %@", error);
                                              
                                          }
                                          else
                                          {
                                              id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                              if ([json isKindOfClass:[NSDictionary class]])
                                              {
                                                  NSDictionary *location = (NSDictionary *)json;
                                                  if ([[location objectForKey:@"status"] compare:@"deleted"] == NSOrderedSame)
                                                  {
                                                      dispatch_async(dispatch_get_main_queue(), ^
                                                                     {
                                                                         callback(YES);
                                                                     });

                                                  }
                                                  else
                                                  {
                                                      dispatch_async(dispatch_get_main_queue(), ^
                                                                     {
                                                                         callback(NO);
                                                                     });

                                                  }
                                              }
                                          }
                                      }];
    
    [task resume];
    [session finishTasksAndInvalidate];
}

- (void)uploadDocument:(NSData *)document documentPreview:(NSImage *)documentPreview callback:(void (^)(BOOL))callback
{
    NSData *imageData = [documentPreview TIFFRepresentation];
    NSURL *url = [NSURL URLWithString:kCHServerConnectorDocumentsURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = [NSString stringWithFormat:@"----------*------------------*************--------------*------------"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:kCHServerConnectorHeaderContentType];
    
    [request addValue:self.accessToken forHTTPHeaderField:@"Authorization"];

    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"preview\"; filename=\"preview.tiff\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    

    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"document\"; filename=\"document.chi\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:document]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^
                                  (NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                  {
                                      if (error != nil)
                                      {
                                          NSLog(@"ERROR: %@", error);
                                          dispatch_async(dispatch_get_main_queue(), ^
                                                         {
                                                             callback(NO);
                                                         });

                                          
                                      }
                                      else
                                      {
                                          dispatch_async(dispatch_get_main_queue(), ^
                                                         {
                                                             callback(YES);
                                                         });

                                      }
                                    }];
    
    [task resume];
    [session finishTasksAndInvalidate];
}


- (void)alertWithMessage:(NSString *)message
{
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"OK"];
    [alert setMessageText:message];
    [alert setAlertStyle:NSWarningAlertStyle];
    [alert runModal];
    [alert release];
}


- (void)setAccessToken:(NSString *)accessToken
{
    if (_accessToken != accessToken)
    {
        [_accessToken release];
        _accessToken = [accessToken copy];
    }
}

- (void)dealloc
{
    [_accessToken release];
    [super dealloc];
}

@end
