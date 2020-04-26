/**
 * 投后监管存储
 */

import UIKit

//doc path
let kDocPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
//user storage path
let kUserStoragePath = (kDocPath as NSString).appendingPathComponent("thjg.userBean")

class THJGStorageManager: NSObject {
    
    //write user to file
    static func writeUser(_ user: THJGUserBean) {
        DQSStorageManager.archiveObj(user.archive(), to: kUserStoragePath)
    }
    
    //read user from file
    static func readUser() -> THJGUserBean? {
      return THJGUserBean(unarchive: DQSStorageManager.unArchiveObj(from: kUserStoragePath) as? NSDictionary)
    }
    
    //delete user from file
    static func deleteUser() {
        let file = FileManager.default
        if file.fileExists(atPath: kUserStoragePath) {
            do {
                try file.removeItem(atPath: kUserStoragePath)
            } catch {
                DQSUtils.log("用户数据清空异常：userbean-archive-path:\(kUserStoragePath)")
            }
        }
    }
}
