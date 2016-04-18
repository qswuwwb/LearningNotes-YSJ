//
//  ViewController.swift
//  Dog Walk
//
//  Created by Pietro Rea on 7/17/15.
//  Copyright © 2015 Razeware. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource {
    
    lazy var dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .MediumStyle
        return formatter
    }()
    
    lazy var fetchRequest: NSFetchRequest = {
        let request = NSFetchRequest.init(entityName: "Dog")
        let dogName = "Fido"
        request.predicate = NSPredicate.init(format: "name == %@", dogName)
        return request
    }()
    var context: NSManagedObjectContext!
    var currentDog: Dog!
    @IBOutlet var tableView: UITableView!
    var walks:Array<NSDate> = []
    override func viewDidLoad() {
        super.viewDidLoad()
        let dogEntity = NSEntityDescription.entityForName("Dog", inManagedObjectContext: context)
        do {
            let results = try context.executeFetchRequest(fetchRequest) as! [Dog]
            if results.count > 0 {
                currentDog = results.first
            } else {
                let newDog = Dog.init(entity: dogEntity!, insertIntoManagedObjectContext: context)
                newDog.name = "Fido"
                try context.save()
            }
            
        } catch let error as NSError {
            print("error execute fetch request or save \(error.localizedDescription)")
        }
        
        
        tableView.registerClass(UITableViewCell.self,
            forCellReuseIdentifier: "Cell")
    }
    
    
    
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            if let _ = currentDog.walks{
                return currentDog.walks!.count
            }
            return 0
    }
    
    func tableView(tableView: UITableView,
        titleForHeaderInSection section: Int) -> String? {
            return "List of Walks"
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
            
            let cell =
            tableView.dequeueReusableCellWithIdentifier("Cell",
                forIndexPath: indexPath) as UITableViewCell
            
            let date =  currentDog.walks![indexPath.row].date!
            cell.textLabel!.text = dateFormatter.stringFromDate(date!)
            
            return cell
    }
    
    @IBAction func add(sender: AnyObject) {
        let newWalk = NSEntityDescription.insertNewObjectForEntityForName("Walk", inManagedObjectContext: context) as! Walk
        newWalk.date = NSDate()
        let walks = currentDog.walks?.mutableCopy()
        walks?.addObject(newWalk)
        currentDog.walks = walks?.copy() as? NSOrderedSet
        do {
            try context.save()
        } catch let error as NSError {
            print("error \(error.localizedDescription)")
        }
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let walkToRemove = currentDog.walks![indexPath.row] as! Walk
            context.deleteObject(walkToRemove)
            do {
                try context.save()
            } catch let error as NSError {
                print("error save\(error.localizedDescription)")
            }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
}

