//
//  FirstViewController.swift
//  face_detection
//
//  Created by Steven Tang on 2018/4/25.
//  Copyright © 2018年 hadri. All rights reserved.
//

import UIKit
import ILLoginKit

class FirstViewController: UIViewController {
    
    var hasShownLogin = false
    
    lazy var loginCoordinator: LoginCoordinator = {
        return LoginCoordinator(rootViewController: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard !hasShownLogin else {
            return
        }
        
        hasShownLogin = true
        loginCoordinator.start()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: - LoginViewController Delegate

extension FirstViewController: LoginViewControllerDelegate {
    
    func didSelectLogin(_ viewController: UIViewController, email: String, password: String) {
        print("DID SELECT LOGIN; EMAIL = \(email); PASSWORD = \(password)")
    }
    
    func didSelectForgotPassword(_ viewController: UIViewController) {
        print("LOGIN DID SELECT FORGOT PASSWORD")
    }
    
    func loginDidSelectBack(_ viewController: UIViewController) {
        print("LOGIN DID SELECT BACK")
    }
    
}

