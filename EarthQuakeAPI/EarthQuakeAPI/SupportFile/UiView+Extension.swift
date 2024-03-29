//
//  UiView+Extension.swift
//  EarthQuakeAPI
//
//  Created by Boss on 6/26/19.
//  Copyright © 2019 Boss. All rights reserved.
//

import UIKit

protocol ViewProtocol {
    var cornerRadius: CGFloat {get set}
    var topBorder: Bool {get set}
    var leftBorder: Bool {get set}
    var rightBorder: Bool {get set}
    var bottomBorder: Bool {get set}
    var borderColor: UIColor? {get set}
    var lineWeight: CGFloat {get set}
    func rounderCorner(radius: CGFloat)
    func addBorder(layerNameKey: LayerNameKey, color: UIColor?, lineWeight: CGFloat)
}

extension ViewProtocol {
    func doingAfterLayoutSubview() {
        rounderCorner(radius: cornerRadius)
        if topBorder {
            addBorder(layerNameKey: LayerNameKey.topBorder, color: borderColor, lineWeight: lineWeight)
        }
        if leftBorder {
            addBorder(layerNameKey: LayerNameKey.leftBorder, color: borderColor, lineWeight: lineWeight)
        }
        if rightBorder {
            addBorder(layerNameKey: LayerNameKey.rightBorder, color: borderColor, lineWeight: lineWeight)
        }
        if bottomBorder {
            addBorder(layerNameKey: LayerNameKey.bottomBorder, color: borderColor, lineWeight: lineWeight)
        }
    }
}

@IBDesignable
class ImageView: UIImageView {
    @IBInspectable var cornerRadius: CGFloat = 0
    override func layoutSubviews() {
        super.layoutSubviews()
        rounderCorner(radius: cornerRadius)
    }
}

@IBDesignable
class View: UIView, ViewProtocol {
    @IBInspectable var cornerRadius: CGFloat = 0
    @IBInspectable var lineWeight: CGFloat = 1
    @IBInspectable var topBorder: Bool = false
    @IBInspectable var leftBorder: Bool = false
    @IBInspectable var rightBorder: Bool = false
    @IBInspectable var bottomBorder: Bool = false
    override func layoutSubviews() {
        super.layoutSubviews()
        doingAfterLayoutSubview()
    }
}

@IBDesignable
class Button: UIButton, ViewProtocol {
    @IBInspectable var cornerRadius: CGFloat = 0
    @IBInspectable var lineWeight: CGFloat = 1
    @IBInspectable var topBorder: Bool = false
    @IBInspectable var leftBorder: Bool = false
    @IBInspectable var rightBorder: Bool = false
    @IBInspectable var bottomBorder: Bool = false
    override func layoutSubviews() {
        super.layoutSubviews()
        doingAfterLayoutSubview()
        
    }
}
@IBDesignable
class Label: UILabel, ViewProtocol {
    @IBInspectable var cornerRadius: CGFloat = 0
    @IBInspectable var lineWeight: CGFloat = 1
    @IBInspectable var topBorder: Bool = false
    @IBInspectable var leftBorder: Bool = false
    @IBInspectable var rightBorder: Bool = false
    @IBInspectable var bottomBorder: Bool = false
    override func layoutSubviews() {
        super.layoutSubviews()
        doingAfterLayoutSubview()
    }
}

@IBDesignable
class TextField: UITextField, ViewProtocol {
    @IBInspectable var cornerRadius: CGFloat = 0
    @IBInspectable var lineWeight: CGFloat = 1
    @IBInspectable var topBorder: Bool = false
    @IBInspectable var leftBorder: Bool = false
    @IBInspectable var rightBorder: Bool = false
    @IBInspectable var bottomBorder: Bool = false
    override func layoutSubviews() {
        super.layoutSubviews()
        doingAfterLayoutSubview()
    }
}

// MARK: - Height for View with text
extension UIView {
    func heightForView(text: String, font: UIFont, width: CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        
        return label.frame.height
    }
}

// MARK: - Load Nib
extension UIView {
    static func loadNib<T: UIView>(_ viewType: T.Type) -> T {
        let className = String(describing: viewType)
        
        return Bundle(for: viewType).loadNibNamed(className, owner: nil, options: nil)!.first as! T
    }
    
    static func loadNib() -> Self {
        return loadNib(self)
    }
}


// MARK: - Attribute
extension UIView {
    
