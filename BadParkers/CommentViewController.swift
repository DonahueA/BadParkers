//
//  CommentViewController.swift
//  
//
//  Created by Donahue Avila on 4/7/18.
//

import UIKit

class CommentViewController: UIViewController {
    
    let authors = ["Donahue", "Angi", "Donahue"]
    let comments = ["Hi", "Hey" , "hoi"]
    
    @IBOutlet var CommentTable: UITableView!
    @IBOutlet var Image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CommentTable.delegate = self
        CommentTable.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension CommentViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return authors.count
    }

    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath)
        cell.textLabel?.text = authors[indexPath.row]
        cell.detailTextLabel?.text = comments[indexPath.row]
        return cell
    }
    
    
}
