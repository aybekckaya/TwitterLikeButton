//
//  LikeView.swift
//  TwitterLikeButton
//
//  Created by aybek can kaya on 29.05.2019.
//  Copyright © 2019 aybek can kaya. All rights reserved.
//

import UIKit

class LikeView: UIView{
    
    let mainCircleStartColor:UIColor = #colorLiteral(red: 0.8980392157, green: 0.2196078431, blue: 0.4862745098, alpha: 1)
    let mainCircleEndColor:UIColor = #colorLiteral(red: 0.8392156863, green: 0.6156862745, blue: 0.9019607843, alpha: 1)
   
    
    private let imageView:UIImageView = {
        let imView:UIImageView = UIImageView(frame: .zero)
        imView.translatesAutoresizingMaskIntoConstraints = false
        imView.clipsToBounds = true
        imView.contentMode = UIView.ContentMode.scaleAspectFit
        return imView
    }()
    
    private var mainDotLayer:CircularLayer?
    private var whiteDotLayer:CircularLayer?
    private var sparkleGroup:[Sparkle] = []
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    private func setUpUI() {
        self.addSubview(imageView)
        imageView.addSnapConstraints(baseView: self, top: 0, bottom: 0, leading: 0, trailing: 0)
        imageView.image = UIImage(named:"heartIdle")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewOnTap))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func viewOnTap() {
        self.imageView.alpha = 0
        
        let length:CGFloat = self.frame.size.width + 12
        let sparkleCount = 8
        let angleMargin:Double = Double(360 / sparkleCount)
        for index in 0..<sparkleCount {
            let currentAngle = Double(index) * angleMargin
            let sparkleView1 = Sparkle(angle: currentAngle, length: length , parentView: self, isSecondDot: false)
            self.addSubview(sparkleView1)
            let sparkleView2 = Sparkle(angle: currentAngle, length: length , parentView: self, isSecondDot: true)
            self.addSubview(sparkleView2)
            sparkleGroup.append(sparkleView1)
            sparkleGroup.append(sparkleView2)
        }

        mainDotLayer = CircularLayer(color: mainCircleStartColor)
        mainDotLayer!.frame = CGRect(x: 0, y: 0, width: self.frame.size.width , height: self.frame.size.height)
        mainDotLayer!.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        self.layer.addSublayer(mainDotLayer!)
        
        whiteDotLayer = CircularLayer(color: UIColor.white)
        whiteDotLayer!.frame = CGRect(x: 0, y: 0, width: self.frame.size.width , height: self.frame.size.height)
        whiteDotLayer!.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        self.layer.addSublayer(whiteDotLayer!)
        whiteDotLayer!.opacity = 0
        
       
        animateLike()
 
    }
    
    private func animateLike() {
        let totalDuration:CFTimeInterval = 0.6
        
        let scaleAnimationMainDot = LikeViewAnimator.scaleAnimation(beginTime: 0, duration: totalDuration/3, from: 0.1, to: 1, springAvailable: false)
        let colorAnimationMainDot = LikeViewAnimator.backgroundColorAnimation(from: mainCircleStartColor, to: mainCircleEndColor, beginTime: 0, duration: totalDuration/3)
        let opacityAnimationMainDot = LikeViewAnimator.opacityAnimaton(from: 1, to: 0, beginTime: 1.9*totalDuration/3, duration: totalDuration/12)
        let mainDotAnimations:[CAAnimation] = [scaleAnimationMainDot , colorAnimationMainDot , opacityAnimationMainDot]
        LikeViewAnimationGroup(animations: mainDotAnimations, layer: mainDotLayer!).startAnimating {
           
        }
        
        let opacityAnimationWhiteDot = LikeViewAnimator.opacityAnimaton(from: 0, to: 1, beginTime: totalDuration/3, duration: totalDuration/30)
        let scaleAnimationWhiteDot = LikeViewAnimator.scaleAnimation(beginTime: totalDuration/3, duration: totalDuration/3, from: 0, to: 0.95, springAvailable: false)
        let whiteDotAnimations:[CAAnimation] = [opacityAnimationWhiteDot , scaleAnimationWhiteDot]
        LikeViewAnimationGroup(animations: whiteDotAnimations, layer: self.whiteDotLayer!).startAnimating {
            self.imageView.alpha = 1
            self.bringSubviewToFront(self.imageView)
            self.imageView.image = UIImage(named: "heartSelected")
        }
       
        let scaleAnimationHeart = LikeViewAnimator.scaleAnimation(beginTime: 2*totalDuration/3, duration: totalDuration/8, from: 0, to: 1, springAvailable: true)
        LikeViewAnimationGroup(animations: [scaleAnimationHeart], layer: self.imageView.layer).startAnimating {
            
        }
       
        sparkleGroup.forEach { sp in
            sp.animate(beginTime: 2*totalDuration/3 - totalDuration/8, duration: totalDuration/8)
        }
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class Sparkle:UIView {
    private let size:CGSize = CGSize(width: 4, height: 4)
    private let colors:[UIColor] = [#colorLiteral(red: 0.7215686275, green: 0.5, blue: 0.9411764706, alpha: 1)  ,  #colorLiteral(red: 0.6392156863, green: 0.9692583934, blue: 0.8156862745, alpha: 1) ,  #colorLiteral(red: 1, green: 0.3535613239, blue: 0.8156862745, alpha: 1) ]
    
    private var angle:CGFloat = 0
    private var length:CGFloat = 10
    private var isSecondDot:Bool = false
    
    private var path:CGPath?
    private var parentView:UIView?
    
    init(angle:Double , length:CGFloat , parentView:UIView , isSecondDot:Bool) {
        super.init(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        self.center = CGPoint(x: parentView.frame.size.width/2, y: parentView.frame.size.height/2)
        self.angle = CGFloat(angle.degrees)
        self.length = CGFloat(Int.random(in: Int(length)-8..<Int(length)+8 ))
        self.parentView = parentView
        self.isSecondDot = isSecondDot
        setUp()
        createPath()
    }
    
    private func setUp() {
        let color:UIColor = self.colors.randomElement()!
        self.layer.cornerRadius = self.frame.size.width/2
        self.layer.masksToBounds = true
        self.backgroundColor = color
    }
    
    private func createPath() {
        guard let parentView = parentView else { return }
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: parentView.frame.size.width/2, y: parentView.frame.size.height/2))
        path.addLine(to: CGPoint(x: parentView.frame.size.width/2, y: parentView.frame.size.height/2+length))
        if isSecondDot == true {
            path.apply(CGAffineTransform(translationX: self.frame.size.width, y: 0))
        }
        path.apply(CGAffineTransform(translationX: -1*parentView.frame.size.width/2, y: -1*parentView.frame.size.height/2))
        path.apply(CGAffineTransform(rotationAngle: angle))
        path.apply(CGAffineTransform(translationX: 1*parentView.frame.size.width/2, y: 1*parentView.frame.size.height/2))
       
        self.path = path.cgPath
       
        //self.layer.opacity = 0
        //debugPath()
    }
    
    private func debugPath() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.green.cgColor
        shapeLayer.lineWidth = 1
         parentView!.layer.addSublayer(shapeLayer)
    }
    
    func animate(beginTime:CFTimeInterval , duration:CFTimeInterval) {
        let randomStartTime:CFTimeInterval = randomTime(between: beginTime+duration, max: beginTime+duration*8)
        let randomDuration:CFTimeInterval = randomTime(between: beginTime+duration, max: beginTime+duration*16)
        
        let positionAnim = positionAnimation(path: self.path!, beginTime: beginTime, duration: randomTime(between: duration, max: duration*4))
        let scaleAnim = LikeViewAnimator.scaleAnimation(beginTime: randomStartTime, duration: randomDuration, from: 1, to: 0, springAvailable: false)
        let opacityAnim = LikeViewAnimator.opacityAnimaton(from: 1, to: 0, beginTime: randomStartTime, duration: randomDuration)
        LikeViewAnimationGroup(animations: [positionAnim , scaleAnim , opacityAnim], view: self).startAnimating {
            
        }
    }
    
    private func randomTime(between min:CFTimeInterval , max:CFTimeInterval)->CFTimeInterval {
        let constant:Double = 1000
        let minInteger:Int = Int(min*constant)
        let maxInteger:Int = Int(max*constant)
        let random:Double = Double(Int.random(in: minInteger..<maxInteger)) / constant
        return CFTimeInterval(random)
    }
    
    
    private func positionAnimation(path:CGPath , beginTime:CFTimeInterval , duration:CFTimeInterval)->CAKeyframeAnimation {
        let animationPosition = CAKeyframeAnimation(keyPath: "position")
        animationPosition.path = path
        animationPosition.fillMode = CAMediaTimingFillMode.forwards
        animationPosition.isRemovedOnCompletion = false
        animationPosition.beginTime = beginTime
        animationPosition.duration = duration
        return animationPosition
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}








class LikeViewAnimator {
    
    static func backgroundColorAnimation(from:UIColor , to:UIColor , beginTime:CFTimeInterval , duration:CFTimeInterval)->CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "fillColor")
        animation.fromValue = from.cgColor
        animation.toValue = to.cgColor
        animation.duration = duration
        animation.beginTime = beginTime
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        return animation
    }
    
    
    static func opacityAnimaton(from:CGFloat , to:CGFloat , beginTime:CFTimeInterval , duration:CFTimeInterval)->CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = from
        animation.toValue = to
        animation.duration = duration
        animation.beginTime = beginTime
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        return animation
    }
    
    static  func scaleAnimation(beginTime:CFTimeInterval  , duration:CFTimeInterval , from:CGFloat = 1 , to:CGFloat = 0, springAvailable:Bool = false )->CAAnimation {
        if springAvailable == true {
            let animationScale = CAKeyframeAnimation(keyPath: "transform.scale")
            animationScale.values = [0, 0.45, 0.60, 0.95, 1.25, 1.35, 1.40, 1.25, 1]
            animationScale.keyTimes = [0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875, 1]
            animationScale.duration = duration
            animationScale.beginTime = beginTime
            animationScale.isRemovedOnCompletion = false
            animationScale.fillMode = CAMediaTimingFillMode.forwards
            return animationScale
        }
        let animationScale = CABasicAnimation(keyPath: "transform.scale")
        animationScale.fromValue = from
        animationScale.toValue = to
        animationScale.duration = duration
        animationScale.beginTime = beginTime
        animationScale.isRemovedOnCompletion = false
        animationScale.fillMode = CAMediaTimingFillMode.forwards
        return animationScale
    }
    
}


