/**
 * 归档、解档协议
 * 方便直接归解档Struct
 */

protocol DQSArchivable {
    //archive: transform the struct to the dic which conforms to NSCoding
    func archive() -> NSDictionary
    //unArchive: restore the struct from the dic
    init?(unarchive: NSDictionary?)
}
