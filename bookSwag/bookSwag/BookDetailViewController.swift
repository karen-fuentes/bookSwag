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
        self.lastCheckedOutByLabel.text = selectedBook.lastCheckedOutBy
        self.lastCheckedOutLabel.text = selectedBook.lastCheckedOut!
        checkoutButton.addTarget(self, action: #selector(checkoutButtonWasPressed), for: .touchUpInside)
    }
    func shareButtonWasPressed() {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
            let socialController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            socialController?.setInitialText("Check out this book: \(selectedBook.title)")
            socialController?.add(URL(string: "http://prolific-interview.herokuapp.com/591f301514bbf7000a22d177" + selectedBook.url))
            
            self.present(socialController!, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
   func checkoutButtonWasPressed () {
//        //let today = Book.todaysDate()
//        let borrower = "Vic"
//        
//        let requestBody: [ String : Any ] = [
//            "author" : selectedBook.author,
//            "categories": selectedBook.categories,
//            "id": selectedBook.id,
//            "lastCheckedOut": today,
//            "lastCheckedOutBy": borrower,
//            "publisher": selectedBook.publisher as Any,
//            "title": selectedBook.title,
//            "url": selectedBook.url
//        ]
//        
//        APIRequestManager.manager.putRequest(endPoint: baseEndpoint + bookEndpoint, id: selectedBook.id, dataBody: requestBody) { (response: HTTPURLResponse?) in
//            DispatchQueue.main.async {
//                if response != nil {
//                    APIRequestManager.manager.getData(endPoint: self.baseEndpoint + self.selectedBook.url) { (data: Data?) in
//                        if let validData = data, let validBook = Book.getSingleBook(from: validData) {
//                            self.selectedBook = validBook
//                            if let lastCheckedOutBy = self.selectedBook.lastCheckedOutBy, let lastCheckedOut = self.selectedBook.lastCheckedOut {
//                                DispatchQueue.main.async {
//                                    self.checkedOutLabel.text = "Last Checked Out By: \(lastCheckedOutBy) @ \(Book.dateStringToReadableString(lastCheckedOut))"
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
    }
    
    func configureConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        checkoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -30).isActive = true
        
        checkoutButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20).isActive = true
        checkoutButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15).isActive = true
        checkoutButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15).isActive = true
    }
    
    func setUpViews() {
        //self.view.addSubview(titleLabel)
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

    }
    
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
}
