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
    
    func convigureView(model: NewsListModel.List) {
        titleLabel.text = model.title
        dateLabel.text = model.date
        publicationSourceLabel.text = model.source?.name
        textNewsLabel.text = model.description
        
        if let urlImage = model.urlToImage {
            imageView.load(url: urlImage)
        }
        
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
        scrollView.addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(imageView)
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(dateLabel)
        mainStackView.addArrangedSubview(publicationSourceLabel)
        mainStackView.addArrangedSubview(fullTextOfTheNewsTextView)
        mainStackView.addArrangedSubview(textNewsLabel)
    }
    
    func makeConstraints() {
        
        ///если бы разрешили использовать либо, на snapKit сделал бы динамический скролл с маленьким содержимым контента, по дефолту не получатеся :( хотя snapKit это просто обертка же, хахаах. Многому еще учиться похоже надо :)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 12).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -12).isActive = true
        scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 224).isActive = true
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 8).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        mainStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -100).isActive = true
    }
    
    func setupViews() {
        setupTextView()
        backgroundColor = .white
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        mainStackView.axis = .vertical
        mainStackView.spacing = 8
        
        imageView.image = UIImage(named: "newsImage")
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
        fullTextOfTheNewsTextView.textColor = NewsTFSColor.osloGrey
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

