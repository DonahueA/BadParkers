//
//  CommentViewController.swift
//  
//
//  Created by Donahue Avila on 4/7/18.
//

import UIKit
import Firebase

class CommentViewController: UIViewController{
    

    
    @IBOutlet var CommentTable: UITableView!
    @IBOutlet var Image: UIImageView!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet var commentTextfield: UITextField!
    @IBOutlet var commentHeight: NSLayoutConstraint!
    
    var dataId: String?
    var imageReference: String?
    var comments: [Comment] = []
    
    let storage = Storage.storage()
    var colRef: CollectionReference!
    var quoteListener: ListenerRegistration!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let pathReference = storage.reference(withPath: imageReference!)
        pathReference.getData(maxSize: 1024*1024*10) { [weak self] (data, error) in
            if error != nil {
                print("Error downloading image icon")
            } else {
                self?.Image.image = UIImage(data: data!)
                self?.loadingIndicator.stopAnimating()
                self?.Image.isHidden = false
            }
        }
        
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
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification
            , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        commentTextfield.delegate = self
        CommentTable.delegate = self
        CommentTable.dataSource = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        quoteListener.remove()
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let duration = notification.userInfo?["UIKeyboardAnimationDurationUserInfoKey"] as? Double, let curve = notification.userInfo?["UIKeyboardAnimationCurveUserInfoKey"] as? UInt, let height = (notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? NSValue)?.cgRectValue.height{
            UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: curve), animations: {[weak self] in self?.commentHeight.constant = height; self?.view.layoutIfNeeded()}, completion: nil)
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        commentHeight.constant = 0
    }
    

}

extension CommentViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath)
        cell.textLabel?.text = comments[indexPath.row].Author
        cell.detailTextLabel?.lineBreakMode = .byWordWrapping
        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = comments[indexPath.row].Comment
        return cell
    }
}

extension CommentViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        commentTextfield.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, text.count > 0 {
            colRef.addDocument(data: ["Author": "Anonymous", "Comment" : text, "Date" : Date() ])
            textField.text! = ""
        }
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textLength = textField.text!.count + string.count
        return textLength <= 140
    }
    
}
