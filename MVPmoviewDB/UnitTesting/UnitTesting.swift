//
//  UnitTesting.swift
//  UnitTesting
//
//  Created by Felipe Araujo on 27/03/24.
//

import XCTest
@testable import MVPmoviewDB

final class UnitTesting: XCTestCase {

    override func setUpWithError() throws {
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    func testMakeDetailsView() throws {
        let fetchExpectation = expectation(description: "make details view")
    
        var sut = MoviePresenter()
        
        APIMovieRepository.shared.fetchMovies(endpoint: .popular) { isFinished in
            let indexPath = IndexPath(index: IndexPath.Element(1))
            
            let detailsView = sut.makeMovieDetailViewControllerModel(indexPath: indexPath, for: 2, section: 0)
            
            print(detailsView.title)
            
            fetchExpectation.fulfill()
        }
        
        
        waitForExpectations(timeout: 5)
    }
    
    
    func testMovieGetters() throws {
        let movie = Movie(id: 0, title: "TitleTest", overview: "OverviewTest", voteAverage: 7.12, posterPath: "unknown", genreIds: [0, 1, 2])
        
        let title = movie.description
        
    }
    
    func testFetchNowPlaying() throws {
            var sut: APIMovieRepository!
            try super.setUpWithError()
            sut = APIMovieRepository()
            
            sut.fetchMovies(endpoint: .nowPlaying) { isFinished in
                XCTAssertTrue(isFinished)
            }
        }
        
        func testFetchPopular() throws {
            var sut: APIMovieRepository!
            try super.setUpWithError()
            sut = APIMovieRepository()
            
            sut.fetchMovies(endpoint: .popular) { isFinished in
                XCTAssertTrue(isFinished)
            }
        }
        
        func testGetNumberOfSections() throws {
            var sut: APIMovieRepository!
            try super.setUpWithError()
            sut = APIMovieRepository()
            
            let endPointCount = Endpoint.allCases.count
            XCTAssertEqual(endPointCount, sut.getNumberOfSections())
        }
        
        func testGetNumberOfMovies() throws {
            var sut: APIMovieRepository!
            try super.setUpWithError()
            sut = APIMovieRepository()
            
            print("1")
            
            sut.fetchMovies(endpoint: .popular) { isFinished in
                print("2")
                XCTAssertEqual(sut.moviesPopular.count, sut.getNumberOfMovies(endpoint: .popular))
            }
            
            print("3")
            
            
    //        XCTAssertEqual(sut.moviesNowPlaying.count, sut.getNumberOfMovies(endpoint: .nowPlaying))
        }
        
        
        func testFetchMovies() throws {
            var sut: APIMovieRepository!
            try super.setUpWithError()
            sut = APIMovieRepository()
            let expectation = self.expectation(description: "Fetch Movies")
            
            sut.fetchMovies(endpoint: .popular) { success in
                XCTAssertTrue(success, "Fetching movies failed")
                expectation.fulfill()
            }
            
            waitForExpectations(timeout: 2) { error in
                if let error = error {
                    XCTFail("Timeout Error: \(error)")
                }
            }
            print("movies fetched!")
        }
    
    
    func testTags() throws {
        
        let fetchExpectation = expectation(description: "Fetch movies")
        
        var sut = APIMovieRepository()
        
        sut.fetchMovies(endpoint: .popular) { isFinished in
            XCTAssertEqual(sut.getTagsOfMovie(indexOf: 0, endpoint: .popular), "Action, Adventure, Animation, Comedy, Family")
            
            fetchExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 5)
        
        //sut.getTagsOfMovie(indexOf: <#T##Int#>, endpoint: <#T##Endpoint#>)
    }
    
    func testRatings() throws {
        let fetchExpectation = expectation(description: "Fetch movies")
        
        var sut = APIMovieRepository()
        
        sut.fetchMovies(endpoint: .popular) { isFinished in
            XCTAssertEqual(sut.getVoteAverageOfMovie(indexOf: 0, endpoint: .popular), 6.967)
            
            fetchExpectation.fulfill()
        }
        
        
        waitForExpectations(timeout: 5)
    }
    
    func testOverview() throws {
        let fetchExpectation = expectation(description: "Fetch movies")
        let overview = "Po is gearing up to become the spiritual leader of his Valley of Peace, but also needs someone to take his place as Dragon Warrior. As such, he will train a new kung fu practitioner for the spot and will encounter a villain called the Chameleon who conjures villains from the past."
        var sut = APIMovieRepository()
        
        sut.fetchMovies(endpoint: .popular) { isFinished in
            XCTAssertEqual(sut.getOverviewOfMovie(indexOf: 0, endpoint: .popular), overview)
            
            fetchExpectation.fulfill()
        }
        
        
        waitForExpectations(timeout: 5)
    }
    
    func testPresenterTags() throws {
        let fetchExpectation = expectation(description: "Fetch movies")
    
        var sut = MoviePresenter()
        
        APIMovieRepository.shared.fetchMovies(endpoint: .popular) { isFinished in
            XCTAssertEqual(sut.getTags(indexOf: 0, section: 0), "Action, Adventure, Animation, Comedy, Family")
            
            fetchExpectation.fulfill()
        }
        
        
        waitForExpectations(timeout: 5)
    }
    

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
