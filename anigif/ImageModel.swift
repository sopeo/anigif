
import UIKit
import CloudKit


@objc protocol ImageModelDelegate {
    func findComplete(result: Image)
    func findFailed(error: NSError)
    func requestComplete(result: [Image])
    func requestFailed(error: NSError)
    func createComplete(result: Image)
    func createFailed(error: NSError)
}


class ImageModel: NSObject {
    static let sharedInstance = ImageModel()
    var delegate: ImageModelDelegate?
    let publicDatabase : CKDatabase = CKContainer.defaultContainer().publicCloudDatabase
    var cursor:CKQueryCursor?
    var images = [Image]()
    let TableName = "Images"
    
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
                let image = Image()
                results!.forEach { result in
                    
                    image.id = result["id"] as? String
                    image.state = result["state"] as? Int
                    image.user_id = result["user_id"] as? String
                    image.emo_id = result["emo_id"] as? String
                    
                    
                }
                self.delegate?.findComplete(image)
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
            let image = Image()
            image.id = record["id"] as? String
            image.state = record["state"] as? Int
            image.user_id = record["user_id"] as? String
            image.emo_id = record["emo_id"] as? String
            self.images.append(image)
        }
        
        queryOp.queryCompletionBlock = { (cursor: CKQueryCursor?, error: NSError?) -> Void in
            if error == nil {
                self.delegate?.requestComplete(self.images)
            } else {
                self.delegate?.requestFailed(error!)
            }
        }
        
        publicDatabase.addOperation(queryOp)
        
    }
    
    func create(data: Image) {
        
        let image = CKRecord(recordType: TableName)
        image.setObject(data.id, forKey: "id")
        image.setObject(data.state, forKey: "state")
        image.setObject(data.user_id, forKey: "user_id")
        image.setObject(data.emo_id, forKey: "emo_id")
        
        // レコードを保存する
        publicDatabase.saveRecord(image) {
            record, error in
            if error == nil {
                self.delegate?.createComplete(data)
            } else {
                // 失敗
                self.delegate?.createFailed(error!)
            }
        }
    }
    
    func saveGif() {
        
    }
    
    
    
    
}