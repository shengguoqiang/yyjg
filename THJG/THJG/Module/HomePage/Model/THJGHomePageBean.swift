/**
 * 首页实体
 */

//MARK: - HOMEPAGE_BEAN
struct THJGHomePageBean: THJGBaseBean {
    
    //properties
    var banners: [THJGBannerBean]
    var bulletins: [PlatformNoticeBean]
    var newsInfos: [THJGNewsBean]
    var projects: [THJGProjectBean]
    
    static func parse(_ data: JSONTYPE) -> THJGHomePageBean {
        //banner
        var banners = [THJGBannerBean]()
        if let bannerArray = data["banners"].array {
            for banner in bannerArray {
                banners.append(THJGBannerBean.parse(banner))
            }
        }
        //bulletin
        var bulletins = [PlatformNoticeBean]()
        if let bulletinArray = data["bulletins"].array {
            for bulletin in bulletinArray {
                bulletins.append(PlatformNoticeBean.parse(bulletin))
            }
        }
        //news
        var newsInfos = [THJGNewsBean]()
        if let newsInfoArray = data["newsInfos"].array {
            for newsInfo in newsInfoArray {
                newsInfos.append(THJGNewsBean.parse(newsInfo))
            }
        }
        //project
        var projects = [THJGProjectBean]()
        if let projectArray = data["projects"].array {
            for project in projectArray {
                projects.append(THJGProjectBean.parse(project))
            }
        }
        
        return THJGHomePageBean(banners: banners,
                                bulletins: bulletins,
                                newsInfos: newsInfos,
                                projects: projects)
    }
    
    
}

//MARK: - BANNER_BEAN
struct THJGBannerBean: THJGBaseBean {
    
    //properties
    var bannerId: String
    var bannerType: Int
    var bannerImg: String
    var bannerLink: String
    var bannerTitle: String
    
    //parse method
    static func parse(_ data: JSONTYPE) -> THJGBannerBean {
        return THJGBannerBean(bannerId: data["bannerId"].string ?? "",
                                      bannerType: data["bannerType"].int ?? 0,
                                      bannerImg: data["bannerImg"].string ?? "",
                                      bannerLink: data["bannerLink"].string ?? "",
                                      bannerTitle: data["bannerTitle"].string ?? "")
    }
    
}

//MARK: - NEWS_BEAN
struct THJGNewsBean: THJGBaseBean {
    var newsId: String
    var newsTitle: String
    var newsImg: String
    var newsDate: Int64
    var newsType: Int // 10 新闻资讯 20 企业资讯 30 行业动态 40 政策动向
    var newsAbstract: String
    
    static func parse(_ data: JSONTYPE) -> THJGNewsBean {
        return THJGNewsBean(newsId: data["newsId"].string ?? "",
                            newsTitle: data["newsTitle"].string ?? "",
                            newsImg: data["newsImg"].string ?? "",
                            newsDate: data["newsDate"].int64 ?? 0,
                            newsType: data["newsType"].int ?? 0,
                            newsAbstract: data["newsAbstract"].string ?? "")
    }
}

//MARK: - PROJECT_BEAN
struct THJGProjectBean: THJGBaseBean {
    
    //properties
    var projectId: String
    var projectName: String
    var projectStatus: Int
    var projectImg: String
    var projectType: String
    var projectLoanAmount: Double
    var projectLoanBalance: Double
    var projectExpireDate: Int64
    
    //parse method
    static func parse(_ data: JSONTYPE) -> THJGProjectBean {
        return THJGProjectBean(projectId: data["projectId"].string ?? "",
                               projectName: data["projectName"].string ?? "",
                               projectStatus: data["projectStatus"].int ?? 0,
                               projectImg: data["projectImg"].string ?? "",
                               projectType: data["projectType"].string ?? "",
                               projectLoanAmount: data["projectLoanAmount"].double ?? 0,
                               projectLoanBalance: data["projectLoanBalance"].double ?? 0,
                               projectExpireDate: data["projectExpireDate"].int64 ?? 0)
    }
    
}

//MARK: - 版本升级
struct THJGAppUpgradeBean: THJGBaseBean {
    var upgrades: [AppUpgradeBean]
    
    static func parse(_ data: JSONTYPE) -> THJGAppUpgradeBean {
        var upgrades = [AppUpgradeBean]()
        if let upgradesArray = data["upgrades"].array {
            for up in upgradesArray {
                upgrades.append(AppUpgradeBean.parse(up))
            }
        }
        return THJGAppUpgradeBean(upgrades: upgrades)
    }
}

struct AppUpgradeBean: THJGBaseBean {
    
    var upgradeForce: Int
    var upgradeVersion: String
    var upgradeContent: String
    var upgradeDownloadUrl: String
    
    static func parse(_ data: JSONTYPE) -> AppUpgradeBean {
        return AppUpgradeBean(upgradeForce: data["upgradeForce"].int ?? 0,
                              upgradeVersion: data["upgradeVersion"].string ?? "",
                              upgradeContent: data["upgradeContent"].string ?? "",
                              upgradeDownloadUrl: data["upgradeDownloadUrl"].string ?? "")
    }
}

//MARK: - 紧急公告实体
struct THJGEmergentMsgBean: THJGBaseBean {

    var emergentMsgs: [EmergentMsgBean]
    
    static func parse(_ data: JSONTYPE) -> THJGEmergentMsgBean {
        var emergentMsgs = [EmergentMsgBean]()
        if let emergentMsgsArray = data["emergentMsgs"].array {
            for emer in emergentMsgsArray {
                emergentMsgs.append(EmergentMsgBean.parse(emer))
            }
        }
        return THJGEmergentMsgBean(emergentMsgs: emergentMsgs)
    }
}

struct EmergentMsgBean: THJGBaseBean  {
    
    var msgTitle: String
    var msgContent: String
    
    static func parse(_ data: JSONTYPE) -> EmergentMsgBean {
        return EmergentMsgBean(msgTitle: data["msgTitle"].string ?? "",
                                   msgContent: data["msgContent"].string ?? "")
    }
    
}

