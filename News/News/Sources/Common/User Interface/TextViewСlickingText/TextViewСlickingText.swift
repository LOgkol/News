//
//  TextViewСlickingText.swift
//  NewsTFS
//
//  Created by Александр Джегутанов on 2/5/23.
//

import UIKit

final class TextViewWithLink: UITextView {
    
    typealias Links = [String: String]
    
    //MARK: - Init
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        isEditable = false
        isSelectable = true
        isScrollEnabled = false
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - Public Method
    
    func addLinks(_ links: Links) {
        guard attributedText.length > 0  else {
            return
        }
        let mText = NSMutableAttributedString(attributedString: attributedText)
        
        for (linkText, urlString) in links {
            if linkText.count > 0 {
                let linkRange = mText.mutableString.range(of: linkText)
                mText.addAttribute(.link, value: urlString, range: linkRange)
            }
        }
        attributedText = mText
    }
}

