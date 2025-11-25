// To view markdown: Xcode -> Editor -> Show Rendered Markup
/*:
 # Chapter 3
 This Playground is designed to follow the book's structure closely. Each code snippet is labeled with the same question number as in the book, so you can easily match the code with the corresponding question or example.
 - - -
*/
/*:
 8.**What are Cyclomatic Complexities in iOS apps?**
 ![Cyclomatic Complexity error in xcode](Q8-1.png)
 
 **Such error can be avoided if UI updates are being done on Main thread.**
 ![Cyclomatic Complexity error in xcode](Q8-2.png)
 
 */

/*:
 10.**What are GCD queues and when to use them?**
 ````
 //Example of Main thread
 DispatchQueue.main.async {
    myLabel.text = "UI should Always update on Main thread"
 }
 ````
 **Example of Global queue**
 ````
 DispatchQueue.global(qos: .background).async {
     print("Background task running")
     let result = someDataFetching()
     // Should be call on Background thread
 }
````
 */

/*:
 11.**Difference between Sync and Async in GCD?**
 **Example of how async works**
 */
import Foundation
import PlaygroundSupport

 let queue = DispatchQueue.global()

 print("Before async task")
 queue.async {
     Thread.sleep(forTimeInterval: 2)
     print("Async task completed")
 }
 print("After async task")
 //will print
 //Before async task
 //After async task
 //Async task completed
/*:
**Synchronous dispatch (sync)**
*/

let syncQueue = DispatchQueue.global()

print("Before sync task")
syncQueue.sync {
    Thread.sleep(forTimeInterval: 2)
    print("Sync task completed")
}
print("After sync task")
// Output:
//Before sync task
//Sync task completed (Wait for 2 seconds)
//After sync task

/*:
 12.**How DispatchSemaphores work in GCD?**
 
 */
let semaphore = DispatchSemaphore(value: 2) // Allows 2 concurrent tasks
let semaphoreQueue = DispatchQueue.global()

for i in 1...5 {
    semaphoreQueue.async {
        semaphore.wait() // will decrement semaphore count
        print("Task \(i) started")
        sleep(2) // do some network task/ database access etc;
        print("Task \(i) completed")
        semaphore.signal() // will increment semaphore count, signal next task to access the resource
    }
}
/*:
 **Cancel a DispatchWorkItem Example**
 */

let workItem = DispatchWorkItem {
    for i in 1...5 {
        if workItem.isCancelled { return }
        print("Task \(i)")
        sleep(1)
    }
}

let dispatchWorkItemQueue = DispatchQueue.global()
dispatchWorkItemQueue.async(execute: workItem)
workItem.cancel()
print("Canceled, before start")
//output:  Canceled, before start

/*:
 **Synchronous execution of a DispatchWorkItem Example**
 */

let syncWorkItem = DispatchWorkItem {
    print("Task started")
    sleep(2)
    print("Task finished")
}
let syncWorkItemQueue = DispatchQueue.global()
syncWorkItemQueue.async(execute: syncWorkItem)
syncWorkItem.wait()
print("Finished Waiting")
//output:
//Task started
//Task finished
//Finished Waiting

/*:
 **Modify Execution Behaviour**
 */
let behaviourWorkItem = DispatchWorkItem {
    print("Primary task completed")
}
let nextWorkItem = DispatchWorkItem {
    print("Next work item executed.")
}

let behaviourWorkItemQueue = DispatchQueue.global()
behaviourWorkItemQueue.async(execute: behaviourWorkItem)
behaviourWorkItem.notify(queue: .main, execute: nextWorkItem)
//Output:
//Primary task completed
//Next work item executed.

/*:
 **Adjusting QoS dynamically**
 */

let qosQueue = DispatchQueue.global()
// Define a work item with an initial QoS
var qosWorkItem = DispatchWorkItem(qos: .utility) {
    print("Executing task with initial QoS: Utility")
    sleep(2)
    print("Task completed")
}

// Execute with initial QoS
qosQueue.async(execute: qosWorkItem)

