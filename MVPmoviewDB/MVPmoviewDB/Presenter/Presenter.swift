//
//  Presenter.swift
//  MVPmoviewDB
//
//  Created by Luana Tais Thomas on 19/03/24.
//

import Foundation
import UIKit

protocol MoviePresenterDelegate: AnyObject {
    func setupUI()
    func updateUI(atIndex indexPath: IndexPath)
}

extension Endpoint {
    init(section: Int) {
        switch section {
        case 0:
            self = .popular
        case 1:
            self = .nowPlaying
        default:
            self = .popular
        }
    }
    
    var name: String {
        switch self {
        case .nowPlaying:
            return "Now Playing"
        case .popular:
            return "Popular"
        }
    }
}

class MoviePresenter {
    let repository: APIMovieRepository = APIMovieRepository.shared
    weak var delegate: MoviePresenterDelegate?

    var coordinator: CoordinatorFlowController?
    
    let group = DispatchGroup()
    
    func viewDidLoad() {
        var finishedNowPlaying = false
        var finishedPopular = false
        
        if repository.moviesNowPlaying.isEmpty {
            group.enter()
            repository.fetchMovies(endpoint: .nowPlaying) { isFinished in
                if isFinished {
                    finishedNowPlaying = true
                }
                self.group.leave()
            }
        }
        
        if repository.moviesPopular.isEmpty {
            group.enter()
            repository.fetchMovies(endpoint: .popular) { isFinished in
                if isFinished {
                    finishedPopular = true
                }
                self.group.leave()
            }
        }
        
        group.notify(queue: .main) {
            if finishedPopular && finishedNowPlaying {
                self.delegate?.setupUI()
            }
        }
    }
    
    func getNumberOfRowsInSection(section: Int) -> Int {
        return repository.getNumberOfMovies(endpoint: Endpoint(section: section))
    }
    
    func getNumberOfSections() -> Int {
        return repository.getNumberOfSections()
    }
    
    func getSectionName(section: Int) -> String {
        return Endpoint(section: section).name
    }
    
    func getTitleLabel(indexOf: Int, section: Int) -> String {
        return repository.getTitleOfMovie(indexOf: indexOf, endpoint: Endpoint(section: section))
    }
    
    func getOverviewLabel(indexOf: Int, section: Int) -> String {
        return repository.getOverviewOfMovie(indexOf: indexOf, endpoint: Endpoint(section: section))
    }
    
    func getTags(indexOf: Int, section: Int) -> String {
        return repository.getTagsOfMovie(indexOf: indexOf, endpoint: Endpoint(section: section))
    }
    
    func getVoteAverageLabel(indexOf: Int, section: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2

        if let formattedString = formatter.string(from: NSNumber(value: repository.getVoteAverageOfMovie(indexOf: indexOf, endpoint: Endpoint(section: section)))) {
            return formattedString
        } else {
            return "\(repository.getVoteAverageOfMovie(indexOf: indexOf, endpoint: Endpoint(section: section)))"
        }
    }
    
    func getImage(indexPath: IndexPath, indexOf: Int, section: Int) -> Data? {
        let image = repository.getImageOfMovie(indexOf: indexOf, endpoint: Endpoint(section: section))
        
        if let imageData = image {
            return imageData
        } else {
            repository.getImage(urlPath: repository.getPosterPathOfMovie(indexOf: indexOf, endpoint: Endpoint(section: section))) { image, urlString in
                if Endpoint(section: section) == .nowPlaying {
                    guard let movieIndex = self.repository.moviesNowPlaying.firstIndex(where: { $0.posterPath == urlString }) else { return }
                    self.repository.moviesNowPlaying[movieIndex].imageCover = image?.pngData()
                    DispatchQueue.main.async {
                        self.delegate?.updateUI(atIndex: indexPath)
                    }
                } else {
                    guard let movieIndex = self.repository.moviesPopular.firstIndex(where: { $0.posterPath == urlString }) else { return }
                    self.repository.moviesPopular[movieIndex].imageCover = image?.pngData()
                    DispatchQueue.main.async {
                        self.delegate?.updateUI(atIndex: indexPath)
                    }
                }
            }
        }
        

        return repository.getImageOfMovie(indexOf: indexOf, endpoint: Endpoint(section: section))
    }
    
    func didSelectRowAt(indexPath: IndexPath) {
        coordinator?.goToDetail(indexPath: indexPath)
    }
}
