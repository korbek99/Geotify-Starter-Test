//
//  AppDelegate.swift
//  Geotify
//
//  Created by Ken Toh on 24/1/15.
//  Copyright (c) 2015 Ken Toh. All rights reserved.
//

import UIKit

import CoreLocation


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

  var window: UIWindow?

  let locationManager = CLLocationManager()
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    locationManager.delegate = self
    locationManager.requestAlwaysAuthorization()
    
    // For notification:
    application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: .Sound | .alert | .Badge, categories: nil))
    UIApplication.shared.cancelAllLocalNotifications()
    
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
  
  // = = = =  = = = =  = = = =  = = = =
  func handleRegionEvent(_ region: CLRegion!) {
//    println("Geofence triggered!")
      // Show an alert if application is active
      if UIApplication.shared.applicationState == .active {
        if let message = notefromRegionIdentifier(region.identifier) {
          if let viewController = window?.rootViewController {
            showSimpleAlertWithTitle(nil, message: message, viewController: viewController)
          }
        }
      } else {
        // Otherwise present a local notification
        var notification = UILocalNotification()
        notification.alertBody = notefromRegionIdentifier(region.identifier)
        notification.soundName = "Default";
        UIApplication.shared.presentLocalNotificationNow(notification)
      }

  }
  
  
  
  func locationManager(_ manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
    if region is CLCircularRegion {
      handleRegionEvent(region)
    }
  }
  
  func locationManager(_ manager: CLLocationManager!, didExitRegion region: CLRegion!) {
    if region is CLCircularRegion {
      handleRegionEvent(region)
    }
  }
  
  func notefromRegionIdentifier(_ identifier: String) -> String? {
    if let savedItems = UserDefaults.standard.array(forKey: kSavedItemsKey) {
      for savedItem in savedItems {
        if let geotification = NSKeyedUnarchiver.unarchiveObject(with: savedItem as! Data) as? Geotification {
          if geotification.identifier == identifier {
            return geotification.note
          }
        }
      }
    }
    return nil
  }
  
  
  
  
  
}