// Simulate a priority boost after 1 second
DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
    print("Re-executing with higher QoS: User Initiated")
    
    // Create a new work item with a higher QoS
    qosWorkItem = DispatchWorkItem(qos: .userInitiated) {
        print("Executing task with boosted QoS: User Initiated")
        sleep(2)
        print("Boosted task completed")
    }
    qosQueue.async(execute: qosWorkItem)
}
//Executing task with initial QoS: Utility
//Re-executing with higher QoS: User Initiated
//Executing task with boosted QoS: User Initiated
//Task completed

/*:
 14.**What is role of OperationQueue and BlockOperation in GCD?**
 
 */
let operationQueue = OperationQueue()
operationQueue.maxConcurrentOperationCount = 2 // Limits concurrency

operationQueue.addOperation {
    print("Task 1 - Executed on: \(Thread.current)")
}

operationQueue.addOperation {
    print("Task 2 - Executed on: \(Thread.current)")
}
//Output:
//Task 1 - Executed on: <NSThread: 0x600001706380>{number = 5, name = (null)}
//Task 2 - Executed on: <NSThread: 0x600001709200>{number = 2, name = (null)}

/*:
 **Example of Block Operation**
 */

let blockOperationQueue = OperationQueue()

let blockOperation1 = BlockOperation {
    print("Block 1 started")
    sleep(2) // Simulate some work
    print("Block 1 finished")
}

let blockOperation2 = BlockOperation {
    print("Block 2 started")
    sleep(1)
    print("Block 2 finished")
}

blockOperation2.addDependency(blockOperation1) // Block 2 depends on Block 1

blockOperationQueue.addOperation(blockOperation1)
blockOperationQueue.addOperation(blockOperation2)

blockOperationQueue.waitUntilAllOperationsAreFinished() // Wait until all operations complete.
print("All operations finished")

//output:
//Block 1 started
//Block 1 finished
//Block 2 started
//Block 2 finished
//All operations finished

/*:
 21.**How to Use Keychain in iOS apps?**
 
 ````
 import Security

 func saveToKeychain(account: String, password: String) {
     let data = password.data(using: .utf8)!
     
     let query: [String: Any] = [
         kSecClass as String: kSecClassGenericPassword,
         kSecAttrAccount as String: account,
         kSecValueData as String: data
     ]
     SecItemAdd(query as CFDictionary, nil)
 }

 func retrieveFromKeychain(account: String) -> String? {
     let query: [String: Any] = [
         kSecClass as String: kSecClassGenericPassword,
         kSecAttrAccount as String: account,
         kSecReturnData as String: kCFBooleanTrue!,
         kSecMatchLimit as String: kSecMatchLimitOne
     ]
     
     var dataTypeRef: AnyObject?
     if SecItemCopyMatching(query as CFDictionary, &dataTypeRef) == errSecSuccess {
         if let data = dataTypeRef as? Data {
             return String(data: data, encoding: .utf8)
         }
     }
     return nil
 }
 ````
 */

/*:
 23.**What is background fetch and when we should implement such feature in your app?**
 
 **Adding Background mode capability**
 ![Adding Background mode capability](Q23-1.png)
 
 **Enabling Background Fetch**
 ![Enabling Background fetch](Q23-2.png)
 
 **Adding BG task schedular identifier in info.plist**
 ![Adding Background task scheduler identifier in Info.plist](Q23-3.png)
 
 After all set up above use the below code for background fetch
 ````
 func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
         // Register background task
         BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.yourapp.fetchData", using: nil) { task in
             self.handleBackgroundFetch(task: task as! BGAppRefreshTask)
         }
         return
}
 ````
*/

/*:
 26.**What are the Zombies objects in iOS?**
 
 **Enabling Zombies object in project's scheme**
 ![Enabling Background fetch](Q26.png)
 */

/*:
30.**What is the Thread Sanitizer (TSan) in iOS?**
 
 **Enabling Thread Sanitizer in project scheme**
 ![Enabling Background fetch](Q26.png)
 
 //MARK: Playground may not show the data race, Please create a sample proejct and run the below code snippet.
 ````
 class TSanExample {
        var count = 0
 }

 let dataRaceExample = TSanExample()
 DispatchQueue.global().async {
     dataRaceExample.count += 1  // (Data race here)
 }
 DispatchQueue.global().async {
     dataRaceExample.count += 1  // (Data race here)
 }
 ````
 **System will generate the purple warning for the data race points shown above in code snippet**
 ![Enabling Background fetch](Q31-1.png)

 **TSan showing the warning on console as well please review the below screenshot**
 ![Enabling Background fetch](Q31-2.png)
 
 */

