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

    override func viewDidLoad() {
        super.viewDidLoad()

        cancelButton.alpha = 0
        noButton.alpha = 0
        yesButton.alpha = 0
        speakButton.alpha = 0
        
        noSmallButton.alpha = 0
        cancelSmallButton.alpha = 0
        speakSmallButton.alpha = 0
        yesSmallButton.alpha = 0

        //DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: { self.animateSmall() })
    }

    override func viewDidAppear(_ animated: Bool) {
        animateSmall()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            
            let duration = 1.0
            
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
        animate(mainView: self.view, a: speakSmallButton, b: speakButton, onCompletition: {})
    }
    
    func animateSmall() {
        func animate(view: UIView, onCompletition: @escaping ()->Void) {
            CATransaction.begin()
            CATransaction.setCompletionBlock({
                onCompletition()
            })
            
            UIView.animate(withDuration: 0.25, animations: {
                view.alpha = 1
            })

            CATransaction.commit()
        }
        
        noSmallButton.alpha = 0
        cancelSmallButton.alpha = 0
        speakSmallButton.alpha = 0
        yesSmallButton.alpha = 0
        
        animate(view: self.noSmallButton) {
            animate(view: self.cancelSmallButton) {
                animate(view: self.speakSmallButton) {
                    animate(view: self.yesSmallButton) {
                        self.animateAll()
                    }
                }
            }
        }
    }
    
    
    func deleteButton(button: RoundedButton, onCompletition: @escaping ()->Void) {
        let buttonCopy = RoundedButton(frame: button.frame)
        buttonCopy.backgroundColor = button.backgroundColor
        buttonCopy.layer.cornerRadius = button.frame.size.height / 2
        button.superview?.insertSubview(buttonCopy, belowSubview: button)
        button.alpha = 0
        UIView.perform(UISystemAnimation.delete, on: [buttonCopy], options: UIViewAnimationOptions.curveEaseInOut, animations: {
        }, completion: { finished in
            onCompletition()
        })
    }
    
    func deleteButtons(buttons: [RoundedButton], onCompletition: @escaping ()->Void) {
        deleteButton(button: buttons[0]) {
            self.speakView.isHidden = false
            self.deleteButton(button: buttons[1]) {
            }
            self.deleteButton(button: buttons[2]) {
            }
            self.animateSmall()
        }
    }
    
    
    @IBAction func onSpeak(_ sender: Any) {
        deleteButton(button: speakButton) { 
            self.speakView.isHidden = true
        }
    }
    
    @IBAction func onCancel(_ sender: Any) {
        deleteButtons(buttons: [cancelButton, yesButton, noButton], onCompletition: {})
    }
    
    @IBAction func onYes(_ sender: Any) {
        deleteButtons(buttons: [yesButton, noButton, cancelButton], onCompletition: {})
    }
    
    @IBAction func onNo(_ sender: Any) {
        deleteButtons(buttons: [noButton, yesButton, cancelButton], onCompletition: {})
    }
}

