//
//  ViewController.swift
//  DesignCodeApp
//
//  Created by Meng To on 11/14/17.
//  Copyright © 2017 Meng To. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var deviceImageView: UIImageView!
    @IBOutlet weak var playVisualEffectView: UIVisualEffectView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var heroView: UIView!
    @IBOutlet weak var bookView: UIView!
    @IBOutlet weak var chapterCollectionView: UICollectionView!

    @IBAction func playButtonTapped(_ sender: Any) {
        let urlString = "https://player.vimeo.com/external/235468301.hd.mp4?s=e852004d6a46ce569fcf6ef02a7d291ea581358e&profile_id=175"
        let url = URL(string: urlString)
        let player = AVPlayer(url: url!)
        let playerController = AVPlayerViewController()
        playerController.player = player
        present(playerController, animated: true) {
            player.play()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self
        chapterCollectionView.delegate = self
        chapterCollectionView.dataSource = self
        
        titleLabel.alpha = 0
        deviceImageView.alpha = 0
        playVisualEffectView.alpha = 0
        
        UIView.animate(withDuration: 1) {
            self.titleLabel.alpha = 1
            self.deviceImageView.alpha = 1
            self.playVisualEffectView.alpha = 1
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HomeToSection" {
            let toViewController = segue.destination as! SectionViewController
            let indexPath = sender as! IndexPath
            let section = sections[indexPath.row]
            toViewController.section = section
            toViewController.sections = sections
            toViewController.indexPath = indexPath
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sectionCell", for: indexPath) as! SectionCollectionViewCell
        let section = sections[indexPath.row]
        cell.titleLabel.text = section["title"]
        cell.captionLabel.text = section["caption"]
        cell.coverImageView.image = UIImage(named: section["image"]!)

        cell.layer.transform = animateCell(cellFrame: cell.frame)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "HomeToSection", sender: indexPath)
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY < 0 {
            // Without this, when you drag down more than the views allow the top part will move down and a blank area will be displayed above the hero view. But with this code we will instead make the hero view stay in place and everything below will move.
            heroView.transform = CGAffineTransform(translationX: 0, y: offsetY)

            // Here we will use like above but move play visual effect view instead. But we will also take the offset and add an minus infront of it. If the offsetY value is -6 already it will then be converted to +6 and then we use divide that value with 3 to change the speed it will be transform down. The calculation will basically be -(-6)/3=2 and the play visual effect view will basically move down 1 px for each -3px the scroll is offset.
            playVisualEffectView.transform = CGAffineTransform(translationX: 0, y: -offsetY/3)

            titleLabel.transform = CGAffineTransform(translationX: 0, y: -offsetY/3)

            deviceImageView.transform = CGAffineTransform(translationX: 0, y: -offsetY/4)
            // When we transform the background image view down it will probably go out of bounds which will not look that great. So we have to set clipsToBounds to true. This can be done directly to the clipsToBounds setter on the object or in te storyboard.
            // We will also set the top contraint to negative 50 so that we dont get a blank bar at the top, but consider that it can actually be a white bar at the top if the scroll offset is to huge. -(-250)/5 will be 50 so after that we will get a white bar at the top.
            // backgroundImageView.transform = CGAffineTransform(translationX: 0, y: -offsetY/5)

            // We can actually fix the problem that we had above by zooming instead
            backgroundImageView.transform = CGAffineTransform(scaleX: (-offsetY/1000)+1, y: (-offsetY/1000)+1)
        }

        if let collectionView = scrollView as? UICollectionView {
            for cell in collectionView.visibleCells as! [SectionCollectionViewCell] {
                let indexPath = collectionView.indexPath(for: cell)!
                let attributes = collectionView.layoutAttributesForItem(at: indexPath)!
                let cellFrame = collectionView.convert(attributes.frame, to: view)

                let translatioX = cellFrame.origin.x / 5
                cell.coverImageView.transform = CGAffineTransform(translationX: translatioX, y: 0)


                cell.layer.transform = animateCell(cellFrame: cellFrame)
            }
        }
    }

    func animateCell(cellFrame: CGRect) -> CATransform3D {
        let angleFromX = Double((-cellFrame.origin.x) / 10)
        let angle = CGFloat((angleFromX * Double.pi) / 180.0)
        var transform = CATransform3DIdentity
        transform.m34 = -1.0/1000
        let rotation = CATransform3DRotate(transform, angle, 0, 1, 0)

        var scaleFromX = (1000 - (cellFrame.origin.x - 200)) / 1000
        let scaleMax: CGFloat = 1.0
        let scaleMin: CGFloat = 0.6
        if scaleFromX > scaleMax {
            scaleFromX = scaleMax
        }
        if scaleFromX < scaleMin {
            scaleFromX = scaleMin
        }
        let scale = CATransform3DScale(CATransform3DIdentity, scaleFromX, scaleFromX, 1)

        return CATransform3DConcat(rotation, scale)
    }
}
