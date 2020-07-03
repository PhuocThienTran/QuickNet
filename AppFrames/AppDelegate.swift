//
//  AppDelegate.swift
//  QuickNet
//
//  Created by DTran on 11/18/19.
//  Copyright © 2019 TPT. All rights reserved.
//

import UIKit
import Network
import Network
import Foundation
import CoreData


let apiKey = "a3sAoP0LddaudGCuZ16FuwJCYnnXbeKu"
let appDelegate = UIApplication.shared.delegate as! AppDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var sudoku: sudokuClass = sudokuClass()
    var load: sudokuData?
    
    let monitor = NWPathMonitor()
    
    var weatherResponses = [WeatherResponse]()
    var modeCitys = [ModeSearchCity]()
    
    var restrictRotation: TypeInterfaceOrientationMask = .portrait
    
    // ---------[ getPuzzles ]---------------------
    func getPuzzles(_ name : String) -> [String] {
        guard let url = Bundle.main.url(forResource: name, withExtension: "plist") else { return [] }
        guard let data = try? Data(contentsOf: url) else { return [] }
        guard let array = try? PropertyListDecoder().decode([String].self, from: data) else { return [] }
        return array
    }
    // ---------

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        
        self.weatherResponses = UserDefaults.standard.locationArray(WeatherResponse.self, forKey: "weatherResponses")
        self.modeCitys = UserDefaults.standard.locationArray(ModeSearchCity.self, forKey: "modeCitys")
        
        downloadNewsArticles()
               getSources()
               darkMode = UserDefaults.standard.integer(forKey: "darkMode")
               
               monitor.pathUpdateHandler = { path in
                   if path.status == .satisfied{
                       
                   } else {
                       self.dialogOKCancel()
                   }
               }
               
               let queue = DispatchQueue(label: "Monitor")
               monitor.start(queue: queue)
        
        return true
    }
    func downloadNewsArticles(){
           NewsService.instance.downloadNewsDetails {
               NotificationCenter.default.post(name: NOTIF_DOWNLOAD_COMPLETE, object: nil)
           }
       }
       func getSources()
       {
           NewsService.instance.downloadSourceDetails {
               NotificationCenter.default.post(name: NOTIF_DOWNLOAD_COMPLETE, object: nil)
           }
       }
       
       func dialogOKCancel(){
           let alertController = UIAlertController (title: "No Internet Connection", message: "Please turn on Mobile Data or connect to a Wi-Fi network.", preferredStyle: .alert)
           
           alertController.addAction(UIAlertAction(title: "Open Settings",
                                         style: UIAlertAction.Style.default,
                                         handler: openSettings))
           alertController.addAction(UIAlertAction(title: "Cancel",
                                         style: UIAlertAction.Style.default,
                                         handler: nil))
           
           let alertWindow = UIWindow(frame: UIScreen.main.bounds)
           
           alertWindow.rootViewController = UIViewController()
           alertWindow.windowLevel = UIWindow.Level.alert + 1;
           alertWindow.makeKeyAndVisible()
           
           alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)

       }
       
       func openSettings(alert: UIAlertAction!) {
           if let url = URL.init(string: UIApplication.openSettingsURLString) {
               UIApplication.shared.open(url, options: [:], completionHandler: nil)
           }
       }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
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
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        self.saveLocalStorage(save: sudoku.grid)

    }
    // ---------------------[ Save files ]----------------------------
    func saveLocalStorage(save: sudokuData) {
        // Use Filemanager to store Local files
        let documentsDirectory =
            FileManager.default.urls(for: .documentDirectory,
                                     in: .userDomainMask).first!
        let saveURL = documentsDirectory.appendingPathComponent("sudoku_save")
                                        .appendingPathExtension("plist")
        // Encode and save to Local Storage
        //let propertyListEncoder = PropertyListEncoder()
        let saveGame = try? PropertyListEncoder().encode(save) // TODO: error here -- notes
        try? saveGame?.write(to: saveURL)
    } // end saveLocalStorage()
    
    // ---------------------[ Load Files ]-----------------------------
    func loadLocalStorage() -> sudokuData {
        let documentsDirectory =
            FileManager.default.urls(for: .documentDirectory,
                                     in: .userDomainMask).first!
        let loadURL = documentsDirectory.appendingPathComponent("sudoku_save").appendingPathExtension("plist")
        // Decode and Load from Local Storage
        if let data = try? Data(contentsOf: loadURL) {
            let decoder = PropertyListDecoder()
            load = try? decoder.decode(sudokuData.self, from: data)
            // once loaded, delete save
            try? FileManager.default.removeItem(at: loadURL)
        }
        
        return load!
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
    switch self.restrictRotation {
    case .all:
        return .all
    case .allButUpsideDown:
        return .allButUpsideDown
    case .portrait:
        return .portrait
    case .landscape:
        return .landscape
    }
}
}
