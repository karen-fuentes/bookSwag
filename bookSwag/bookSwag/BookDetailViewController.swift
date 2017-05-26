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
    
    // Mark: - Properties
    
    var selectedBook: Book!
    let stackView = UIStackView()
    var borrower = String()
    var endPoint = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .bookSwagPurple
        self.title = "Detail"
        
        setUpViews()
        configureConstraints()
        loadBookDetail()
        
        self.titleLabel.text = selectedBook.title
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ShareIcon"), style: .plain, target: self, action: #selector (shareButtonWasPressed))
        
        checkoutButton.addTarget(self, action: #selector(checkoutButtonWasPressed), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteButtonWasPressed), for: .touchUpInside)
    }
    
    //MARK: - Creating Selected Book Method
    
    func loadBookDetail() {
        var checkoutLabelText = "Last Checked Out By: "
        
        titleLabel.text = selectedBook.title
        authorLabel.text = selectedBook.author
        
        if let publisher = selectedBook.publisher {
            publisherLabel.text = "Publishers: \(publisher)"
        } else {
            publisherLabel.text = "Publishers: None"
        }
        
        if let lastCheckedOut = selectedBook.lastCheckedOut,
            let lastCheckedOutBy = selectedBook.lastCheckedOutBy {
            checkoutLabelText += "\(lastCheckedOutBy) @ \(Book.dateStringToReadableString(lastCheckedOut))"
        } else {
            checkoutLabelText += "None"
        }
        
        categoriesLabel.text = "Categories: \(selectedBook.categories!)"
        lastCheckedOutLabel.text = checkoutLabelText
    }
    
    // MARK: - Share Method
    
    func shareButtonWasPressed() {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
            let socialController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            
            socialController?.setInitialText("Check out this book: \(selectedBook.title!)")
            socialController?.add(URL(string: endPoint + selectedBook.url))
            
            self.present(socialController!, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Delete Button method (deletes book, alerts user)
    
    func deleteButtonWasPressed()  {
        let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete this book?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive, handler: { (alert) in
            
            NetworkRequestManager.manager.makeRequest(to: self.endPoint + self.selectedBook.url, method: .delete, body: nil) { (data, _) in
                let successfulDeleteAlert = UIAlertController(title: "Succesful!", message: "You Succesfully Deleted This Book", preferredStyle: UIAlertControllerStyle.alert)
                
                successfulDeleteAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (alert) in
                    self.dismiss(animated: true, completion: nil)
                    
                    _ = self.navigationController?.popViewController(animated: true)
                }))
                
                self.present(successfulDeleteAlert, animated: true, completion: nil)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { (alert) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Checkout Button Method (post, update data, and alert)
    
    func checkoutButtonWasPressed() {
        let alert = UIAlertController(title: "Name", message: "please enter your name", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Name"
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            
            if let text = textField?.text {
                self.borrower = text
                
                let requestBody: [ String : Any ] = [
                    "lastCheckedOutBy": self.borrower
                ]
                
                NetworkRequestManager.manager.makeRequest(to: self.endPoint + self.selectedBook.url, method: .put, body: requestBody) { (_, response) in
                    if let responseHTTP = response as? HTTPURLResponse {
                        if responseHTTP.statusCode == 200 {
                            NetworkRequestManager.manager.makeRequest(to: self.endPoint + self.selectedBook.url) { (data, _) in
                                if let validData = data {
                                    self.selectedBook = Book.getOneBook(from: validData)
                                    
                                    DispatchQueue.main.async {
                                        guard let checkoutBy = self.selectedBook.lastCheckedOutBy,
                                            let date = self.selectedBook.lastCheckedOut else {return}
                                        
                                        self.lastCheckedOutLabel.text = "Last Checked Out By: \(checkoutBy) @ \(Book.dateStringToReadableString(date))"
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Set up views and constraints
    
    func configureConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        checkoutButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        // self.edgesForExtendedLayout = []
        
        let _ = [
            stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
            stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8),
            
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
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 20, weight: UIFontWeightBold)
        lbl.numberOfLines = 2
        lbl.lineBreakMode = .byWordWrapping
        lbl.textAlignment = .left
        return lbl
    }()
    
    lazy var authorLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightSemibold)
        lbl.numberOfLines = 2
        lbl.lineBreakMode = .byWordWrapping
        lbl.textAlignment = .left
        return lbl
    }()
    
    lazy var publisherLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightThin)
        lbl.lineBreakMode = .byWordWrapping
        lbl.textAlignment = .left
        return lbl
    }()
    
    lazy var categoriesLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightThin)
        lbl.numberOfLines = 2
        lbl.lineBreakMode = .byWordWrapping
        lbl.textAlignment = .left
        return lbl
    }()
    
    lazy var lastCheckedOutLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightThin)
        lbl.numberOfLines = 2
        lbl.lineBreakMode = .byWordWrapping
        lbl.textAlignment = .left
        return lbl
    }()
    
    lazy var lastCheckedOutByLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightThin)
        lbl.numberOfLines = 3
        lbl.lineBreakMode = .byWordWrapping
        lbl.textAlignment = .left
        return lbl
    }()
    
    lazy var checkoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Check Out", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.backgroundColor = .bookSwagGray
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
