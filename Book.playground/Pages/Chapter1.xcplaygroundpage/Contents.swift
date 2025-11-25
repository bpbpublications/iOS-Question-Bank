// To view markdown: Xcode -> Editor -> Show Rendered Markup
/*:
 # Chapter 1
 This Playground is designed to follow the book's structure closely. Each code snippet is labeled with the same question number as in the book, so you can easily match the code with the corresponding question or example.
 - - -
 
 2.**How to check which version of Swift you are working with?**
 
 `xcrun swift –version` or
 `swift –version`
 ![](Q2.png)

 
 6.**What are the initializers in Swift? What is the difference between Designated and convenience initializers in Swift?**
 
 Example of Initializer of a class
 ````
 class Initializer {
 init() {
 //…
 }
 }
 ````
 Example of designated Initializer:
 ````
 class DesignatedInitializerEmployee {
 var name: String
 var age: Int
 var employeeId: Int
 
 init(name: String, age: Int, employeeId: Int) {
 self.name = name
 self.age = age
 self.employeeId = employeeId
 }
 }
 
 let user = DesignatedInitializerEmployee(name: “John”, age: 30, employeeId: 12345)
 print(user.name)
 
 ````
 Example on how convenience works:
 ````
 class DesignatedInitializerEmployee {
 var name: String
 var age: Int
 var employeeId: Int
 var companyName: String
 
 // Designated initializer
 init(name: String, age: Int, employeeId: Int, companyName: String) {
 self.name = name
 self.age = age
 self.employeeId = employeeId
 self.companyName = companyName
 }
 
 // Convenience initializer with default company name
 convenience init(name: String, age: Int, employeeId: Int) {
 self.init(name: name, age: age, employeeId: employeeId, companyName: “Apple”)
 }
 }
 
 // Using the designated initializer
 let employee1 = DesignatedInitializerEmployee(name: “John”, age: 30, employeeId: 1234)
 print(“\(employee1.name) works at \(employee1.companyName).”)
 ````
 Example on failable initializer:
 ````
 struct Person {
 var name: String
 var age: Int
 
 // Failable Initializer
 init?(name: String, age: Int) {
 guard age > 0 else {
 return nil// if age is less than 0 it will fail the initialization
 }
 self.name = name
 self.age = age
 }
 }
 
 if let invalidPerson = Person(name: “John”, age: -5) {
 print(“Person created: \(invalidPerson.name), \(invalidPerson.age)”)
 } else {
 print(“Failed to create Person”) // This will print because age is invalid
 }
 ````
 Example on default initializer:
 ````
 class Subscription {
 var subscriptionName: String = “Silver Membership”
 var upgraded = false
 }
 
 var subscription = Subscription()
 print(subscription.subscriptionName)//Will print Silver Membership
 ````
 
 7.**What are the de-initializers in Swift?**
 
 Example:
 ````
 deinit {
 NotificationCenter.default.removeObserver(self, name: .customObserver, object: nil)
 downloadTask?.cancel()
 print(“Class deallocated”)
 }
 ````
 
 10.**What are the format specifiers available in Swift?**
 */
import Foundation
import PlaygroundSupport

// Required to allow asynchronous code to complete in playgrounds
PlaygroundPage.current.needsIndefiniteExecution = true
 func printFormatSpecifiersExamples() {
     print("Swift String Format Specifiers Examples:\n")

     let examples: [(description: String, formatted: String)] = [
         ("%@", String(format: "Hello, %@", "John")),
         ("%d", String(format: "Age: %d", 30)),
         ("%u", String(format: "Unsigned: %u", UInt32.max)),
         ("%f", String(format: "Pi: %.2f", 3.14159)),
         ("%e", String(format: "Scientific (e): %e", 3.14159)),
         ("%E", String(format: "Scientific (E): %E", 3.14159)),
         ("%g", String(format: "Shortest (%g): %g", 3.14159)),
         ("%G", String(format: "Shortest (%G): %G", 3.14159)),
         ("%x", String(format: "Hex (x): %x", 255)),
         ("%X", String(format: "Hex (X): %X", 255)),
         ("%o", String(format: "Octal: %o", 255)),
         ("%c", String(format: "Character: %c", 65)), // 65 = 'A'
         ("%%", String(format: "Percentage: %%"))
     ]
     
     for (specifier, result) in examples {
         print("Specifier: \(specifier)\nResult:   \(result)\n")
     }
 }

 printFormatSpecifiersExamples()

