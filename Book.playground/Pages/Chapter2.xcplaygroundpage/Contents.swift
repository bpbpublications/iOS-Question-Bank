// To view markdown: Xcode -> Editor -> Show Rendered Markup
/*:
 # Chapter 2
 This Playground is designed to follow the book's structure closely. Each code snippet is labeled with the same question number as in the book, so you can easily match the code with the corresponding question or example.
 - - -
 
 1.**In-App Purchase flow?**
 ![In App purchase flow](Q1.png)
 */

/*:
 2.**What are the differences between Key-Value Observation (KVO) and delegates?**
 */
import Foundation
import PlaygroundSupport

 class Observable: NSObject {
     @objc dynamic var observedProperty: String = "Hello, World"
 }

// The observer class
class Observer {
    private var observation: NSKeyValueObservation?

    init(observable: Observable) {
        observation = observable.observe(\.observedProperty, options: [.old, .new]) { observedProperty, change in
            print("Name changed from \(change.oldValue ?? "") to \(change.newValue ?? "")")
        }
    }
}

let observable = Observable()
let observer = Observer(observable: observable)

observable.observedProperty = "Hello, World. Welcome!"
//will print: Name changed from Hello, World to Hello, World. Welcome!

/*:
3.**What do you understand by Push Notification?**
 ![Adding push capabilities to your app](Q3-1.png)
 
 ![Requesting User Permission to receive push notification for the app](Q3-2.png)

 ````
 func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
         // Request notification permission
         let center = UNUserNotificationCenter.current()
         center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
             if granted {
                 DispatchQueue.main.async {
                     UIApplication.shared.registerForRemoteNotifications()
                 }
             } else {
                 print("Notification permission denied: \(error?.localizedDescription ?? "Unknown error")")
             }
         }
         return true
 }

 // Called when device token is received
 func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
         let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
         print("Device Token: \(tokenString)")
         // Send this token to your server
 }

 // Called when registration for notifications fails
 func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
         print("Failed to register for notifications: \(error.localizedDescription)")
 }
````
 ````
 extension AppDelegate: UNUserNotificationCenterDelegate {
     func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
         // Show the notification as an alert even if the app is in the foreground
         completionHandler([.alert, .sound, .badge])
     }

     func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
         // Handle the user's response to the notification
         print("Notification received: \(response.notification.request.content.userInfo)")
         completionHandler()
     }
 }

````
 
 9.**What is the capture list in closures?**

 Capture list in closure example and syntax
 ````
 { [captureList] (parameters) -> returnType in
     //body
 }
 ````
 */

/*:
 10.**What is the difference between escaping and non-escaping closures in Swift?**
 
 
 //example below for non-escaping closures
 ````
 func sum(_ num1: Int, _ num2: Int, completion: (Int) -> ()) {
     let sum = num1 + num2
     completion(sum)
 }

 // Using the function with a non-escaping closure
 sum(2,7) { result in
     print("Sum is = \(result)") // output will be 9
 }
 ````
 */
func sum(_ num1: Int, _ num2: Int, completion: @escaping (Int) -> Void) {
    // Perform the calculation asynchronously
    DispatchQueue.global(qos: .userInitiated).async {
        let sum = num1 + num2
        // Delay result
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            completion(sum)
        }
        print("function returned here")
    }
}

// Using the function with an escaping closure
sum(5, 4) { result in
    print("Sum is = \(result)") // Output: "Sum is = 9"
}
//Output will be
//function returned here
//Sum is = 9

/*:
 11.**what is the concept of a higher-order function, and their examples**
*/


//MARK: Sorted example
let numbers = [4,5,12,10,2]

let sortedNumbers = numbers.sorted { $0 < $1 }
print(sortedNumbers) // Output: [2, 4, 5, 10, 12]


//MARK: Filter example
let numbersFilterArr = [3,7,8]

// Using `filter` to get even numbers
let evenNumbers = numbersFilterArr.filter { $0 % 2 == 0 }
print(evenNumbers) // Output: [8]


//MARK: Reduce example
let numbersReduceArr = [2,4,6]

// Using `reduce` to sum the numbers
let sum = numbersReduceArr.reduce(0) { $0 + $1 }
print(sum) // Output: 12


//MARK: Compactmap example
let optionalArray: [Int?] = [1, nil, 3, nil, 5]

// Using `compactMap` to remove nil values and unwrapping optionals
let nonNilCollection = optionalArray.compactMap { $0 }
print(nonNilCollection) // Output: [1, 3, 5]


/*:
 12.**What is ATS in Info.plist?**
 ![ATS condifuguration in info.plist](Q12.png)
*/