class CircularLayer: CAShapeLayer {
    override var position: CGPoint{
        didSet {
            self.setUp()
        }
    }
    
    private var color:UIColor!
    
    override init() {
        super.init()
        
    }
   
    init(color:UIColor) {
        super.init()
        self.color = color
    }
    
    private func setUp() {
        let bezierPath = UIBezierPath(arcCenter: CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2), radius: self.frame.size.width, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        self.path = bezierPath.cgPath
        self.fillColor = self.color.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




class LikeViewAnimationGroup: CAAnimationGroup, CAAnimationDelegate {
    private var completion:(()->())!
    private var view:UIView?
    private var layer:CALayer?
    
    override init() {
        super.init()
    }
    
    init(animations:[CAAnimation] , view:UIView) {
        super.init()
        self.animations = animations
        self.view = view
    }
    
    init(animations:[CAAnimation] , layer:CALayer) {
        super.init()
        self.animations = animations
        self.layer = layer
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimating(completion:@escaping (()->())) {
        self.completion = completion
        self.delegate = self
        self.duration = durationFromAnimations(animations: self.animations)
        self.fillMode = CAMediaTimingFillMode.forwards
        self.isRemovedOnCompletion = false
        if let view = self.view {
            view.layer.add(self, forKey: nil)
        }
        else if let layer = layer {
            layer.add(self, forKey: nil)
        }
        
    }
    
    private func durationFromAnimations(animations:[CAAnimation]?)->CFTimeInterval {
        guard let animations = animations else { return 0 }
        var max:CFTimeInterval = 0
        animations.forEach { anim in
            if anim.beginTime + anim.duration > max {
                max = anim.beginTime + anim.duration
            }
        }
        return max
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.completion()
    }
    
}


