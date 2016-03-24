//
//  MasterViewController.swift
//  itunesHttpSample
//
//  Created by Alex Chen on 2016/3/23.
//  Copyright © 2016年 Alex.Chen. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var detailViewController: DetailViewController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil
    var musics: [Music] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.registerNib(UINib(nibName: "MusicCell", bundle: nil), forCellReuseIdentifier: "MusicCell")


        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        self.navigationItem.rightBarButtonItem = addButton

        iTunesService.sharedInstance.search("Swift") { (items) -> Void in
            self.musics = items
            self.tableView.reloadData()
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.estimatedRowHeight = 100.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                //let object = self.fetchedResultsController.objectAtIndexPath(indexPath)
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                //controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100.0
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.musics.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell: MusicCell = tableView.dequeueReusableCellWithIdentifier("MusicCell") as! MusicCell

        cell.titleLabel.text = self.musics[indexPath.row].trackCensoredName
        cell.subtitleLabel.text = "\(self.musics[indexPath.row].artistName) - \(self.musics[indexPath.row].collectionCensoredName)"
        cell.musicImageView.image = UIImage(data: self.musics[indexPath.row].artworkUrl)

        return cell
    }

    // MARK: - UITableViewDelegate Methods
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: DetailViewController = storyboard.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        vc.previewUrl = self.musics[indexPath.row].previewUrl
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

