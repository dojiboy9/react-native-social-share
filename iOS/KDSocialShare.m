//
//  KDSocialShare.m
//  ReactNativeSocialShare
//
//  Created by Kim Døfler Sand Laursen on 25-04-15.
//  Copyright (c) 2015 Facebook. All rights reserved.
//

#import "KDSocialShare.h"
#import <React/RCTConvert.h>
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>


@interface KDSocialShare() <MFMessageComposeViewControllerDelegate>

@end

@implementation KDSocialShare
{
  RCTPromiseResolveBlock _resolve;
  RCTPromiseRejectBlock _reject;
}

// Expose this module to the React Native bridge
RCT_EXPORT_MODULE()

- (dispatch_queue_t)methodQueue
{
  return dispatch_get_main_queue();
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result
{
  if (result == MessageComposeResultCancelled){
    _resolve(@NO);
  }
  else if (result == MessageComposeResultSent){
    _resolve(@YES);
  }
  else{
    _reject(@"error_in_sending_message", @"Error sending text message.", nil);
  }
  
  _resolve = nil;
  _reject = nil;

  UIViewController *vc = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
  [vc dismissViewControllerAnimated:YES completion:nil]; //<---- This line
}

- (void)share:(NSDictionary *)options
        service:(NSString *)serviceType
        resolver:(RCTPromiseResolveBlock)resolve
        rejecter:(RCTPromiseRejectBlock)reject
{
  NSLog(@"Sharing with: %@", serviceType);
  SLComposeViewController *composeCtl = [SLComposeViewController composeViewControllerForServiceType:serviceType];

  if ([options objectForKey:@"link"] && [options objectForKey:@"link"] != [NSNull null]) {
    NSString *link = [RCTConvert NSString:options[@"link"]];
    [composeCtl addURL:[NSURL URLWithString:link]];
  }

  if ([options objectForKey:@"image"] && [options objectForKey:@"image"] != [NSNull null]) {
    [composeCtl addImage: [UIImage imageNamed: options[@"image"]]];
  } else if ([options objectForKey:@"imagelink"] && [options objectForKey:@"imagelink"] != [NSNull null]) {
    NSString *imagelink = [RCTConvert NSString:options[@"imagelink"]];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imagelink]]];
    [composeCtl addImage:image];
  }

  if ([options objectForKey:@"text"] && [options objectForKey:@"text"] != [NSNull null]) {
    NSString *text = [RCTConvert NSString:options[@"text"]];
    [composeCtl setInitialText:text];
  }

  [composeCtl setCompletionHandler:^(SLComposeViewControllerResult result) {
    if (result == SLComposeViewControllerResultDone) {
      // Sent
      resolve(@YES);
    }
    else if (result == SLComposeViewControllerResultCancelled){
      // Cancelled
      resolve(@NO);
    }
  }];

  UIViewController *ctrl = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
  [ctrl presentViewController:composeCtl animated:YES completion: nil];
}

#pragma mark - Public Methods

RCT_EXPORT_METHOD(shareOnFacebook:(NSDictionary *)options
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  [self share:options service:SLServiceTypeFacebook resolver:resolve rejecter:reject];
}

RCT_EXPORT_METHOD(shareOnMessenger:(NSDictionary *)options
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  [self share:options service:@"com.facebook.Messenger.ShareExtension" resolver:resolve rejecter:reject];
}


RCT_EXPORT_METHOD(tweet:(NSDictionary *)options
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  [self share:options service:SLServiceTypeTwitter resolver:resolve rejecter:reject];
}

RCT_EXPORT_METHOD(sendText:(NSDictionary *)options
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  if (![MFMessageComposeViewController canSendText]) {
    reject(@"no_message_services", @"Message services are not available.", nil);
  }

  NSString *message = @"";
  if ([options objectForKey:@"text"] && [options objectForKey:@"text"] != [NSNull null]) {
    NSString *text = [RCTConvert NSString:options[@"text"]];
    message = [message stringByAppendingString:text];
  }

  if ([options objectForKey:@"link"] && [options objectForKey:@"link"] != [NSNull null]) {
    NSString *link = [RCTConvert NSString:options[@"link"]];
    message = [message stringByAppendingString:@" "];
    message = [message stringByAppendingString:link];
  }

  // ignore the image and image link
  
  MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
  messageController.messageComposeDelegate = self;
  [messageController setBody:message];
  
  // Present message view controller on screen
  
  _resolve = resolve;
  _reject = reject;

  UIViewController *vc = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
  [vc presentViewController:messageController animated:YES completion:nil];
}

@end
