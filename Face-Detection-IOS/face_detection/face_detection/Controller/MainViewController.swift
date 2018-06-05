//
//  MainViewController.swift
//  face_detection
//
//  Created by Steven Tang on 2018/4/6.
//  Copyright © 2018年 hadri. All rights reserved.
//

import UIKit
import ILLoginKit

class MainViewController: UIViewController {

//    var label:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.white
        //        label = UILabel(frame: CGRect(x: 60, y: 100, width: 240, height: 44))
        //        label.text = ""
        //        self.view.addSubview(label)
        
        let button = UIButton(frame: CGRect(x: 120, y: 250, width: 135, height: 135))
        button.layer.cornerRadius = button.frame.width / 2
        button.setTitle("开始识别", for: UIControlState())
        button.backgroundColor = UIColor.brown
        button.addTarget(self, action: #selector(MainViewController.openViewController), for: .touchUpInside)
        self.view.addSubview(button)
        
        let button1 = UIButton(frame: CGRect(x: 120, y: 450, width: 135, height: 135))
        button1.layer.cornerRadius = button1.frame.width / 2
        button1.setTitle("添加到人脸库", for: UIControlState())
        button1.backgroundColor = UIColor.brown
        button1.addTarget(self, action: #selector(MainViewController.openAddFaceViewController), for: .touchUpInside)
        self.view.addSubview(button1)
        
        let button2 = UIButton(frame: CGRect(x: 80, y: 630, width: 100, height: 100))
        button2.layer.cornerRadius = button2.frame.width / 2
        button2.setTitle("登陆", for: UIControlState())
        button2.backgroundColor = UIColor.brown
        button2.addTarget(self, action: #selector(MainViewController.openFirstViewController), for: .touchUpInside)
        self.view.addSubview(button2)
        
        let button3 = UIButton(frame: CGRect(x: 180, y: 630, width: 100, height: 100))
        button3.layer.cornerRadius = button3.frame.width / 2
        button3.setTitle("AR", for: UIControlState())
        button3.backgroundColor = UIColor.brown
        button3.addTarget(self, action: #selector(MainViewController.openARViewController), for: .touchUpInside)
        self.view.addSubview(button3)
        
        let button4 = UIButton(frame: CGRect(x: 280, y: 630, width: 100, height: 100))
        button4.layer.cornerRadius = button4.frame.width / 2
        button4.setTitle("AR Face", for: UIControlState())
        button4.backgroundColor = UIColor.brown
        button4.addTarget(self, action: #selector(MainViewController.openARFaceViewController), for: .touchUpInside)
        self.view.addSubview(button4)
    }
    
    @objc func openARFaceViewController()
    {
        let newViewController = ARFaceViewController()
        self.present(newViewController, animated: false, completion: nil)
    }
    
    @objc func openARViewController()
    {
        let newViewController = ARViewController()
        self.present(newViewController, animated: false, completion: nil)
    }
    
    @objc func openViewController()
    {
        let newViewController = ViewController()
        self.present(newViewController, animated: false, completion: nil)
    }
    
    @objc func openAddFaceViewController()
    {
        let newViewController = FCSearchViewController()
        self.present(newViewController, animated: false, completion: nil)
    }
    
    @objc func openFirstViewController()
    {
        let newViewController = FirstViewController()
        self.present(newViewController, animated: false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
