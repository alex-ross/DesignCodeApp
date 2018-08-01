//
//  TestimonialViewController.swift
//  DesignCodeApp
//
//  Created by Alexander Ross on 2018-07-23.
//  Copyright © 2018 Meng To. All rights reserved.
//

import UIKit

class TestimonialViewController: UIViewController {
    @IBOutlet weak var testimonialCollectionView: UICollectionView!


    override func viewDidLoad() {
        super.viewDidLoad()
        testimonialCollectionView.delegate = self
        testimonialCollectionView.dataSource = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TestimonialViewController: UICollectionViewDelegate, UICollectionViewDataSource  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return testimonials.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "testimonialCell", for: indexPath) as! TestimonialCollectionViewCell
        let testimonial = testimonials[indexPath.row]
        cell.textLabel.text = testimonial["text"]
        cell.nameLabel.text = testimonial["name"]
        cell.jobLabel.text = testimonial["job"]
        cell.avatarImageView.image = UIImage(named: testimonial["avatar"]!)
        return cell
    }
}
