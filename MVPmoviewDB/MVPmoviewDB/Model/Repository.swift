//
//  Repository.swift
//  MVPmoviewDB
//
//  Created by Luana Tais Thomas on 19/03/24.
//

import Foundation
import UIKit

enum Endpoint: String, CaseIterable {
    case nowPlaying = "https://0e29e443-3b1a-4444-8587-1ac8a3e190df.mock.pstmn.io/nowPlayingMovies"
    case popular = "https://0e29e443-3b1a-4444-8587-1ac8a3e190df.mock.pstmn.io/popularMovies"
}

protocol MovieRepository {
    func fetchMovies(endpoint: Endpoint, completion: @escaping (Bool) -> Void)
    func getImage(urlPath: String, completionBlock: @escaping (UIImage?, String) -> Void)
}

class APIMovieRepository: MovieRepository {
    // Singleton - só consigo inicializar com o shared
    static let shared: APIMovieRepository = APIMovieRepository()
    private init(){}
    
    var moviesNowPlaying: [Movie] = []
    var moviesPopular: [Movie] = []
    
    private var dictGenres: [Int: String] = [28:"Action",
                                             12:"Adventure",
                                             16:"Animation",
                                             35:"Comedy",
                                             80:"Crime",
                                             99:"Documentary",
                                             18:"Drama",
                                             10751:"Family",
                                             14:"Fantasy", 
                                             36:"History",
                                             27:"Horror",
                                             10402:"Music",
                                             9648:"Mystery",
                                             10749:"Romance",
                                             878:"Science Fiction",
                                             10770:"TV Movie",
                                             53:"Thriller",
                                             10752:"War",
                                             37:"Western"]
    
    func fetchMovies(endpoint: Endpoint, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: endpoint.rawValue) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200,
                  error == nil,
                  let data = data
            else {
                print(error ?? "Erro tentando conectar com a API")
                return
            }
            
            guard let decoded = Self.decodeByProtocols(data: data) else {
                completion(false)
                return
            }
            
            if endpoint == .popular {
                self.moviesPopular = decoded.results
            } else {
                self.moviesNowPlaying = decoded.results
            }
            completion(true)
        }
        .resume()
    }

    static func decodeByProtocols(data: Data) -> MovieResponse? {
        do {
            let decodedResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
            return decodedResponse
        } catch {
            print(error)
        }
        return nil
    }
}

// get functions
extension APIMovieRepository {
    func getImage(urlPath: String, completionBlock: @escaping (UIImage?, String) -> Void) {
        let urlString = "https://image.tmdb.org/t/p/w500\(urlPath)"
        guard let url = URL(string: urlString) else {
            completionBlock(nil, urlString)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200,
                  error == nil,
                  let data = data
            else {
                completionBlock(nil, urlPath)
                print(url)
                print(error ?? "error aqui")
                return
            }
            
            guard let image = UIImage(data: data) else {
                completionBlock(nil, urlPath)
                return
            }
            
            completionBlock(image, urlPath)
        }
        .resume()
    }
    
    func getNumberOfSections() -> Int {
        return Endpoint.allCases.count
    }
    
    func getNumberOfMovies(endpoint: Endpoint) -> Int {
        return endpoint == .nowPlaying ? moviesNowPlaying.count : moviesPopular.count
    }
    
    func getTitleOfMovie(indexOf: Int, endpoint: Endpoint) -> String {
        return endpoint == .nowPlaying ? moviesNowPlaying[indexOf].title : moviesPopular[indexOf].title
    }
    
    func getOverviewOfMovie(indexOf: Int, endpoint: Endpoint) -> String {
        return endpoint == .nowPlaying ? moviesNowPlaying[indexOf].overview : moviesPopular[indexOf].overview
    }
    
    func getVoteAverageOfMovie(indexOf: Int, endpoint: Endpoint) -> Double {
        return endpoint == .nowPlaying ? moviesNowPlaying[indexOf].voteAverage : moviesPopular[indexOf].voteAverage
    }
    
    func getImageOfMovie(indexOf: Int, endpoint: Endpoint) -> Data? {
        return endpoint == .nowPlaying ? moviesNowPlaying[indexOf].imageCover : moviesPopular[indexOf].imageCover
    }
    
    func getPosterPathOfMovie(indexOf: Int, endpoint: Endpoint) -> String {
        return endpoint == .nowPlaying ? moviesNowPlaying[indexOf].posterPath : moviesPopular[indexOf].posterPath
    }
    
    func getTagsOfMovie(indexOf: Int, endpoint: Endpoint) -> String {
        return getGenresText(listId: endpoint == .nowPlaying ? moviesNowPlaying[indexOf].genreIds : moviesPopular[indexOf].genreIds)
    }
    
    func getGenresText(listId: [Int]) -> String{
        var list: [String] = []
        
        for id in listId{
            list.append(dictGenres[id]!)
        }
        
        let finalStr = list.joined(separator:", ")
        
        return finalStr
    }
}

