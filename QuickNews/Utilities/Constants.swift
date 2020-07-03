//
//  Constants.swift
//  QuickNet
//
//  Created by DTran on 12/24/19.
//  Copyright © 2019 TPT. All rights reserved.
//

import Foundation


typealias DownloadComplete = () -> ()

let NOTIF_DOWNLOAD_COMPLETE = NSNotification.Name("dataDownloaded")


var API_KEY = "509b8e2ed6b8416f9f33a2b6fbf71d8a"
var ENDPOINT = "top-headlines"
var COUNTRY = "us"
var SOURCES = ""
var SEARCH_TERM = ""
var BASE_API_URL = "https://newsapi.org/v2/\(ENDPOINT)?country=\(COUNTRY)&pageSize=50&apiKey=\(API_KEY)"
var SEARCH_BASE_API_URL = "https://newsapi.org/v2/everything?q=\(SEARCH_TERM)&apiKey=\(API_KEY)"
var SOURCES_BASE_API_URL = "https://newsapi.org/v2/sources?apiKey=\(API_KEY)"
