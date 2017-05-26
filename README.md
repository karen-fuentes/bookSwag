# Book SWAG
Book SWAG allows the SWAG committee to keep track of books user check out from the Prolific library server. The user has the ability to add, delete, checkout, and share their favorite book to their friends on facebook. 
 
### Features
 
- GET, POST, DELETE, and PUT HTTP Methods are used with the Prolific Library server  
- With these different HTTP Methods user can add, delete and checkout a book
- Social library was used to allow user to share a book to their facebook profile
 
 
### Network Request Manager 
Being that we are going to do various HTTP Methods. I had various refactoring stages for the object in charge of Networking. 
##### Singleton 
When creating my Network Request Manager I decided to go with a singleton. We would want a global access to the different methods of the network request manager, and we would only want only one instance of the object. Being that this is a simple app its ok to use a singleton, but as we know singleton are not ideal for larger apps because the way objects communicate with each other can become fuzzy. 
##### DRY
Dont Repeat Yourself. Three words us coders live by... well at least try to. In the first couple of iterations of this project I had varying methods for this class one for each method :worried:. I like to make sure indiviual parts work prior to making a dynamic function like the one below. This function takes various types of Http methods, and depending on that it makes the request to the server.  

``` Swift 
    func makeRequest(to endpoint: String,  method: RequestMethod = .get, body: [String:Any]? = nil, completion: @escaping (Data?, URLResponse?) -> Void) {
        
        guard let url: URL = URL(string: endpoint) else { return }
        
        var request: URLRequest = URLRequest(url: url)
        
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let jsonObject = body {
            do {
                let body = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
                request.httpBody = body
            }
                
            catch {
                print("Error serializing body: \(error)")
            }
        }
        
        let session = URLSession.shared
        
        session.dataTask(with: request) { (data: Data?, response:URLResponse?, error: Error?) in
            if error != nil {
                print("Error encountered during post request: \(String(describing: error))")
            }
            
            if response != nil {
                let httpResponse = (response! as! HTTPURLResponse)
                print("Response status code: \(httpResponse.statusCode)")
            }
            
            completion(data, response)
            
            }.resume()
    }
```
 
## Demos: checkout book, add book, delete book/ all books, and share books
##### Checkout book 
<img src="https://github.com/karen-fuentes/bookSwag/blob/master/images/checkoutBook.gif" width="320" />
##### Add book 
<img src="https://github.com/karen-fuentes/bookSwag/blob/master/images/addingBook.gif" width="320" />
##### delete book / all books 
<img src="https://github.com/karen-fuentes/bookSwag/blob/master/images/deleteBook.gif" width="320" />
##### Share Books
<img src="https://github.com/karen-fuentes/bookSwag/blob/master/images/shareBook.gif" width="320" />
##### Posted on users facebook
<img src="https://github.com/karen-fuentes/bookSwag/blob/master/images/proofOfUpload.png" width="320" />



