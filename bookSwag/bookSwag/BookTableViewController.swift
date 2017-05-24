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

    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        self.tableView.register(BookTableViewCell.self, forCellReuseIdentifier: "bookCell")
        self.title = "Book"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add
            , target: self, action: #selector(addBookButtonWasPressed))
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getData()
    }
    
    //MARK: - Networking
    
    func getData() {
        let booksEndpoint = "http://prolific-interview.herokuapp.com/591f301514bbf7000a22d177/books"
        APIRequestManager.manager.getData(endPoint: booksEndpoint) { (data) in
            if let validData = data {
                self.arrOfBooks = Book.createBookObjects(data: validData)!
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
   
    
    // MARK: - addBook Functionality
    
    func addBookButtonWasPressed() {
        let navController = UINavigationController(rootViewController: AddBookViewController())
        self.present(navController, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrOfBooks.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookCell", for: indexPath) as! BookTableViewCell
        cell.bookTitleLabel.text = arrOfBooks[indexPath.row].title
        cell.bookAuthorLabel.text = arrOfBooks[indexPath.row].author
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = BookDetailViewController()
        detailVC.selectedBook = arrOfBooks[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