    func rounderCorner(radius: CGFloat) {
        if radius == -1 {
            layer.cornerRadius = frame.width < frame.height ? frame.width * 0.5 : frame.height * 0.5
        } else {
            layer.cornerRadius = radius
        }
        contentMode = .scaleToFill
        layer.masksToBounds = true
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}

// MARK: - Animation
extension UIView {
    func animate(animations: ((Bool) -> ())? = nil) {
        UIView.animate(withDuration: 0.2, animations: {
            self.layer.transform = CATransform3DMakeScale(1.25, 1.25, 1);
        }, completion: { (completed) in
            UIView.animate(withDuration: 0.2, animations: {
                self.layer.transform = CATransform3DMakeScale(1, 1, 1);
            }, completion: { (completed) in
                animations?(completed)
            })
        })
        
    }
    func animateToSmaller(animations: @escaping (Bool) -> ()) {
        UIView.animate(withDuration: 0.2, animations: {
            self.layer.transform = CATransform3DMakeScale(0.75, 0.75, 1);
        }, completion: { (completed) in
            UIView.animate(withDuration: 0.2, animations: {
                self.layer.transform = CATransform3DMakeScale(1, 1, 1);
            }, completion: { (completed) in
                animations(completed)
            })
        })
        
    }
    func rotate(angle: CGFloat) {
        //        let radians = angle / 180.0 * CGFloat(Double.pi)
        let rotation = transform.rotated(by: angle)
        transform = rotation
    }
    
    func roundAndRound(duration: CFTimeInterval = 5.0) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(.pi * 2.0)
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount = .greatestFiniteMagnitude
        self.layer.add(rotateAnimation, forKey: nil)
    }
    
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        
        self.layer.add(animation, forKey: nil)
    }
    func fadeTransition(_ duration: CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
    func shake() {
        backgroundColor = UIColor.orange
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
    
    func resetAfterShake() {
        backgroundColor = UIColor.white
    }
}

// MARK: - Border 4 edges
enum LayerNameKey : String {
    case topBorder = "top-border"
    case bottomBorder = "bottom-border"
    case leftBorder = "left-border"
    case rightBorder = "right-boder"
    
    func getRect(with layer: CALayer, lineWeight: CGFloat) -> CGRect {
        switch self {
        case .topBorder:
            return  CGRect(x: 0, y: 0, width: layer.frame.width, height: lineWeight)
        case .bottomBorder:
            return CGRect(x: 0, y: layer.frame.height - lineWeight, width: layer.frame.width, height: lineWeight)
        case .leftBorder:
            return CGRect(x: 0, y: 0, width: lineWeight, height: layer.frame.height)
        case .rightBorder:
            return CGRect(x: layer.frame.width - lineWeight, y: 0, width: lineWeight, height: layer.frame.height)
        }
    }
}


extension UIView {
    func addBorder(layerNameKey: LayerNameKey, color: UIColor? = nil, lineWeight: CGFloat = 1) {
        // add top border
        let border = UIView(frame: layerNameKey.getRect(with: layer, lineWeight: lineWeight))
        border.layer.name = layerNameKey.rawValue
        border.backgroundColor = color ?? UIColor.groupTableViewBackground
        layer.setValue(border, forKey: layerNameKey.rawValue)
        addSubview(border)
    }
    
    func removeBorderLayer(layerNameKey: LayerNameKey) {
        if let border = layer.value(forKey: layerNameKey.rawValue) as? UIView {
            border.removeFromSuperview()
            layer.setValue(nil, forKey: layerNameKey.rawValue)
        }
    }
}

// MARK: - Constraint
extension UIView {
    
    func fill(left: CGFloat? = 0, top: CGFloat? = 0, right: CGFloat? = 0, bottom: CGFloat? = 0) {
        guard let superview = superview else {
            print("\(self.description): there is no superView")
            return
        }
        self.translatesAutoresizingMaskIntoConstraints = false
        if let left = left {
            self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: left).isActive = true
        }
        if let top = top  {
            self.topAnchor.constraint(equalTo: superview.topAnchor, constant: top).isActive = true
        }
        
        if let right = right {
            self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -right).isActive = true
        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -bottom).isActive = true
        }
    }
    
    func alignCenter(deltaPoint: CGPoint = .zero) {
        guard let superview = superview else {
            print("\(self.description): there is no superView")
            return
        }
        self.translatesAutoresizingMaskIntoConstraints = false
        self.centerXAnchor.constraint(equalTo: superview.centerXAnchor, constant: deltaPoint.x).isActive = true
        self.centerYAnchor.constraint(equalTo: superview.centerYAnchor, constant: deltaPoint.y).isActive = true
    }
}
