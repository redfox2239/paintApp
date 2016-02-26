//
//  ListViewController.swift
//  坂田さん塗り絵
//
//  Created by HARADA REO on 2016/02/13.
//  Copyright © 2016年 reo harada. All rights reserved.
//

import UIKit

// tableViewを使う準備その１
class ListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var listTableView: UITableView!
    // データを用意
    var paintData: Array<String> = [
        "usagi.png",
        "tora.png",
        "uma.png",
        "nezumi.png",
        "hogehoge.png",
        "アンパンマンTシャツ.png",
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // tableViewを使う準備その２
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        
        // カスタムcellをtableViewに登録します
        let xib = UINib(nibName: "PaintTableViewCell", bundle: nil)
        self.listTableView.registerNib(xib, forCellReuseIdentifier: "paintCell")
    }
    
    // tableViewとの相談↓
    // セクションの数どうする？
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // セルの数どうする？
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.paintData.count
    }
    
    // セルの中身どうする？
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // カスタムcellを使ってね
        // as!はクラスを保証してあげる
        let cell = tableView.dequeueReusableCellWithIdentifier("paintCell", forIndexPath: indexPath) as! PaintTableViewCell
        // 配列からファイル名取得
        let fileName = self.paintData[indexPath.row]
        // cellの画像を指定する
        cell.listImageView.image = UIImage(named: fileName)
        return cell
    }
    
    // セルの高さどうする？
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 274
    }
    
    // セルを選択した時どうする？
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // 次の画面へ行く
        // 次の画面を呼んできます
        let nextView = self.storyboard?.instantiateViewControllerWithIdentifier("色を塗る画面") as! ViewController
        // データを渡す
        nextView.imageFile = self.paintData[indexPath.row]
        self.navigationController?.pushViewController(nextView, animated: true)
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

}
