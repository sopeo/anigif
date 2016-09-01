
import UIKit
import CloudKit


@objc protocol UserModelDelegate {
    func findComplete(result: User)
    func findFailed(error: NSError)
    func requestComplete(result: [User])
    func requestFailed(error: NSError)
    func createComplete(result: User)
    func createFailed(error: NSError)
}


class UserModel: NSObject {
    static let sharedInstance = UserModel()
    weak var delegate: UserModelDelegate?
    let publicDatabase : CKDatabase = CKContainer.defaultContainer().publicCloudDatabase
    var cursor:CKQueryCursor?
    var users = [User]()
    let TableName = "Profiles"
    var ud = NSUserDefaults.standardUserDefaults()
    
    private override init() {
        super.init()
    }
    
    func find(id: String) {
        
        let predicate = NSPredicate(format: "id = %@", id)
        let query : CKQuery = CKQuery(recordType: TableName, predicate: predicate)

        publicDatabase.performQuery(query, inZoneWithID: nil, completionHandler: {
            results, error in
            
            if error == nil {
                let user = User()
                results!.forEach { result in

                    user.id = result["id"] as? String
                    user.name = result["name"] as? String
                    user.icon = result["icon"] as? String
                    user.state = result["state"] as? Int
                    user.message = result["message"] as? String
                    
                }
                self.delegate?.findComplete(user)
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
            let user = User()
            user.id = record["id"] as? String
            user.icon = record["icon"] as? String
            user.state = record["state"] as? Int
            user.message = record["message"] as? String
            self.users.append(user)
        }
        
        queryOp.queryCompletionBlock = { (cursor: CKQueryCursor?, error: NSError?) -> Void in
            if error == nil {
                self.delegate?.requestComplete(self.users)
            } else {
                self.delegate?.requestFailed(error!)
            }
        }
        
        publicDatabase.addOperation(queryOp)

    }
    
    func create(data: User) {

        let user = CKRecord(recordType: TableName)
        user.setObject(data.id, forKey: "id")
        user.setObject(data.name, forKey: "name")
        user.setObject(data.icon, forKey: "icon")
        user.setObject(data.state, forKey: "state")
        user.setObject(data.message, forKey: "message")
        
        // レコードを保存する
        publicDatabase.saveRecord(user) {
            record, error in
            if error == nil {
                self.delegate?.createComplete(data)
                self.ud.setObject(data, forKey: "user")
            } else {
                // 失敗
                self.delegate?.createFailed(error!)
            }
        }
    }
    
    


}