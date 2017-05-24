//
//  BookDetailViewController.swift
//  bookSwag
//
//  Created by Karen Fuentes on 5/21/17.
//  Copyright © 2017 Karen Fuentes. All rights reserved.
//

import UIKit
import Social

class BookDetailViewController: UIViewController {
    var selectedBook: Book!
    let stackView = UIStackView()
    var endPoint = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "Detail"
        setUpViews()
        configureConstraints()
        self.titleLabel.text = selectedBook.title
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ShareIcon"), style: .plain, target: self, action: #selector (shareButtonWasPressed))
        self.authorLabel.text = selectedBook.author
        self.publisherLabel.text = selectedBook.publisher
        self.categoriesLabel.text = selectedBook.catrgoires
        self.lastCheckedOutByLabel.text = selectedBook.lastCheckedOutBy!
        self.lastCheckedOutLabel.text = selectedBook.lastCheckedOut!
        checkoutButton.addTarget(self, action: #selector(checkoutButtonWasPressed), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteButtonWasPressed), for: .touchUpInside)
    }
    
    
    // MARK: - Button Methods
    
    func shareButtonWasPressed() {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
            let socialController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            socialController?.setInitialText("Check out this book: \(selectedBook.title!)")
            socialController?.add(URL(string: "http://prolific-interview.herokuapp.com/591f301514bbf7000a22d177" + selectedBook.url))
            self.present(socialController!, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func deleteButtonWasPressed()  {
        let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete this book?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive, handler: { (alert) in
            
            NetworkRequestManager.manager.makeRequest(to: self.endPoint, method: .delete, body: nil, id: self.selectedBook.id) { (data) in
                let successfulDeleteAlert = UIAlertController(title: "Succesful!", message: "You Succesfully Deleted This Book", preferredStyle: UIAlertControllerStyle.alert)
                
                successfulDeleteAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (alert) in
                    self.dismiss(animated: true, completion: nil)
                    
                    let nav = UINavigationController(rootViewController: BookTableViewController())
                    self.present(nav, animated: true, completion: nil)
                }))
                self.present(successfulDeleteAlert, animated: true, completion: nil)
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { (alert) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func checkoutButtonWasPressed() {
        let today = Book.todaysDate()
        let borrower = "Karen"
        let requestBody: [ String : Any ] = [
            "lastCheckedOut": today,
            "lastCheckedOutBy": borrower
        ]
        
        
        NetworkRequestManager.manager.makeRequest(to: endPoint, method: .put, body: requestBody, id: selectedBook.id) { (data) in
            //
        }
        
        
    }
    
    // MARK: - Set up views and constraints
    
    func configureConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        checkoutButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        let _ = [
            stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -30),
            
            checkoutButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            checkoutButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            checkoutButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15),
            
            deleteButton.topAnchor.constraint(equalTo: checkoutButton.bottomAnchor, constant: 20),
            deleteButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            deleteButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15)
            ].map({$0.isActive = true })
    }
    
    func setUpViews() {
        stackView.axis  = UILayoutConstraintAxis.vertical
        stackView.distribution  = UIStackViewDistribution.equalSpacing
        stackView.alignment = UIStackViewAlignment.center
        stackView.spacing = 16.0
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(authorLabel)
        stackView.addArrangedSubview(publisherLabel)
        stackView.addArrangedSubview(categoriesLabel)
        stackView.addArrangedSubview(lastCheckedOutLabel)
        stackView.addArrangedSubview(lastCheckedOutByLabel)
        
        self.view.addSubview(stackView)
        self.view.addSubview(checkoutButton)
        self.view.addSubview(deleteButton)
        
    }
    
    //MARK: - UI Objects
    
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .blue
        return lbl
    }()
    lazy var authorLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .blue
        return lbl
    }()
    lazy var publisherLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .blue
        return lbl
    }()
    lazy var categoriesLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .blue
        return lbl
    }()
    lazy var lastCheckedOutLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .blue
        return lbl
    }()
    lazy var lastCheckedOutByLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .blue
        return lbl
    }()
    lazy var checkoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Check Out", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        return button
    }()
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Delete Book", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .red
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        return button
    }()
}
