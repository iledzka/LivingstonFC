//
//  NewsfeedTableViewController.swift
//  LivingstonFC
//
//  Created by Iza Ledzka on 19/04/2018.
//  Copyright © 2018 Iza Ledzka. All rights reserved.
//

import UIKit

//  Newsfeed Table View Controller manages View with two sections: Game cells and News Article cells.
class NewsfeedTableViewController: UITableViewController {
    
    //  This var is used when the cell is dequeued
    private var items = [NewsfeedRowsItem]()
    
    private var newsArticles = [Array<BBCNewsArticle>]() {
        didSet {
            if newsArticles.count > 0, items.count > 0 {
                if items.count == 1 {
                    items.append(ArticleItem(newsArticles.first!))
                } else {
                    items[1] = ArticleItem(newsArticles.first!)
                }
            }
        }
    }
    private var games = [Game]()
    
    //  Refresh data every time the view is displayed
    override func viewWillAppear(_ animated: Bool) {
        hideKeyboardWhenTappedAround()
        LivingstonFCAPIManager.sharedInstance.getGames(onSuccess: { [weak self] games in
            DispatchQueue.main.async {
                if games.count != self?.games.count {
                    self?.games.removeAll()
                    self?.games = games
                    self?.items.insert(GameItem(games), at: 0)
                    self?.tableView.reloadData()
                }
                
            }
            }, onFailure: { error in
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
        })
        
        BBCSportAPIManager.sharedInstance.getNews(onSuccess: { [weak self] news in
            DispatchQueue.main.async {
                self?.newsArticles.append(news)
                self?.tableView.reloadData()
                
            }
            }, onFailure: { error in
                let alert = CustomAlert.offlineAlert
                self.present(alert, animated: true, completion: nil)
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "NEWSFEED"
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items[section].rowCount
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let item = items[section]
        if item.rowCount > 0 {
            return item.sectionTitle
        }
        return nil
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = items[indexPath.section]
        switch item.type {
        case .game:
            if let gameCell = tableView.dequeueReusableCell(withIdentifier: "GamesCollectionView", for: indexPath) as? NewsfeedTopHeaderGameTableViewCell {
                gameCell.games = games
                return gameCell
            }
        case .news:
            if let articleCell = tableView.dequeueReusableCell(withIdentifier: "NewsArticle", for: indexPath) as? BBCNewsTableViewCell{
                let article = (items[indexPath.section] as? ArticleItem)?.articles[indexPath.row]
                articleCell.newsArticle = article
                return articleCell
            }
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.section]
        switch item.type {
        case .news:
            let article = (items[indexPath.section] as? ArticleItem)?.articles[indexPath.row]
            if let linkToArticle = article?.url {
                UIApplication.shared.open(linkToArticle, options: [:], completionHandler: nil)
            }
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch items[indexPath.section].type {
        case .game:
            return CGFloat(220)
        default:
            return UITableViewAutomaticDimension
        }
        
    }
    
    //  Remove space before first section
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.1 : 42
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let view = view as? UITableViewHeaderFooterView {
            view.textLabel?.backgroundColor = UIColor.clear
            view.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            view.textLabel?.textColor = UIColor.black
            view.textLabel?.textAlignment = .center
        }
        
    }
    
}

enum NewsfeedRowsDataType {
    case game
    case news
}

protocol NewsfeedRowsItem {
    var type: NewsfeedRowsDataType { get }
    var rowCount: Int { get }
    var sectionTitle: String?  { get }
}

class ArticleItem: NewsfeedRowsItem {
    var type: NewsfeedRowsDataType {
        return .news
    }
    var sectionTitle: String? {
        return "NEWS"
    }
    var rowCount: Int {
        return articles.count
    }
    var articles = [BBCNewsArticle]()
    
    init(_ articles: [BBCNewsArticle]){
        self.articles = articles.sorted(by: {
            $0.date.compare($1.date) == .orderedDescending //sort articles by date
        })
    }
}

class GameItem: NewsfeedRowsItem {
    var type: NewsfeedRowsDataType {
        return .game
    }
    var sectionTitle: String? {
        return nil
    }
    var rowCount: Int {
        return 1
    }
    var games = [Game]()
    
    init(_ games: [Game]){
        self.games = games
    }
}

