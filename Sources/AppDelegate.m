// AppDelegate.m
#import "AppDelegate.h"
#import "Constants.h"
#import <UserNotifications/UserNotifications.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UNUserNotificationCenter currentNotificationCenter]
        requestAuthorizationWithOptions:(UNAuthorizationOptionAlert |
                                         UNAuthorizationOptionSound)
                      completionHandler:^(BOOL granted,
                                          NSError *_Nullable error) {
                        if (granted) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                              [application registerForRemoteNotifications];
                            });
                        }
                      }];
    [self makeGETRequest];
    return YES;
}

- (void)application:(UIApplication *)application
    didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

    const unsigned char *dataBuffer =
        (const unsigned char *)[deviceToken bytes];
    NSMutableString *tokenString =
        [NSMutableString stringWithCapacity:(deviceToken.length * 2)];

    for (int i = 0; i < deviceToken.length; ++i) {
        [tokenString appendFormat:@"%02x", dataBuffer[i]];
    }

    NSLog(@"📲 Device Token: %@", tokenString);

    // OPTIONAL: Store it in UserDefaults
    [[NSUserDefaults standardUserDefaults] setObject:tokenString
                                              forKey:@"StoredDeviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    // OPTIONAL: Send it to your server
    [self registerDeviceWithName:@"YourDeviceName"
                     deviceToken:tokenString
                      completion:nil];
}

- (void)registerDeviceWithName:(NSString *)name
                   deviceToken:(NSString *)deviceToken
                    completion:(void (^)(BOOL success))completion {
    NSURL *url = [NSURL URLWithString:registerDeviceURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    NSDictionary *bodyDict = @{@"name" : name, @"device_token" : deviceToken};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:bodyDict
                                                       options:0
                                                         error:&error];
    if (!jsonData) {
        NSLog(@"Error serializing JSON: %@", error);
        if (completion)
            completion(NO);
        return;
    }
    request.HTTPBody = jsonData;

    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession]
        dataTaskWithRequest:request
          completionHandler:^(NSData *_Nullable data,
                              NSURLResponse *_Nullable response,
                              NSError *_Nullable error) {
            if (error) {
                NSLog(@"Error sending device token: %@", error);
                if (completion)
                    completion(NO);
                return;
            }

            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            NSLog(@"Server response status: %ld",
                  (long)httpResponse.statusCode);

            if (httpResponse.statusCode == 200) {
                if (completion)
                    completion(YES);
            } else {
                if (completion)
                    completion(NO);
            }
          }];
    [dataTask resume];
}

- (void)application:(UIApplication *)application
    didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Failed to register: %@", error);
}
// Called when a notification is delivered to a foreground app
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:
             (void (^)(UNNotificationPresentationOptions options))
                 completionHandler {
    NSLog(@"Foreground notification received: %@",
          notification.request.content.userInfo);

    // Show alert, sound, badge even when app is foreground
    completionHandler(UNNotificationPresentationOptionAlert |
                      UNNotificationPresentationOptionSound |
                      UNNotificationPresentationOptionBadge);
}

// Called when a notification is tapped and the app is in background or
// terminated
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
    didReceiveNotificationResponse:(UNNotificationResponse *)response
             withCompletionHandler:(void (^)(void))completionHandler {

    NSDictionary *userInfo = response.notification.request.content.userInfo;
    NSLog(@"📲 Notification tapped with payload: %@", userInfo);

    // You can use this to navigate, open a screen, etc.
    // Example: send a local notification or update some view controller

    completionHandler();
}

- (void)makeGETRequest {
    NSURL *url = [NSURL URLWithString:visitedURL];
    NSURLSession *session = [NSURLSession sharedSession];

    NSURLSessionDataTask *task =
        [session dataTaskWithURL:url
               completionHandler:^(NSData *data, NSURLResponse *response,
                                   NSError *error) {
                 if (error) {
                     NSLog(@"❌ Error: %@", error.localizedDescription);
                     return;
                 }
               }];

    [task resume];
}

@end