/*:
 11.**What is difference between raw values and associated values in Swift’s enumerations?**
 
Example:
````
enum Direction: String {
    case north, south, east, west
}
print(Direction.north.rawValue)// will print: north
````
 */
enum Direction {
    case north(isNorthUp: Bool)               // Associated value of type Bool
    case south(distance: Int)                // Associated value of type Int
    case east(speed: Double, unit: String)   // Multiple associated values (Double and String)
    case west(isDaytime: Bool)               // Associated value of type Bool
}
let north = Direction.north(isNorthUp: true)
print(north)

/*:
 16.**What is a protocol in Swift?**
 
 ````
 //Defining a protocol
 protocol GetUserDetails {
     //...
     //...
 }

 Adopting a protocol
 class Users: GetUserDetails, AnotherProtocol {
     
 }
 ````
 17.**How to make an optional function/method in protocol?**
 
 ````
 @objc protocol GetUserDetails: NSObjectProtocol {
     @objc optional func optionalMethod()
     func requiredMethod()
 }


 class Users: NSObject,GetUserDetails {
     func requiredMethod() {
         print(“—Required—")
     }
 }

 protocol GetUserDetails {
     func optionalMethod()
     func requiredMethod()
 }

 extension GetUserDetails {
     //This can be empty or default implementation i.e setting up some value or some data initially
     func optionalMethod() {
         print(“default implementation”)
     }
 }

 class Users: GetUserDetails {
     func requiredMethod() {
         print(“—Required—")
     }
 }
````
 
 18.**What is a Static Class in Swift?**
 */

class Users {
    static func staticMethod() {
        print("This is a static method")
    }
}

print(Users.staticMethod())

/*:
20.**What is delegate in swift?**
 
 ````
 
 1. Define your delegate protocol:
 protocol DelegateToDoSomething: AnyObject {
     func willDoSomething()
 }

 2. Create the Delegating Class:
 class DelegatingClass {
         weak var delegte: DelegateToDoSomething?
     
         Func doSomething() {
             delegte?.willDoSomething()
     }
 }

 3. Implement the delegate:
 class ImplementDelegate: DelegateToDoSomething {
     func willDoSomething() {
         print(“Something will be done here”)
     }
 }

 4. Assign the delegate:
 let delegateClass = DelegatingClass()
 let implementDelegate = ImplementDelegate()
 delegateClass.delegte = implementDelegate
 delegateClass.doSomething()
````

 25.**What is IBDesignable/IBInspectable?**

 ````
import UIKit

@IBDesignable
class RoundedRectButton: UIButton {
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            self.layer.borderColor = borderColor?.cgColor
        }
    }
}

 ````
 */
/*:
 27.**What do you understand by Scene delegate?**
 //Configuration of multiple scenes in your app
 ![Multiple Scene Configuration](Q27.png)
 */


/*:
 31.**How to launch Accessibility Inspector from Xcode menu?**
 ![Launch Accessibility Inspector](Q31.png)
 */

/*:
32.**What is the use of defer keyword?
 */
func readFile() {
    print("Opening file.")
    defer {
        print("Closing File...")
    }

   print("Reading file...")
    // Simulate an error or early return
    return
   print("Processing data...") // This line is not executed
}

readFile()
// Output:
//Opening file...
// Reading file...
// Closing file...


//LIFO Example
func processTask() {
    defer {
        print("Task 1 completed")
    }

    defer {
        print("Task 2 completed")
   }

    print("Processing tasks...")
}

processTask()
// Output:
// Processing tasks...
// Task 2 completed
// Task 1 completed

/*:
33.**What is the use of fallthrough keyword?**
*/
let number = 1

switch number {
case 1:
    print("Matched case 1")
    fallthrough
case 2:
    print("Matched case 2")
default:
    print("Default case")
}
// Output:
// Matched case 1
// Matched case 2

/*:
35.**What is difference between is and as keyword?**
*/

class Animal {}
class Dog: Animal {}
class Cat: Animal {}

let animal: Animal = Dog()

// Check and cast using 'is' and 'as?'
if animal is Dog {
    let dog = animal as! Dog
    print("This is a Dog.")
} else {
    print("This is not a Dog.")
}
// Output: This is a Dog.

/*:
36.**What is difference @avaialble and #available?**
*/
@available(iOS 18.0, *)
class NewFeature {
    func runIfAvailable() {
        print("This feature is available on iOS 18 or later.")
    }
}


