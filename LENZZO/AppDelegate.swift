//
//  AppDelegate.swift
//  LENZZO
//
//  Created by Apple on 8/13/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import SwiftyJSON
import Firebase
import UserNotifications
import OneSignal
import MFSDK

//K1ll3r145789
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, OSPermissionObserver, OSSubscriptionObserver {

    var window: UIWindow?
    var navCon:UINavigationController?

    let gcmMessageIDKey = "gcm.message_id"
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
         self.setInitialRootToPlayVideo()
        self.setStatusBarColor()
        
        FirebaseApp.configure()
        
       if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
            UNUserNotificationCenter.current().delegate = self
            Messaging.messaging().delegate = self
            
            application.registerForRemoteNotifications()


        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

    
        
        // set up your MyFatoorah Merchant details
                       let directPaymentToken = "qrz8Areo9E4bUBTrVFjfGGsWw-b5vSwoljdj1ZLX15dR5k-eHvHH_FjtqUZ5AT2IuLnjb6hbfM1Ee2h8jVNjY0ZzxIgQ3nBKFWsQ9MWk6DOXzjJwFG0i2O3NS-zwFgFYvUvFHQRwon0GTLl_qywRhvojuKwg3wJfVkzpK9DRNb52IACMwqzrpIR3IDzO6jeh2uhelQhGKdL6c23ohRA7fXx7PB5W-6xjjWAspMJHR1N1jKoD8kA5k15JWWM4uPgcqX90bMaWwZWFg1Vdq9Fpdy8-VK4fQQWPtijzDJMWKJ7Nkx-XQGP7NVPYM-5MMSYNZYwpPPJnOWA61f3-lPapozLrv2kCjQG91Z0RGsTrCTJt1wxPQUU9eyyN4_Gt0s7XzU1t90WlcyUJ4khSCCPeOiPK3D6rYGDLZxYL-DARoF5fhg071OXTvviFAAiBcbfBwVZMXUOwPCC__be_FVOdaVkoAbwJRPWuq2pqfMFKotX2rLrKdnnsI92Hohb7nuq6Hu14SNN5AjgqhoMhsEi8iVj0L57IW9WHPxkNWoSgQYkphanQh32AD4xDG2HDeeSAcLXeIeU7tz0rsg8jAAhNP8wGHnoQFDgCJj5pwvHDn184lkpHyrZVQBtU9o-4iOWcVncdxVubetINdUbKnHm147k96FnvvptGIbKUj75cDmTDT7bYuX9K0AWL8iPouHj63RfoMg"
              // let token = "jc8whj0GPUKu7MlnXCum7x832rqFtKryOlvEXj0trVo4f4rWDnFjVSKRIa6FUOhNhVi2BMTGVDCgYtnPM_aX_u8umRqAlaWIrP-jya7LkspmAkYOO3lO4HfilFe2gma6_2wG5h30DFAJ_GGd02ahXn2U6QZ6bRyRWbPG2_w_2f_s32eMQTYQZyVrG6-p5W4Wu-7PbAcRDwF5upYWnC0aDK-6GeFljyx5dBc0n4heu53onn9OtG10cqap90Nb7bgFzDk9Pdy4GPfeqmLz5HNdvJJyr-YKyqMnvaXOay5hHUVWZQ5ev3y0mjt9AQsG3AWCagxkTthwF2NuJAtqgCS8iz45gBi39s0StrMmBzf99i82QMHkL13cyaYt2hLpWoleO_mtb9bO4j5Q2IfrzVFByHlLV5wQ_dycqZFi4SqdaXoNwihxFJKKMfVXj7YwHjKA4kEAljBM5zdYDUEqNSGS9JNDlvi4JrcJTCG-UH8QLH4bKURy0iDmAhKt5grDc0SycdNrdPrDdvvvXKWaJST9vsBCvuKlTx24Zq8S9bjceGSuUZmDUeJCvhJ6af877_WwJ-E00oMltCpoctReseDMsDBY31JkTctvBOrS9tKAW_83U3wa_SnnxWiXwxfx3Tdf5YzLG3O_8zX7or2rucHX_fNFJcVfs1evHf_8W7sRCR-XsKzZ"


               let baseURL = "https://api.myfatoorah.com"
               MFSettings.shared.configure(token: directPaymentToken, baseURL: baseURL)
               
               // you can change color and title of navigation bar
               let them = MFTheme(navigationTintColor: .white, navigationBarTintColor: .lightGray, navigationTitle: "Payment", cancelButtonTitle: "Cancel")
               MFSettings.shared.setTheme(theme: them)
        
        
        IQKeyboardManager.shared.enable = true
       if #available(iOS 13, *) {
        window?.overrideUserInterfaceStyle = .light
       }
   UIViewController.preventPageSheetPresentation

        let myId = self.getUserId()
        print(myId)
       // FirebaseApp.configure()
       // Messaging.messaging().delegate = self
       // Messaging.messaging().shouldEstablishDirectChannel = true
       // pushNotificationAdd(application: application)
        

        let notificationReceivedBlock: OSHandleNotificationReceivedBlock = { notification in
            
            print("Received Notification: \(String(describing: notification!.payload.notificationID))")
        }
        
        let notificationOpenedBlock: OSHandleNotificationActionBlock = { result in
            // This block gets called when the user reacts to a notification received
            self.updateNotification()
            let payload: OSNotificationPayload = result!.notification.payload
            if payload.additionalData != nil {
                let additionalData = payload.additionalData
                print("additionalData = \(String(describing: additionalData))")
                if additionalData?["notification"] != nil {
                    
                    if(additionalData?["notification"] as? String == "new_offer")
                    {
                        KeyConstant.user_Default.set(additionalData?["offer_id"] as? String ?? "", forKey: KeyConstant.kpush_notification_offerid)
                        KeyConstant.sharedAppDelegate.setRoot()

                       return
                    }
                    else if(additionalData?["notification"] as? String == "order")
                    {
                        if let userid = KeyConstant.user_Default.value(forKey: KeyConstant.kuserId) as? String
                        {
                            KeyConstant.user_Default.set("yes", forKey: KeyConstant.push_notification_myorder)
                            KeyConstant.sharedAppDelegate.setRoot()
                          
                            return
                        }
                    }
                }
            }
            
            //KeyConstant.sharedAppDelegate.setRoot()
           // self.setRoot()
            
            
        }
        
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
        
        // Replace 'YOUR_APP_ID' with your OneSignal App ID.0aed61eb-fd91-45a7-ba20-5fde2cc2c1d4
        //26716a06-ca71-479c-8331-b247dda4e98c old and lenzzo appid
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: "0aed61eb-fd91-45a7-ba20-5fde2cc2c1d4",
                                        handleNotificationReceived: notificationReceivedBlock,
                                        handleNotificationAction: notificationOpenedBlock ,
                                        settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        
        // Recommend moving the below line to prompt for push after informing the user about
        //   how your app will use them.
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
        
        OneSignal.add(self as OSPermissionObserver)
        OneSignal.add(self as OSSubscriptionObserver)
        self.setRoot()
       
        
        // Need to set currncy for now use static currency
        KeyConstant.user_Default.setValue("KWD", forKey: KeyConstant.kSelectedCurrency)
        
