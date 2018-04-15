//
//  CommentViewController.swift
//  
//
//  Created by Donahue Avila on 4/7/18.
//

import UIKit
import Firebase

class CommentViewController: UIViewController {
    

    
    @IBOutlet var CommentTable: UITableView!
    @IBOutlet var Image: UIImageView!
    
    var dataId: String?
    
    var comments: [Comment] = []
    
    var colRef: CollectionReference!
    var quoteListener: ListenerRegistration!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        colRef = Firestore.firestore().collection("photoLocations/\(dataId!)/comments/")
        quoteListener = colRef.addSnapshotListener({ (QuerySnapshot, Error) in
            if let err = Error {
                print("Error getting documents: \(err)")
            } else {
                self.comments.removeAll() // TODO: Figure out how to make QuerySnapshot not retrievew all documents if we already retrieved them.
                for document in QuerySnapshot!.documents {
                    if let newAuthor = document.data()["Author"] as? String, let newComment = document.data()["Comment"] as? String, let newDate = document.data()["Date"] as? Date {
                        self.comments.append(Comment(Author: newAuthor, Comment: newComment, date: newDate))
                    }
                }

            }
            self.comments.sort(by: >)
            self.CommentTable.reloadData() //I dont think this is a memory cycle
        })
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        CommentTable.delegate = self
        CommentTable.dataSource = self
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        quoteListener.remove()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier == "commentCreation", let modal = segue.destination as? CommentCreationViewController {
            modal.dataId = dataId
        }
    }

}

extension CommentViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath)
        cell.textLabel?.text = comments[indexPath.row].Author
        cell.detailTextLabel?.text = comments[indexPath.row].Comment
        return cell
    }
}
