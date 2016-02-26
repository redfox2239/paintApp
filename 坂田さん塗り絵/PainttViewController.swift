//
//  PainttViewController.swift
//  坂田さん塗り絵
//
//  Created by HARADA REO on 2015/12/19.
//  Copyright © 2015年 reo harada. All rights reserved.
//

import UIKit

class PainttViewController: UIViewController {

    @IBOutlet weak var paintImageView: UIImageView!
    @IBOutlet weak var lineWidthSlideBar: UISlider!
    // タッチの始点の座標
    var touchPoint: CGPoint!
    // 色を保存する配列
    var selectedColor: Array<CGFloat> = [0.0, 0.0, 0.0]
    // 画像データを受け取る
    var paintImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // 受け取った画像をpaintImageViewに設定する
        self.paintImageView.image = self.paintImage
        print(self.paintImage.size)
    }
    
    // タッチはじめたらどうする？
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // 座標を取得します
        let touch = touches.first
        let point = touch?.locationInView(self.paintImageView)
        // 始点のタッチ情報を保存する
        self.touchPoint = point
    }
    
    // ドラッグしたらどうする？
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // 座標を取得します
        let touch = touches.first
        let point = touch?.locationInView(self.paintImageView)
        // 色を塗る
        // グラフィックコンテキストモード起動
        UIGraphicsBeginImageContext(self.paintImageView.frame.size)
        // どこをペイントするか
        self.paintImageView.image?.drawInRect(CGRectMake(0, 0, self.paintImageView.frame.width, self.paintImageView.frame.height))
        // 始点の指定
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), self.touchPoint.x, self.touchPoint.y)
        // 終点の指定
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), point!.x, point!.y)
        // 線の太さを変える（CGFloatに変換する必要がある）
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), CGFloat(self.lineWidthSlideBar.value))
        
        // 型
        // Int 整数           3
        // Float 少数         3.0000000000000
        // CGFloat
        // Double 長い少数     3.00000000000000000000000000
        // String 文字        "3"
        
        // 塗る形を丸くします
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), CGLineCap.Round)
        // 塗る色を変える
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), self.selectedColor[0], self.selectedColor[1], self.selectedColor[2], 1.0)
        CGContextSetAlpha(UIGraphicsGetCurrentContext(), 0.1)
        // 始点と終点を結ぶ
        CGContextStrokePath(UIGraphicsGetCurrentContext())
        // ペイントした画像をpaintImageViewにコピーします
        let img = UIGraphicsGetImageFromCurrentImageContext()
        self.paintImageView.image = img//UIImage(named: "usagi")
        print(self.paintImageView.contentMode)
        //self.paintImageView.contentMode = UIViewContentMode.ScaleAspectFit
        // グラフィックコンテキストモード終了
        UIGraphicsEndImageContext()
        // 始点を更新してあげる
        self.touchPoint = point
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func tapSelectColorButton(sender: AnyObject) {
        // 色を変える
        // どのボタンを押したかは特定します(UIButtonですよと保証します)
        let selectButton = sender as! UIButton
        // 上のボタンの色を取得します
        // 色を保存する場所を用意
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        // 透明度を保存する場所
        var alpha: CGFloat = 1.0
        selectButton.currentTitleColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        // selectedColorの色を変える
        self.selectedColor[0] = red
        self.selectedColor[1] = green
        self.selectedColor[2] = blue
    }
    
    @IBAction func tapGradeButton(sender: AnyObject) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("採点画面") as! GradeViewController
        vc.paintImage = self.paintImageView.image
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
