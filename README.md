# Book SWAG
Book SWAG allows the SWAG committee to keep track of books user possess from the Prolific library server. The user has the ability to add, delete, checkout books from the Prolific Library. The user can also share a book to their friends on facebook. 

<img src="https://github.com/karen-fuentes/bookSwag/blob/master/images/icon.png" width="320" />
 
### Features
 
- GET, POST, DELETE, and PUT HTTP Methods are used   
- With these different HTTP Methods user can add, delete and checkout a book
- Social library was used to allow user to share a book to their facebook profile
 
### Network Request Manager 

The NetworkRequestManager is the object in charge of making request to the server. Being that we are going to do various requests with varying HTTP Methods. I had many many :silly: refactoring stages for this object's networking methods.

##### Singleton 

When creating my Network Request Manager I decided to go with a singleton. We would want a global access to the different methods the NetworkRequestManager has. 

Why? :confused:

If we have global access that means that any module within our project that uses this object's method doesn't need to create an instance of it to access those methods. The singleton design pattern allows for only on instance of that object. Hey memory ain't cheap :money: Being that this is a simple app I thought that is was good to use a singleton pattern, but as we know singleton are not ideal for larger apps because the way objects communicate with each other can become fuzzy and harder to test. 
##### DRY

Dont Repeat Yourself. Three words us coders live by... well at least try to. In the first couple of iterations of this project I had varying methods for this class one for each method :worried:. I like to make sure indiviual parts work prior to making a dynamic function like the one below. Seeing that the code seemed redundant for each different http method with its own function. I refactored and refactored until I made a working function that takes in various types of Http methods, and depending on that it makes the request to the server. 

##### Make Request Method 
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

###### Inputs 

This function takes in an enpoint and its going to be of type String. We Use the URL method within the function to convert it to a valid URL for our request. The function also takes a method type which is the enum listed below 

``` Swift 
enum RequestMethod: String {
    case post, put, get, delete
}
```
I first thought that the string of http method types was case sensative, but it turns out that after trial and error along with this [stack overFlow question] (https://stackoverflow.com/questions/5258977/are-http-headers-case-sensitive) its not and request will still work with the lower case raw values of the RequestMethod type.

The function optionally takes in a body which is of type [String:Any] this is ideal for when we want to update an object with in our data. 

###### Completion Block 

Then there is the completion handler this allows for the data to load asynchronous. Now what does that mean? Well think about it like this. Let's say you wanted to make chicken noodle soup. There are various tasks you must complete in order to get this done. Similar to your network request. Some things may take longer to complete like getting the chicken ready for your soup. Networking is similar in that it's a long process, and it has various factors that can make it even slower. There might be something wrong with the server, your computer maybe slow, or the wifi may be faulty. To be effecient one must do other tasks like chop up veggies while the chicken cooks. The data is loading in the background thread while you do other things on the main thread. That way your app is still running on the main thread while data loads in the back. 

##### Results 

ONE BEAUTIFUL DYNAMIC FUNCTION :love:

## Demos: checkout book, add book, delete book/ all books, and share books
#### Checkout book 
<img src="https://github.com/karen-fuentes/bookSwag/blob/master/images/checkoutBook.gif" width="320" />

#### Add book 
<img src="https://github.com/karen-fuentes/bookSwag/blob/master/images/addingBook.gif" width="320" />

#### delete book / all books 
<img src="https://github.com/karen-fuentes/bookSwag/blob/master/images/deleteBook.gif" width="320" />

#### Share Books
<img src="https://github.com/karen-fuentes/bookSwag/blob/master/images/shareBook.gif" width="320" />

#### Posted on users facebook
<img src="https://github.com/karen-fuentes/bookSwag/blob/master/images/proofOfUpload.png" width="320" />



