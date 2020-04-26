/**
 * 实体协议
 */

protocol THJGBaseBean {
    static func parse(_ data: JSONTYPE) -> Self
}
