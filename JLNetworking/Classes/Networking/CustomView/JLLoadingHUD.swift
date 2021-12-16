//
//  JLLoadingHUD.swift
//  JLNetworking
//
//  Created by Jerry on 2021/12/16.
//

import Foundation
import SnapKit

public class JLLoadingHUD {
    
    
    static private let shared = JLLoadingHUD()
    
    /// 当前显示中的指示器
    private var indicatorView: JLLoadingIndicatorView?
    
    public static func showHUD(_ view: UIView? = nil) {
        JLLoadingHUD.shared.showHUD(view)
    }
    
    public static func dismissHUD(view: UIView? = nil) {
        JLLoadingHUD.shared.dismissHUD(view: view)
    }
    
    private func showHUD(_ view: UIView?) {
        
        /// 可能存在2个window
        var window = UIApplication.shared.keyWindow
        if UIApplication.shared.windows.count > 2, let lastWindow = UIApplication.shared.windows.last {
            window = lastWindow
        }
        
        guard let superView: UIView = (view ?? window) else {
            print("父视图为nil")
            return
        }
        
        if self.indicatorView != nil {
            self.indicatorView?.removeFromSuperview()
        }
        
        
        let indicatorView = JLLoadingIndicatorView(frame: .zero)
        superView.addSubview(indicatorView)
        
        indicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        self.indicatorView = indicatorView
    }
    
    private func dismissHUD(view: UIView?) {
        self.indicatorView?.removeFromSuperview()
        self.indicatorView = nil
    }
}
