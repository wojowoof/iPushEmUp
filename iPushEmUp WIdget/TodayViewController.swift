//
//  TodayViewController.swift
//  iPushEmUp WIdget
//
//  Created by Jack Woychowski on 8/24/18.
//  Copyright © 2018 Jack Woychowski. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreData

class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var CountLabel: UILabel!
    
    @IBOutlet weak var NewDateButton: UIButton!
    @IBOutlet weak var NewCountInput: UITextField!

    let dayCount : Int = 37
    let newCount : Int = 15

    private let persCont = NSPersistentContainer(name: "iPushEmUp")
    
    /*fileprivate lazy var fetchedResCtrl: NSFetchedResultsController<Session> = {
        
        print("THE moc: \(self.persCont.viewContext)")    
        let frC = NSFetchedResultsController(fetchRequest: fetchReq, managedObjectContext: self.persCont.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        frC.delegate = self
        print("Frc: \(frC)")
        return frC
    }()*/

    fileprivate lazy var fetchReq : NSFetchRequest<NSFetchRequestResult> = {

        let fR: NSFetchRequest<NSFetchRequestResult> = Session.fetchRequest()
        var expDescList = [AnyObject]()
        expDescList.append("dateTime" as AnyObject)
        expDescList.append("count" as AnyObject)
        
        var expDescCountSum = NSExpressionDescription()
        expDescCountSum.name = "pushupCount"
        //expDescCountSum.expression = NSExpression(format: "@sum.count")
        expDescCountSum.expression = NSExpression(forFunction: "sum:", arguments: [NSExpression(forKeyPath: "count")])
        expDescCountSum.expressionResultType = .integer64AttributeType
        // expDescList.append(expDescCountSum)
        
        //fR.propertiesToGroupBy = ["dateTime"]
        fR.resultType = .dictionaryResultType
        //fR.propertiesToFetch = expDescList
        fR.propertiesToFetch = [ "dateTime", "count" ]
        
        //fR.sortDescriptors = [NSSortDescriptor(key: "dateTime", ascending: false)]
    
        print("FR: \(fR)")
        return fR
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        persCont.loadPersistentStores(completionHandler: { (storeDesc, error) in
            if let err = error {
                print("Unable to load persistent store")
                print("\(err): \(err.localizedDescription)")
            } else {
                print("iPEU loaded persistent store")
                /*do {
                    try self.fetchedResCtrl.performFetch()
                } catch {
                    let fErr = error as NSError
                    print("iPEU: Unable to fetch")
                    print("\(fErr) - \(fErr.localizedDescription)")
                }*/
                self.configFields()
            }
        })
        // Do any additional setup after loading the view from its nib.
        configFields()
    }
    
    private func configFields() {
        var results : [NSFetchRequestResult]? // : [[String:AnyObject]]?
        do {
            results = try persCont.viewContext.fetch(fetchReq)
        } catch _ {
            print("Whoopsie")
            results = nil
        }
        print("results (\(String(describing: results?.count)): \(String(describing: results))")

        if let dl = DateLabel {
            let df = DateFormatter()
            df.dateFormat = "MM/dd/yy"
            dl.text = df.string(from: Date())
        }
        if let cl = CountLabel {
            cl.text = "\(dayCount) pushups"
        }
        if let ndB = NewDateButton {
            ndB.setTitle(txtForNow(inFormat: "MM/dd/yy hh:mm"), for: .normal)
        }
        if let nCI = NewCountInput {
            nCI.text = "15"
        }
    }
    
    private func txtForNow(inFormat: String) -> String {
        let df = DateFormatter()
        df.dateFormat = inFormat
        return df.string(from: Date())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func newDateButtonPress(_ sender: Any) {
        print("Click!")
        print("Click: add \(NewCountInput.text!) pushups for \(NewDateButton.title(for: .normal)!)")
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
}

extension TodayViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?) {
        print("Change!")
    }
}
