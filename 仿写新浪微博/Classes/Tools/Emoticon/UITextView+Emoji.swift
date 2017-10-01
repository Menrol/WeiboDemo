//
//  UITextView+Emoji.swift
//  Emoticon
//
//  Created by Apple on 2017/8/16.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import UIKit

extension UITextView {
    
    /// 表情文本
    var emoticonText: String? {
        let attributedText = self.attributedText!
        var strM: String = String()
        
        attributedText.enumerateAttributes(in: NSRange(location: 0, length: attributedText.length), options: []) { (dic, range, _) in
            
            if let attr = dic["NSAttachment"] as? EmoticonAttachment {
                strM += attr.emoticon.chs ?? ""
            }else {
                let str = (attributedText.string as NSString).substring(with: range)
                strM += str
            }
        }
        
        return strM
    }

    
    /// 显示表情
    func insertEmoticon(emoticon: Emoticon) {
        // 空白表情
        if emoticon.isEmpty {
            return
        }
        
        // 删除表情
        if emoticon.isDelete {
            deleteBackward()
            return
        }
        
        // emoji
        if let emoji = emoticon.emoji {
            replace(selectedTextRange!, withText: emoji)
            return
        }
        
        // 图片表情
        insertImageEmoticon(emoticon: emoticon)
        
        // 通知代理文本变化了
        delegate?.textViewDidChange!(self)
    }
    
    /// 显示图片表情
    private func insertImageEmoticon(emoticon: Emoticon) {
        // 图片的属性文本
        let imageText = EmoticonAttachment(emoticon: emoticon).imageText(font: font!)
        // 记录attributeString
        let attributedString = NSMutableAttributedString(attributedString: attributedText)
        // 插入图片文本
        attributedString.replaceCharacters(in: selectedRange, with: imageText)
        // 记录光标位置
        let range = selectedRange
        // 替换愿来的字符串
        attributedText = attributedString
        // 恢复光标
        selectedRange = NSRange(location: range.location + 1, length: 0)
    }

}
