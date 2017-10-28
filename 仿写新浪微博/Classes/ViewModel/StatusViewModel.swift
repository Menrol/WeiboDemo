//
//  StatusesViewModel.swift
//  仿写新浪微博
//
//  Created by Apple on 2017/6/15.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import UIKit

/// 微博数据模型 - 处理单个微博的业务逻辑
class StatusViewModel: CustomStringConvertible{
    /// 数据模型
    var status: Status
    /// CellId
    var cellID: String {
        return status.retweeted_status != nil ? StatusRetweetCellId : StatusNormalCellId
    }
    /// 用户头像URL
    var userIconURL: URL{
        
        return URL(string: status.user?.profile_image_url ?? "")!
    }
    /// 用户默认头像
    var userdefultImage: UIImage {
        
        return UIImage(named: "avatar_default_big")!
    }
    /// 用户认证图标
    /// -1：没有认证，0：认证用户 ，2,3,5：企业认证，220：达人
    var uservipImage: UIImage? {
        switch status.user?.verified_type ?? -1 {
        case 0:
            return UIImage(named: "avatar_vip")
        case 2,3,5:
            return UIImage(named: "avatar_enterprise_vip")
        case 220:
            return UIImage(named: "avatar_grassroot")
        default:
            return nil
        }
    }
    /// 用户会员图标
    var userMemberImage: UIImage? {
        if (status.user?.mbrank)! > 0 && (status.user?.mbrank)! < 7 {
            return UIImage(named: "common_icon_membership_level\(status.user!.mbrank)")
        }
        return nil
    }
    /// 配图URL数组 - 存储型属性
    var thumbnailUrls: [URL]?
    /// 行高
    var rowHeight: CGFloat = 0
    /// 转发微博
    var retweetText: String? {
        guard let status = status.retweeted_status else {
            return nil
        }
        
        return "@" + (status.user?.screen_name ?? "") + ":" + (status.text ?? "")
    }
    /// 转发数
    var reposts_count: String?
    /// 评论数
    var comments_count: String?
    /// 表态数
    var attitudes_count: String?
    /// 发布时间
    var createTime: String? {
        return Date.sinaDate(string: status.created_at ?? "")?.dateDescirption
    }
    /// 配图视图高度
    var pictureViewSize: CGSize = CGSize()
    
    private func calRowHeight() {
        let margin: CGFloat = 12
        let iconWidth: CGFloat = 35
        let toolbarHeight: CGFloat = 44
        var height: CGFloat = 0
        let labelSize = CGSize(width: UIScreen.main.bounds.width - 2 * margin, height: CGFloat(MAXFLOAT))
        let normalFont = UIFont.systemFont(ofSize: 15)
        let retweetFont = UIFont.systemFont(ofSize: 14)
        
        // 计算顶部高度
        height = 2 * margin + iconWidth + margin
        
        // 微博文本高度
        if let text = status.text {
            height += text.boundingRect(with: labelSize, options: [.usesLineFragmentOrigin], attributes: [NSAttributedStringKey.font: normalFont], context: nil).height
        }
        
        // 转发微博高度
        if status.retweeted_status != nil {
            height += 2 * margin
            
            // 转发文本高度
            if let text = retweetText {
                height += text.boundingRect(with: labelSize, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedStringKey.font: retweetFont], context: nil).height
            }
        }
        
        // 配图视图
        if thumbnailUrls?.count ?? 0 > 0 {
            height += margin * 2 + pictureViewSize.height
        }else {
            height += margin + pictureViewSize.height
        }
        
        // 底部试图高度
        height += toolbarHeight
        
        rowHeight = height
    }
    
    func updateSinglePictureSize(image: UIImage) {
        pictureViewSize = image.size
        
        // 更新行高
        calRowHeight()
    }
    
    private func calPictureViewSize(count: Int?) -> CGSize {
        if count == 0 || count == nil {
            return CGSize()
        }
        
        let row = (count! - 1) / 3 + 1
        let width = UIScreen.main.bounds.width - 2 * StatusCellMargin
        let height = StatusCellPictureViewMargin * CGFloat(row - 1) + StatusCellPictureViewItemWidth * CGFloat(row)
        
        return CGSize(width: width, height: height)
    }
    
    private func countDescription(count: Int, message: String) -> String {
        if count == 0 {
            return message
        }
        if count > 10000 {
            let c = Double(count) / 10000
            
            return String(format: "%.1f万", c)
        }
        
        return "\(count)"
    }
    
    
    init(status: Status) {
        self.status = status
        
        if let urls = status.retweeted_status?.pic_urls ?? status.pic_urls{
            thumbnailUrls = [URL]()
            
            for dic in urls {
                let url = URL(string: dic["thumbnail_pic"]!)
                thumbnailUrls?.append(url!)
            }
        }
        
        reposts_count = countDescription(count: status.reposts_count, message: "转发")
        comments_count = countDescription(count: status.comments_count, message: "评论")
        attitudes_count = countDescription(count: status.attitudes_count, message: "赞")
        
        pictureViewSize = calPictureViewSize(count: thumbnailUrls?.count)
        
        calRowHeight()
    }
    
    var description: String{
        return status.description +  "\((thumbnailUrls ?? []) as NSArray)"
    }
}