//        for family in UIFont.familyNames {
//            print("\(family)")
//
//            for name in UIFont.fontNames(forFamilyName: family) {
//                print("   \(name)")
//            }
//        }
        
        
        return true
    }
    
    

    
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
           if let url = userActivity.webpageURL {
              print(url)
           }
        }
        return false
    }
    
  
    
    func setStatusBarColor()
    {
                
        if #available(iOS 13.0, *) {
            let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
            statusBar.backgroundColor = AppColors.themeColor
             UIApplication.shared.keyWindow?.addSubview(statusBar)
               
            
            
        } else {
            
             if let statusbar = UIApplication.shared.value(forKey: "statusBar") as? UIView {
                       statusbar.backgroundColor = AppColors.themeColor
                   }
            
        }
    }
    
    
    func getUserId()->String
    {
        if let userId = KeyConstant.user_Default.value(forKey: KeyConstant.kuserId) as? String
        {
            return userId
        }
            
        else if let checkoutGuestId = KeyConstant.user_Default.value(forKey: KeyConstant.kCheckoutGuestId) as? String
        {
            return checkoutGuestId
            
        }
        else if let seesionTempId = KeyConstant.user_Default.value(forKey: KeyConstant.kUserSessionTempId) as? String
        {
            return seesionTempId

        }
        else
        {
            let uDID = KeyConstant.deviceUUID
            KeyConstant.user_Default.set(uDID, forKey: KeyConstant.kUserSessionTempId)
           // KeyConstant.user_Default.set("", forKey: KeyConstant.kuserId)

            return String(uDID)

        }
    }
    
    func pushBrands()
    {
        let objHome = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BrandsListVC")
    }
    
  
    
    func showFilterScreen(vc:UIViewController)
    {
        let filterVC = vc.storyboard?.instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
        
        vc.present(filterVC, animated: false, completion: nil)
    }
    func showCountryScreen(vc:UIViewController)
    {
        let countryVC = vc.storyboard?.instantiateViewController(withIdentifier: "CountryListVC") as! CountryListVC
        vc.present(countryVC, animated: false, completion: nil)
    }
    func showCartScreen(vc:UIViewController)
    {
        let countryVC = vc.storyboard?.instantiateViewController(withIdentifier: "MyCartVC") as! MyCartVC
        vc.present(countryVC, animated: false, completion: nil)
    }
    
  
    func showSearchScreen(vc:UIViewController)
    {
        let searchProductVC = vc.storyboard?.instantiateViewController(withIdentifier: "SearchProductVC") as! SearchProductVC
        searchProductVC.modalPresentationStyle = .overCurrentContext
        vc.present(searchProductVC, animated: false, completion: nil)
    }
    
    func setInitialRootToPlayVideo(){
        let objHome = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
        navCon = UINavigationController(rootViewController: objHome)
        navCon!.isNavigationBarHidden = true
        window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = navCon
        self.window?.makeKeyAndVisible()
    }

    func setRoot()
    {
        //var slideMenuController : SlideMenuController!
                    self.guestDeviceTokenUpdate()

                    
//                    let objLeft = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LeftMenuVC") as! LeftMenuVC
//                    if((UserDefaults.standard.array(forKey: "AppleLanguages")?.first as?
//                        String) == "ar")
//                    {
//                         slideMenuController = SlideMenuController(mainViewController: objHome, rightMenuViewController: objLeft)
//
//
//                    }
//                    else{
//
//                         slideMenuController = SlideMenuController(mainViewController: objHome, leftMenuViewController: objLeft)
//                    }
        
                    let objHome = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeTabBarController") as! HomeTabBarController
                    navCon = UINavigationController(rootViewController: objHome)
                    navCon!.isNavigationBarHidden = true
                    window = UIWindow(frame: UIScreen.main.bounds)
                    self.window?.rootViewController = navCon
                    self.window?.makeKeyAndVisible()
                

                
        
        //ArgAppUpdater.getSingleton().showUpdateWithConfirmation()
        //ArgAppUpdater.getSingleton().showUpdateWithForce()

        
    }
  
    func updateNotification()
    {
        WebServiceHelper.sharedInstanceAPI.hitPostAPI(urlString: KeyConstant.notification_update, params: ["device_id":KeyConstant.user_Default.value(forKey: KeyConstant.kDeviceToken) as? String ?? ""], completionHandler: { (result: [String:Any], err:Error?) in
        })
    }
    
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if let scheme = url.scheme,
            scheme.localizedCaseInsensitiveCompare("com.Lenzzo") == .orderedSame,
            let view = url.host {
            var parameters: [String: String] = [:]
            URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.forEach {
                parameters[$0.name] = $0.value
                
            }
            print(url.scheme,url.host,parameters)
            //com.Lenzzo://product?id=%@&name=%@
            if(url.host == "product")
            {
            if let productID = parameters["id"]
            {
                if(productID.count > 0)
                {
                    let detailsVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC
                    detailsVC.productId = productID
                    self.window?.rootViewController?.present(detailsVC, animated: false, completion: nil)
                }
            }
            }
        }
        return true
    }
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name("applicationWillEnterForeground"), object: nil)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        application.applicationIconBadgeNumber = 0

    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "LENZZO")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func showAlertView(vc : UIViewController, titleString : String , messageString: String) ->()
    {
        let alertView = UIAlertController(title: titleString.uppercased(), message: messageString, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: NSLocalizedString("MSG18", comment: ""), style: .default) { (alert) in
            
            
        }
        alertAction.setValue(AppColors.SelcetedColor, forKey: "titleTextColor")

        alertView.addAction(alertAction)
        let msgFont = [NSAttributedString.Key.font: UIFont(name: FontLocalization.medium.strValue, size: 15.0)!]
        let msgAttrString = NSMutableAttributedString(string: messageString, attributes: msgFont)
        alertView.setValue(msgAttrString, forKey: "attributedMessage")
        alertView.view.tintColor = UIColor.black
        alertView.view.layer.cornerRadius = 40
        alertView.view.backgroundColor = UIColor.white
        vc.present(alertView, animated: true, completion: nil)
        
    }
    
    func showAlertViewWithTextField(vc : UIViewController, titleString : String , messageString: String, textField:UITextField) ->()
    {
        let alertView = UIAlertController(title: titleString.uppercased(), message: messageString, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: NSLocalizedString("MSG18", comment: ""), style: .default) { (alert) in

            textField.becomeFirstResponder()
        }
        alertAction.setValue(AppColors.SelcetedColor, forKey: "titleTextColor")

        alertView.addAction(alertAction)
//        let imageView = UIImageView(frame: CGRect(x: UIScreen.main.bounds.width / 3.5, y: 3, width: 50, height: 20))
//        imageView.image = UIImage(named:"logo")
//        imageView.contentMode = .scaleAspectFit
//        alertView.view.addSubview(imageView)
//
        let msgFont = [NSAttributedString.Key.font: UIFont(name: FontLocalization.medium.strValue, size: 15.0)!]
        let msgAttrString = NSMutableAttributedString(string: messageString, attributes: msgFont)
        alertView.setValue(msgAttrString, forKey: "attributedMessage")
        alertView.view.tintColor = UIColor.black
        alertView.view.layer.cornerRadius = 40
        alertView.view.backgroundColor = UIColor.white
        vc.present(alertView, animated: true, completion: nil)
        
    }
}

