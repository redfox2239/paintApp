//
//  ViewController.swift
//  坂田さん塗り絵
//
//  Created by HARADA REO on 2015/10/24.
//  Copyright © 2015年 reo harada. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var draftImageView: UIImageView!
    // 選んだ色を保存する配列
    var selectedColor: Array<UInt8> = [255,255,255]
    // タッチした座標
    var touchX: Int!
    var touchY: Int!
    // 受け取る画像ファイル名
    var imageFile: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 受け取った画像ファイルに変更
        self.draftImageView.image = UIImage(named: self.imageFile)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        self.selectedColor[0] = UInt8(redColor*255)
        self.selectedColor[1] = UInt8(greenColor*255)
        self.selectedColor[2] = UInt8(blueColor*255)
    }
    
    // タッチされたらどうする？
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // タッチされた情報を取得
        let touchInfo = touches.first
        // 座標を取得
        let point = touchInfo?.locationInView(self.draftImageView)
        // 座標を変換（ビットマップ用の画像）
        print(point)
        let x = (point?.x)! * (self.draftImageView.image?.size.width)! / self.draftImageView.frame.size.width
        let y = (point?.y)! * (self.draftImageView.image?.size.height)! / self.draftImageView.frame.size.height
        print("\(x),\(y)")
        // 整数に変換して保存します
        self.touchX = Int(x)
        self.touchY = Int(y)
        
        // CGImageに変換
        let cgImage = self.draftImageView.image?.CGImage
        // 画像provierを用意する（画像providerはいろんな情報を取得してくれる）
        let provider = CGImageGetDataProvider(cgImage)
        // CFDataを取得します
        let cfData = CGDataProviderCopyData(provider)
        // CFDataを変更できる形=mutalbleの形に変更する
        let mutableCfData = CFDataCreateMutableCopy(nil, 0, cfData)
        // ビットマップを取得する
        let bitmap = CFDataGetMutableBytePtr(mutableCfData)
        // 座標のビットマップの色を取得します
        // (Y座標×画像の横幅 + X座標)×4 ←タッチした座標のビットマップ情報
        let index = (self.touchY * CGImageGetWidth(cgImage) + self.touchX) * 4
        
        let length = CFDataGetLength(mutableCfData)
        
        if(index < length){
            // red
            bitmap[index] = self.selectedColor[0]
            // green
            bitmap[index+1] = self.selectedColor[1]
            // blue
            bitmap[index+2] = self.selectedColor[2]
            
            // 塗る座標を保存する配列を作る
            var fillPoint: Array<Array<Int>> = []
            
            // 繰り返し（無限ループ）
            while(true){
                // 上方向に1pixel、色を塗ってみましょう
                let indexUp = ((self.touchY-1) * CGImageGetWidth(cgImage) + self.touchX) * 4
                // 黒色(R=0,G=0,B=0)だったら塗らない
                if(!(bitmap[indexUp] == 0 && bitmap[indexUp+1] == 0 && bitmap[indexUp+2] == 0)) {
                    // 自分が選んだ色だったら塗らない
                    if(!(bitmap[indexUp] == self.selectedColor[0] && bitmap[indexUp+1] == self.selectedColor[1] && bitmap[indexUp+2] == self.selectedColor[2])) {
                        // 座標を保存します
                        fillPoint.append([self.touchX,self.touchY-1])
                        // red
                        bitmap[indexUp] = self.selectedColor[0]
                        // green
                        bitmap[indexUp+1] = self.selectedColor[1]
                        // blue
                        bitmap[indexUp+2] = self.selectedColor[2]
                    }
                }
                
                // 下方向にも1pixel、色を塗ってみましょう
                let indexDown = ((self.touchY+1) * CGImageGetWidth(cgImage) + self.touchX) * 4
                // 黒色(R=0,G=0,B=0)だったら塗らない
                if(!(bitmap[indexDown] == 0 && bitmap[indexDown+1] == 0 && bitmap[indexDown+2] == 0)) {
                    if(!(bitmap[indexDown] == self.selectedColor[0] && bitmap[indexDown+1] == self.selectedColor[1] && bitmap[indexDown+2] == self.selectedColor[2])) {
                        // 座標を保存します
                        fillPoint.append([self.touchX,self.touchY+1])
                        // red
                        bitmap[indexDown] = self.selectedColor[0]
                        // green
                        bitmap[indexDown+1] = self.selectedColor[1]
                        // blue
                        bitmap[indexDown+2] = self.selectedColor[2]
                    }
                }
                
                // 右方向に30pixel、色を塗ってみましょう
                let indexRight = (self.touchY * CGImageGetWidth(cgImage) + (self.touchX+1)) * 4
                // 黒色(R=0,G=0,B=0)だったら塗らない
                if(!(bitmap[indexRight] == 0 && bitmap[indexRight+1] == 0 && bitmap[indexRight+2] == 0)) {
                    if(!(bitmap[indexRight] == self.selectedColor[0] && bitmap[indexRight+1] == self.selectedColor[1] && bitmap[indexRight+2] == self.selectedColor[2])) {
                        // 座標を保存します
                        fillPoint.append([self.touchX+1,self.touchY])
                        // red
                        bitmap[indexRight] = self.selectedColor[0]
                        // green
                        bitmap[indexRight+1] = self.selectedColor[1]
                        // blue
                        bitmap[indexRight+2] = self.selectedColor[2]
                    }
                }
                
                // 左方向に30pixel、色を塗ってみましょう
                let indexLeft = (self.touchY * CGImageGetWidth(cgImage) + (self.touchX-1)) * 4
                // 黒色(R=0,G=0,B=0)だったら塗らない
                if(!(bitmap[indexLeft] == 0 && bitmap[indexLeft+1] == 0 && bitmap[indexLeft+2] == 0)) {
                    if(!(bitmap[indexLeft] == self.selectedColor[0] && bitmap[indexLeft+1] == self.selectedColor[1] && bitmap[indexLeft+2] == self.selectedColor[2])) {
                        // 座標を保存します
                        fillPoint.append([self.touchX-1,self.touchY])
                        // red
                        bitmap[indexLeft] = self.selectedColor[0]
                        // green
                        bitmap[indexLeft+1] = self.selectedColor[1]
                        // blue
                        bitmap[indexLeft+2] = self.selectedColor[2]
                    }
                }
                
                // 右斜め上
                let indexUpRight = ((self.touchY-1) * CGImageGetWidth(cgImage) + (self.touchX+1)) * 4
                if(!(bitmap[indexUpRight] == 0 && bitmap[indexUpRight+1] == 0 && bitmap[indexUpRight+2] == 0)) {
                    if(!(bitmap[indexUpRight] == self.selectedColor[0] && bitmap[indexUpRight+1] == self.selectedColor[1] && bitmap[indexUpRight+2] == self.selectedColor[2])) {
                        // 座標を保存します
                        fillPoint.append([self.touchX+1,self.touchY-1])
                        // red
                        bitmap[indexUpRight] = self.selectedColor[0]
                        // green
                        bitmap[indexUpRight+1] = self.selectedColor[1]
                        // blue
                        bitmap[indexUpRight+2] = self.selectedColor[2]
                    }
                }
                
                // 右斜め下
                let indexDownRight = ((self.touchY+1) * CGImageGetWidth(cgImage) + (self.touchX+1)) * 4
                if(!(bitmap[indexDownRight] == 0 && bitmap[indexDownRight+1] == 0 && bitmap[indexDownRight+2] == 0)) {
                    if(!(bitmap[indexDownRight] == self.selectedColor[0] && bitmap[indexDownRight+1] == self.selectedColor[1] && bitmap[indexDownRight+2] == self.selectedColor[2])) {
                        // 座標を保存します
                        fillPoint.append([self.touchX+1,self.touchY+1])
                        // red
                        bitmap[indexDownRight] = self.selectedColor[0]
                        // green
                        bitmap[indexDownRight+1] = self.selectedColor[1]
                        // blue
                        bitmap[indexDownRight+2] = self.selectedColor[2]
                    }
                }
                
                // 左斜め下
                let indexDownLeft = ((self.touchY+1) * CGImageGetWidth(cgImage) + (self.touchX-1)) * 4
                if(!(bitmap[indexDownLeft] == 0 && bitmap[indexDownLeft+1] == 0 && bitmap[indexDownLeft+2] == 0)) {
                    if(!(bitmap[indexDownLeft] == self.selectedColor[0] && bitmap[indexDownLeft+1] == self.selectedColor[1] && bitmap[indexDownLeft+2] == self.selectedColor[2])) {
                        // 座標を保存します
                        fillPoint.append([self.touchX-1,self.touchY+1])
                        // red
                        bitmap[indexDownLeft] = self.selectedColor[0]
                        // green
                        bitmap[indexDownLeft+1] = self.selectedColor[1]
                        // blue
                        bitmap[indexDownLeft+2] = self.selectedColor[2]
                    }
                }
                
                // 左斜め上
                let indexUpLeft = ((self.touchY-1) * CGImageGetWidth(cgImage) + (self.touchX-1)) * 4
                if(!(bitmap[indexUpLeft] == 0 && bitmap[indexUpLeft+1] == 0 && bitmap[indexUpLeft+2] == 0)) {
                    if(!(bitmap[indexUpLeft] == self.selectedColor[0] && bitmap[indexUpLeft+1] == self.selectedColor[1] && bitmap[indexUpLeft+2] == self.selectedColor[2])) {
                        // 座標を保存します
                        fillPoint.append([self.touchX-1,self.touchY-1])
                        // red
                        bitmap[indexUpLeft] = self.selectedColor[0]
                        // green
                        bitmap[indexUpLeft+1] = self.selectedColor[1]
                        // blue
                        bitmap[indexUpLeft+2] = self.selectedColor[2]
                    }
                }
                    
                // fillPointの配列の数が0なら終了
                if(fillPoint.count == 0){
                        break
                }
                
                // fillPointの一番後ろの数字を求める
                let lastNumber = fillPoint.count - 1
                self.touchX = fillPoint[lastNumber][0]
                self.touchY = fillPoint[lastNumber][1]
                // fillPointの一番後ろの配列を消します
                fillPoint.removeLast()
            }
        }
        
        //逆に変換していく
        // CFDataに変換します
        let outputCFData = CFDataCreate(nil, bitmap, CFDataGetLength(cfData))
        // 画像providerを用意する
        let outputProvider = CGDataProviderCreateWithCFData(outputCFData)
        // CGImageに変換します
        let outputCGImage = CGImageCreate(CGImageGetWidth(cgImage),
            CGImageGetHeight(cgImage),
            CGImageGetBitsPerComponent(cgImage),
            CGImageGetBitsPerPixel(cgImage),
            CGImageGetBytesPerRow(cgImage),
            CGImageGetColorSpace(cgImage),
            CGImageGetBitmapInfo(cgImage),
            outputProvider,
            nil,
            CGImageGetShouldInterpolate(cgImage),
            CGImageGetRenderingIntent(cgImage))
        // UIImageに変換
        let outputUIImage = UIImage(CGImage: outputCGImage!)
        // draftImageViewに画像を入れる
        self.draftImageView.image = outputUIImage
    }
    
    @IBAction func tapPaintModeButton(sender: AnyObject) {
        // 次の画面を呼んでくる
        let nextView = self.storyboard?.instantiateViewControllerWithIdentifier("ペイント画面") as! PainttViewController
        // 次の画面に画像を渡す
        // ビットマップ画像のcontextを作成.
        UIGraphicsBeginImageContextWithOptions(self.draftImageView.frame.size, false, 0.0)
        let context: CGContextRef = UIGraphicsGetCurrentContext()!
        // 対象のview内の描画をcontextに複写する.
        self.draftImageView.layer.renderInContext(context)
        // 現在のcontextのビットマップをUIImageとして取得.
        let capturedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        // contextを閉じる.
        UIGraphicsEndImageContext()
        nextView.paintImage = capturedImage
        // 次の画面に移動する
        self.navigationController?.pushViewController(nextView, animated: true)
    }
    
    @IBAction func tapGradeButton(sender: AnyObject) {
        // 次の画面を呼んでくる
        let nextView = self.storyboard?.instantiateViewControllerWithIdentifier("採点画面") as! GradeViewController
        // 次の画面に画像を渡す
        nextView.paintImage = self.draftImageView.image
        // 次の画面に移動する
        self.navigationController?.pushViewController(nextView, animated: true)
    }
}







