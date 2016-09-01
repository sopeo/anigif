
import UIKit

class User: NSObject {
    var id: String?
    var name: String?
    var message: String?
    var icon: String?
    var state: Int?
    
    override init () {
        id = NSUUID().UUIDString
        name = ""
        message = ""
        icon = ""
        state = 0
    }

}
