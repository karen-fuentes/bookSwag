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
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.title = "Book"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add
            , target: self, action: #selector(addBookButtonWasPressed))
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
    }
    
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
    func addBookButtonWasPressed() {
      print("button was pressed")
        self.navigationController?.pushViewController(AddBookViewController(), animated: true)
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
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.text = arrOfBooks[indexPath.row].title
        cell.detailTextLabel?.text = arrOfBooks[indexPath.row].author
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = BookDetailViewController()
        detailVC.selectedBook = arrOfBooks[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
