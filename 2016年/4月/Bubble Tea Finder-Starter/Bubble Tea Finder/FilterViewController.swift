//
//  FilterViewController.swift
//  Bubble Tea Finder
//
//  Created by Pietro Rea on 8/27/14.
//  Copyright (c) 2014 Pietro Rea. All rights reserved.
//

import UIKit
import CoreData

class FilterViewController: UITableViewController {
    
    @IBOutlet weak var firstPriceCategoryLabel: UILabel!
    @IBOutlet weak var secondPriceCategoryLabel: UILabel!
    @IBOutlet weak var thirdPriceCategoryLabel: UILabel!
    @IBOutlet weak var numDealsLabel: UILabel!
    
    //Price section
    @IBOutlet weak var cheapVenueCell: UITableViewCell!
    @IBOutlet weak var moderateVenueCell: UITableViewCell!
    @IBOutlet weak var expensiveVenueCell: UITableViewCell!
    
    //Most popular section
    @IBOutlet weak var offeringDealCell: UITableViewCell!
    @IBOutlet weak var walkingDistanceCell: UITableViewCell!
    @IBOutlet weak var userTipsCell: UITableViewCell!
    
    //Sort section
    @IBOutlet weak var nameAZSortCell: UITableViewCell!
    @IBOutlet weak var nameZASortCell: UITableViewCell!
    @IBOutlet weak var distanceSortCell: UITableViewCell!
    @IBOutlet weak var priceSortCell: UITableViewCell!
    
    var coreDataStack: CoreDataStack!
    lazy var cheapVenuePredicate: NSPredicate = {
        return NSPredicate(format: "priceInfo.priceCategory == %@", "$")
    }()
    lazy var moderateVenuePredicate: NSPredicate = {
        return NSPredicate(format: "priceInfo.priceCategory == %@", "$$")
    }()
    
    func populateCheapVenueCountLabel() {
        let cheapVenueFetchRequest = NSFetchRequest(entityName: "Venue")
        cheapVenueFetchRequest.predicate = cheapVenuePredicate
        cheapVenueFetchRequest.resultType = .CountResultType
        do {
            let results = try coreDataStack.context.executeFetchRequest(cheapVenueFetchRequest) as! [NSNumber]
            let count = results.first?.integerValue
            firstPriceCategoryLabel.text = "\(count ?? 0) bubble tea places"
        } catch let error as NSError {
            print("error \(error.localizedDescription)")
        }
    }
    
    func populateModerateVenueCountLabel() {
        let moderateFetchRequest = NSFetchRequest(entityName: "Venue")
        moderateFetchRequest.predicate = moderateVenuePredicate
        moderateFetchRequest.resultType = .CountResultType
        do {
            let results = try coreDataStack.context.executeFetchRequest(moderateFetchRequest) as! [NSNumber]
            
            let count = results.first?.integerValue
            secondPriceCategoryLabel.text = "\(count ?? 0) bubble tea places"
        } catch let error as NSError {
            print("error \(error.localizedDescription)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateCheapVenueCountLabel()
        populateModerateVenueCountLabel()
    }
    
    //MARK - UITableViewDelegate methods
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    // MARK - UIButton target action
    
    @IBAction func saveButtonTapped(sender: UIBarButtonItem) {
        
        dismissViewControllerAnimated(true, completion:nil)
    }
}
