
import UIKit
import CloudKit


@objc protocol LikeModelDelegate {
    func findComplete(result: Like)
    func findFailed(error: NSError)
    func requestComplete(result: [Like])
    func requestFailed(error: NSError)
    func createComplete(result: Like)
    func createFailed(error: NSError)
}


class LikeModel: NSObject {
    static let sharedInstance = LikeModel()
    var delegate: LikeModelDelegate?
    let publicDatabase : CKDatabase = CKContainer.defaultContainer().publicCloudDatabase
    var cursor:CKQueryCursor?
    var likes = [Like]()
    let TableName = "Likes"
    
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
                let like = Like()
                results!.forEach { result in
                    
                    like.id = result["id"] as? String
                    like.state = result["state"] as? Int
                    like.user_id = result["user_id"] as? String
                    like.image_id = result["image_id"] as? String
                    
                }
                self.delegate?.findComplete(like)
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
            let like = Like()
            like.id = record["id"] as? String
            like.state = record["state"] as? Int
            like.user_id = record["user_id"] as? String
            like.image_id = record["image_id"] as? String
            self.likes.append(like)
        }
        
        queryOp.queryCompletionBlock = { (cursor: CKQueryCursor?, error: NSError?) -> Void in
            if error == nil {
                self.delegate?.requestComplete(self.likes)
            } else {
                self.delegate?.requestFailed(error!)
            }
        }
        
        publicDatabase.addOperation(queryOp)
        
    }
    
    func create(data: Like) {
        
        let like = CKRecord(recordType: TableName)
        like.setObject(data.id, forKey: "id")
        like.setObject(data.state, forKey: "state")
        like.setObject(data.user_id, forKey: "user_id")
        like.setObject(data.image_id, forKey: "image_id")
        
        // レコードを保存する
        publicDatabase.saveRecord(like) {
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