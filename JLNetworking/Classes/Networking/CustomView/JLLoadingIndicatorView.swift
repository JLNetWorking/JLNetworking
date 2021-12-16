//
//  JLLoadingIndicatorView.swift
//  JLNetworking
//
//  Created by Jerry on 2021/12/16.
//

import Foundation
import SnapKit

fileprivate var _loadingText = "Loding..."
public class JLLoadingIndicatorView: UIView {

    public static var loadingText: String {
        set { _loadingText = newValue}
        get { _loadingText }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initUI() {
        
        self.layer.cornerRadius = 8
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        
        let imageView = UIImageView()
        imageView.image = UIImage.init(named: "doratoon_loading", in: JLResourceBundle.current(), compatibleWith: nil)
        
        let textLabel = UILabel()
        textLabel.text = _loadingText
        textLabel.textColor = .white
        textLabel.font = .systemFont(ofSize: 10, weight: .medium)
        
        let stackView = UIStackView(arrangedSubviews: [imageView, textLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 4
        self.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(48)
        }
        
        
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateAnimation.toValue = CGFloat.pi * 2
        rotateAnimation.duration = 1
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.repeatCount = .greatestFiniteMagnitude
        imageView.layer.add(rotateAnimation, forKey: "rotateAnimation")
        
    }
 
    public override var intrinsicContentSize: CGSize {
        return .init(width: 80, height: 88)
    }
}
