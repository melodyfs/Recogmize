//
//  JapanVC.swift
//  Mnist
//
//  Created by Melody on 4/14/18.
//  Copyright © 2018 Melody Yang. All rights reserved.
//

import UIKit

class JapanVC: UIViewController {

    @IBOutlet weak var canvas: UIView!
    @IBOutlet weak var resultImage: UIImageView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var recognizeButton: UIButton!
    
    var path = UIBezierPath()
    var startPoint = CGPoint()
    var touchPoint = CGPoint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        canvas.clipsToBounds = true
        canvas.isMultipleTouchEnabled = true
        resultImage.isHidden = true
        styleButtons()
    }
    
    func styleButtons() {
        clearButton.makeRounded()
        clearButton.addBorder(color: UIColor.cherryPink)
        clearButton.setTitleColor(UIColor.cherryPink, for: .normal)
        
        recognizeButton.makeRounded()
        recognizeButton.backgroundColor = UIColor.cherryPink
        recognizeButton.setTitleColor(UIColor.white, for: .normal)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let point = touch?.location(in: canvas) {
            startPoint = point
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let point = touch?.location(in: canvas) {
            touchPoint = point
        }
        
        path.move(to: startPoint)
        path.addLine(to: touchPoint)
        startPoint = touchPoint
        draw()
    }
    
    
    func draw() {
        let strokeLayer = CAShapeLayer()
        strokeLayer.fillColor = nil
        strokeLayer.lineWidth = 8
        
        if segmentedControl.selectedSegmentIndex == 0 {
             strokeLayer.strokeColor = UIColor.orange.cgColor
        } else {
             strokeLayer.strokeColor = UIColor.yellow.cgColor
        }
       
        strokeLayer.path = path.cgPath
        canvas.layer.addSublayer(strokeLayer)
        
    }

    @IBAction func recognizePressed(_ sender: UIButton) {
        resultImage.image = UIImage.init(view: canvas)
        let pixelBuffer = resultImage.image?.pixelBuffer()

        if segmentedControl.selectedSegmentIndex == 0 {
            let model = hiraganaModel3()
            let output = try? model.prediction(image: pixelBuffer!)
            informResultPopUp(message: (output?.classLabel)!)
            print(output?.classLabel)
        } else {
            let model = katakanaModel()
            let output = try? model.prediction(image: pixelBuffer!)
            informResultPopUp(message: (output?.classLabel)!)
            print(output?.classLabel)
        }
        
       
    }
    
    func informResultPopUp(message: String) {
        let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: { action in
            self.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(ok)
        self.present(alertController, animated: true) { () in
        }
    }
    
    @IBAction func clearPressed(_ sender: UIButton) {
        path.removeAllPoints()
        canvas.layer.sublayers = nil
        canvas.setNeedsDisplay()
        
       
    }
    
}
