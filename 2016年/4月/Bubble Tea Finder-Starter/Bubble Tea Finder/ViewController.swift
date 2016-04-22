//
//  ViewController.swift
//  Bubble Tea Finder
//
//  Created by Pietro Rea on 8/24/14.
//  Copyright (c) 2014 Pietro Rea. All rights reserved.
//

import UIKit
import CoreData

let filterViewControllerSegueIdentifier = "toFilterViewController"
let venueCellIdentifier = "VenueCell"

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var coreDataStack: CoreDataStack!
    var fetchRequest: NSFetchRequest!
    var venues: [Venue]!
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchRequest = coreDataStack.context.persistentStoreCoordinator!.managedObjectModel.fetchRequestTemplateForName("FetchRequest")
        fetchAndReload()
    }
    
    func fetchAndReload() {
        do {
            venues = try coreDataStack.context.executeFetchRequest(fetchRequest) as! [Venue]
//            tableView.reloadData()
        } catch let error as NSError {
            print("fetch error \(error.userInfo)")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == filterViewControllerSegueIdentifier {
            let navi = segue.destinationViewController as! UINavigationController
            let filterVC = navi.topViewController as! FilterViewController
            filterVC.coreDataStack = coreDataStack
        }
    }
    
    @IBAction func unwindToVenuListViewController(segue: UIStoryboardSegue) {
        
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return venues.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(venueCellIdentifier)!
        cell.textLabel!.text = venues[indexPath.row].name
        cell.detailTextLabel!.text = venues[indexPath.row].priceInfo?.priceCategory
        
        return cell
    }
}
