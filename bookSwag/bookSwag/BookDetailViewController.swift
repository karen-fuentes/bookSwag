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
    let basePoint = "http://prolific-interview.herokuapp.com/591f301514bbf7000a22d177"
    let bookEndpoint = "/books/"
    

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
        let today = Book.todaysDate()
        let borrower = "Karen"
        
        let requestBody: [ String : Any ] = [
            "lastCheckedOut": today,
            "lastCheckedOutBy": borrower
        ]
        
     APIRequestManager.manager.updateData(data: requestBody, method: .put, id: selectedBook.id)
    
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
