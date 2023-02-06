//
//  NoResultView.swift
//  NewsTFS
//
//  Created by Александр Джегутанов on 2/4/23.
//

import UIKit

enum NoResultsViewType {
    case withoutFilter
    case errorRequest
}

final class NoResultsView: UIView {
    
    // MARK: - UI Elements
    
    private let mainStackView = UIStackView()
    private let noResultsImageView = UIImageView()
    private let noDataLabel = NewsTFSLabel(type: .mainBold)
    
    // MARK: - Logic Variables
    
    var type: NoResultsViewType = .withoutFilter
    
    // MARK: - Init
    
    convenience init(type: NoResultsViewType) {
        self.init()
        self.type = type
        setup()
    }
}

// MARK: - Private Methods

private extension NoResultsView {
    
    func setup() {
        addViews()
        setupConstraints()
        setupView()
    }
    
    func addViews() {
        addSubview(mainStackView)
        mainStackView.addArrangedSubview(noResultsImageView)
        mainStackView.addArrangedSubview(noDataLabel)
    }
    
    func setupConstraints() {
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 12).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -12).isActive = true
    }
    
    func setupView() {
        backgroundColor = .lightGray
        
        mainStackView.axis = .vertical
        mainStackView.distribution = .fill
        mainStackView.alignment = .center
        mainStackView.spacing = 4
        mainStackView.setCustomSpacing(16, after: noResultsImageView)
        
        noDataLabel.text = "Нет данных"
        switch type {
        case .withoutFilter:
            noResultsImageView.image = UIImage(named: "no_results_icon")
        case .errorRequest:
            noResultsImageView.image = UIImage(named: "no_results_icon")
            noDataLabel.isHidden = true
        }
        noDataLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
}
