//
//  ViewController.swift
//  ADBanner
//
//  Created by Johnny Wang on 2017/9/29.
//  Copyright © 2017年 Johnny Wang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MLBannerViewBehaviorDelegate {
    @IBOutlet weak var myBanner: MLBannerView!
    
    func whenPagingComplete(currentPage: Int, currentView: UIView) {
        print("You paging to: \(currentPage)")
    }
    
    func whenTapView(currentPage: Int, currentView: UIView) {
        print("You are on tap: \(currentPage)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        myBanner.setNumberOfPages(7)
        myBanner.delegate = self
        
        for innerView in myBanner.bannerList {
            let r = CGFloat((arc4random() % 10)) / 10.0
            let g = CGFloat((arc4random() % 10)) / 10.0
            let b = CGFloat((arc4random() % 10)) / 10.0
            innerView.backgroundColor = UIColor.init(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: 1.0)
            
            let label = UILabel(frame: CGRect(origin: CGPoint.zero, size: innerView.frame.size))
            label.numberOfLines = 2
            label.textAlignment = .center
            label.font = UIFont(name: label.font.familyName, size: 30.0)
            label.text = "R:\(CGFloat(r))  G:\(CGFloat(g))  B:\(CGFloat(b)) \n (Background Color)"
            label.textColor = UIColor.white
            
            innerView.addSubview(label)
        }
        
        view.addSubview(myBanner)
        myBanner.isHiddenPageControl(false)
        
        myBanner.startAutoPaging(6.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

