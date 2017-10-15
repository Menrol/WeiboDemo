//
//  EmoticonAttachment.swift
//  Emoticon
//
//  Created by Apple on 2017/8/15.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import UIKit

class EmoticonAttachment: NSTextAttachment {
    /// 表情模型
    var emoticon: Emoticon
    
    /// 将当前附件中的 emoticon 转换成属性文本
    func imageText(font: UIFont) -> NSMutableAttributedString {
        // 线高表示字体的高度
        let lineHeight = font.lineHeight
        // 图片的属性文本
        let attachment = EmoticonAttachment(emoticon: emoticon)
        attachment.image = UIImage(contentsOfFile: emoticon.path)
        // frame = center + bounds * tranform
        // bounds(x,y) = contentOffSet
        attachment.bounds = CGRect(x: 0, y: -4, width: lineHeight, height: lineHeight)
        let imageText = NSMutableAttributedString(attributedString: NSAttributedString(attachment: attachment))
        // 添加字体
        imageText.addAttribute(NSAttributedStringKey.font, value: font, range: NSRange(location: 0, length: 1))
        
        return imageText
    }
    
    // MARK: - 构造函数
    init(emoticon: Emoticon) {
        self.emoticon = emoticon
        super.init(data: nil, ofType: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
