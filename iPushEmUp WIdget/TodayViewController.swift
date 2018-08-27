//
//  TodayViewController.swift
//  iPushEmUp WIdget
//
//  Created by Jack Woychowski on 8/24/18.
//  Copyright © 2018 Jack Woychowski. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var CountLabel: UILabel!

    let dayCount : Int = 37

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        if let dl = DateLabel {
            let df = DateFormatter()
            df.dateFormat = "MM/dd/yy"
            dl.text = df.string(from: Date())
        }
        if let cl = CountLabel {
            cl.text = "\(dayCount) pushups"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
