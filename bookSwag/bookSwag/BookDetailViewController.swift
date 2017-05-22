//
//  BookDetailViewController.swift
//  bookSwag
//
//  Created by Karen Fuentes on 5/21/17.
//  Copyright © 2017 Karen Fuentes. All rights reserved.
//

import UIKit

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
        
      
    
    
    }
    func shareButtonWasPressed() {
        
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