/*:
 16.**What is serialization and deserialization in Swift?**
*/
struct Employee: Codable {
    let id: Int
    let name: String
    let email: String
}

// Create an Employee instance with updated values
let employee = Employee(id: 1, name: "Test", email: "test@test.com")

do {
    // Serialize Employee struct to JSON
    let jsonData = try JSONEncoder().encode(employee)
    let jsonString = String(data: jsonData, encoding: .utf8)
    print("Serialized JSON:", jsonString ?? "")
} catch {
    print("Failed to serialize:", error)
}
//response would be
//Serialized JSON: {"email":"test@test.com","name":"Test","id":1}

// JSON string representing an Employee
let jsonString = """
{
    "id": 1,
    "name": "Test",
    "email": "test@test.com"
}
"""

if let jsonData = jsonString.data(using: .utf8) {
    do {
        let employee = try JSONDecoder().decode(Employee.self, from: jsonData)
        print("Deserialized Employee:", employee)
    } catch {
        print("Failed to deserialize:", error)
    }
}
//Output:
//Deserialized Employee: Employee(id: 1, name: "Test", email: "test@test.com")

/*:
 17.**What are CodingKeys in Swift?**
 
 ````
 struct Employee: Codable {
     let firstName: String
     let lastName: String
     let age: Int
     let employeeID: String
     let department: String

     enum CodingKeys: String, CodingKey {
         case firstName = "first_name"
         case lastName = "last_name"
         case age
         case employeeID = "employee_id"
         case department
     }
 }
````
*/

/*:
25.**What is ===  and !== operators in Swift**?
*/
class Employee_Operator_Example {
    var name: String
    var id: Int
    
    init(name: String, id: Int) {
        self.name = name
        self.id = id
    }
}

let employee1 = Employee_Operator_Example(name: "Test", id: 100)
let employee2 = employee1
// employee2 refers to the same instance as employee1
let employee3 = Employee_Operator_Example(name: "Test", id: 100)
// employee3 is a different instance with the same data

// Using === to check if both references point to the same instance
print(employee1 === employee2)
// true, because both refer to the same instance
print(employee1 === employee3)
// false, because they are different instances
print(employee1 !== employee2)
// false, because both refer to the same instance
print(employee1 !== employee3)
 // true, because they are different instances

/*:
26.**What is the @frozen keyword**?
 ````
 @frozen
 public enum EmployeeStatus {
     case employed
     case unemployed
     case retired
 }
````
*/

/*:
 27.**What is the purpose of the @inline() attribute in Swift?**
 
 ````
 @inline(__always)
 func square(_ x: Int) -> Int {
 return x * x
 }
 ````
 ````
 @inline(never)
 func square(_ x: Int) -> Int {
     return x * x
 }
 ````
 */

/*:
 29.**What is the Comparable protocol in Swift?**
 */
 struct Employee_Comparable_Example: Comparable {
     let name: String
     let age: Int

     static func < (lhs: Employee_Comparable_Example, rhs: Employee_Comparable_Example) -> Bool {
         return lhs.age < rhs.age
     }
 }

 let employeeFirst = Employee_Comparable_Example(name: "Alex", age: 25)
 let employeeSecond = Employee_Comparable_Example(name: "Sam", age: 30)

 print("Comparable Protocol Example:",employeeFirst < employeeSecond)
 // true
 print("Comparable Protocol Example:",employeeFirst > employeeSecond)
 // false

/*:
 30.**What is the Equatable protocol in Swift?**
 */
struct Employee_Equatable_Example: Equatable {
    let name: String
    let age: Int
}

let emp1 = Employee_Equatable_Example(name: "Alex", age: 25)
let emp2 = Employee_Equatable_Example(name: "Alex", age: 25)
let emp3 = Employee_Equatable_Example(name: "Sam", age: 30)

print("Equatable Protocol Example:",emp1 == emp2)  // true
print("Equatable Protocol Example:",emp1 == emp3)  // false

/*:
 32.**What is the Hashable protocol in Swift?**
 */
