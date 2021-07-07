//
//  NetworkManager.swift
//  MovieApp
//
//  Created by Andrey Markov on 2021-06-13.
//
import UIKit
class NetworkManager {
    
    static let shared = NetworkManager()

    func getMovieById(id: Int, completion: @escaping (Movie?, Error?) -> Void) {
    guard let url = URL(string:"https://api.themoviedb.org/3/movie/\(id)?api_key=da68977b15247aa866da5e39e0c44390&language=en-US") else { return }
        print(url)
        URLSession.shared.dataTask(with: url) { (data, _, error) in
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                if let error = error{
                    print("Error")
                    completion(nil, error)
                }
                guard let data = data else { return }
                print(data)
                let jsonDecoder = JSONDecoder()
                do {
                    let movie = try? jsonDecoder.decode(Movie.self, from: data)
                    completion(movie,nil)
                } catch let error {
                    print(error.localizedDescription)
                    completion(nil, error)
                }
            }
        }
        }.resume()
}
    func searchMovies(array: [Int], completion: @escaping ([Result], Error?) -> Void) {
        let string = formatArray(array: array)
        guard let url = URL(string:
                                "https://api.themoviedb.org/3/discover/movie?api_key=da68977b15247aa866da5e39e0c44390&with_genres=\(string)&sort_by=popularity.desc&vote_average.gte=6.5") else { return }
        print(url)

            URLSession.shared.dataTask(with: url) { (data, _, error) in
            DispatchQueue.global().async {
                DispatchQueue.main.async {
                    if let error = error{
                        print("Error")
                        
                    }
                    guard let data = data else { return }
                    let jsonDecoder = JSONDecoder()
                    do {
                        let movies = try? jsonDecoder.decode(Similar.self, from: data)
                        guard let results = movies?.results else {return}
                        
                        completion(results,nil)
                    } catch let error {
                        print(error.localizedDescription)
            
                    }
                }
    }
    }.resume()
}
    func formatArray(array: [Int]) -> String{
        let string = array.map(String.init).joined(separator: ",")
        return string
    }

}
