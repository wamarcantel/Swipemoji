//
//  CustomDictionaryViewController.swift
//  SwipemojiKeyboard
//
//  Created by Takashi Wickes on 3/21/17.
//  Copyright © 2017 swipemoji. All rights reserved.
//

import UIKit

class CustomDictionaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var _library = PointCloudLibrary.getDemoLibrary()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _library.pointClouds.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dictionaryEntryCell", for: indexPath) as! DictionaryEntryTableViewCell
        cell.emojiLabel.text = _library.pointClouds[indexPath.row].name
        
        return cell
    }
    
//    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == .delete {
//            self.dawgs.removeAtIndex(indexPath.row)
//            self.tableView.reloadData()
//        }
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
