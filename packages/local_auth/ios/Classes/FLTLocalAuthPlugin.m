// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
#import <LocalAuthentication/LocalAuthentication.h>

#import "FLTLocalAuthPlugin.h"

@interface FLTLocalAuthPlugin ()
@property(copy, nullable) NSDictionary<NSString *, NSNumber *> *lastCallArgs;
@property(nullable) FlutterResult lastResult;
@property(nullable, nonatomic, strong) FlutterMethodChannel *channel;
@end

@implementation FLTLocalAuthPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  FlutterMethodChannel *channel =
      [FlutterMethodChannel methodChannelWithName:@"plugins.flutter.io/local_auth"
                                  binaryMessenger:[registrar messenger]];
  FLTLocalAuthPlugin *instance = [[FLTLocalAuthPlugin alloc] initWithChannel:channel];
  [registrar addMethodCallDelegate:instance channel:channel];
  [registrar addApplicationDelegate:instance];
}

- (instancetype)initWithChannel:(FlutterMethodChannel *)channel {
    self = [super init];
    if (self) {
        self.channel = channel;
    }
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
  if ([@"authenticateWithBiometrics" isEqualToString:call.method]) {
    [self authenticateWithBiometrics:call.arguments withFlutterResult:result];
  } else if ([@"getAvailableBiometrics" isEqualToString:call.method]) {
    [self getAvailableBiometrics:result];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

#pragma mark Private Methods

- (void)alertMessage:(NSString *)message
         firstButton:(NSString *)firstButton
       flutterResult:(FlutterResult)result
    additionalButton:(NSString *)secondButton {
  UIAlertController *alert =
      [UIAlertController alertControllerWithTitle:@""
                                          message:message
                                   preferredStyle:UIAlertControllerStyleAlert];

  UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:firstButton
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
                                                          result(@NO);
                                                        }];

  [alert addAction:defaultAction];
  if (secondButton != nil) {
    UIAlertAction *additionalAction = [UIAlertAction
        actionWithTitle:secondButton
                  style:UIAlertActionStyleDefault
                handler:^(UIAlertAction *action) {
                  if (UIApplicationOpenSettingsURLString != NULL) {
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    [[UIApplication sharedApplication] openURL:url];
                    result(@NO);
                  }
                }];
    [alert addAction:additionalAction];
  }
  [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alert
                                                                                     animated:YES
                                                                                   completion:nil];
}

- (void)getAvailableBiometrics:(FlutterResult)result {
    LAContext *context = [[LAContext alloc] init];
    NSMutableArray<NSString *> *biometrics = [[NSMutableArray<NSString *> alloc] init];
    NSError *authError = nil;
    [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError];
    if (@available(iOS 11.0, *)) {
        switch (context.biometryType) {
            case LABiometryTypeTouchID:
                [biometrics addObject:@"fingerprint"];
                break;
            case LABiometryTypeFaceID:
                [biometrics addObject:@"face"];
                break;
            default:
                break;
        }
    }
    result(biometrics);
}

- (void)authenticateWithBiometrics:(NSDictionary *)arguments
                 withFlutterResult:(FlutterResult)result {
  LAContext *context = [[LAContext alloc] init];
  NSError *authError = nil;
  self.lastCallArgs = nil;
  self.lastResult = nil;
  context.localizedFallbackTitle = @"";
  if (arguments && [arguments objectForKey:@"okButton"]) {
      if (@available(iOS 10.0, *)) {
          context.localizedCancelTitle = [arguments objectForKey:@"okButton"];
      }
  }

  if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                           error:&authError]) {
    [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
            localizedReason:arguments && [arguments objectForKey:@"localizedReason"] ? arguments[@"localizedReason"] : @""
                      reply:^(BOOL success, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
                        if (success) {
                          result(@YES);
                        } else {
                          switch (error.code) {
                            case LAErrorPasscodeNotSet:
                            case LAErrorTouchIDNotAvailable:
                            case LAErrorTouchIDNotEnrolled:
                            case LAErrorTouchIDLockout:
                              [self handleErrors:error
                                   flutterArguments:arguments
                                  withFlutterResult:result];
                              return;
                            case LAErrorSystemCancel:
                              if (arguments && [arguments objectForKey:@"stickyAuth"] && [arguments[@"stickyAuth"] boolValue]) {
                                self.lastCallArgs = arguments;
                                self.lastResult = result;
                                return;
                              }
                          }
                            if (self.channel) {
                                [self.channel invokeMethod:@"on_fail_attempt" arguments:nil];
                            }
                          result(@NO);
                        }
        });
    }];
  } else {
    [self handleErrors:authError flutterArguments:arguments withFlutterResult:result];
  }
}

- (void)handleErrors:(NSError *)authError
     flutterArguments:(NSDictionary *)arguments
    withFlutterResult:(FlutterResult)result {
  NSString *errorCode = @"NotAvailable";
  switch (authError.code) {
    case LAErrorPasscodeNotSet:
    case LAErrorTouchIDNotEnrolled:
      if ([arguments[@"useErrorDialogs"] boolValue]) {
        [self alertMessage:arguments[@"goToSettingDescriptionIOS"]
                 firstButton:arguments[@"okButton"]
               flutterResult:result
            additionalButton:arguments[@"goToSetting"]];
        return;
      }
      errorCode = authError.code == LAErrorPasscodeNotSet ? @"PasscodeNotSet" : @"NotEnrolled";
      break;
    case LAErrorTouchIDLockout:
      [self alertMessage:arguments[@"lockOut"]
               firstButton:arguments[@"okButton"]
             flutterResult:result
          additionalButton:nil];
      return;
  }
  result([FlutterError errorWithCode:errorCode
                             message:authError.localizedDescription
                             details:authError.domain]);
}

#pragma mark - AppDelegate

- (void)applicationDidBecomeActive:(UIApplication *)application {
  if (self.lastCallArgs != nil && self.lastResult != nil) {
    [self authenticateWithBiometrics:_lastCallArgs withFlutterResult:self.lastResult];
  }
}

@end
