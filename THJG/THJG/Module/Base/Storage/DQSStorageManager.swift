/**
 * 存储相关
 */

class DQSStorageManager {

    /**
     * 存储数据
     * @param obj      数据
     * @param filePath 存储路径
     */
    static func archiveObj(_ obj: Any, to filePath: String) {
        NSKeyedArchiver.archiveRootObject(obj, toFile: filePath)
    }
    
    /**
     * 读取数据
     * @param filePath 存储路径
     * @return 
     */
    static func unArchiveObj(from filePath: String) -> Any? {
       return NSKeyedUnarchiver.unarchiveObject(withFile: filePath)
    }
    
}
