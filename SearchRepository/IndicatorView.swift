//
//  IndicatorView.swift
//  SearchRepository
//
//  Created by seibin on 2020/08/31.
//  Copyright © 2020年 seibin. All rights reserved.
//

import UIKit

extension NSObject {
    // MARK: - Public Functions
    // http://stackoverflow.com/a/31801454
    class var className: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
    
    var className: String {
        return NSStringFromClass(type(of: self)).components(separatedBy: ".").last!
    }
}


class BaseView: UIView {
    // MARK: - Public Functions
    func addNibViewToSelf() {
        backgroundColor = .clear
        clipsToBounds = true
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.className, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        insertSubview(view, at: 0)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        let bindings = ["view": view]
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|",
                                                      options: NSLayoutFormatOptions(rawValue: 0),
                                                      metrics: nil,
                                                      views: bindings))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|",
                                                      options: NSLayoutFormatOptions(rawValue: 0),
                                                      metrics: nil,
                                                      views: bindings))
    }
}

class IndicatorView: BaseView {
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    private let tagNum = 100000;
    
    // コードから初期化はここから
    override init(frame: CGRect) {
        super.init(frame: frame)
        comminInit()
    }
    
    // Storyboard/xib から初期化はここから
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        comminInit()
    }
    
    // xibからカスタムViewを読み込んで準備する
    private func comminInit() {
        addNibViewToSelf()
        tag = tagNum
    }
    
    func showIndicator(_ view: UIView) {
        view.addSubview(self)
        indicator.startAnimating()
    }
    
    func hiddenIndicator(_ view: UIView) {
        if let viewWithTag = view.viewWithTag(tagNum) {
            viewWithTag.removeFromSuperview()
        }
        indicator.stopAnimating()
    }
}