/*:
32.**What do you mean by Quick Actions/Home Screen Quick Actions for an app?**
 
 **Below actions usually referred as Quick Actions for an app**
 ![Enabling Background fetch](Q32-1.png)
 
 **Adding Shortcut information in Info.plist**
 ![Adding short cut info in Info.plist](Q32-2.png)
 
 **Now create actions and perform action on user's selection on quick action/shotcut**
 
 ````
 // Create an enum to List of shortcut actions
 enum ActionType: String {
     case search = "Search"
     case share = "Share"
 }
````
 ````
 // 2. Create a function to handle user's action on short cut items
 func windowScene(_ windowScene: UIWindowScene,
                      performActionFor shortcutItem: UIApplicationShortcutItem,
                      completionHandler: @escaping (Bool) -> Void) {
         //Call a function to handle the shortcut item's action here and pass it to a closure so that the system knows the action is complete.
         let handled = handleShortCutItem(shortcutItem: shortcutItem)
         completionHandler(handled)
         }

 ````
 ````
 //Handling of shortcut actions
 func handleShortCutItem(shortcutItem: UIApplicationShortcutItem) -> Bool {
         if let selectedAction = ActionType(rawValue: shortcutItem.type) {
             switch selectedAction {
             case .search:
                 showAlert(message: "Search triggered")
             case .share:
                 showAlert(message: "Share triggered")
         }
         return true
     }
 }
 ````
*/

/*:
 36.**Please explain the concepts of PassthroughSubject and CurrentValueSubject in Combine**

 **Example of how subscriptions work with PassthroughSubjects**
 */
import Combine
 
 let subject = PassthroughSubject<String, Never>()
 
 let subscriber1 = subject.sink { value in
     print("Subscriber 1 received: \(value)")
 }
 //Early subscription of subject will receive all values
 subject.send("Early")
 subject.send("Subscription")

 let subscriber2 = subject.sink { value in
     print("Subscriber 2 received: \(value)")
 }
 //Subscriber 2 will receive values after subscription (Only last value will be received)
 subject.send("Another Value")
 //Output:
 //Subscriber 1 received: Early
 //Subscriber 1 received: Subscription
 //Subscriber 1 received: Another Value
 //Subscriber 2 received: Another Value

/*:
**Example of how subscriptions work with PassthroughSubjects**
*/

let currentValueSubject = CurrentValueSubject<String, Never>("Initial Value")

let currentValueSubscriber = currentValueSubject.sink { value in
    print("Subscriber 1 received: \(value)")
}
// Output: 1st Susbcriber will recevies the initial value and updated too.
currentValueSubject.send("Updated Value")
let currentValueSubscriber2 = currentValueSubject.sink { value in
    print("Subscriber 2 received: \(value)")
}
// 2nd Susbcriber will (Receives the last stored value immediately)
//Output will be
//Subscriber 1 received: Initial Value
//Subscriber 1 received: Updated Value
//Subscriber 2 received: Updated Value


/*:
 37.**What is AnyCancellable in Combine?**

 ````
 var cancellable: AnyCancellable?

 let publisher = Just("Hello, World!")
 cancellable = publisher.sink { value in
     print(value)
 }
 cancellable = nil
 ````
 */


/*:
 38.**What is backpressure and how Combine handle it?**
 */

let publisher = (1...10).publisher

final class CustomSubscriber: Subscriber {
    typealias Input = Int
    typealias Failure = Never

    func receive(subscription: Subscription) {
        // Request only 3 values initially
        subscription.request(.max(3))
    }

    func receive(_ input: Int) -> Subscribers.Demand {
        print("Received value: \(input)")
        sleep(2) // Simulate some processing time
        return .max(1)
    }

    func receive(completion: Subscribers.Completion<Never>) {
        print("Completed")
    }
}

let subscriber = CustomSubscriber()
publisher.subscribe(subscriber)
//Output:
//Received value: 1
//Received value: 2
//Received value: 3
//Received value: 4
//Received value: 5
//Received value: 6
//Received value: 7
//Received value: 8
//Received value: 9
//Received value: 10
//Completed

