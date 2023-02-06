//
//  NewsTableViewCell.swift
//  NewsTFS
//
//  Created by Александр Джегутанов on 2/3/23.
//

import UIKit

final class NewsTableViewCell: UITableViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    //MARK: - UI properties
    
    private let iconImageView = UIImageView()
    private let titleLabel = NewsTFSLabel(type: .main)
    private let numberOfcontentNewsLabel = NewsTFSLabel(type: .helper)
    private let stackView = UIStackView()
    
    //MARK: init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        iconImageView.kf.setImage(with: URL(string: ""))
        iconImageView.image = UIImage(named: "newsImage")
    }
    
    // MARK: - Public Methods
    
    func configureView(_ model: NewsListModel.News) {
        titleLabel.text = model.title
        
        iconImageView.kf.setImage(with: model.urlToImage, placeholder: UIImage(named: "newsImage"))
        
        if model.numberOfNewsViews != 0 {
            numberOfcontentNewsLabel.text = "количество просмотров \(model.numberOfNewsViews)"
            numberOfcontentNewsLabel.isHidden = false
        } else {
            numberOfcontentNewsLabel.isHidden = true
        }
    }
}

//MARK: - Private methods

private extension NewsTableViewCell {
    
    //MARK: - Setup
    
    func setup() {
        addViews()
        makeConstraints()
        setupViews()
    }
    
    func addViews() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(numberOfcontentNewsLabel)
    }
    
    func makeConstraints() {

        stackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(12)
            $0.leading.trailing.equalToSuperview().inset(8)
        }
        
        iconImageView.snp.makeConstraints {
            $0.height.equalTo(224)
        }
    }
    
    func setupViews() {
        selectionStyle = .none
        separatorInset = .zero
        backgroundColor = .white
        
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .equalSpacing
        
        numberOfcontentNewsLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        iconImageView.clipsToBounds = true
        iconImageView.layer.cornerRadius = 8
    }
}