struct Employee_Hashable_Example: Hashable {
    let id: Int
    let name: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// Creating Employee instances
let empFirst = Employee_Hashable_Example(id: 101, name: "Alice")
let empSecond = Employee_Hashable_Example(id: 102, name: "Bob")

var employeeRecords: [Employee_Hashable_Example: String] = [:]
employeeRecords[empFirst] = "iOS Developer"
employeeRecords[empSecond] = "Backend Developer"

print("Hashable Protocol Example:",employeeRecords[empFirst] ?? "Not Found")
// will print: iOS Developer

/*:
 34.**What is the Marker protocol in Swift?**
 */

// Marker Protocol
protocol FullTimeEmployee {}

// Employee Structs
struct Employee_Marker_Example {
    let name: String
    let salary: Double
}

// Conforming to Marker Protocol
struct Manager: FullTimeEmployee {
    let name: String
    let salary: Double
}

struct Intern {
    let name: String
    let stipend: Double
}

// Function to check if an employee is full-time
func checkFullTimeStatus(_ employee: Any) {
    
    if employee is FullTimeEmployee {
        print("This employee is a full-time worker.")
    } else {
        print("This employee is not full-time.")
    }
}

// Testing
let manager = Manager(name: "Alex", salary: 2000)
let intern = Intern(name: "Sam", stipend: 1500)

checkFullTimeStatus(manager)
// Output: This employee is a full-time worker.
checkFullTimeStatus(intern)
 // Output: This employee is not full-time.

/*:
 37.**What is protocol Composition in Swift**
 
 ````
 protocol Drive {
         func drive()
 }

 protocol Reverse {
     func reverse()
 }

 typealias Driveable = Drive & Reverse
````
 */

/*:
 38.**How to provide default implementation for protocol methods?**
 */
protocol Driveable {
        func drive()
}

extension Driveable {
    func drive() {
        print("driving")
    }
}

struct Person: Driveable {}

let alex = Person()
alex.drive()
// Will print: driving

/*:
 40.**Is it possible to limit the protocol to be confirmed by specific types only?**
 */
protocol NumericOperation {
    func double() -> Self
}

extension NumericOperation where Self: Numeric {
    func double() -> Self {
        return self + self
    }
}

extension Int: NumericOperation {}

print("Protocol Usage of Where clause:",5.double())
// will print: 10

/*:
 41.**What would be the outcome if a protocol specifies a method that a conforming class also inherits from a superclass?**
 
````
protocol Printable {
    func printInfo()
}

class Parent {
    func printInfo() {
        print("Parent info")
    }
}

class Child: Parent, Printable {
    override func printInfo() {
        // needs Explicit override required
        print("Child info")
    }
}
````
*/

/*:
 42.**How to create a class-only protocol in Swift??**
 ````
 protocol ClassTypeOnly: AnyObject {
     func doSomething()
 }
````
*/

/*:
 43.**Explain method chaining in Swift?**
*/
protocol EmployeeJoining {
    func setName(_ name: String) -> Self
    func setEmployeeID(_ id: Int) -> Self
    func assignToDepartment(_ department: String) -> Self
}

class Employee_Method_Chaining_Example: EmployeeJoining {
    var name: String = ""
    var employeeID: Int = 0
    var department: String = ""

    func setName(_ name: String) -> Self {
        self.name = name
        return self
    }

    func setEmployeeID(_ id: Int) -> Self {
        self.employeeID = id
        return self
    }

    func assignToDepartment(_ department: String) -> Self {
        self.department = department
        return self
    }
    