extension AppDelegate:MessagingDelegate,UNUserNotificationCenterDelegate{
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
      print("Firebase registration token: \(fcmToken)")

      let dataDict:[String: String] = ["token": fcmToken]
      NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        
      //  self.xd.saveSetting(name: "FCMToken", value: fcmToken)
        
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    
    
    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        Messaging.messaging().apnsToken = deviceToken as Data
    }
    
    
    
    
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
//      // If you are receiving a notification message while your app is in the background,
//      // this callback will not be fired till the user taps on the notification launching the application.
//      // TODO: Handle data of notification
//
//      // With swizzling disabled you must let Messaging know about the message, for Analytics
//      // Messaging.messaging().appDidReceiveMessage(userInfo)
//
//      // Print message ID.
//      if let messageID = userInfo[gcmMessageIDKey] {
//        print("Message ID: \(messageID)")
//      }
//
//      // Print full message.
//      print(userInfo)
//    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification

      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)

      // Print message ID.
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }

      // Print full message.
      print(userInfo)

      completionHandler(UIBackgroundFetchResult.newData)
    }
    
    // This method will be called when app received push notifications in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.alert, .badge, .sound])
    }
    
}




extension AppDelegate{
    
    
    func pushNotificationAdd(application:UIApplication)
    {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
    }

//
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
//
//        if(fcmToken.count > 0)
//        {
//        print("Firebase registration token: \(fcmToken)")
//
//                KeyConstant.user_Default.set(fcmToken, forKey: KeyConstant.kDeviceToken)
//                    self.guestDeviceTokenUpdate()
//
//
//
//        }
//
//
//
//    }
    
    
//    func application(application: UIApplication,
//                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
//      //  Messaging.messaging().apnsToken = deviceToken as Data
//    }
//
//
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
//                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//
//
//
//        if application.applicationState == .active
//        {
//            let userAPS = userInfo["aps"] as? [String:AnyObject]
//            if let userMessage = userAPS?["alert"] as? [String:AnyObject]
//            {
//                self.showAlertView(vc: window!.rootViewController!, titleString: userMessage["title"] as? String ?? "", messageString: userMessage["body"] as? String ?? "")
//            }
//        }
//        else
//        {
//            if(userInfo.count > 0)
//            {
//            if let notificationType = userInfo["gcm.notification.notification_type"] as? String
//            {
//                if(notificationType == "new_offer")
//                {
//                    let brandVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OffersHomeVC") as! OffersHomeVC
//                    self.window?.rootViewController?.present(brandVC, animated: false, completion: nil)
//                    return
//                }
//                else if(notificationType == "order")
//                {
//                    if let userid = KeyConstant.user_Default.value(forKey: KeyConstant.kuserId) as? String
//                    {
//                    let brandVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderHistoryVC") as! OrderHistoryVC
//                    self.window?.rootViewController?.present(brandVC, animated: false, completion: nil)
//                    return
//                    }
//                }
//            }
//            }
//            KeyConstant.sharedAppDelegate.setRoot()
//
//        }
//
//        completionHandler(UIBackgroundFetchResult.newData)
//    }
    
