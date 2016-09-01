
import UIKit
import CloudKit


@objc protocol ResponsModelDelegate {
    func findComplete(result: Respons)
    func findFailed(error: NSError)
    func requestComplete(result: [Respons])
    func requestFailed(error: NSError)
    func createComplete(result: Respons)
    func createFailed(error: NSError)
}


class ResponsModel: NSObject {
    static let sharedInstance = ResponsModel()
    var delegate: ResponsModelDelegate?
    let publicDatabase : CKDatabase = CKContainer.defaultContainer().publicCloudDatabase
    var cursor:CKQueryCursor?
    var respons = [Respons]()
    let TableName = "Responses"
    
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
                let respons = Respons()
                results!.forEach { result in
                    
                    respons.id = result["id"] as? String
                    respons.state = result["state"] as? Int
                    respons.thread_id = result["thread_id"] as? String
                    respons.user_id = result["user_id"] as? String
                    respons.image_id = result["image_id"] as? String
                    respons.message = result["message"] as? String
                    
                }
                self.delegate?.findComplete(respons)
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
            let respons = Respons()
            respons.id = record["id"] as? String
            respons.state = record["state"] as? Int
            respons.thread_id = record["thread_id"] as? String
            respons.user_id = record["user_id"] as? String
            respons.image_id = record["image_id"] as? String
            respons.message = record["message"] as? String
            self.respons.append(respons)
        }
        
        queryOp.queryCompletionBlock = { (cursor: CKQueryCursor?, error: NSError?) -> Void in
            if error == nil {
                self.delegate?.requestComplete(self.respons)
            } else {
                self.delegate?.requestFailed(error!)
            }
        }
        
        publicDatabase.addOperation(queryOp)
        
    }
    
    func create(data: Respons) {
        
        let thread = CKRecord(recordType: TableName)
        thread.setObject(data.id, forKey: "id")
        thread.setObject(data.state, forKey: "state")
        thread.setObject(data.thread_id, forKey: "thread_id")
        thread.setObject(data.user_id, forKey: "user_id")
        thread.setObject(data.image_id, forKey: "image_id")
        thread.setObject(data.message, forKey: "message")
        
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