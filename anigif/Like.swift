
import UIKit

class Like: NSObject {
    var id: String?
    var image_id: String?
    var user_id: String?
    var state: Int?
    
    override init () {
        id = NSUUID().UUIDString
        image_id = ""
        user_id = ""
        state = 0
    }
}
