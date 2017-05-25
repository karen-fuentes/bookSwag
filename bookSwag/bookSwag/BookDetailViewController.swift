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
    let date = Book.todaysDate()
//    let formatter = DateFormatter()
//    var currentDate = String()
    let borrower = "Karen"
    var endPoint = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
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
        
        if let lastCheckedOut = selectedBook.lastCheckedOut, let lastCheckedOutBy = selectedBook.lastCheckedOutBy {
            checkoutLabelText += "\(lastCheckedOutBy) @ \(lastCheckedOut)"
        } else {
            checkoutLabelText += "None"
        }
        
        categoriesLabel.text = "Categories: \(selectedBook.catrgoires!)"
        lastCheckedOutLabel.text = checkoutLabelText
        
        dump(selectedBook)
 
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
       // let today = Book.todaysDate()
        //let borrower = "Karen"
        let requestBody: [ String : Any ] = [
            "lastCheckedOutBy": borrower
        ]
        
        
        NetworkRequestManager.manager.makeRequest(to: endPoint, method: .put, body: requestBody, id: selectedBook.id) { (data) in
//            self.formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//            self.formatter.dateStyle = .long
//            self.currentDate = self.formatter.string(from: self.date)
//            self.lastCheckedOutLabel.text = "\(self.borrower) @ \(self.currentDate)"
            
            let cDate = Book.dateStringToReadableString(self.date)
            self.lastCheckedOutLabel.text = "\(self.borrower) @ \(cDate)"
            self.loadBookDetail()
            
            
           

        }
        
    }
    
    // MARK: - Set up views and constraints
    
    func configureConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        checkoutButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        self.edgesForExtendedLayout = []
        let _ = [
            stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            //stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -30),
            stackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20),
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
