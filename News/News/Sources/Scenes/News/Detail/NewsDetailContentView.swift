//
//  NewsDetailContentView.swift
//  NewsTFS
//
//  Created by Александр Джегутанов on 2/5/23.
//

import UIKit

protocol NewsDetailContentViewProtocol: AnyObject {
    func openWebView()
}

final class NewsDetailContentView: UIView {
    
    // MARK: - UI Elements
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let imageView = UIImageView()
    private let titleLabel = NewsTFSLabel(type: .mainBold)
    private let dateLabel = NewsTFSLabel(type: .helper)
    private let publicationSourceLabel = NewsTFSLabel(type: .helper)
    private let fullTextOfTheNewsTextView = TextViewWithLink()
    private let textNewsLabel = NewsTFSLabel(type: .main)
    
    private let mainStackView = UIStackView()
    
    //MARK: - Data properties
    
    private let clickableTextInTextView = "Ссылка на полный текст новости"
    
    // MARK: - MVP Variables
    
    weak var delegate: NewsDetailContentViewProtocol?
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Public Methods
    
    func convigureView(model: NewsListModel.News) {
        titleLabel.text = model.title
        dateLabel.text = model.date
        publicationSourceLabel.text = model.sourceName
        textNewsLabel.text = model.description
        
        imageView.kf.setImage(with: model.urlToImage, placeholder: UIImage(named: "newsImage"))
        
        if let link = model.url {
            fullTextOfTheNewsTextView.addLinks([
                clickableTextInTextView: "\(link)"
            ])
        }
    }
}

// MARK: - Private Methods

private extension NewsDetailContentView {
    
    //MARK: - setupUI
    
    func setupUI() {
        addViews()
        makeConstraints()
        setupViews()
    }
    
    func addViews() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(imageView)
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(dateLabel)
        mainStackView.addArrangedSubview(publicationSourceLabel)
        mainStackView.addArrangedSubview(fullTextOfTheNewsTextView)
        mainStackView.addArrangedSubview(textNewsLabel)
    }
    
    func makeConstraints() {
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.greaterThanOrEqualTo(safeAreaLayoutGuide).offset(30)
        }
        
        mainStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(100).priority(.low)
        }
        
        imageView.snp.makeConstraints {
            $0.height.equalTo(224)
        }
    }
    
    func setupViews() {
        setupTextView()
        backgroundColor = .white
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        mainStackView.axis = .vertical
        mainStackView.spacing = 8
        
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        dateLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        textNewsLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        publicationSourceLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
    
    func setupTextView() {
        fullTextOfTheNewsTextView.delegate = self
        fullTextOfTheNewsTextView.font = UIFont.systemFont(ofSize: 14)
        fullTextOfTheNewsTextView.text = "\(clickableTextInTextView)"
    }
}

//MARK: - UITextViewDelegate

extension NewsDetailContentView: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        delegate?.openWebView()
        return false
    }
    
    //disable text selection:
    func textViewDidChangeSelection(_ textView: UITextView) {
        textView.selectedTextRange = nil
    }
}

