
import UIKit

class Respons: NSObject {
    var id: String?
    var state: Int?
    var thread_id: String?
    var user_id: String?
    var image_id: String?
    var message: String?
    
    override init () {
        id = NSUUID().UUIDString
        state = 0
        thread_id = ""
        user_id = ""
        image_id = ""
        message = ""
    }
}