    func displayDetails() {
         print("Name: \(name), ID: \(employeeID), Department: \(department)")
     }
    
}

_ = Employee_Method_Chaining_Example()
    .setName("Alex")
    .setEmployeeID(123)
    .assignToDepartment("Technology")
    .displayDetails()
// will print: Name: Alex, ID: 123, Department: Technology

/*:
 47.**How can I enable code coverage for my test targets?**
 ![Enabling test coverage in targets](Q47.png)
*/

/*:
 48.**Could you elaborate on the purpose of the XCTSkip() function within the context of unit testing in Swift?**
 
 ````
 func testSomeCondition() throws {
         let conditionMet = false
         if !conditionMet {
             throw XCTSkip("Required condition not met. Skip rest of test")
         }
         XCTAssertTrue(true, "Test pass if condition met")
 }
 //Output: Required condition not met. Skip rest of test
 ````
*/

/*:
 52.**What is the usage of isIgnoringInteractionEvents API?**
 
 ````
 UIApplication.shared.beginIgnoringInteractionEvents()
 activityIndicator.startAnimating()

 callAPI { _afterResponse
     activityIndicator.stopAnimating()
     UIApplication.shared.endIgnoringInteractionEvents()
 }

 ````
 */

/*:
 54.**How to display the badge icon on iOS apps?**
 
 ````
import UserNotifications

UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) { granted, error in
    if granted {
        DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
}
 ````
To Display a badge with count we can use below API
 ````
 UIApplication.shared.applicationIconBadgeNumber = 5
````
And to remove Badge we can use same property but with 0 badge count like below
 ````
 UIApplication.shared.applicationIconBadgeNumber = 0
````
*/

/*:
 55.**What is the usage of isProtectedDataAvailable property in IOS apps?**
````
 func application(_ application: UIApplication,
                  didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
     
     UIApplication.shared.isIdleTimerDisabled = true
     UIApplication.shared.applicationSupportsShakeToEdit = true
     
     NotificationCenter.default.addObserver(
         self,
         selector: #selector(protectedDataDidBecomeAvailable),
         name: UIApplication.protectedDataDidBecomeAvailableNotification,
         object: nil
     )
     
     NotificationCenter.default.addObserver(
         self,
         selector: #selector(protectedDataWillBecomeUnavailable),
         name: UIApplication.protectedDataWillBecomeUnavailableNotification,
         object: nil
     )
     
     if UIApplication.shared.isProtectedDataAvailable {
         print("Protected data is available.")
     } else {
         print("Protected data is not available.")
     }
     
     return true
 }
 
 @objc func protectedDataDidBecomeAvailable() {
     print("Protected data did become available.")
 }
 
 @objc func protectedDataWillBecomeUnavailable() {
     print("Protected data will become unavailable.")
 }
 ````
*/

/*:
 57.**What is a jailbroken device, and how can you tell if an app is running on one?**
````
 func isDeviceJailbroken() -> Bool {
     #if targetEnvironment(simulator)
     return false
     #else
     let jailbreakFilePaths = [
         "/Applications/Cydia.app",
         "/Library/MobileSubstrate/MobileSubstrate.dylib",
         "/bin/bash",
         "/usr/sbin/sshd",
         "/etc/apt",
         "/private/var/lib/apt/"
     ]
     
     for path in jailbreakFilePaths {
         if FileManager.default.fileExists(atPath: path) {
             return true
         }
     }
     
     if canOpen(path: "/Applications/Cydia.app") {
         return true
     }
     
     if canWriteToRestrictedPath() {
         return true
     }
     
     return false
     #endif
 }

 private func canOpen(path: String) -> Bool {
     if let url = URL(string: path), UIApplication.shared.canOpenURL(url) {
         return true
     }
     return false
 }

 private func canWriteToRestrictedPath() -> Bool {
     let testPath = "/private/jailbreak_test.txt"
     do {
         try "Jailbreak Test".write(toFile: testPath, atomically: true, encoding: .utf8)
         try FileManager.default.removeItem(atPath: testPath)
         return true
     } catch {
         return false
     }
 }
 ````
*/

/*:
  61.**What is caching in iOS apps?**
 
````
 //To access globally we can create a singleton class
 class ImageCacheManager {
     static let shared = ImageCacheManager()
     private let cache = NSCache<NSString, UIImage>()

     // Save image to cache
     func setImage(_ image: UIImage, forKey key: String) {
         cache.setObject(image, forKey: key as NSString)
     }

     // Retrieve image from cache
     func getImage(forKey key: String) -> UIImage? {
         return cache.object(forKey: key as NSString)
     }

     // Clear cache
     func clearCache() {
         cache.removeAllObjects()
     }
 }

 And can be used like below

let imageCache = ImageCacheManager.shared
let imageKey = "User_profile"

if let image = UIImage(named: "profile.jpg") {
    imageCache.setImage(image, forKey: imageKey)
}

// Retrieving image from cache
if let cachedImage = imageCache.getImage(forKey: imageKey) {
    //use the cachedImage above
} else {
    //Not in cache make a network call to download the image
}
````
 **Example of Disk Caching**
 ````
 class DiskCacheManager {
     static let shared = DiskCacheManager()
     
     
     private let cacheDirectory: URL = FileManager.default.temporaryDirectory
     
     // created for image some thing similar can be done for other types of data like video or json etc;
     func saveImage(_ image: UIImage, forKey key: String) {
         let fileURL = cacheDirectory.appendingPathComponent("\(key).png")
         if let imageData = image.pngData() {
             try? imageData.write(to: fileURL)
         }
     }
     
     // Retrieve image from disk cache
     func getImage(forKey key: String) -> UIImage? {
         let fileURL = cacheDirectory.appendingPathComponent("\(key).png")
         if let data = try? Data(contentsOf: fileURL) {
             return UIImage(data: data)
         }
         return nil
     }
     
     // Clear disk cache
     func clearCache() {
         try? FileManager.default.removeItem(at: cacheDirectory)
     }
 }

 It can be used as the following:

         
         let diskCache = DiskCacheManager.shared
         let imageKey = "profile_picture"

         // Save image
         if let image = UIImage(named: "profile.jpg") {
             diskCache.saveImage(image, forKey: imageKey)
         }

         // Retrieve image
         if let cachedImage = diskCache.getImage(forKey: imageKey) {
             //use the cachedImage above
         } else {
             //Not in cache make a network call to download the image
         }
````
*/

/*:
- [Next Chapter](Chapter3)
*/
