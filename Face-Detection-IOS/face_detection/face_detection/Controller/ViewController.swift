//
//  ViewController.swift
//  face_detection
//
//  Created by Yuhan Tang
//

import UIKit

class ViewController: UIViewController, FrameExtractorDelegate {
//    var viewController : NewViewController?
    
    @IBOutlet var imageview: UIImageView!
    var frameExtractor: FrameExtractor!
    @IBOutlet var imageView1: UIImageView!
    
    func captured(image: UIImage) {
        self.imageView1 = UIImageView(frame: CGRect(x: 0, y: 150, width: 375, height: 460));
        self.view.addSubview(imageView1);
        
        imageView1.image = OpencvWrapper.detect(image);
        
        var xv = Int(OpencvWrapper.xValue());
        var yv = Int(OpencvWrapper.yValue());
        if(xv > 255){
            xv = 255;
        }
        if(yv > 380){
            yv = 380;
        }
        let rn = OpencvWrapper.returnName();
//        NSLog("%d xv", xv)
//        NSLog("%d yv", yv)
        
        // 注意规范一下边界，别溢出
        let rect = CGRect(x: xv, y: yv, width: 120, height: 80)
        let label = UILabel(frame: rect)
        label.text = rn
        let font = UIFont(name: "Arial", size: 30)
        label.font = font
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.yellow
        imageView1.addSubview(label)
        //imageview.image = OpencvWrapper.detect(image);
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        frameExtractor = FrameExtractor()
        frameExtractor.delegate = self
        
        let button = UIButton(frame: CGRect(x: 125, y: 700, width: 125, height: 40))
        button.setTitle("返回", for: UIControlState())
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor.brown
//        flip_camera(button)
        button.addTarget(self, action: #selector(ViewController.dismissSelf), for: .touchUpInside)
        self.view.addSubview(button)
        
        let button2 = UIButton(frame: CGRect(x: 125, y: 640, width: 125, height: 40))
        button2.setTitle("切换镜头", for: UIControlState())
        button2.backgroundColor = UIColor.black
        button2.setTitleColor(UIColor.white, for: UIControlState.normal)
        button2.addTarget(self, action: #selector(ViewController.flip_camera1), for: .touchUpInside)
        self.view.addSubview(button2)
    }
    
    @objc func dismissSelf()
    {
        self.dismiss(animated: false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func flip_camera(_ sender: UIButton) {
        frameExtractor.flipCamera()
    }
    
    @objc func flip_camera1() {
        frameExtractor.flipCamera()
    }
    
}


