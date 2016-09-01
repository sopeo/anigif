
import UIKit

class Image: NSObject {
    var id: String?
    var user_id: String?
    var emo_id: String?
    var path: String?
    var state: Int?
    var like_count: Int?
    
    override init () {
        id = NSUUID().UUIDString
        user_id = ""
        emo_id = ""
        path = ""
        state = 0
        like_count = 0
    }
}
