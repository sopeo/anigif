
import UIKit

class LoginViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    func checkUserID() {
        let user = UserModel.sharedInstance
        let userData = user.getUserData()
        if userData["id"] != nil {
            changeStroyBoard()
        }
    }*/
    
    func changeStroyBoard() {
        var stbNextView: UIStoryboard!
        var nvcNextViewCtrl: ViewController!
        stbNextView = UIStoryboard(name: "Main", bundle: nil)
        nvcNextViewCtrl = stbNextView!.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        self.presentViewController(nvcNextViewCtrl, animated:false, completion: nil)
    }
    
    
    @IBAction func changeView() {
        changeStroyBoard()
    }
    
}


