

import UIKit
import CloudKit

class ViewController: BaseViewController, UserModelDelegate {
    
    let userModel = UserModel.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        let respons = Respons()
        respons.state = ""
        respons.thread_id = "2"
        respons.user_id = "rerererere"
        respons.image_id = "aaa"
        respons.message = "fdsafaa"
 */
        
        //ResponsModel.save(respons)
        
        /*
        let user = User()
        user.name = "nagomin"
        user.message = "よろいくちゃああああ"
        user.icon = ""
        let userModel = UserModel.sharedInstance
        userModel.save(user)
 */
        
        
        //userModel.delegate = self
        //userModel.request(2)
        
        
        //userModel.addObserver(self, forKeyPath: "users", options: NSKeyValueObservingOptions(), context: nil)
        
        

        
    }
    

    
    
    override func viewDidDisappear(animated: Bool){
        //userModel.removeObserver(self, forKeyPath: "users")
    }
    

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }


    
    @IBAction func tap() {
        print("tap")
        //userModel.request(2)

    }
    
    func findComplete(result: User) {}
    func findFailed(error: NSError) {}
    func requestComplete(result: [User]) {
        print(result)
        print("------")
    }
    func requestFailed(error: NSError) {}
    func createComplete(result: User) {}
    func createFailed(error: NSError) {}


}


