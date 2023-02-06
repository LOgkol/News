//
//  WebViewsHelper.swift
//  NewsTFS
//
//  Created by Александр Джегутанов on 2/5/23.
//

import WebKit

struct WebViewsHelper {
    
    /// Clean cache and cookies
    static func cleanWebView() {
        cleanURLCache()
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes,
                                                        for: [record],
                                                        completionHandler: {})
            }
        }
    }
    
    /// Clean cache
    static func cleanURLCache() {
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
    }
}

