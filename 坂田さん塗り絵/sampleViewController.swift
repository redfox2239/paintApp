//
//  ViewController.swift
//  坂田さん塗り絵
//
//  Created by HARADA REO on 2015/10/24.
//  Copyright © 2015年 reo harada. All rights reserved.
//

import UIKit

class sampleViewController: UIViewController {
    
    @IBOutlet weak var draftImageView: UIImageView!
    // 選んだ色を保存する配列
    var selectedColor: Array<UInt8> = [255,255,255]
    // タッチした座標
    var touchX: Int!
    var touchY: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
        let x = (point?.x)! * (self.draftImageView.image?.size.width)! / self.draftImageView.frame.size.width
        let y = (point?.y)! * (self.draftImageView.image?.size.width)! / self.draftImageView.frame.size.height
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
        let index = (CGImageGetWidth(self.draftImageView.image?.CGImage) * self.touchY + self.touchX) * 4
        if(index < CFDataGetLength(cfData)){
            bitmap[index] = self.selectedColor[0]
            bitmap[index+1] = self.selectedColor[1]
            bitmap[index+2] = self.selectedColor[2]
            let resultCFData = CFDataCreate(nil, bitmap, CFDataGetLength(cfData))
            let resultDataProvider = CGDataProviderCreateWithCFData(resultCFData)
            let resultCGImage = CGImageCreate(
                CGImageGetWidth(self.draftImageView.image?.CGImage),
                CGImageGetHeight(self.draftImageView.image?.CGImage),
                CGImageGetBitsPerComponent(self.draftImageView.image?.CGImage),
                CGImageGetBitsPerPixel(self.draftImageView.image?.CGImage),
                CGImageGetBytesPerRow(self.draftImageView.image?.CGImage),
                CGImageGetColorSpace(self.draftImageView.image?.CGImage),
                CGImageGetBitmapInfo(self.draftImageView.image?.CGImage),
                resultDataProvider,
                nil,
                CGImageGetShouldInterpolate(self.draftImageView.image?.CGImage),
                CGImageGetRenderingIntent(self.draftImageView.image?.CGImage)
            )
            let resultUIImage = UIImage(CGImage: resultCGImage!)
            self.draftImageView.image = resultUIImage
        }
    }
    
}







