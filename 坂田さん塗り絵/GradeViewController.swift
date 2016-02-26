//
//  GradeViewController.swift
//  坂田さん塗り絵
//
//  Created by HARADA REO on 2016/02/20.
//  Copyright © 2016年 reo harada. All rights reserved.
//

import UIKit

class GradeViewController: UIViewController {

    @IBOutlet weak var ArtisticPoint: UITextField!
    @IBOutlet weak var talentPoint: UITextField!
    @IBOutlet weak var sensePoint: UITextField!
    @IBOutlet weak var cutePoint: UITextField!
    @IBOutlet weak var colorPoint: UITextField!
    @IBOutlet weak var deliverableImageView: UIImageView!
    @IBOutlet weak var sumPoint: UILabel!
    // 画像を受け取る部品    
    var paintImage: UIImage!
    // タイマー機能
    var timer: NSTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // 受け取った画像をdeliverableImageViewにいれる
        self.deliverableImageView.image = self.paintImage
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "updateScore", userInfo: nil, repeats: true)
    }
    
    func updateScore() {
        var artPoint = 0
        if(self.ArtisticPoint.text != ""){
            artPoint = Int(self.ArtisticPoint.text!)!
            self.alert(self.talentPoint)
        }
        var talentPoint = 0
        if(self.talentPoint.text != ""){
            talentPoint = Int(self.talentPoint.text!)!
            self.alert(self.talentPoint)
        }
        var sensePoint = 0
        if(self.sensePoint.text != ""){
            sensePoint = Int(self.sensePoint.text!)!
            self.alert(self.sensePoint)
        }
        var cutePoint = 0
        if(self.cutePoint.text != ""){
            cutePoint = Int(self.cutePoint.text!)!
            self.alert(self.cutePoint)
        }
        var colorPoint = 0
        if(self.colorPoint.text != ""){
            colorPoint = Int(self.colorPoint.text!)!
            self.alert(self.colorPoint)
        }

        let score = artPoint + talentPoint + sensePoint + cutePoint + colorPoint
        self.sumPoint.text = "\(score)点"
    }
    
    func alert(textField: UITextField) {
        if(textField.text != ""){
            let point = Int(textField.text!)!
            if (point > 20) {
                self.timer.invalidate()
                let alert = UIAlertController(title: "注意", message: "20点以内で点数をつけてください", preferredStyle: UIAlertControllerStyle.Alert)
                let action = UIAlertAction(title: "はい", style: UIAlertActionStyle.Default, handler: nil)
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: { () -> Void in
                    textField.text = ""
                    self.timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "updateScore", userInfo: nil, repeats: true)
                })
            }
        }
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

    @IBAction func tapCompleteButton(sender: AnyObject) {
        let imageData = UIImagePNGRepresentation(self.paintImage)
        let score = self.sumPoint.text
        
        if(score == nil || Int(score!) > 100) {
            let alert = UIAlertController(title: "警告", message: "点数を正確に入れてください。", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if userDefaults.objectForKey("saveImageData") == nil {
            userDefaults.setObject([imageData!], forKey: "saveImageData")
            userDefaults.setObject([score!], forKey: "saveScoreData")
        }
        var imageSaveData = userDefaults.objectForKey("saveImageData") as! [NSData]
        var scoreSaveData = userDefaults.objectForKey("saveScoreData") as! [String]
        imageSaveData.append(imageData!)
        scoreSaveData.append(score!)
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
}
