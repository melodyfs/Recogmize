//
//  ViewController.swift
//  Mnist
//
//  Created by Melody on 3/15/18.
//  Copyright © 2018 Melody Yang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var canvas: UIView!
    
    var path = UIBezierPath()
    var startPoint = CGPoint()
    var touchPoint = CGPoint()
    @IBOutlet weak var resultImage: UIImageView!
    @IBOutlet weak var outputLabel: UILabel!
    
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
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
        
        goButton.makeRounded()
        goButton.backgroundColor = UIColor.cherryPink
        goButton.setTitleColor(UIColor.white, for: .normal)
        
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
        strokeLayer.strokeColor = UIColor.white.cgColor
        strokeLayer.path = path.cgPath
        canvas.layer.addSublayer(strokeLayer)
        
    }
    
    @IBAction func clearButtonPressed(_ sender: Any) {
        path.removeAllPoints()
        canvas.layer.sublayers = nil
        canvas.setNeedsDisplay()
        
    }
    
    
    @IBAction func goButtonPressed(_ sender: Any) {
        resultImage.image = UIImage.init(view: canvas)
        let pixelBuffer = resultImage.image?.pixelBuffer()
        let model = mnistModel()
        let output = try? model.prediction(image: pixelBuffer!)
        print(output?.classLabel)
        outputLabel.text = output?.classLabel
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    

}



