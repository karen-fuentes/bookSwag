//
//  AddBookViewController.swift
//  bookSwag
//
//  Created by Karen Fuentes on 5/20/17.
//  Copyright © 2017 Karen Fuentes. All rights reserved.
//

import UIKit

class AddBookViewController: UIViewController {
    let stackView = UIStackView()
    var endPoint = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red:0.54, green:0.77, blue:0.96, alpha:1.0)
        self.title = "Add Book"
        self.navigationItem.setHidesBackButton(true , animated: true)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(doneButtonWasPressed))
        submitButton.addTarget(self, action: #selector(submitButtonWasPressed), for: .touchUpInside)
        self.navigationController?.navigationBar.tintColor = .clear 
        viewHiearchy()
        configureConstraint()
    }
    
    func doneButtonWasPressed() {
        self.dismiss(animated: true , completion: nil)
    }
    func submitButtonWasPressed(){
        if let title = titleTextField.text,
            let publisher = publisherTextField.text,
            let author = authorTextField.text,
            let categories = categoriesTextField.text {
            let postData:[String:Any] = [
                "title": "\(title)",
                "author": "\(author)",
                "publisher": "\(publisher)",
                "categories": "\(categories)"
            ]
            NetworkRequestManager.manager.makeRequest(to: endPoint, method: .post, body: postData, completion: { (data) in
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Successful 🎉", message: "You have successfuly saved this book", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (alert) in
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
       
    }
    
    //MARK: - Constraint Config.
    
    func configureConstraint() {
        self.edgesForExtendedLayout = []
        stackView.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        authorTextField.translatesAutoresizingMaskIntoConstraints = false
        publisherTextField.translatesAutoresizingMaskIntoConstraints = false
        categoriesTextField.translatesAutoresizingMaskIntoConstraints = false
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        
        let _ = [
            stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40.0),
            
            titleTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8),
            titleTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8),
            titleTextField.heightAnchor.constraint(equalToConstant: 40),
            
            authorTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8),
            authorTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8),
            authorTextField.heightAnchor.constraint(equalToConstant: 40),
            
            publisherTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8),
            publisherTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8),
            publisherTextField.heightAnchor.constraint(equalToConstant: 40),
            
            categoriesTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8),
            categoriesTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8),
            categoriesTextField.heightAnchor.constraint(equalToConstant: 40),
            
            submitButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            submitButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            submitButton.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.25),
            ].map({$0.isActive = true})
    }
    
    // MARK: - ViewHiearchy
    
    func viewHiearchy() {
        stackView.axis  = UILayoutConstraintAxis.vertical
        stackView.distribution  = UIStackViewDistribution.equalSpacing
        stackView.alignment = UIStackViewAlignment.center
        stackView.spacing = 16.0
        
        stackView.addArrangedSubview(titleTextField)
        stackView.addArrangedSubview(authorTextField)
        stackView.addArrangedSubview(publisherTextField)
        stackView.addArrangedSubview(categoriesTextField)
        
        self.view.addSubview(stackView)
        self.view.addSubview(submitButton)
    }
    
    lazy var titleTextField: UITextField = {
        let txtField = UITextField()
        txtField.placeholder = "Title"
        txtField.backgroundColor = .white
        txtField.textAlignment = .center
        txtField.borderStyle = .line
        return txtField
    }()
    lazy var authorTextField: UITextField = {
        let txtField = UITextField()
        txtField.placeholder = "Author"
        txtField.backgroundColor = .white
        txtField.textAlignment = .center
        txtField.borderStyle = .line
        return txtField
    }()
    lazy var publisherTextField: UITextField = {
        let txtField = UITextField()
        txtField.placeholder = "Publisher"
        txtField.backgroundColor = .white
        txtField.textAlignment = .center
        txtField.borderStyle = .line
        return txtField
    }()
    lazy var categoriesTextField: UITextField = {
        let txtField = UITextField()
        txtField.placeholder = "Categories"
        txtField.backgroundColor = .white
        txtField.textAlignment = .center
        txtField.borderStyle = .line
        return txtField
    }()
    lazy var submitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Submit", for: .normal)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.backgroundColor = .clear
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red:0.29, green:0.47, blue:0.75, alpha:1.0)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        return button
    }()
}
