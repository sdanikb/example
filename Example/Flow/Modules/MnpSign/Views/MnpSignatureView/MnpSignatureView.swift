//
//  MnpSignatureView.swift
//  Kcell-Activ
//
//  Created by admin on 12/13/20.
//  Copyright © 2020 company. All rights reserved.
//

import UIKit

@objc protocol MnpSignature where Self: UIView {
    var strokeColor: UIColor { get set }
    var strokeWidth: CGFloat { get set }
    
    func clear()
    func getSignatureAsImage() -> UIImage?
    func getSignatureAsData() -> Data?
}

final class MnpSignatureView: UIView, NibOwnerLoadable, MnpSignature {

    // MARK: - Private Vars
    fileprivate var bezierPoints = [CGPoint](repeating: CGPoint(), count: 5)
    fileprivate var bezierPath = UIBezierPath()
    fileprivate var bezierCounter : Int = 0
    
    // MARK: - Public Vars
    var strokeColor: UIColor = Colors.secondary ?? .black
    var strokeWidth: CGFloat = 2.0 {
        didSet { bezierPath.lineWidth = strokeWidth }
    }
    
    private var isSigned: Bool = false
    
    // MARK: - Initializers
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateColors()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        loadNibContent()
        self.backgroundColor = UIColor.clear
        bezierPath.lineWidth = strokeWidth
        addLongPressGesture()
        updateColors()
    }

    private func updateColors() {
//        backgroundColor = Colors.white
    }
    
    override func draw(_ rect: CGRect) {
        bezierPath.stroke()
        strokeColor.setStroke()
        bezierPath.stroke()
    }
}

// MARK: - Touch Functions
extension MnpSignatureView {
    private func addLongPressGesture() {
        //Long press gesture is used to keep clear dots in the canvas
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(MnpSignatureView.longPressed(_:)))
        longPressGesture.minimumPressDuration = 1.5
        self.addGestureRecognizer(longPressGesture)
    }
    
    @objc func longPressed(_ gesture: UILongPressGestureRecognizer) {
        let touchPoint = gesture.location(in: self)
        let endAngle: CGFloat = .pi * 2.0
        bezierPath.move(to: touchPoint)
        bezierPath.addArc(withCenter: touchPoint, radius: 2, startAngle: 0, endAngle: endAngle, clockwise: true)
        setNeedsDisplay()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let currentPoint = touchPoint(touches) {
            isSigned = true
            bezierPoints[0] = currentPoint
            bezierCounter = 0
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let currentPoint = touchPoint(touches) {
            bezierCounter += 1
            bezierPoints[bezierCounter] = currentPoint

            //Smoothing is done by Bezier Equations where curves are calculated based on four concurrent  points drawn
            if bezierCounter == 4 {
                bezierPoints[3] = CGPoint(x: (bezierPoints[2].x + bezierPoints[4].x) / 2 , y: (bezierPoints[2].y + bezierPoints[4].y) / 2)
                bezierPath.move(to: bezierPoints[0])
                bezierPath.addCurve(to: bezierPoints[3], controlPoint1: bezierPoints[1], controlPoint2: bezierPoints[2])
                setNeedsDisplay()
                bezierPoints[0] = bezierPoints[3]
                bezierPoints[1] = bezierPoints[4]
                bezierCounter = 1
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        bezierCounter = 0
    }
    
    private func touchPoint(_ touches: Set<UITouch>) -> CGPoint? {
        if let touch = touches.first {
            return touch.location(in: self)
        }
        return nil
    }
    
}

//MARK: Utility Methods
extension MnpSignatureView {
    func clear() {
        isSigned = false
        bezierPath.removeAllPoints()
        setNeedsDisplay()
    }
    
    func getSignatureAsImage() -> UIImage? {
        if isSigned {
            UIGraphicsBeginImageContext(CGSize(width: self.bounds.size.width, height: self.bounds.size.height))
            self.layer.render(in: UIGraphicsGetCurrentContext()!)
            let signature: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            return signature
        }
        return nil
    }
    
    func getSignatureAsData() -> Data? {
        // TODO - !!!: common function
        return getSignatureAsImage()?.jpegData(compressionQuality: 0.5)
    }
}