/*:
 39.**What do you understand debounce and throttle in Combine?**
 
 **Debounce Example**
 ````
class MessageAutoSaveManager {
    private var cancellables = Set<AnyCancellable>()
    private let subject = PassthroughSubject<String, Never>()
    
    init() {
        subject
            .debounce(for: .seconds(1.0), scheduler: RunLoop.main)
        //I would suggest to comment the above code and see the output
            .sink { [weak self] message in
                self?.saveDraft(message)
            }
            .store(in: &cancellables)
    }
    
    func messageDidChange(_ message: String) {
        subject.send(message)
    }
    
    private func saveDraft(_ message: String) {
        // Code to save the draft
        print("Draft saved: \(message)")
    }
}

let autoSaveManager = MessageAutoSaveManager()
autoSaveManager.messageDidChange("First message")
autoSaveManager.messageDidChange("Second message")
autoSaveManager.messageDidChange("Final message")
 ````
 **Throttle Example**
 ````
 class MessageAutoSaveManager {
     private var cancellables = Set<AnyCancellable>()
     private let subject = PassthroughSubject<String, Never>()

     init() {
         subject
              .throttle(for: .seconds(1.0), scheduler: RunLoop.main, latest: true)
             // Try commenting throttle to see the difference in how often the saveDraft is called
             .sink { [weak self] message in
                 self?.saveDraft(message)
             }
             .store(in: &cancellables)
     }

     func messageDidChange(_ message: String) {
         subject.send(message)
     }

     private func saveDraft(_ message: String) {
         // Code to save the draft
         print("Draft saved: \(message)")
     }
 }

 let autoSaveManager = MessageAutoSaveManager()
 autoSaveManager.messageDidChange("First message")
 autoSaveManager.messageDidChange("Second message")
 autoSaveManager.messageDidChange("Final message")

 ````
 */

/*:
 40.**How to improve operations in complex combine operations?**
 
 **Break Operation in smaller units**
 
**Before**
 ````
 let publisher = URLSession.shared.dataTaskPublisher(for: URL(string: "https://example.com/api/data")!)
     .map { $0.data }
     .decode(type: DataResponse.self, decoder: JSONDecoder())
     .catch { _ in Just(DataResponse()) }
     .sink { [weak self] response in
         self?.handleResponse(response)
     }
````
 **After**
 ````
 func fetchData() -> AnyPublisher<DataResponse, Never> {
     URLSession.shared.dataTaskPublisher(for: URL(string: "https://example.com/api/data")!)
         .map { $0.data }
         .decode(type: DataResponse.self, decoder: JSONDecoder())
         .catch { _ in Just(DataResponse()) }
         .eraseToAnyPublisher()
 }
````
 
 **Create Custom Extension or operator if required**
 ````
 extension Publisher {
     func filterNil<T>() -> Publishers.CompactMap<Self, T> where Self.Output == T? {
         return compactMap { $0 }
     }
 }

 ````
 
 **Operator ordering optimization**
 
 **Bad Approach**
 ````
 publisher
     .map { expensiveTransformation($0) }
     .filter { $0.shouldProcess }
````
 
 **Good approach**
 ````
 publisher
     .filter { $0.shouldProcess }
     .map { expensiveTransformation($0) }

 ````
 */

/*:
 41.**What are the ways we can add functional reactive programming with imperative programming in Swift?**
 
 **Bring Reactive Subjects to bridge gap between UIKit's event and Actions**
 ````
 let combineSubject = PassthroughSubject<Void, Never>()

 @objc func buttonPressed() {
     combineSubject.send()
 }

 combineSubject
     .sink { print("Button was tapped") }
     .store(in: &cancellables)
````
 
 **Combine Publishers along with UIKit's Components**
 ````
 textField
     .publisher(for: \.text)
     .compactMap { $0 }
     .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
     .sink { query in
         print("Search query: \(query)")
     }
     .store(in: &cancellables)

 ````
*/

/*:
 44.**What are the SOLID principle of programming?**
 
 **5 Solid Principles are as:**
 ![Solid Principles](Q44.png)
 
 */
 
 

