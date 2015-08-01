//
//  AudioTableViewController.swift
//  Voice Changer
//
//  Created by Luke on 2015/08/01.
//  Copyright (c) 2015年 Luke Tunnicliffe. All rights reserved.
//


import UIKit

class AudioTableViewController: UITableViewController {
    
    var previousData = [String]()
    
    override func viewWillAppear(animated: Bool) {
        loadData()
    }
    
    func loadData(){
        if audioAlreadyExists() == true {
            previousData = NSUserDefaults.standardUserDefaults().objectForKey("audio") as! [String]!
        }
        self.tableView.reloadData()
    }
    
    func audioAlreadyExists() -> Bool {
        if (NSUserDefaults.standardUserDefaults().objectForKey("audio") != nil) {
            return true
        }else {
            return false
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return previousData.count
    }
    
    func saveData(){
        NSUserDefaults.standardUserDefaults().setObject(previousData, forKey: "audio")
    }
    
//    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == UITableViewCellEditingStyle.Delete {
//            let fileName = previousData[indexPath.row]
//            let fileManager = NSFileManager.defaultManager()
//            let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
//            let pathArray = [dirPath, fileName]
//            let filePath = dirPath.stringByAppendingPathComponent(fileName)
//            var error: NSError
//            let success:Bool = fileManager.removeItemAtPath(filePath, error: &error)
//            if success{
//                previousData.removeAtIndex(indexPath.row)
//                saveData()
//            }
//        }
//    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AudioCell", forIndexPath: indexPath) as! UITableViewCell
        let cellInfoToBeUsed = previousData[indexPath.row]
        cell.textLabel?.text = cellInfoToBeUsed
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("PlaySoundsViewController") as! PlaySoundsViewController
        let fileName = previousData[indexPath.row]
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        let pathArray = [dirPath, fileName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        let recordedAudio = RecordedAudio(title: fileName, filePathUrl: filePath!)
        println(fileName)
        println(filePath)
        detailController.receivedAudio = recordedAudio
        self.navigationController!.pushViewController(detailController, animated: true)
    }
}

