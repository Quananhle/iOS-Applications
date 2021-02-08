//
//  MovieDetailsViewController.swift
//  flixster
//
//  Created by Ashley Le on 2/8/21.
//  Copyright © 2021 codepath. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var backdropView: UIImageView!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    
    var movie: [String: Any]!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print (movie["title"])
        titleLabel.text = movie["title"] as? String
        synopsisLabel.text = movie["overview"] as? String
        
        let baseUrl = "https://image.tmdb.org/t/p/w185" //w342
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