    func guestDeviceTokenUpdate()
    {
        
        let isGuestUpdateDevice = KeyConstant.user_Default.value(forKey: KeyConstant.kGuestSaveDeviceID) as? String ?? ""
        if(isGuestUpdateDevice.count == 0)
        {
        
        // "guestID":KeyConstant.user_Default.value(forKey: KeyConstant.kUserSessionTempId) as? String ?? ""
        WebServiceHelper.sharedInstanceAPI.hitPostAPI(urlString: KeyConstant.APIUpdateDeviceToken, params: ["device_id":KeyConstant.user_Default.value(forKey: KeyConstant.kDeviceToken) as? String ?? "","guestid":KeyConstant.user_Default.value(forKey: KeyConstant.kUserSessionTempId) as? String ?? ""], completionHandler: { (result: [String:Any], err:Error?) in
            print(result)
            KeyConstant.user_Default.set("yes", forKey: KeyConstant.kGuestSaveDeviceID)

            
        })
        }
        
    }
}
extension AppDelegate

{
    
    
    func getOneSingnalCall()
    {
    }
    func onOSSubscriptionChanged(_ stateChanges: OSSubscriptionStateChanges!) {
        if !stateChanges.from.subscribed && stateChanges.to.subscribed {
            print("Subscribed for OneSignal push notifications!")
            // get player ID
            //            stateChanges.to.pushToken
            //            stateChanges.to.userId
            if(stateChanges.to.userId.count > 0)
            {
                print(" registration token: \(stateChanges.to.userId)")
                
                KeyConstant.user_Default.set(stateChanges.to.userId, forKey: KeyConstant.kDeviceToken)
                self.guestDeviceTokenUpdate()
                
                
                
            }
            
        }
        print("SubscriptionStateChange: \n\(stateChanges)")
    }
    func onOSPermissionChanged(_ stateChanges: OSPermissionStateChanges!) {
        
        // Example of detecting answering the permission prompt
        if stateChanges.from.status == OSNotificationPermission.notDetermined {
            if stateChanges.to.status == OSNotificationPermission.authorized {
                print("Thanks for accepting notifications!")
            } else if stateChanges.to.status == OSNotificationPermission.denied {
                print("Notifications not accepted. You can turn them on later under your iOS settings.")
            }
        }
        // prints out all properties
        print("PermissionStateChanges: \n\(stateChanges)")
    }
    
}
