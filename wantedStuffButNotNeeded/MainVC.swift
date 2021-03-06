//
//  ViewController.swift
//  wantedStuffButNotNeeded
//
//  Created by Chase McElroy on 7/8/16.
//  Copyright © 2016 Chase McElroy. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    var fetchedResultsController: NSFetchedResultsController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // generateTestData()
        attemptFetch()
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 132
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as! ItemCell
        configureCell(cell, indexPath: indexPath)
        
        return cell
    }
    
    func configureCell(cell: ItemCell, indexPath: NSIndexPath) {
        if let item = fetchedResultsController.objectAtIndexPath(indexPath) as? Item {
            //update data
            cell.configureCell(item)
        }
    }
    
    func attemptFetch() {
        setFetchedResults()
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let error = error as NSError
            print("\(error), \(error.userInfo)")
        }
        
    }
    
    func setFetchedResults() {
        let section: String? = segment.selectedSegmentIndex == 1 ? "store.name" : nil
        
        let fetchRequest = NSFetchRequest(entityName: "Item")
        
        let sortDescriptor = NSSortDescriptor(key: "created", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: ad.managedObjectContext, sectionNameKeyPath: section, cacheName: nil)
        
        controller.delegate = self
        
        fetchedResultsController = controller
        
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
        case .Insert:
            if let indexPath = newIndexPath {
                tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            break
        case .Delete:
            if let indexPath = indexPath {
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            break
        case .Update:
            if let indexPath = indexPath {
                let cell = tableView.cellForRowAtIndexPath(indexPath) as! ItemCell
                // update cell data
                configureCell(cell, indexPath: indexPath)
            }
            break
        case .Move:
            if let indexPath = indexPath {
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            
            if let newIndexPath = newIndexPath {
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
            }
            break
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let objs = fetchedResultsController.fetchedObjects where objs.count > 0{
            let item = objs[indexPath.row] as! Item
            
            performSegueWithIdentifier("ItemDetailsVC", sender: item)
            
        }
    }
    
    func generateTestData() {
        let item = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: ad.managedObjectContext) as! Item
        
        item.title = "Cool Lego Set"
        item.price = 49.99
        item.details = "This is super cool and I want itt sooo bad!"
        
        let item2 = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: ad.managedObjectContext) as! Item
        
        item2.title = "USB Cable"
        item2.price = 149.99
        item2.details = "What!!! So pricey!!"
        
        let item3 = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: ad.managedObjectContext) as! Item
        
        item3.title = "R8 Auddi"
        item3.price = 4900000
        item3.details = "Best car ever!!!!!!"
        
        ad.saveContext()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ItemDetailsVC" {
            let vc = segue.destinationViewController as! ItemDetailsVC
            vc.itemToEdit = sender as? Item
        }
    }


}

