//
//  ViewController.swift
//  iPushEmUp
//
//  Created by Jack Woychowski on 8/10/18.
//  Copyright © 2018 Jack Woychowski. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    private let segueAddSessionViewController = "SegueAddSessViewController"

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var activeInd: UIActivityIndicatorView!

    private let persCont = NSPersistentContainer(name: "iPushEmUp")

    /*
 lazy var mOC: NSManagedObjectContext = {
        guard let appD = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("No appDelegate?")
        }
        let moc = appD.persistentContainer.viewContext
        print("Moc: \(moc)")
        return moc
    }()
 */

    fileprivate lazy var fetchedResCtrl: NSFetchedResultsController<Session> = {
        let fR: NSFetchRequest<Session> = Session.fetchRequest()
        fR.sortDescriptors = [NSSortDescriptor(key: "dateTime", ascending: false)]
        print("FR: \(fR)")
        print("THE moc: \(self.persCont.viewContext)")
        let frC = NSFetchedResultsController(fetchRequest: fR, managedObjectContext: self.persCont.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        frC.delegate = self
        print("Frc: \(frC)")
        return frC
    }()

    //var names: [String] = []
    /* var sessions: [Session] = [] */

    override func viewDidLoad() {
        super.viewDidLoad()
        persCont.loadPersistentStores(completionHandler: { (storeDesc, error) in
            if let error = error {
                print("Unable to load persistent store")
                print("\(error): \(error.localizedDescription)")
            } else {
                print("Persistent store loaded")

                do {
                    try self.fetchedResCtrl.performFetch()
                } catch {
                    let fetchErr = error as NSError
                    print("Unable to perform fetch")
                    print("\(fetchErr) - \(fetchErr.localizedDescription)")
                }
                self.setupView();
            }
        })
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground(_:)), name: Notification.Name.UIApplicationDidEnterBackground, object: nil)
        title = "Da List"
    }

    fileprivate func updateView() {
        activeInd.stopAnimating()
    }

    private func setupView() {
        updateView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /*
        guard let appD = UIApplication.shared.delegate as? AppDelegate else { return }
        let moc = appD.persistentContainer.viewContext
        let fR = NSFetchRequest<Session>(entityName: "Session")
        do {
            sessions = try moc.fetch(fR)
        } catch let error as NSError {
            print("Unable to fetch: \(error) - \(error.userInfo)")
        }
         */
    }

    private func saveCtx() {
        print("saveCtx")
        do {
            try persCont.viewContext.save()
        } catch let error as NSError {
            print("Failed to persist changes: \(error)")
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueAddSessionViewController {
            if let destViewCtrl = segue.destination as? addSessionViewController {
                print("set destView.moc to \(persCont.viewContext)")
                destViewCtrl.moc = persCont.viewContext
            }
        } else {
            print("Unidentified segue: \(String(describing: segue.identifier))")
        }
    }

    /*
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
     */

    // MARK: - Notification Handling
    @objc func appDidEnterBackground(_ notification: Notification) {
        saveCtx()
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sesses = fetchedResCtrl.fetchedObjects else { return 0 }
        return sesses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // let sess = sessions[indexPath.row]
        guard let cell = tblView.dequeueReusableCell(withIdentifier: SessTableViewCell.reuseId, for: indexPath) as? SessTableViewCell else {
            fatalError("Unexpected Index Path")
        }

        let sess = fetchedResCtrl.object(at: indexPath)
        let theDate = sess.dateTime
        print("date \(String(describing: theDate))")
        let df = DateFormatter()
            df.dateFormat = "MM/dd/yy hh:mm"
            //cell.textLabel?.text = df.string(from:theDate!) + ": \(sess.count)"
            cell.dateLabel.text = df.string(from:theDate!)
            cell.countLabel.text = "\(sess.count)"
            return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("delete at \(indexPath)")
            let sess = fetchedResCtrl.object(at: indexPath)
            sess.managedObjectContext?.delete(sess)
            saveCtx()
        }
        print("edit \(editingStyle) at \(indexPath)")
    }
}

extension Date {
    func format(format:String = "MM/dd/yyyy hh:mm:ss") -> Date {
        let dF = DateFormatter();
        dF.dateFormat = format
        let dateStr = dF.string(from: self)
        if let newDate = dF.date(from:dateStr) {
            return newDate
        } else {
            return self
        }
    }
}

extension ViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tblView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tblView.endUpdates()
        updateView()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tblView.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            if let idxPath = indexPath {
                tblView.deleteRows(at: [idxPath], with: .fade)
            }
            break;
        default:
            print("...TBD...")
        }
    }
}

