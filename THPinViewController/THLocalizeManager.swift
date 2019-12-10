//
//  THLocalizeManager.swift
//  THPinViewControllerExample
//
//  Created by Morten Hjortshøj Nielsen on 10/12/2019.
//  Copyright © 2019 Thomas Heß. All rights reserved.
//

import UIKit

@objc class THLocalizeManager: NSObject {
    @objc var titlePrompt: String = ""
    @objc var titleCancel: String = ""
    @objc var titleDelete: String = ""

    //MARK: - Singleton
    
    @objc public static let shared = THLocalizeManager()
    
    private override init() { }
    
}


//"prompt_title" = "Enter PIN";
//"cancel_button_title" = "Cancel";
//"delete_button_title" = "Delete";


