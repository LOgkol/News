//
//  NewsTFSLabel.swift
//  NewsTFS
//
//  Created by Александр Джегутанов on 2/3/23.
//

import UIKit

enum EKZHLabelType {
    
    /// font = systemFont 16;
    /// textColor = titaniumGrey
    case main
    
    /// font = systemFont 14;
    /// textColor = osloGrey
    case helper
    
    /// font = boldSystemFont 16;
    /// textColor = titaniumGrey
    case mainBold
}

final class NewsTFSLabel: UILabel {
    
    // MARK: - Logic Variables
    
    private var type: EKZHLabelType = .main
    
    // MARK: - Init
    
    convenience init(type: EKZHLabelType, numberOfLines: Int = 0, textAlignment: NSTextAlignment = .natural) {
        self.init()
        self.type = type
        setupLabel()
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
    }
}

// MARK: - Private Methods

private extension NewsTFSLabel {
    
    func setupLabel() {
        switch type {
        case .main:
            font = UIFont.systemFont(ofSize: 16)
            textColor = NewsTFSColor.titaniumGrey
        case .helper:
            font = UIFont.systemFont(ofSize: 14)
            textColor = NewsTFSColor.osloGrey

        case .mainBold:
            font = UIFont.boldSystemFont(ofSize: 16)
            textColor = NewsTFSColor.titaniumGrey
        }
        sizeToFit()
    }
}

