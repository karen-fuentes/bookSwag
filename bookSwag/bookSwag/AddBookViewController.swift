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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = "Add Book"
        self.navigationItem.setHidesBackButton(true , animated: true)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonWasPressed))
        viewHiearchy()
        configureConstraint()
      
    }

    func doneButtonWasPressed() {
        
    }
    func configureConstraint() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        authorTextField.translatesAutoresizingMaskIntoConstraints = false
        publisherTextField.translatesAutoresizingMaskIntoConstraints = false
        categoriesTextField.translatesAutoresizingMaskIntoConstraints = false
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        self.edgesForExtendedLayout = []
        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40.0).isActive = true
        
        titleTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8).isActive = true
        titleTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8).isActive = true
        titleTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        authorTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8).isActive = true
        authorTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8).isActive = true
        authorTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        publisherTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8).isActive = true
        publisherTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8).isActive = true
       publisherTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        categoriesTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8).isActive = true
        categoriesTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8).isActive = true
        categoriesTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        submitButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16).isActive = true
        submitButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        submitButton.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.25).isActive = true
    }
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
    
    //UI Objects

    
    lazy var titleTextField: UITextField = {
        let txtField = UITextField()
        txtField.placeholder = "Title"
        txtField.textAlignment = .center
        txtField.borderStyle = .line
        return txtField
    }()
    lazy var authorTextField: UITextField = {
        let txtField = UITextField()
        txtField.placeholder = "Author"
        txtField.textAlignment = .center
        txtField.borderStyle = .line
        return txtField
    }()
    lazy var publisherTextField: UITextField = {
        let txtField = UITextField()
        txtField.placeholder = "Publisher"
        txtField.textAlignment = .center
        txtField.borderStyle = .line
        return txtField
    }()
    lazy var categoriesTextField: UITextField = {
        let txtField = UITextField()
        txtField.placeholder = "Categories"
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
        button.setTitleColor(.blue, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor

        return button
    }()

}
