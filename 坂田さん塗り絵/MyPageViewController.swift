//
//  MyPageViewController.swift
//  坂田さん塗り絵
//
//  Created by HARADA REO on 2016/02/27.
//  Copyright © 2016年 reo harada. All rights reserved.
//

import UIKit

class MyPageViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var imageSaveData: [NSData] = []
    var scoreSaveData: [String] = []
    @IBOutlet weak var myPageTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let nib = UINib(nibName: "MyPageTableViewCell", bundle: nil)
        self.myPageTableView.registerNib(nib, forCellReuseIdentifier: "MyPageTableViewCell")
    }
    
    override func viewWillAppear(animated: Bool) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if userDefaults.objectForKey("saveImageData") != nil {
            self.imageSaveData = userDefaults.objectForKey("saveImageData") as! [NSData]
            self.scoreSaveData = userDefaults.objectForKey("saveScoreData") as! [String]
        }
        self.myPageTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.imageSaveData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MyPageTableViewCell", forIndexPath: indexPath) as! MyPageTableViewCell
        cell.scoreLabel.text = self.scoreSaveData[indexPath.row]
        let image = UIImage(data: self.imageSaveData[indexPath.row])
        cell.paintImageView.image = image
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cell = tableView.dequeueReusableCellWithIdentifier("MyPageTableViewCell") as! MyPageTableViewCell
        let height = CGRectGetHeight(cell.frame)
        return height
    }
    
}
