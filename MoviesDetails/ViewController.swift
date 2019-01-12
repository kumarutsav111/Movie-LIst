//
//  ViewController.swift
//  MoviesDetails
//
//  Created by Kumar Utsav on 08/01/19.
//  Copyright © 2019 Kumar Utsav. All rights reserved.
//
import UIKit
import Kingfisher
class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    @IBOutlet weak var productCell: UICollectionView!
    
    struct Blog: Decodable {
        let articles: [Article]
       
        enum CodingKeys : String, CodingKey {
            case articles = "Search"
        }
    }
    
    struct Article: Decodable {
        let Title: String
        let Year: String
        let MovieType: String
        let Poster: String
        
        enum CodingKeys : String, CodingKey {
            case Title = "Title"
            case Year = "Year"
            case MovieType = "Type"
            case Poster = "Poster"
        }
        
    }
    var blogResult:Blog?
    var count:Int = 0
   
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        guard let url = URL(string: "http://www.omdbapi.com/?s=Batman&page=1&apikey=eeefc96f") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print("Error: No data to decode")
                return
            }
            
            guard let blog = try? JSONDecoder().decode(Blog.self, from: data) else {
                print("Error: Couldn't decode data into Blog")
                return
            }
            self.blogResult = blog
            print("articles:")
                DispatchQueue.main.async {
                    self.productCell.reloadData()
                }
           
            }.resume();
    }
    //MARK:- Collection View Data Source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return blogResult?.articles.count ?? 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCollection", for: indexPath) as! DataCollectionViewCell
        cell.typeLabel.text = blogResult?.articles[indexPath.item].MovieType
        cell.titleLabel.text = blogResult?.articles[indexPath.item].Title
        cell.yearsLabel.text = blogResult?.articles[indexPath.item].Year
        
        guard let imageUrl = URL(string: blogResult?.articles[indexPath.item].Poster ?? "https://m.media-amazon.com/images/M/MV5BZmUwNGU2ZmItMmRiNC00MjhlLTg5YWUtODMyNzkxODYzMmZlXkEyXkFqcGdeQXVyNTIzOTk5ODM@._V1_SX300.jpg") else {
            return cell
        }
        let resourse = ImageResource.init(downloadURL: imageUrl, cacheKey: imageUrl.absoluteString)
        cell.titleImage.kf.setImage(with: resourse)
        return cell
    }
    // MARK: CollectionViewDelegate didSelectItem
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showCounterSegue", sender: indexPath)
    }

    //MARK: - Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCounterSegue" {
           let selectedIndexpath = sender as? IndexPath
            let vc = segue.destination as! DetailsViewController
            print("Index Path: ",selectedIndexpath?.item ?? "No Index")
            vc.titleString = blogResult?.articles[selectedIndexpath?.item ?? 2].Title ?? "No Values"
            vc.typeString = blogResult?.articles[selectedIndexpath?.item ?? 2].MovieType
            guard let imageUrl = URL(string: blogResult?.articles[selectedIndexpath?.item ?? 2].Poster ?? "https://m.media-amazon.com/images/M/MV5BZmUwNGU2ZmItMmRiNC00MjhlLTg5YWUtODMyNzkxODYzMmZlXkEyXkFqcGdeQXVyNTIzOTk5ODM@._V1_SX300.jpg") else {
                return
            }
            let resourse = ImageResource.init(downloadURL: imageUrl, cacheKey: imageUrl.absoluteString)
            vc.imageUrl = resourse
        }
    }
    
}

