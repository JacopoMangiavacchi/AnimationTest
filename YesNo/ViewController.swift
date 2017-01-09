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

    var speakButtonCopy: RoundedButton?

    
    func degreesToRadians(_ x: Double) -> CGFloat {
        return CGFloat(x * M_PI / 180.0)
    }

    func animateAll() {
        func animate(mainView: UIView, a: UIView, b: UIView, onCompletition: @escaping ()->Void) {
            
            let aPoint = a.superview!.convert(CGPoint(x: a.frame.origin.x, y: a.frame.origin.y), to: mainView)
            let bPoint = b.superview!.convert(CGPoint(x: b.frame.origin.x, y: b.frame.origin.y), to: mainView)
            let cPoint = CGPoint(x: min(aPoint.x, bPoint.x) + (abs(bPoint.x - aPoint.x)/2),
                            y: min(aPoint.y, bPoint.y) + (abs(bPoint.y - aPoint.y)/2))

            b.alpha = 0
            a.alpha = 0

            let circle = UIView()
            circle.backgroundColor = a.backgroundColor
            circle.frame = CGRect(origin: aPoint, size: a.frame.size)
            circle.layer.cornerRadius = circle.frame.size.height / 2
            circle.layer.anchorPoint =  CGPoint(x: 0.0, y: 0.0)
            mainView.addSubview(circle)
            
            let radius = sqrt(pow(abs(bPoint.x - aPoint.x),2) + pow(abs(bPoint.y - aPoint.y),2)) / 2;
            
            let v1 = CGVector(dx: aPoint.x - cPoint.x, dy: aPoint.y - cPoint.y)
            let v2 = CGVector(dx: radius, dy: 0)
            
            let radiant = atan2(v1.dy, v1.dx) - atan2(v2.dy, v2.dx)
            
            let path = UIBezierPath(arcCenter: cPoint, radius: radius, startAngle: radiant, endAngle: radiant + CGFloat(M_PI), clockwise: false)
            
            CATransaction.begin()
            CATransaction.setCompletionBlock({
                b.alpha = 1
                circle.alpha = 0
                circle.removeFromSuperview()
                onCompletition()
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
        
        animate(mainView: self.view, a: cancelSmallButton, b: cancelButton, onCompletition: {})
        animate(mainView: self.view, a: noSmallButton, b: noButton, onCompletition: {})
        animate(mainView: self.view, a: yesSmallButton, b: yesButton, onCompletition: {})
        animate(mainView: self.view, a: speakSmallButton, b: speakButton, onCompletition: {
            self.speakButtonCopy = RoundedButton(frame: self.speakButton.frame)
            self.speakButtonCopy!.backgroundColor = self.speakButton.backgroundColor
            self.speakButtonCopy!.layer.cornerRadius = self.speakButtonCopy!.frame.size.height / 2
            self.speakButtonCopy!.addConstraints(self.speakButtonCopy!.constraints)
//            self.speakButtonCopy!.setTitle(self.speakButton.titleLabel?.text, for: .normal)
//            self.speakButtonCopy!.titleLabel?.font = self.speakButton.titleLabel?.font
//            self.speakButtonCopy!.titleLabel?.textColor = self.speakButton.titleLabel?.textColor
//            self.speakButtonCopy!.addTarget(self, action: #selector(self.onSpeak), for: .touchUpInside)
            self.speakView?.insertSubview(self.speakButtonCopy!, belowSubview: self.speakButton)
            self.speakButtonCopy!.alpha = 0
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cancelButton.alpha = 0
        noButton.alpha = 0
        yesButton.alpha = 0
        speakButton.alpha = 0
        
        //DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: { self.animateAll() })
    }

    override func viewDidAppear(_ animated: Bool) {
        animateAll()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func onSpeak(_ sender: Any) {
        self.speakButtonCopy!.frame = self.speakButton.frame
        self.speakButtonCopy!.alpha = 1
        self.speakButton.alpha = 0
        animateAll()
        UIView.perform(UISystemAnimation.delete, on: [speakButtonCopy!], options: UIViewAnimationOptions.curveEaseInOut, animations: {
            // any changes defined here will occur
            // in parallel with the system animation
            
        }, completion: { finished in
            // any code entered here will be applied
            // once the animation has completed
            
        })
    }
    
    @IBAction func onCancel(_ sender: Any) {
    }
    
    @IBAction func onYes(_ sender: Any) {
    }
    
    @IBAction func onNo(_ sender: Any) {
    }
}

