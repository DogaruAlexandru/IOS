//
//  PeopleTableViewController.swift
//  CD People Table
//
//  Created by student on 23.04.2024.
//

import UIKit
import CoreData

class PeopleTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    //MARK: - CD methods and actions
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var peopleManagedObject : CDPeople!
    var peopleEntity : NSEntityDescription!
    var frc : NSFetchedResultsController<NSFetchRequestResult>!
    
    func makeRequest() -> NSFetchRequest<NSFetchRequestResult> {
        // define where to request
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CDPeople")
        
        // make sorters and predicates
        let sorter1 = NSSortDescriptor(key: "name", ascending: true)
        let sorter2 = NSSortDescriptor(key: "phone", ascending: true)
        
        request.sortDescriptors = [sorter1, sorter2]
        
        return request
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // make frc and its delegate
        frc = NSFetchedResultsController(fetchRequest: makeRequest(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        
        // perform fetch
        do {
            try frc.performFetch()
        } catch {
            print("FRC cannot fatch")
        }
        
    }

    //MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return frc.sections!.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return frc.sections![section].numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // get peopleManagedObject
        peopleManagedObject = frc.object(at: indexPath) as! CDPeople
        
        // Configure the cell...
        cell.textLabel?.text = peopleManagedObject.name
        cell.detailTextLabel?.text = peopleManagedObject.phone
        
        // get image from documents
        let image = getImage(name: peopleManagedObject.address!)
        cell.imageView?.image = image

        return cell
    }
    
    func getImage(name: String) -> UIImage! {
        // get the path to documents
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let imagePath = path.appendingPathComponent(name)
        
        return UIImage(contentsOfFile: imagePath)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            peopleManagedObject = frc.object(at: indexPath) as! CDPeople
            context.delete(peopleManagedObject)
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "cellSegue" {
            // Get the new view controller using segue.destination.
            let destination = segue.destination as! AddUpdateViewController
            
            // get indexPath of sender and find its data
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
            peopleManagedObject = frc.object(at: indexPath!) as! CDPeople
            
            // Pass the selected object to the new view controller.
            destination.peopleManagedObject = peopleManagedObject
        }
    }

}
