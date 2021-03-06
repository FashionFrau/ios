//
//  AppDelegate.swift
//  fashionfrau
//
//  Created by Nilson Junior on 09/04/2017.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import UIKit
import AlamofireNetworkActivityIndicator
import Flurry_iOS_SDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private let apiKey = "PVHSVZGQYDYG7M43B25T"

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        setupFlurry()

        NetworkActivityIndicatorManager.shared.isEnabled = true
        NetworkActivityIndicatorManager.shared.startDelay = 1.0

        openStoryboard()

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
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    private func setupFlurry() {
        let flurrySession =  FlurrySessionBuilder()
            .withLogLevel(FlurryLogLevelDebug)
            .withCrashReporting(true)

        Flurry.startSession(apiKey, with: flurrySession)
    }


    private func openStoryboard() {
        window = UIWindow(frame: UIScreen.main.bounds)
        checkUserAlreadyLogged()
    }

    private func checkUserAlreadyLogged() {
        let service = UserService.us

        if(service.isCurrentUserValid() == true) {
            redirectToApp()

        } else {
            redirectToLogin()
        }
    }

    private func redirectToApp() {

        let stb = UIStoryboard(name: AppStoryboard, bundle: nil)

        let tab = stb.instantiateViewController(withIdentifier: "TabBarController") as! FFTabBarController

        window?.rootViewController = tab
    }

    private func redirectToLogin() {

        let stb = UIStoryboard(name: LoginStoryboard, bundle: nil)

        let loginController = stb.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController

        window?.rootViewController = loginController
    }
}
