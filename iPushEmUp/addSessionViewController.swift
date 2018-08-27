//
//  addSessionViewController.swift
//  iPushEmUp
//
//  Created by Jack Woychowski on 8/10/18.
//  Copyright © 2018 Jack Woychowski. All rights reserved.
//

import UIKit
import CoreData

class addSessionViewController: UIViewController {


    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet var dateField: UITextField!
    @IBOutlet var countField: UITextField!

    var moc: NSManagedObjectContext?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let dtnow = Date()
        datePicker.date = dtnow
        setDateTo(date: dtnow)
        /*
        let df = DateFormatter()
        df.dateFormat = "MM/dd/yy hh:mm"
        dateField.text = df.string(from:dtnow)
         */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func save(sender: UIBarButtonItem) {
        guard let mOC = moc else { return }
        let sess = Session(context: mOC)
        sess.dateTime = datePicker.date
        sess.count = Int64(countField.text!)!
        do {
            try mOC.save()
        } catch let error as NSError {
            print("Failed to persist changes: \(error)")
        }
        _ = navigationController?.popViewController(animated: true)
    }

    private func setDateTo(date: Date) {
        let df = DateFormatter()
        df.dateFormat = "MM/dd/yy hh:mm"
        dateField.text = df.string(from: date)
    }

    @IBAction func datePickerChanged(_ sender: Any) {
        setDateTo(date: datePicker.date as Date)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
