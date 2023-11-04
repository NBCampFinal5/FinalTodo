//
//  CircularProgressView.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 11/4/23.
//

import UIKit

class CircularProgressView: UIView {
    // First create two layer properties
    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    private var round: CGFloat
    private var lineWidth: CGFloat
    private var circleColor: CGColor
    private var progressColor: CGColor
    
    init (round: CGFloat, lineWidth: CGFloat, circleColor: CGColor, progressColor: CGColor){
        self.round = round
        self.lineWidth = lineWidth
        self.circleColor = circleColor
        self.progressColor = progressColor
        super.init(frame: .zero)
        createCircularPath()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createCircularPath() {
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: round, startAngle: -.pi / 2, endAngle: 3 * .pi / 2, clockwise: true)
        circleLayer.path = circularPath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = lineWidth
        circleLayer.strokeColor = circleColor
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = lineWidth / 2
        progressLayer.strokeEnd = 0
        progressLayer.strokeColor = progressColor
        layer.addSublayer(circleLayer)
        layer.addSublayer(progressLayer)
    }
    func progressAnimation(duration: TimeInterval, value: CGFloat) {
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circularProgressAnimation.duration = duration
        circularProgressAnimation.toValue = value
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
    }
}
