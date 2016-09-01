
import UIKit
import CloudKit


@objc protocol ThreadModelDelegate {
    func findComplete(result: Thread)
    func findFailed(error: NSError)
    func requestComplete(result: [Thread])
    func requestFailed(error: NSError)
    func createComplete(result: Thread)
    func createFailed(error: NSError)
}


class ThreadModel: NSObject {
    static let sharedInstance = ThreadModel()
    var delegate: ThreadModelDelegate?
    let publicDatabase : CKDatabase = CKContainer.defaultContainer().publicCloudDatabase
    var cursor:CKQueryCursor?
    var threads = [Thread]()
    let TableName = "Threads"
    
    //var ud = NSUserDefaults.standardUserDefaults()
    
    private override init() {
        super.init()
    }
    
    func find(id: String) {
        
        let predicate = NSPredicate(format: "id = %@", id)
        let query : CKQuery = CKQuery(recordType: TableName, predicate: predicate)
        
        publicDatabase.performQuery(query, inZoneWithID: nil, completionHandler: {
            results, error in
            
            if error == nil {
                let thread = Thread()
                results!.forEach { result in
                    
                    thread.id = result["id"] as? String
                    thread.user_id = result["user_id"] as? String
                    thread.state = result["state"] as? Int
                    
                }
                self.delegate?.findComplete(thread)
            } else {
                self.delegate?.findFailed(error!)
            }
        })
    }
    
    func request(count: Int) {
        
        let predicate = NSPredicate(format: "state = %d", 0)
        let query: CKQuery = CKQuery(recordType: TableName, predicate: predicate)
        var queryOp : CKQueryOperation
        
        if self.cursor == nil{
            queryOp = CKQueryOperation(query: query)
        } else {
            queryOp = CKQueryOperation(cursor: self.cursor!)
        }
        
        queryOp.resultsLimit = count
        
        queryOp.recordFetchedBlock = {(record:CKRecord!) -> Void in
            let thread = Thread()
            thread.id = record["id"] as? String
            thread.user_id = record["user_id"] as? String
            thread.state = record["state"] as? Int
            self.threads.append(thread)
        }
        
        queryOp.queryCompletionBlock = { (cursor: CKQueryCursor?, error: NSError?) -> Void in
            if error == nil {
                self.delegate?.requestComplete(self.threads)
            } else {
                self.delegate?.requestFailed(error!)
            }
        }
        
        publicDatabase.addOperation(queryOp)
        
    }
    
    func create(data: Thread) {
        
        let thread = CKRecord(recordType: TableName)
        thread.setObject(data.id, forKey: "id")
        thread.setObject(data.user_id, forKey: "user_id")
        thread.setObject(data.state, forKey: "state")
        
        // レコードを保存する
        publicDatabase.saveRecord(thread) {
            record, error in
            if error == nil {
                self.delegate?.createComplete(data)
            } else {
                // 失敗
                self.delegate?.createFailed(error!)
            }
        }
    }
    
    
    
    
}