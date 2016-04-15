//
//  ViewController.swift
//  HitList
//
//  Created by ysj on 16/4/15.
//  Copyright © 2016年 newbieYin. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource {

    var people = [NSManagedObject]()
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addName(sender: AnyObject) {
        let alertVC = UIAlertController.init(title: "New Name", message: "Add a new name", preferredStyle: .Alert)
        let saveAction = UIAlertAction.init(title: "Save", style: .Default) { (action: UIAlertAction) -> Void in
            let textField = alertVC.textFields?.first
            let newPeople = NSEntityDescription.insertNewObjectForEntityForName("People", inManagedObjectContext: self.context())
            
            newPeople.setValue(textField?.text, forKey: "name")
            do {
                try self.context().save()
                self.people.append(newPeople)
            } catch let error as NSError {
                print(error.userInfo)
            }
            
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .Default) { (action: UIAlertAction) -> Void in
        }
        alertVC.addTextFieldWithConfigurationHandler { (textField: UITextField) -> Void in
        }
        alertVC.addAction(saveAction)
        alertVC.addAction(cancelAction)
        presentViewController(alertVC, animated: true) { () -> Void in
        }
    }
    
    func context() -> NSManagedObjectContext {
        let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        return (appDelegate?.managedObjectContext)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\"Hit List\""
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let fetchRequest = NSFetchRequest.init(entityName: "People")
        do {
            let fetchResult = try context().executeFetchRequest(fetchRequest)
            people = fetchResult as! [NSManagedObject]
        } catch let error as NSError {
            print(error.userInfo)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel?.text = people[indexPath.row].valueForKey("name") as? String
        return cell
    }


}

