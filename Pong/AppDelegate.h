//
//  AppDelegate.h
//  Pong
//
//  Created by Jake Boxer on 4/21/12.
//  Copyright Jake Boxer 2012. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow *window;
	RootViewController *viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
