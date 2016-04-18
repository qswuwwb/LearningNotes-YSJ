//
//  ViewController.swift
//  BowTies
//
//  Created by ysj on 16/4/16.
//  Copyright © 2016年 newbieYin. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    var context: NSManagedObjectContext!
    var currentBowTie: BowTie!
    
    @IBOutlet weak var segementControl: UISegmentedControl!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var timesWornLabel: UILabel!
    
    @IBOutlet weak var lastWornLabel: UILabel!
    
    @IBOutlet weak var favoriteLabel: UILabel!
    
    @IBAction func segmentedControl(sender: UISegmentedControl) {
        do {
            let results = try fetchResults(sender.titleForSegmentAtIndex(sender.selectedSegmentIndex)!)
            currentBowTie = results.first
            populate(currentBowTie)
        } catch let error as NSError {
            print(error.userInfo)
        }
    }
    
    @IBAction func wear(sender: UIButton) {
        currentBowTie.lastWorn = NSDate()
        let intValue = currentBowTie.timesWorn?.integerValue
        currentBowTie.timesWorn = NSNumber(integer: intValue! + 1)
        do {
            try context.save()
            populate(currentBowTie)
        } catch let error as NSError {
            print("Save failed \(error.localizedDescription)")
        }
    }
    
    @IBAction func rate(sender: AnyObject) {
        let alertController = UIAlertController.init(title: "New Rating", message: "Rate this bow tie", preferredStyle: .Alert)
        let saveAction = UIAlertAction.init(title: "Save", style: .Default) { (action: UIAlertAction) -> Void in
            let ratingString = alertController.textFields?.first?.text
            self.currentBowTie.rating = NSNumber(double: Double(ratingString!)!)
            
        }
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .Default) { (action: UIAlertAction) -> Void in
            self.updateRating()
        }
        alertController.addTextFieldWithConfigurationHandler { (textField: UITextField) -> Void in
            textField.keyboardType = .NumberPad
        }
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true) { () -> Void in
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        insertSampleData()
        
        do {
            let results = try fetchResults(segementControl.titleForSegmentAtIndex(0)!)
            currentBowTie = results.first
            populate(currentBowTie)
        }
        catch let error as NSError {
            print("Fetch error: \(error.localizedDescription) \n in the view controller")
        }
    }
    
    func fetchResults(searchKey: String) throws -> [BowTie] {
        let fetchRequest = NSFetchRequest.init(entityName: "BowTie")
        fetchRequest.predicate = NSPredicate.init(format: "searchKey == %@", searchKey)
        do {
            let results = try context.executeFetchRequest(fetchRequest) as! [BowTie]
            return results
        } catch let error as NSError {
            throw error
        }
    }
    
    func insertSampleData() {
        let fetchRequest = NSFetchRequest.init(entityName: "BowTie")
        fetchRequest.predicate = NSPredicate.init(format: "searchKey != nil", argumentArray: nil)
        
        if context.countForFetchRequest(fetchRequest, error: nil) != 0 {
            return
        }else {
            let path = NSBundle.mainBundle().pathForResource("SampleData", ofType: "plist")
            let bowTies = NSArray(contentsOfFile: path!)
            if let _ = bowTies {
                for bowTieInfo in bowTies! {
                    let newBowTie = NSEntityDescription.insertNewObjectForEntityForName("BowTie", inManagedObjectContext: context) as! BowTie
                    let dic = bowTieInfo as! NSDictionary
                    
                    newBowTie.name = dic["name"] as? String
                    newBowTie.rating = dic["rating"] as? NSNumber
                    newBowTie.searchKey = dic["searchKey"] as? String
                    newBowTie.timesWorn = dic["timesWorn"] as? NSNumber
                    newBowTie.lastWorn = dic["lastWorn"] as? NSDate
                    newBowTie.isFavorite = dic["isFavorite"] as? Bool
                    newBowTie.imageName = dic["imageName"] as? String
                    
                    let tintColorDic = dic["tintColor"] as? NSDictionary
                    newBowTie.tintColor = colorFromDic(tintColorDic!)
                    
                    let image = UIImage(named: newBowTie.imageName!)
                    let photoData = UIImagePNGRepresentation(image!)
                    newBowTie.photoData = photoData
                }
            } else {
                print("SampleData.plist转出的数组是空啊")
            }
            
            
            
            
            
        }
        
    }
    
    func colorFromDic(RGBDic: NSDictionary) -> UIColor {
        let red = RGBDic["red"] as? NSNumber
        let green = RGBDic["green"] as? NSNumber
        let blue = RGBDic["blue"] as? NSNumber
        
        
        let color = UIColor.init(red: CGFloat(red!) / 255.0,
            green: CGFloat(green!) / 255.0,
            blue: CGFloat(blue!) / 255.0,
            alpha: 1)
        return color
    }
    
    func populate(bowTie: BowTie) {
        imageView.image = UIImage(data: bowTie.photoData!)
        nameLabel.text = bowTie.name
        ratingLabel.text = "Rating: " + (bowTie.rating?.stringValue)! + "/5"
        timesWornLabel.text = "Times worn: " + (bowTie.timesWorn?.stringValue)!
        
        let formatter = NSDateFormatter.init()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .NoStyle
        lastWornLabel.text = "Last worn: " + formatter.stringFromDate(bowTie.lastWorn!)
        favoriteLabel.hidden = !(bowTie.isFavorite?.boolValue)!
        view.tintColor = bowTie.tintColor as! UIColor
    }
    
    func updateRating() {
        do {
            try self.context.save()
            self.populate(self.currentBowTie)
        } catch let error as NSError {
            if error.domain == NSCocoaErrorDomain && (error.code == NSValidationNumberTooLargeError || error.code == NSValidationNumberTooSmallError) {
                rate("heheda")
            }
            print("Save failed \(error.localizedDescription)")
        }
    }
}

