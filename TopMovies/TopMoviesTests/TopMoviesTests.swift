//
//  TopMoviesTests.swift
//  TopMoviesTests
//
//  Created by Oscar Gamiz on 21/5/22.
//

import XCTest
@testable import TopMovies

class TopMoviesTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    //MARK: - UTILS TEST
    func testDataQueryURLTopRated() throws
    {
        let dataQuery = Utils.getDataQuery(.movie, withPath: "top_rated")
        //Not nil for required data
        XCTAssertNotNil(dataQuery.iUrl)
        XCTAssertNotNil(dataQuery.iBaseURL)
        XCTAssertNotNil(dataQuery.iPath)
        XCTAssertNotNil(dataQuery.iParameters["api_key"])
        XCTAssertNotNil(dataQuery.iParameters["language"])
        //Results equals to example
        XCTAssertEqual(dataQuery.iUrl, "https://api.themoviedb.org/3/movie/top_rated")
        XCTAssertEqual(dataQuery.iBaseURL, "https://api.themoviedb.org/3/")
        XCTAssertEqual(dataQuery.iPath, "movie/top_rated")
        XCTAssertEqual(dataQuery.iParameters["api_key"], "1cabc14aa36df93f88e9f0860baf3b19")
        XCTAssertEqual(dataQuery.iParameters["language"], Locale.current.languageCode)
    }
    func testDataQueryURLSearch() throws
    {
        let dataQuery = Utils.getDataQuery(.search, withPath: "movie/")
        //Not nil for required data
        XCTAssertNotNil(dataQuery.iUrl)
        XCTAssertNotNil(dataQuery.iBaseURL)
        XCTAssertNotNil(dataQuery.iPath)
        XCTAssertNotNil(dataQuery.iParameters["api_key"])
        XCTAssertNotNil(dataQuery.iParameters["language"])
        //Results equals to example
        XCTAssertEqual(dataQuery.iUrl, "https://api.themoviedb.org/3/search/movie/")
        XCTAssertEqual(dataQuery.iBaseURL, "https://api.themoviedb.org/3/")
        XCTAssertEqual(dataQuery.iPath, "search/movie/")
        XCTAssertEqual(dataQuery.iParameters["api_key"], "1cabc14aa36df93f88e9f0860baf3b19")
        XCTAssertEqual(dataQuery.iParameters["language"], Locale.current.languageCode)
    }
    func testDataQueryURLImage() throws
    {
        //https://image.tmdb.org/t/p/w342/dc1fX265fZIIY5Hab8I7CdETyJy.jpg?api_key=1cabc14aa36df93f88e9f0860baf3b19
        let dataQuery = Utils.getDataQuery(.image, withPath: "/dc1fX265fZIIY5Hab8I7CdETyJy.jpg", forImageType: .poster)
        //Not nil for required data
        XCTAssertNotNil(dataQuery.iUrl)
        XCTAssertNotNil(dataQuery.iBaseURL)
        XCTAssertNotNil(dataQuery.iPath)
        XCTAssertNotNil(dataQuery.iParameters["api_key"])
        //Results equals to example
        XCTAssertEqual(dataQuery.iUrl, "https://image.tmdb.org/t/p/w342/dc1fX265fZIIY5Hab8I7CdETyJy.jpg")
        XCTAssertEqual(dataQuery.iBaseURL, "https://image.tmdb.org/t/p/w342")
        XCTAssertEqual(dataQuery.iPath, "/dc1fX265fZIIY5Hab8I7CdETyJy.jpg")
        XCTAssertEqual(dataQuery.iParameters["api_key"], "1cabc14aa36df93f88e9f0860baf3b19")
    }
    func testResizeImage()
    {
        let image:UIImage = UIImage(named: "AppLogo")!
        
        let imageResized = Utils.resizeImage(image, withSize: CGSize(width: 24.0, height: 24.0))
        
        XCTAssertEqual(imageResized.size.width, 24.0)
        XCTAssertEqual(imageResized.size.height, 24.0)
    }
    
    func testGetFormattedTime()
    {
        var formattedTime = Utils.getFormattedTime(43)
        XCTAssertEqual(formattedTime, "43m")
        
        formattedTime = Utils.getFormattedTime(91)
        XCTAssertEqual(formattedTime, "1h31m")
        
        formattedTime = Utils.getFormattedTime(137)
        XCTAssertEqual(formattedTime, "2h17m")
        
        formattedTime = Utils.getFormattedTime(200)
        XCTAssertEqual(formattedTime, "3h20m")
    }
    
    //MARK: - MOVIE LIST TEST
    func testCreateModuleMovieList()
    {
        let movieListModule = MovieListRouter.createModule()
        
        XCTAssertNotNil(movieListModule.iPresenter)
        XCTAssertNotNil(movieListModule.iPresenter?.iView)
        XCTAssertNotNil(movieListModule.iPresenter?.iInteractor)
        XCTAssertNotNil(movieListModule.iPresenter?.iRouter)
        XCTAssertNotNil(movieListModule.iPresenter?.iInteractor?.iPresenter)
    }
    func testGetMovieListDataQuery() throws
    {
        //https://api.themoviedb.org/3/movie/top_rated?api_key=1cabc14aa36df93f88e9f0860baf3b19&language=es&page=1
        let dataQuery = MovieListPresenter().getMovieListDataQuery()
        //Not nil for required data
        XCTAssertNotNil(dataQuery.iUrl)
        XCTAssertNotNil(dataQuery.iBaseURL)
        XCTAssertNotNil(dataQuery.iPath)
        XCTAssertNotNil(dataQuery.iParameters["api_key"])
        XCTAssertNotNil(dataQuery.iParameters["language"])
        XCTAssertNotNil(dataQuery.iParameters["page"])
        //Results equals to example
        XCTAssertEqual(dataQuery.iUrl, "https://api.themoviedb.org/3/movie/top_rated")
        XCTAssertEqual(dataQuery.iBaseURL, "https://api.themoviedb.org/3/")
        XCTAssertEqual(dataQuery.iPath, "movie/top_rated")
        XCTAssertEqual(dataQuery.iParameters["api_key"], "1cabc14aa36df93f88e9f0860baf3b19")
        XCTAssertEqual(dataQuery.iParameters["language"], Locale.current.languageCode)
    }
    
    func testSetSearchingParameters() throws
    {
        let movieListPresenter = MovieListPresenter()
        movieListPresenter.setSearchingParameters("Star wars")
        
        XCTAssertEqual(movieListPresenter.iCurrentSearchText, "Star wars")
        XCTAssertEqual(movieListPresenter.iCurrentPath, "movie/")
        XCTAssertEqual(movieListPresenter.iCurrentPage, 0)
        XCTAssertEqual(movieListPresenter.iTotalPages, 0)
        
        movieListPresenter.setSearchingParameters("")
        
        XCTAssertEqual(movieListPresenter.iCurrentSearchText, "")
        XCTAssertEqual(movieListPresenter.iCurrentPath, "top_rated")
        XCTAssertEqual(movieListPresenter.iCurrentPage, 0)
        XCTAssertEqual(movieListPresenter.iTotalPages, 0)
    }
    
    
    //MARK: - MOVIE DETAIL TEST
    func testCreateModuleMovieDetail()
    {
        let movieDetailModule = MovieDetailRoute.createModule()
        
        XCTAssertNotNil(movieDetailModule.iPresenter)
        XCTAssertNotNil(movieDetailModule.iPresenter?.iView)
        XCTAssertNotNil(movieDetailModule.iPresenter?.iInteractor)
        XCTAssertNotNil(movieDetailModule.iPresenter?.iRouter)
        XCTAssertNotNil(movieDetailModule.iPresenter?.iInteractor?.iPresenter)
    }
    func testGetMovieDetailDataQuery() throws
    {
        //https://api.themoviedb.org/3/movie/1895?api_key=1cabc14aa36df93f88e9f0860baf3b19&append_to_response=credits&language=es
        let dataQuery = MovieDetailPresenter().getMovieDetailDataQuery(1895)
        //Not nil for required data
        XCTAssertNotNil(dataQuery.iUrl)
        XCTAssertNotNil(dataQuery.iBaseURL)
        XCTAssertNotNil(dataQuery.iPath)
        XCTAssertNotNil(dataQuery.iParameters["api_key"])
        XCTAssertNotNil(dataQuery.iParameters["language"])
        //Results equals to example
        XCTAssertEqual(dataQuery.iUrl, "https://api.themoviedb.org/3/movie/1895")
        XCTAssertEqual(dataQuery.iBaseURL, "https://api.themoviedb.org/3/")
        XCTAssertEqual(dataQuery.iPath, "movie/1895")
        XCTAssertEqual(dataQuery.iParameters["api_key"], "1cabc14aa36df93f88e9f0860baf3b19")
        XCTAssertEqual(dataQuery.iParameters["language"], Locale.current.languageCode)
        XCTAssertEqual(dataQuery.iParameters["append_to_response"], "credits")
    }
}
