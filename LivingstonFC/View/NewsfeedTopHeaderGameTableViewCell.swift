//
//  NewsfeedTopHeaderGameTableViewCell.swift
//  LivingstonFC
//
//  Created by Iza Ledzka on 11/05/2018.
//  Copyright © 2018 Iza Ledzka. All rights reserved.
//

import UIKit

//  This cell is displayed at the top of NewsfeedTableViewController
class NewsfeedTopHeaderGameTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    var itemsPerRow: CGFloat { return CGFloat(games.count) }
    let sectionInsets = UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)
    
    private var team = [String:Team]()
    var currentPage = 0
    
    //  Page control must be created programatically
    var pageControl : UIPageControl = UIPageControl(frame: .zero)
    
    var games = [Game]() {
        didSet {
            games = games.sorted {
                $0.dateAndTime! > $1.dateAndTime!
            }
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //  Configure collection view
        collectionView.dataSource = self
        collectionView.delegate = self
        let newLayout = PagingFlowLayout()
        newLayout.scrollDirection = .horizontal
        newLayout.itemSize = CGSize(width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
        newLayout.minimumInteritemSpacing = 0;
        newLayout.minimumLineSpacing = 0;
        collectionView.setCollectionViewLayout(newLayout, animated: true)
        setUpPageControl()
        
        LivingstonFCAPIManager.sharedInstance.getTeams(onSuccess: { [weak self] teams in
            DispatchQueue.main.async {
                if teams.count != self?.team.count {
                    for object in teams {
                        self?.team[object.name] = object
                    }
                }
            }
            }, onFailure: { error in
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        })
    }


}

//  Implement Collection View Data Source Delegate methods
extension NewsfeedTopHeaderGameTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCellInNewsfeed", for: indexPath) as? GameCollectionViewCell {
            let game = games[indexPath.row]
            if let opponent = team[game.opponent], let livingston = team["Livingston FC"] {
                cell.opponentTeam = opponent
                cell.livingstonTeam = livingston
            }
            cell.game = game
            return cell
        }
        return UICollectionViewCell()
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return games.count
    }
}

//  Implement Collection View Data Source Delegate Flow Layout methods, which is used to set a size for a single cell
extension NewsfeedTopHeaderGameTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemWidth = collectionView.bounds.size.width
        let itemHeight = collectionView.bounds.size.height
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    
}

//  Implement page control
extension NewsfeedTopHeaderGameTableViewCell: UIScrollViewDelegate{
    
    //ScrollView delegate method - it tells the page controll which page is currently visible
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        let pageWidth = scrollView.frame.width
        self.currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
        self.pageControl.currentPage = self.currentPage
    }
    
    func setUpPageControl() {
        pageControl.isUserInteractionEnabled = true
        pageControl.numberOfPages = 4
        pageControl.currentPage = 0
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        self.pageControl.tintColor = UIColor.white
        self.pageControl.pageIndicatorTintColor = UIColor.black
        self.pageControl.currentPageIndicatorTintColor = UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1)
        self.addSubview(pageControl)
        self.pageControl.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.pageControl.bottomAnchor.constraint(greaterThanOrEqualTo: self.bottomAnchor).isActive = true
    }
}
class PagingFlowLayout: UICollectionViewFlowLayout {
    
    //Implement vertical paging
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let horizontalOffset = proposedContentOffset.x
        let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: self.collectionView!.bounds.size.width, height: self.collectionView!.bounds.size.height)
        for layoutAttributes in super.layoutAttributesForElements(in: targetRect)! {
            let itemOffset = layoutAttributes.frame.origin.x
            if abs(itemOffset - horizontalOffset) < abs(offsetAdjustment){
                offsetAdjustment = itemOffset - horizontalOffset
            }
        }
        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }
}
