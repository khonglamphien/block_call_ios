//
//  SKUIView+Extension.swift
//  SaleKit
//
//  Created by Nguyen Anh on 05/07/2021.
//

import Foundation
import UIKit

// swiftlint:disable force_cast
extension UIView {
    func getTableViewCell() -> UITableViewCell? {
        
        var superView: UIView? = self.superview
        while superView != nil {
            if superView?.isKind(of: UITableViewCell.self) == true {
                return (superView as! UITableViewCell)
            }
            superView = superView?.superview
        }
        
        return nil
    }
    
    func getCollectionViewCell() -> UICollectionViewCell? {
        
        var superView: UIView? = self.superview
        while superView != nil {
            if superView?.isKind(of: UICollectionViewCell.self) == true {
                return (superView as! UICollectionViewCell)
            }
            superView = superView?.superview
        }
        return nil
    }
}

// swiftlint:disable identifier_name
extension UIView {
    
    var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            self.frame.origin.x = newValue
        }
    }
    
    var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            self.frame.origin.y = newValue
        }
    }
    
    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            self.frame.size.width = newValue
        }
    }
    
    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            self.frame.size.height = newValue
        }
    }
    
    func removeAllSubviews() {
        let subviews = self.subviews
        for view in subviews {
            view.removeFromSuperview()
        }
    }
}

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            let color = UIColor.init(cgColor: layer.borderColor!)
            return color
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
            dropShadow()
        }
    }
    
    func dropShadow(shadowColor: CGColor = UIColor.black.cgColor, shadowOpacity: Float = 0.25, shadowOffset: CGSize = CGSize(width: 0, height: 4), shadowRadius: CGFloat = 4, shadowPath: CGPath? = nil) {
        let path = shadowPath ?? UIBezierPath(rect: self.bounds).cgPath
        layer.masksToBounds = false
        layer.shadowColor = shadowColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
        layer.shadowPath = path
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
}

extension UIView {
    
    func removeGradientLayer() {
        layer.sublayers?.forEach({ (layer) in
            if layer is CAGradientLayer {
                layer.removeFromSuperlayer()
            }
        })
    }
    
    func setCommonGradient(_ radius: CGFloat? = nil) {
        removeGradientLayer()
        setGradientBackground(colorTop: .white,
                              colorBottom: .black,
                              radius: radius)
    }
    
    func setGradientBackground(colorTop: UIColor, colorBottom: UIColor, radius: CGFloat? = nil) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorBottom.cgColor, colorTop.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = bounds
        if let radius = radius {
            gradientLayer.cornerRadius = radius
        }
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
}

extension UIView {
    
    @discardableResult
    func addDashedBorder(color: UIColor = .black, lineWidth: CGFloat = 2.0, cornerRadius: CGFloat = 0, parten: [NSNumber]? = [6, 3]) -> CAShapeLayer {
        let color = color.cgColor
        
        let shapeLayer: CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = parten
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: cornerRadius).cgPath
        
        self.layer.addSublayer(shapeLayer)
        return shapeLayer
    }
}

extension UIView {
    
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
        
    }
}

extension UIView: Identifier {

    /// ID View
    static var identifierView: String {
        return String(describing: self)
    }

    /// XIB
    static func xib() -> UINib? {
        return UINib(nibName: self.identifierView, bundle: nil)
    }

}
