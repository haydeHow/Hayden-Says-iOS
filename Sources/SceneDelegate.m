
// SceneDelegate.m
#import "SceneDelegate.h"
#import "ViewControllers/HomeVC.h"

@implementation SceneDelegate

- (void)scene:(UIScene *)scene
willConnectToSession:(UISceneSession *)session
      options:(UISceneConnectionOptions *)connectionOptions {

    if ([scene isKindOfClass:[UIWindowScene class]]) {
        UIWindowScene *windowScene = (UIWindowScene *)scene;

        self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
        HomeViewController *homeVC = [[HomeViewController alloc] init];

        // Optionally wrap in UINavigationController
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:homeVC];
        self.window.rootViewController = navController;

        [self.window makeKeyAndVisible];
    }
}


#pragma mark - Scene lifecycle (optional overrides)

- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called when scene is released by system.
}

- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Restart any paused tasks.
}

- (void)sceneWillResignActive:(UIScene *)scene {
    // Pause ongoing tasks (e.g., game).
}

- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Undo background changes.
}

- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Save data, release resources.
}

@end
