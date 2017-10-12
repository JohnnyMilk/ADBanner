//
//  MLBannerView.swift
//  ADBanner
//
//  Created by Johnny Wang on 2017/9/29.
//  Copyright © 2017年 Johnny Wang. All rights reserved.
//

import Foundation
import UIKit

protocol MLBannerViewBehaviorDelegate {
    func whenPagingComplete(currentPage: Int, currentView: UIView)
    func whenTapView(currentPage: Int, currentView: UIView)
}

// Let keeps protocol optional.
extension MLBannerViewBehaviorDelegate {
    func whenPagingComplete(currentPage: Int, currentView: UIView) {}
}

class MLBannerView: UIView, UIScrollViewDelegate {
    private var scrollView = UIScrollView()
    private var pageControl = UIPageControl()
    private var timer = Timer()
    var bannerList = [UIView]()
    var delegate: MLBannerViewBehaviorDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initTemplateMethod()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initTemplateMethod()
    }
    
    private func initTemplateMethod() {
        addSubview(scrollView)
        scrollViewSetting()
        addSubview(pageControl)
        pageControlSetting()
        bannerListSetting()
        tapGestureRecognizerSetting()
    }
    
    private func scrollViewSetting() {
        scrollView.delegate = self
        scrollView.frame = CGRect(x: 0.0, y: 0.0, width: frame.width, height: frame.height)
        scrollView.scrollsToTop = false
        scrollView.isPagingEnabled = true
        scrollView.alwaysBounceVertical = false
        scrollView.isDirectionalLockEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isUserInteractionEnabled = true
    }
    
    private func pageControlSetting() {
        pageControl.currentPage = 0
        pageControl.numberOfPages = 1
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        setNeedsLayout()
    }
    
    private func bannerListSetting() {
        bannerList.removeAll()
        let width = scrollView.frame.size.width
        let height = scrollView.frame.size.height
        for page in 0...pageControl.numberOfPages - 1 {
            let innerView = UIView(frame: CGRect(x: width*CGFloat(page), y: 0.0, width: width, height: height))
            bannerList.append(innerView)
            scrollView.addSubview(bannerList[page])
        }
        
        scrollView.contentSize = CGSize(width: width*CGFloat(pageControl.numberOfPages), height: height)
    }
    
    private func tapGestureRecognizerSetting() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.whenTap))
        tapGestureRecognizer.numberOfTouchesRequired = 1
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func setNumberOfPages(_ pages: Int) {
        removeAllSubviews()
        pageControl.numberOfPages = pages
        bannerListSetting()
    }
    
    private func removeAllSubviews() {
        for innerView in bannerList {
            innerView.removeFromSuperview()
        }
    }
    
    @objc private func whenTap() {
        let currentPage = pageControl.currentPage
        delegate?.whenTapView(currentPage:currentPage, currentView: bannerList[currentPage])
    }
    
    func startAutoPaging(_ second: Double) {
        timer = Timer.scheduledTimer(timeInterval: second, target: self, selector: #selector(self.paging), userInfo: nil, repeats: true)
    }
    
    func stopAutoPaging() {
        timer.invalidate()
    }
    
    @objc private func paging() {
        let page = pageControl.currentPage
        let currentPage = (page + 1 >= pageControl.numberOfPages) ? 0 : page + 1
        
        let width = scrollView.frame.size.width
        let height = scrollView.frame.size.height
        let destination = CGRect(x: width*CGFloat(currentPage), y: 0.0, width: width, height: height)
        
       scrollView.scrollRectToVisible(destination, animated: true)
    }
    
    func isHiddenPageControl(_ b: Bool) {
        pageControl.isHidden = b
    }
    
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: 0.0)
        
        let width = scrollView.frame.size.width
        let currentPage = Int(((scrollView.contentOffset.x - width / 2) / width) + 1)
        pageControl.currentPage = currentPage
        
        if scrollView.contentOffset.x.truncatingRemainder(dividingBy: self.frame.width) == 0 {
            delegate?.whenPagingComplete(currentPage:currentPage, currentView: bannerList[currentPage])
        }
    }

}
