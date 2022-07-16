//
//  ProgressView.swift
//  Carousel
//
//  Created by Kiroshan Thayaparan on 7/17/22.
//

import Foundation
import MBProgressHUD

// WARNING: - In the initial all launch, the background overlay
// view doesn't cover the navigation bar.
open class ProgressView {
    
    fileprivate var progressView: MBProgressHUD!
    
    open class var shared: ProgressView {
        struct Static {
            static let instance: ProgressView = ProgressView()
        }
        return Static.instance
    }
    
    /**
    Show a progress view in the given view.
    Can show a title and/or subtitle as well.
    
    - parameter view:       View to be displayed in.
    - parameter mainText:   Title.
    - parameter detailText: Subtitle.
    */
    open func show(_ view: UIView, mainText: String?, detailText: String?) {
        progressView = MBProgressHUD(view: view)
        progressView.label.text = mainText ?? ""
        progressView.label.textColor = UIColor.blue
        progressView.detailsLabel.text = detailText ?? ""
        progressView.detailsLabel.textColor = UIColor.black
        //progressView.dimBackground = true
        progressView.isSquare = true
//        progressView.color = UIColor(red: 68/255, green: 68/255, blue: 68/255, alpha: 1)
        progressView.backgroundColor = UIColor(red: 0.92, green: 0.93, blue: 0.93, alpha: 0.5)
        //progressView.contentColor = UIColor.white
        //progressView.tintColor = UIColor.gray
        view.addSubview(progressView)
        progressView.show(animated: true)
    }
    
    /**
    Hide the progress view.
    */
    open func hide() {
        if progressView != nil{
            progressView.hide(animated: true)
        }
        
    }
}