if #available(iOS 18.0, *) {
    print("Running features for iOS 18 or later.")
} else {
    print("Fallback for older iOS versions.")
}

/*:
37.**What is the purpose of ( _ ) in Swift?**
*/

let (_, lastName) = ("Test", "User") // Ignore the first value
print(lastName)
// Output: User

//Ignore the return value from function and will not get any warning
func getUser() -> String {
    return "Test User"
}
_ = getUser()

//Ignore the parameter in the functions when calling
func sum(_ first: Int, _ second: Int) -> Int {
    first + second
}
print(sum(5, 4))

//Ignore parameter name in closures
let numbers = [1, 2, 3]
numbers.forEach { _ in
    print("Hello") // Output: Hello (printed 3 times)
}

//WIld card pattern match
for _ in 1...5 {
    print("Hello")
}

let fruit = "Banana"

switch fruit {
case "Apple":
    print("It's an apple.")
case _:
    print("Unknown fruit.")// Will match the value at wildcard pattern and execute the case
    //will print Unknown fruit
}

//Ignore associated value in an enum
enum Response {
    case success(data: String)
    case failure(error: String)
}

let response: Response = .failure(error: "Network error")

switch response {
case .success(let data):
    print("Data received: \(data)")
case .failure(_): // Ignore the error details
    print("Operation failed.")
}
//Will print operation failed

/*:
39.**What is a variadic parameter in a function?**
*/

//Min is a variadic parameter function which can accepts multiple input at same time
let smallNum = min(10, 20, 5, 15)
print("Smallest number is \(smallNum)")
// Will print 5

/*:
40.**What is inout parameter in a function?**

````
 Func functionName(paramName: inout Type) {
     // Modify parameter here
 }

````
 
 */
func capitalize(_ text: inout String) {
    text = text.uppercased()
}

var message = "hello, world"
capitalize(&message)
print(message)
// Will print: HELLO, WORLD


/*:
41.**What are closures in Swift? Or What is the completion handlers in Swift? or What are the trailing closures?**

````
 { (parameters) -> ReturnType in
     // Code block
 }
 
 func performTask(completion: (ResultType) -> Void) {
     // Perform some task
     completion(result)
 // Call the completion handler when the task is done
 }

````
 */

//See how a closure could be used in the following example:
func fetchUser(completion: (String) -> Void) {
    let user = "User: Alice"
    completion(user) // Pass the fetched data
}

fetchUser { user in
    print(user) // Output: User: Alice
}


/*:
 42.**How to Customize an Xcode Scheme?**
 ![Xcode Scheme](Q42-1.png)
 
 **Configuration Setting of an Xcode Scheme?**
 ![Xcode Scheme Configuration Settings](Q42-2.png)
 */

/*:
 43.**Breakpoint Bar in Xcode**
 
 ![Break Point Debug Bar](Q43.png)
 */

/*:
 45.**Generate method comments/documentation in Xcode**
 
 ![Code Documentation](Q45.png)
 */

/*:
46.**How to handle errors in swift? Or What do you use to handle error in your app?**
*/

enum APIError: Error {
    case invalidURL
    case networkError(String)
    case decodingError
    case serverError(statusCode: Int)
}

// Define the async function
func fetchUserData(from urlString: String) async throws -> Data {
    guard let url = URL(string: urlString) else {
        throw APIError.invalidURL
    }
    let (data, _) = try await URLSession.shared.data(for: URLRequest(url: url))
    return data
}

// Call the async function inside a Task
Task {
    do {
        let data = try await fetchUserData(from: "https://jsonplaceholder.typicode.com/posts/1")
        print("Data received: \(data)")
    } catch APIError.invalidURL {
        print("The URL is invalid.")
    } catch {
        print("An unexpected error occurred: \(error)")
    }
}

func throwingFunction() throws {
    print("This function throws an error.")
    throw APIError.invalidURL
}

func performOperation(_ operation: () throws -> Void) rethrows {
    try operation()
}

do {
    try performOperation {
        try throwingFunction()
    }
} catch {
    print("Caught an error: \(error)")
}

/*:
 48.**Configuration of URL scheme in iOS apps**
 
 ![URL scheme creation](Q48-1.png)
 
 **Launch Deep linked app**
 
 ![URL scheme validation](Q48-2.png)
 
 **Enable Universal Links in iOS apps**
 
 ![Universal links enablement](Q48-3.png)
 */

/*:
- [Next Chapter](Chapter2)
*/
