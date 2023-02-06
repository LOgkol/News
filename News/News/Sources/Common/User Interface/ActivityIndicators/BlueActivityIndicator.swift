//
//  BlueActivityIndicator.swift
//  NewsTFS
//
//  Created by Александр Джегутанов on 2/4/23.
//

import UIKit

enum ActivityIndicatorPlace {
    case center
}

final class BlueActivityIndicator: UIActivityIndicatorView {
    
    // MARK: - Init
    
    override init(style: UIActivityIndicatorView.Style) {
        super.init(style: style)
        setup()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Private Methods

private extension BlueActivityIndicator {
    
    func setup() {
        color = NewsTFSColor.oceanBoatBlue
    }
}
