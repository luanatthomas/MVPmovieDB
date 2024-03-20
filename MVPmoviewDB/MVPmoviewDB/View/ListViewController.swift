//
//  ListViewController.swift
//  MVPmoviewDB
//
//  Created by Luana Tais Thomas on 19/03/24.
//

import Foundation
import UIKit


class ListViewController: UIViewController {
    private var presenter: MoviePresenter
    var scrollView: UIScrollView
    var tableView: UITableView
    var searchController: UISearchController
    
    init(presenter: MoviePresenter = MoviePresenter()) {
        self.presenter = presenter
        self.searchController = UISearchController()
        self.tableView = UITableView()
        self.scrollView = UIScrollView()

        super.init(nibName: nil, bundle: nil)
    
        presenter.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        presenter.viewDidLoad()
        
        self.title = "Movies"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupSearchController()
    }
}

// Search
extension ListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        tableView.reloadData()
    }
    
    
    func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movies"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}


extension ListViewController: UITableViewDelegate {
    
}

extension ListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.getNumberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getNumberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return presenter.getSectionName(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as! MovieTableViewCell
        
        let listViewControllerModel = presenter.makeListViewControllerModel(for: indexPath.row, section: indexPath.section)
        
        cell.titleLabel.text = listViewControllerModel.title
        cell.descriptionLabel.text = listViewControllerModel.description
        cell.overviewLabel.text = listViewControllerModel.overview

        return cell
    }
}

extension ListViewController: MoviePresenterDelegate {
    func setupUI() {
        tableView = UITableView(frame: CGRect(x:0, y:0, width: view.bounds.width, height: view.bounds.height))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        
        view.addSubview(tableView)


        
    }
}

private extension MoviePresenter {
    
    typealias ListViewControllerModel = (title: String, description: String, overview: String, imageCover: Data?)
    
    func makeListViewControllerModel(for index: Int, section: Int) -> ListViewControllerModel {
        let title = getTitleLabel(indexOf: index, section: section)
        let description = getDescriptionLabel(indexOf: index, section: section)
        let overview = getOverviewLabel(indexOf: index, section: section)
        let imageCover = getImage(indexOf: index, section: section)
        
        let listViewControllerModel = ListViewControllerModel(title: title,
                                                              description: description,
                                                              overview: overview,
                                                              imageCover: imageCover)
        
        return listViewControllerModel
    }
    
}

