//
//  ViewController.swift
//  YesNo
//
//  Created by Jacopo Mangiavacchi on 12/21/16.
//  Copyright © 2016 Jacopo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var speakView: UIView!
    @IBOutlet weak var speakButton: RoundedButton!
    @IBOutlet weak var cancelButton: RoundedButton!
    @IBOutlet weak var yesButton: RoundedButton!
    @IBOutlet weak var noButton: RoundedButton!
    @IBOutlet weak var noSmallButton: RoundedButton!
    @IBOutlet weak var cancelSmallButton: RoundedButton!
    @IBOutlet weak var speakSmallButton: RoundedButton!
    @IBOutlet weak var yesSmallButton: RoundedButton!
    
    
    func degreesToRadians(_ x: Double) -> CGFloat {
        return CGFloat(x * M_PI / 180.0)
    }

    func animateAll() {
        func animate(mainView: UIView, a: UIView, b: UIView) {
            
            let aPoint = a.superview!.convert(CGPoint(x: a.frame.origin.x, y: a.frame.origin.y), to: mainView)
            let bPoint = b.superview!.convert(CGPoint(x: b.frame.origin.x, y: b.frame.origin.y), to: mainView)
            let cPoint = CGPoint(x: min(aPoint.x, bPoint.x) + (abs(bPoint.x - aPoint.x)/2),
                            y: min(aPoint.y, bPoint.y) + (abs(bPoint.y - aPoint.y)/2))
            
            let circle = UIView()
            circle.backgroundColor = a.backgroundColor
            circle.frame = CGRect(origin: aPoint, size: a.frame.size)
            circle.layer.cornerRadius = circle.frame.size.height / 2
            circle.layer.anchorPoint =  CGPoint(x: 0.0, y: 0.0)
            mainView.addSubview(circle)
            //a.alpha = 0
            
            let radius = sqrt(pow(abs(bPoint.x - aPoint.x),2) + pow(abs(bPoint.y - aPoint.y),2)) / 2;
            
            let v1 = CGVector(dx: aPoint.x - cPoint.x, dy: aPoint.y - cPoint.y)
            let v2 = CGVector(dx: radius, dy: 0)
            
            let radiant = atan2(v1.dy, v1.dx) - atan2(v2.dy, v2.dx)
            
            let path = UIBezierPath(arcCenter: cPoint, radius: radius, startAngle: radiant, endAngle: radiant + CGFloat(M_PI), clockwise: false)
            
            CATransaction.begin()
            CATransaction.setCompletionBlock({
                circle.alpha = 0
                circle.removeFromSuperview()
            })
            
            let duration = 4.0
            
            let posAnim = CAKeyframeAnimation(keyPath: "position")
            posAnim.path = path.cgPath
            posAnim.calculationMode = kCAAnimationLinear
            //posAnim.rotationMode =  kCAAnimationRotateAuto
            posAnim.repeatCount = 0
            posAnim.duration = duration
            posAnim.fillMode = kCAFillModeForwards
            posAnim.isRemovedOnCompletion = false
            
            let sizeAnim = CABasicAnimation(keyPath: "bounds.size")
            sizeAnim.repeatCount = 0
            sizeAnim.duration = duration
            sizeAnim.fillMode = kCAFillModeForwards
            sizeAnim.isRemovedOnCompletion = false
            sizeAnim.toValue = NSValue(cgSize: b.frame.size)
            
            let cornerAnim = CABasicAnimation(keyPath: "cornerRadius")
            cornerAnim.repeatCount = 0
            cornerAnim.duration = duration
            cornerAnim.fillMode = kCAFillModeForwards
            cornerAnim.isRemovedOnCompletion = false
            cornerAnim.toValue = b.frame.size.height / 2

            circle.layer.add(posAnim, forKey: nil)
            circle.layer.add(sizeAnim, forKey: nil)
            circle.layer.add(cornerAnim, forKey: nil)
            
            CATransaction.commit()
        }
        
        animate(mainView: self.view, a: cancelSmallButton, b: cancelButton)
        animate(mainView: self.view, a: noSmallButton, b: noButton)
        animate(mainView: self.view, a: yesSmallButton, b: yesButton)
        animate(mainView: self.view, a: speakSmallButton, b: speakButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        animateAll()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func onSpeak(_ sender: Any) {
        speakView.isHidden = true
        
//        UIView.perform(UISystemAnimation.delete, on: [speakView], options: UIViewAnimationOptions.curveEaseInOut, animations: {
//            // any changes defined here will occur
//            // in parallel with the system animation
//            
//        }, completion: { finished in
//            // any code entered here will be applied
//            // once the animation has completed
//            
//        })
        
        animateAll()
    }
    
    @IBAction func onCancel(_ sender: Any) {
        speakView.isHidden = false
    }
    
    @IBAction func onYes(_ sender: Any) {
        speakView.isHidden = false
    }
    
    @IBAction func onNo(_ sender: Any) {
        speakView.isHidden = false
    }
}

