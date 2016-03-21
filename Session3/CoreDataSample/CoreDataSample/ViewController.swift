//
//  ViewController.swift
//  CoreDataSample
//
//  Created by Alex Chen on 2016/3/21.
//  Copyright © 2016年 Alex.Chen. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var addTextField: UITextField!
    @IBOutlet weak var qureyTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!

    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    var users: [User] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        getUsers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func RefreshButton(sender: AnyObject) {
        getUsers()
    }

    @IBAction func addButtonTochDown(sender: AnyObject) {

        let product = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: self.managedObjectContext) as! User

        product.id = self.users.count + 1
        product.name = self.addTextField.text!

        do{
            try managedObjectContext.save()
        } catch {
            print(error)
        }

        getUsers()

        self.addTextField.text = ""
    }


    func getUsers() {
        let request = NSFetchRequest(entityName: "User")

        if qureyTextField.text != "" {

            request.predicate = NSPredicate(format: "id == %@", qureyTextField.text!)
        }

        do {
            users = try managedObjectContext.executeFetchRequest(request) as! [User]
            self.tableView.reloadData()

        }catch{
            fatalError("Failed to fetch data: \(error)")
        }
    }

    func deleteUser(index: Int) {
        self.managedObjectContext.deleteObject(self.users[index])
        do {
            try self.managedObjectContext.save()
            self.users.removeAtIndex(index)
        }catch{
            fatalError("Failure to save context: \(error)")
        }
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.text = self.users[indexPath.row].name
        cell.detailTextLabel?.text = "\(self.users[indexPath.row].id)"
        return cell
    }


    // Override to support conditional editing of the table view.
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            self.deleteUser(indexPath.row)
            self.tableView.reloadData()
        }
    }

    // Override to support conditional rearranging of the table view.
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }

}

