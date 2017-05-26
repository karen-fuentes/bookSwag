//
//  BookTableViewController.swift
//  bookSwag
//
//  Created by Karen Fuentes on 5/20/17.
//  Copyright © 2017 Karen Fuentes. All rights reserved.
//

import UIKit

class BookTableViewController: UITableViewController {
    var arrOfBooks = [Book]()
    let endPoint = "http://prolific-interview.herokuapp.com/591f301514bbf7000a22d177"
    let getEndPoint = "books"
    let cleanEndPoint = "clean"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        getData()
        
        self.tableView.register(BookTableViewCell.self, forCellReuseIdentifier: "bookCell")
        self.title = "Book"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add
            , target: self, action: #selector(addBookButtonWasPressed))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete All", style: .plain, target: self, action: #selector(deleteAllWasTapped))
        self.navigationItem.rightBarButtonItem?.tintColor = .red
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        self.tableView.backgroundColor = .bookSwagPurple
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getData()
    }
    
    //MARK: - Networking
    
    func getData(){
        let combinedEndpoint = endPoint + "/" + getEndPoint
        
        NetworkRequestManager.manager.makeRequest(to: combinedEndpoint, method: .get, body: nil) { (data, _) in
            if  let validData = data {
                self.arrOfBooks = Book.createBookObjects(data: validData)!
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Navigation Bar Button target actions
    
    func addBookButtonWasPressed() {
        let destination = AddBookViewController()
        let navController = UINavigationController(rootViewController: destination)
        let combinedEndPoint = endPoint + "/" + getEndPoint
        
        destination.endPoint = combinedEndPoint
        
        self.present(navController, animated: true, completion: nil)
    }
    
    func deleteAllWasTapped() {
        let alert = UIAlertController(title: "Delete All", message: "Are you sure you want to delete all of your books? 🤔", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Delete", style:  UIAlertActionStyle.destructive, handler: { (alert) in
            let combinedEndPoint = self.endPoint + "/" + self.cleanEndPoint
            
            NetworkRequestManager.manager.makeRequest(to: combinedEndPoint, method: .delete) { (data, _) in
                if let validData = data {
                    self.arrOfBooks = Book.createBookObjects(data: validData)!
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { (alert) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOfBooks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookCell", for: indexPath) as! BookTableViewCell
        let cellColor: UIColor = ((indexPath.row % 2) == 0) ? .bookSwagGray : .bookSwagBlue
        
        cell.bookTitleLabel.text = arrOfBooks[indexPath.row].title
        cell.bookAuthorLabel.text = arrOfBooks[indexPath.row].author
        cell.backgroundColor = cellColor
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = BookDetailViewController()
        
        detailVC.selectedBook = arrOfBooks[indexPath.row]
        detailVC.endPoint = self.endPoint
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
