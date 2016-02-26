//
//  PaintViewController.swift
//  坂田さん塗り絵
//
//  Created by HARADA REO on 2015/11/05.
//  Copyright © 2015年 reo harada. All rights reserved.
//

import UIKit

class PaintViewController: UIViewController {

    @IBOutlet weak var paintImageView: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var tmpImageView: UIImageView!
    var selectedColor: Array<CGFloat> = [0,0,0]
    var imageSize: CGFloat!
    var lastPoint: CGPoint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.imageSize = 5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let point = touch!.locationInView(self.paintImageView)
        self.lastPoint = point
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let currentPoint = touch?.locationInView(self.paintImageView)
        
        UIGraphicsBeginImageContext(self.paintImageView.frame.size);
        self.paintImageView.image?.drawInRect(CGRectMake(0, 0, self.paintImageView.frame.size.width, self.paintImageView.frame.size.height))
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), self.lastPoint.x, self.lastPoint.y)
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), (currentPoint?.x)!, (currentPoint?.y)!)
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), CGLineCap.Round)
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), self.imageSize)
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), self.selectedColor[0], self.selectedColor[1], self.selectedColor[2], 1.0)
        //CGContextSetBlendMode(UIGraphicsGetCurrentContext(), CGBlendMode.Normal)
        
        CGContextStrokePath(UIGraphicsGetCurrentContext())
        
        self.paintImageView.image = UIGraphicsGetImageFromCurrentImageContext()

        //[self.tempDrawImage setAlpha:opacity];
        UIGraphicsEndImageContext();
        
        lastPoint = currentPoint;
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /*UIGraphicsBeginImageContext(self.mainImage.frame.size);
        [self.mainImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
        [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:opacity];
        self.mainImage.image = UIGraphicsGetImageFromCurrentImageContext();
        self.tempDrawImage.image = nil;
        UIGraphicsEndImageContext();*/
    }
    
    @IBAction func tapColorButton(sender: AnyObject) {
        // 押されたボタンを取得
        let pushedButton = sender as! UIButton
        
        // RGBを取得します
        var redColor: CGFloat = 0
        var greenColor: CGFloat = 0
        var blueColor: CGFloat = 0
        // 透明度を取得する
        var alpha: CGFloat = 0
        
        // 選択したボタンの色を取得
        pushedButton.currentTitleColor.getRed(&redColor, green: &greenColor, blue: &blueColor, alpha: &alpha)
        
        // 255かけて、UInt8で変換
        // 変換の仕方 UInt8(変換したいもの)
        // selectedColorに保存
        self.selectedColor[0] = redColor
        self.selectedColor[1] = greenColor
        self.selectedColor[2] = blueColor
    }
}
