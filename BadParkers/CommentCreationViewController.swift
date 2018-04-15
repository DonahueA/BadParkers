//
//  CreateCommentViewController.swift
//  BadParkers
//
//  Created by Donahue Avila on 4/15/18.
//  Copyright © 2018 Donahue Avila. All rights reserved.
//

import UIKit
import Firebase

class CommentCreationViewController: UIViewController {

    @IBOutlet var modalView: UIView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var commentTextView: UITextView!

    @IBOutlet var warningLabel: UILabel!
    
    @IBAction func submitButton(_ sender: Any) {
        if (commentTextView.text.isEmpty) {
            warningLabel.isHidden = false
        } else {
            let name = (nameTextField.text?.isEmpty)! ? "Anonymous" : nameTextField.text!
            print(name)
            colRef.addDocument(data: ["Author": name, "Comment" : commentTextView.text, "Date" : Date() ])
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    var colRef : CollectionReference!
    var dataId : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colRef = Firestore.firestore().collection("photoLocations/\(dataId!)/comments/")
        nameTextField.delegate = self
        commentTextView.delegate = self
        modalView.layer.cornerRadius = modalView.layer.bounds.width * 0.05
    }

    
}

extension CommentCreationViewController : UITextViewDelegate, UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textLength = textField.text!.count + string.count
        return textLength <= 10
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let textLength = textView.text!.count + text.count
        return textLength <= 50
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
}
