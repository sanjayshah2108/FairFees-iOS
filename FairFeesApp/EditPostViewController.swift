//
//  EditPostViewController.swift
//  FairFeesApp
//
//  Created by Sanjay Shah on 2018-03-21.
//  Copyright © 2018 Fair Fees. All rights reserved.
//

import UIKit

class EditPostViewController: PostViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func setupCollectionView(){
        
        photosArray = []
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize.init(width: 150, height: 150)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 5.0
        photoCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.addSubview(photoCollectionView)
        
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        photoCollectionView.backgroundColor = UIColor.white
        
        photoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
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
