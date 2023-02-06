//
//  StorageManager.swift
//  News
//
//  Created by Александр Джегутанов on 2/6/23.
//

import Foundation

final class StorageManager {
    
    //MARK: - Init
    
    private init() {}
    
    // MARK: - Public properties
    
    static let shared = StorageManager()
    
    // MARK: - Public methods

    func saveData(model: [NewsListModel.News]) {
        removeDate()
        do {
            try UserDefaults.standard.set(object: model, forKey: Constants.UserDefaultsKeys.saveNewsModel)
        } catch {
            print(error)
        }
    }
    
    func readingData() -> [NewsListModel.News]? {
        let data = try! UserDefaults.standard.get(objectType: [NewsListModel.News].self, forKey: Constants.UserDefaultsKeys.saveNewsModel)
        return data
    }
    
    func removeDate() {
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaultsKeys.saveNewsModel)
    }
}
