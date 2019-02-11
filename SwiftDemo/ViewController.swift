//
//  ViewController.swift
//  SwiftDemo
//
//  Created by Chivalrous on 2019/1/21.
//  Copyright © 2019 ML. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    //MARK: -- xml
    var bookURL: String?
    private var nextURL: String?
    private var preURL: String?
    private var lastURL: String?
    private var type: Int = 0
    private var catalog: [[String: Any]]?
    var index = 1
    
    let list = ["276696", "277144", "276320", "276535", "277514", "276704", "277318", "276532", "276824", "276500", "277149", "277236", "276670", "277079", "277085", "277352", "276374", "276347", "276337", "274424", "274721", "273394", "273475", "277144"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.layer.cornerRadius = 5
        self.textView.contentInset = UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 0)
//        if var localUrl = UserDefaults.standard.object(forKey: "NetBooks") as? String {
//            if localUrl.contains("http://m.630book.la/book_") {
//                localUrl = localUrl.replacingOccurrences(of: "http://m.630book.la/book_", with: "http://www.630book.la/shu/")
//            }
//            lastURL =  localUrl
//        }
        request()
    }
    
    //MARK: -- 下一章节
    @IBAction func nextClick(_ sender: Any) {
        if nextURL == nil {
            return
        }
        type = 1
        self.request()
    }
    
    //MARK: -- 前一章节
    @IBAction func preClick(_ sender: Any) {
        if preURL == nil {
            return
        }
        type = 2
        self.request()
    }
    
    //MARK: -- 请求数据
    private func request() {
        //起始章节
//        var urlStr = "\(host)/shu/1790/946406.html"
//        if lastURL?.contains(host) ?? false {
//            urlStr = lastURL ?? ""
//        }
//        if type != 0 {
//            if type == 1 {
//                urlStr = nextURL ?? ""
//            } else {
//                urlStr = preURL ?? ""
//            }
//        }
//        UserDefaults.standard.set(urlStr, forKey: "NetBooks")
//        UserDefaults.standard.synchronize()
//        print(urlStr)
//        if loadBooks(urlStr: urlStr) {
////            if self.nextURL != nil {
////                self.type = 1
////                //            index += 1
////                self.request()
////            }
//            return
//        }
        //无数据时请求网络
        for str in list {
            let urlStr = "http://fs.dooioo.com/fetch/vp/touxiang/photos/" + str + "_675x900.jpg"
            requestNet(urlStr: urlStr, index: str)
        }
    }
    
    //MARK: -- 缓存章节内容，下次直接访问本地数据
    private func loadBooks(urlStr: String) -> Bool {
        var hasLocalData = false
        if let dict = UserDefaults.standard.object(forKey: urlStr) as? NSDictionary {
            if let title = dict["title"] as? String {
                titleLbl.text = title
                print("获取到title")
            } else {
                return hasLocalData
            }
            if let content = dict["content"] as? String {
                textView.text = content
                scrollTop()
                print("获取到content")
            } else {
                return hasLocalData
            }
            if let pre = dict["preURL"] as? String {
                preURL = pre
                print("获取到preURL")
            } else {
                return hasLocalData
            }
            if let next = dict["nextURL"] as? String {
                nextURL = next
                print("获取到nextURL")
            } else {
                return hasLocalData
            }
            hasLocalData = true
        }
        return hasLocalData
    }
    
    //MARK: -- 无缓存时获取网络数据
    private func requestNet(urlStr: String, index: String) {
        guard let url = URL.init(string: urlStr) else {
            print("生成url失败")
            return
        }
        DispatchQueue.global().async {
            do {
                let htmlData = try Data.init(contentsOf: url)
                if let image = UIImage.init(data: htmlData) {
                    self.write(data: htmlData, urlIndex: index)
                }
//                let document = try ONOXMLDocument.htmlDocument(with: htmlData)
//                DispatchQueue.main.async(execute: {
//                    self.anlzXML(urlStr:urlStr, document: document)
//                })
            } catch {
                print("错误")
            }
        }
    }
    
    //MARK: -- 解析xml
    private func anlzXML(urlStr: String, document: ONOXMLDocument) {
        let bookDict = NSMutableDictionary()
        //获取上一章节url
        let preElement = document.firstChild(withXPath: "//*[@id=\"readbox\"]/div[2]/a[2]")
        if let preClassStr = preElement?.attributes["href"] as? String {
            preURL = host + preClassStr
            bookDict.setValue(preURL, forKey: "preURL")
        } else {
            preURL = nil
            print("未找到上一章节")
        }
        //获取下一章url
        let nextElement = document.firstChild(withXPath: "//*[@id=\"readbox\"]/div[2]/a[4]")
        if let nextClassStr = nextElement?.attributes["href"] as? String {
            nextURL = host + nextClassStr
            bookDict.setValue(nextURL, forKey: "nextURL")
        } else {
            nextURL = nil
            print("未找到下一章节")
        }
        //获取书名
        let nameElement = document.firstChild(withXPath: "//*[@id=\"main\"]/div[1]/span[1]/a[2]")
        cutStr = nameElement?.stringValue ?? ""
        //获取章节标题
        let titleElement = document.firstChild(withXPath: "//*[@id=\"main\"]/h1")
        if let titleStr = titleElement?.stringValue {
            titleLbl.text = titleStr
            bookDict.setValue(titleStr, forKey: "title")
        } else {
            print("未找到章节标题")
        }
        //获取章节内容
        let contentElement = document.firstChild(withXPath: "//*[@id=\"content\"]")
        var contentStr = contentElement?.stringValue ?? ""
        //截取文本
        if contentStr.contains(flagPreStr + cutStr + flagSufStr) {
            contentStr = contentStr.components(separatedBy: flagPreStr + cutStr + flagSufStr).last ?? ""
        }
        if contentStr.contains("<div style=\"display:none\">www.cmfu.com发布</div>　　") {
            contentStr = contentStr.replacingOccurrences(of: "<div style=\"display:none\">www.cmfu.com发布</div>　　", with: "")
        }
        if contentStr.contains("<a href=http://www.cmfu.com> www.cmfu.com 欢迎广大书友光临阅读，最新、最快、最火的连载作品尽在起点原创！</a\r\n            ") {
            contentStr = contentStr.replacingOccurrences(of: "<a href=http://www.cmfu.com> www.cmfu.com 欢迎广大书友光临阅读，最新、最快、最火的连载作品尽在起点原创！</a\r\n            ", with: "")
        }
        if contentStr.contains("<div style=\"display:none\">www.cmfu.com发布</div>\r\n            ") {
            contentStr = contentStr.replacingOccurrences(of: "<div style=\"display:none\">www.cmfu.com发布</div>\r\n            ", with: "")
        }
        if contentStr.contains("(未完待续。如果您喜欢这部作品，欢迎您来起点（qidian.com）投推荐票、月票，您的支持，就是我最大的动力。)") {
            contentStr = contentStr.replacingOccurrences(of: "(未完待续。如果您喜欢这部作品，欢迎您来起点（qidian.com）投推荐票、月票，您的支持，就是我最大的动力。)", with: "")
        }
        if contentStr.contains("(未完待续，如欲知后事如何，请登陆www.CMFU.COM，章节更多，支持作者，支持正版阅读！)\r\n            ") {
            contentStr = contentStr.replacingOccurrences(of: "(未完待续，如欲知后事如何，请登陆www.CMFU.COM，章节更多，支持作者，支持正版阅读！)\r\n            ", with: "")
        }
        contentStr = contentStr.replacingOccurrences(of: "&#8226；", with: "·")
        contentStr = contentStr.replacingOccurrences(of: "#8226；", with: "·")
        contentStr = contentStr.replacingOccurrences(of: "&amp;", with: "·")
        contentStr = contentStr.replacingOccurrences(of: " ", with: "")
        bookDict.setValue(contentStr, forKey: "content")
        cacheBook(urlStr: urlStr, dict: bookDict)
        textView.text = contentStr
        scrollTop()
//        write(book: cutStr, title: "第\(index)章", content: contentStr)
//        if self.nextURL != nil {
//            self.type = 1
////            index += 1
//            self.request()
//        }
    }
    
    //MARK: -- 缓存获取到的数据
    private func cacheBook(urlStr: String, dict: NSDictionary) {
        UserDefaults.standard.set(dict, forKey: urlStr)
        UserDefaults.standard.synchronize()
        print("\(dict["title"] ?? "")缓存完毕")
    }
    
    //MARK: -- 写入文件
    private func write(book: String, title: String, content: String) {
        let filePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last ?? "") + "/books/\(book).txt"
        let manager = FileManager.default
        let writeStr = "\n\(title)\n\(content)"
        guard let writeData = writeStr.data(using: .utf8) else { return }
        if manager.fileExists(atPath: filePath) {
            let fileHandle = FileHandle.init(forWritingAtPath: filePath)
            fileHandle?.seekToEndOfFile()
            fileHandle?.write(writeData)
            fileHandle?.closeFile()
        } else {
            do {
                try manager.createDirectory(atPath: filePath.components(separatedBy: "/\(book).txt").first ?? "", withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("创建文件夹失败")
                return
            }
            manager.createFile(atPath: filePath, contents: writeData, attributes: nil)
        }
    }
    
    private func write(data: Data, urlIndex: String) {
        let filePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last ?? "") + "/books/\(urlIndex).jpeg"
        print(filePath)
        let manager = FileManager.default
//        let writeStr = "\n\(title)\n\(content)"
//        guard let writeData = writeStr.data(using: .utf8) else { return }
        if manager.fileExists(atPath: filePath) {
            let fileHandle = FileHandle.init(forWritingAtPath: filePath)
            fileHandle?.seekToEndOfFile()
            fileHandle?.write(data)
            fileHandle?.closeFile()
        } else {
            do {
                try manager.createDirectory(atPath: filePath.components(separatedBy: "/\(urlIndex).jpeg").first ?? "", withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("创建文件夹失败")
                return
            }
            manager.createFile(atPath: filePath, contents: data, attributes: nil)
        }
    }
    
    private func read(book: String) {
        let filePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last ?? "") + "/books/\(book).txt"
        let manager = FileManager.default
        guard let readData = manager.contents(atPath: filePath) else {
            return
        }
        textView.text = String.init(data: readData, encoding: .utf8) ?? ""
    }
    
    //MARK: -- 滚到最顶部
    private func scrollTop() {
        let range = NSRange.init(location: 0, length: 0)
        textView.scrollRangeToVisible(range)
    }
}

