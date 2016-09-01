
import UIKit

class Thread: NSObject {
    var id: String?
    var user_id: String?
    var state: Int?
    
    override init () {
        id = NSUUID().UUIDString
        user_id = ""
        state = 0
    }
}
