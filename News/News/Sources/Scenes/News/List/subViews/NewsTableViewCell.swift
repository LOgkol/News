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
        //Да, apple говорит что тут не стоит такое делать и лучше делать в cellForRowAt, но практика показывает если сделать тут то тоже ок будет :)
        iconImageView.image = UIImage(named: "newsImage")
    }
    
    // MARK: - Public Methods
    
    func configureView(_ model: NewsListModel.List) {
        titleLabel.text = model.title
        
        if let url = model.urlToImage {
            iconImageView.load(url: url)
        }
        
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
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.heightAnchor.constraint(equalToConstant: 224).isActive = true
    }
    
    func setupViews() {
        selectionStyle = .none
        separatorInset = .zero
        backgroundColor = .white
        
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .equalSpacing
        
        numberOfcontentNewsLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        iconImageView.image = UIImage(named: "newsImage")
        iconImageView.clipsToBounds = true
        iconImageView.layer.cornerRadius = 8
    }
}
