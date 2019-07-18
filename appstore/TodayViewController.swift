//
//  TodayViewController.swift
//  appstore
//
//  Created by Colin Milhench on 17/07/2019.
//  Copyright © 2019 Colin Milhench. All rights reserved.
//

import UIKit

// MARK: - Tile Controller -

class TodayViewController: UICollectionViewController {

    override func viewDidAppear(_ animated: Bool) {
        let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
        statusBar?.backgroundColor = UIColor.white
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.reloadData()
    }

    @IBAction func cancel(_ unwindSegue: UIStoryboardSegue) {}
}

extension TodayViewController/*: UICollectionViewDelegate*/ {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ArticleViewController")
        self.present(controller, animated: true, completion: nil)
    }

    override func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.removeAllAnimations()
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0,
                       options: .beginFromCurrentState,
                       animations: {
                        cell?.transform = .init(scaleX: 0.95, y: 0.95)
        }, completion: nil)

    }

    override func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.removeAllAnimations()
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0,
                       options: .beginFromCurrentState,
                       animations: {
                        cell?.transform = .identity
        }, completion: nil)
    }
}

extension TodayViewController/*: UICollectionViewDataSource*/ {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 6
        default:
            return 24
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = indexPath.row % 6
        if type == 0 {
            let identifier = ArticleCell.reuseIdentifier
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? ArticleCell else {
                fatalError("failed to dequeue cell with identifier\(identifier)")
            }
            cell.backbroundImage.image = UIImage(named: "tile-mountain")
            cell.hideBanner()
            return cell
        } else if type == 1 {
            let identifier = ApplicationCell.reuseIdentifier
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? ApplicationCell else {
                fatalError("failed to dequeue cell with identifier\(identifier)")
            }
            return cell
        } else if type == 2 {
            let identifier = MediaCell.reuseIdentifier
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? MediaCell else {
                fatalError("failed to dequeue cell with identifier\(identifier)")
            }
            return cell
        } else if type == 3 {
            let identifier = ArticleCell.reuseIdentifier
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? ArticleCell else {
                fatalError("failed to dequeue cell with identifier\(identifier)")
            }
            cell.backbroundImage.image = UIImage(named: "tile-paper")
            cell.strapLabel.text = ""
            cell.showBanner()
            return cell
        } else if type == 4 {
            let identifier = ArticleCell.reuseIdentifier
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? ArticleCell else {
                fatalError("failed to dequeue cell with identifier\(identifier)")
            }
            cell.backbroundImage.image = UIImage(named: "tile-skyline")
            cell.strapLabel.text = ""
            cell.showBanner()
            return cell
        } else {
            let identifier = ListCell.reuseIdentifier
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? ListCell else {
                fatalError("failed to dequeue cell with identifier\(identifier)")
            }
            return cell
        }
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let identifier = TodaySectionHeader.reuseIdentifier
        guard let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath) as? TodaySectionHeader else {
            fatalError("failed to dequeue cell with identifier\(identifier)")
        }
        if indexPath.section > 0 {
            cell.sectionButton.isHidden = true
        }
        return cell
    }
}

extension TodayViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return CGSize(width: collectionView.bounds.width, height: 380)
        } else {
            // Calculate how many columns we can render with a known minimum width
            var numberOfItemsInRow = 4
            while collectionView.bounds.width / CGFloat(numberOfItemsInRow) < 320 {
                numberOfItemsInRow = numberOfItemsInRow - 1
            }

            // Calculate the size of the cells with a known maximum width for large cells
            let compressedWidth = collectionView.bounds.width / CGFloat(numberOfItemsInRow)
            var expandedWidth = compressedWidth * 2
            if expandedWidth > 800 {
                expandedWidth = compressedWidth
            }

            // Calculate width based on a wrappable tempo (10|01|10) or (100|010), (i % 6) = (012345)
            var width = compressedWidth
            if [0, 4].contains(indexPath.item % 6) || (numberOfItemsInRow == 3 && (indexPath.item % 6) == 3) {
                width = expandedWidth
            }

            return CGSize(width: width, height: 380)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 100)
    }
}

// MARK: - Header Cell -

class TodaySectionHeader: UICollectionReusableView {
    @IBOutlet var sectionButton: UIButton!
    @IBOutlet var areaLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    
    static var reuseIdentifier: String { return String(describing: self) }
}

// MARK: - Tile Cell -

class TileCell: UICollectionViewCell {
    @IBOutlet var backbroundImage: UIImageView!
    @IBOutlet var iconImage: UIImageView!
    @IBOutlet var areaLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var strapLabel: UILabel!

    static var reuseIdentifier: String { return String(describing: self) }
}

class ArticleCell: TileCell {
    @IBOutlet var bannerView: UIView!
    func showBanner() {
        bannerView.alpha = 0.95
        areaLabel.textColor = UIColor.lightGray
        titleLabel.textColor = UIColor.black
    }
    func hideBanner() {
        bannerView.alpha = 0
        areaLabel.textColor = UIColor.lightText
        titleLabel.textColor = UIColor.white
    }
}

class ApplicationCell: TileCell {}

class MediaCell: TileCell {}

class ListCell: TileCell {
    @IBOutlet var tableView: UITableView!
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: -15)
    }
}

extension ListCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}

extension ListCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        switch indexPath.row {
        case 0:
            cell.imageView?.image = UIImage(named: "camera")
            cell.textLabel?.text = "Lorem: Sed et odio ut ipsum"
            cell.detailTextLabel?.text = "The local way to sell and buy."
        case 1:
            cell.imageView?.image = UIImage(named: "truck")
            cell.textLabel?.text = "Ipsum"
            cell.detailTextLabel?.text = "Buy & Sell Nearby"
        case 2:
            cell.imageView?.image = UIImage(named: "calendar")
            cell.textLabel?.text = "Dolor sit - in ornare nisi erat"
            cell.detailTextLabel?.text = "The market on your doorstep"
        default:
            cell.textLabel?.text = "Consectetur - adipiscing elit."
            cell.detailTextLabel?.text = "Cars, electronics, home & more"
        }

        // Resize the images
        let size = CGSize(width: 44, height: 44)
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        cell.imageView?.image!.draw(in: CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
        cell.imageView?.image! = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        cell.imageView?.layer.cornerRadius = 8
        cell.imageView?.layer.borderWidth = 1
        cell.imageView?.layer.borderColor = UIColor.lightGray.cgColor

        return cell
    }
}

// MARK: - Detail Controller -

class ArticleViewController: UIViewController {
}
