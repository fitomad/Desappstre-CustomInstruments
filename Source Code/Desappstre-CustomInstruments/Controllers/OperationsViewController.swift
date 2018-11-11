//
//  OperationsViewController.swift
//  Desappstre-CustomInstruments
//
//  Created by Adolfo Vera Blasco on 09/11/2018.
//  Copyright © 2018 desappstre {estudio}. All rights reserved.
//

import UIKit
import Foundation

import CoreTraktTV

internal class OperationsViewController: UIViewController
{
    ///
    @IBOutlet private weak var buttonPopular: UIButton!
    ///
    @IBOutlet private weak var buttonTrending: UIButton!
    ///
    @IBOutlet private weak var buttonSearch: UIButton!
    ///
    @IBOutlet private weak var textfieldSearch: UITextField!
    
    //
    // MARK: - Life Cycle
    //
    
    override internal func viewDidLoad() -> Void
    {
        super.viewDidLoad()
        
        self.prepareUI()
    }
    
    //
    // MARK: - Prepare UI
    //
    
    /**
 
    */
    private func prepareUI() -> Void
    {
        [ self.buttonSearch, self.buttonPopular, self.buttonTrending ].forEach({
            $0?.layer.cornerRadius = 8.0
            $0?.layer.masksToBounds = true
            
            $0?.backgroundColor = UIColor(named: "BackgroundColor")
            $0?.tintColor = UIColor(named: "TintColor")
        })
    }
    
    //
    // MARK: - Actions
    //
    
    /**
 
    */
    @IBAction private func handlePopularButtonTap(sender: UIButton) -> Void
    {
        TraktTVClient.shared.popularShows(handler: { (shows: [Show]?, pagination: Pagination?, error: TraktError?) -> Void in
            if let shows = shows
            {
                shows.forEach({ print("> \($0.title)") })
            }
        })
    }
    
    /**
     
     */
    @IBAction private func handleTrendingButtonTap(sender: UIButton) -> Void
    {
        TraktTVClient.shared.trendingShows(handler: { (shows: [TrendyShow]?, pagination: Pagination?, error: TraktError?) -> Void in
            if let shows = shows
            {
                shows.forEach({ print("> \($0.show.title)") })
            }
        })
    }
    
    /**
     
     */
    @IBAction private func handleSearchButtonTap(sender: UIButton) -> Void
    {
        guard var searchTerm = self.textfieldSearch.text, !searchTerm.isEmpty else
        {
            return
        }
        searchTerm = searchTerm.replacingOccurrences(of: " ", with: "+")
        
        TraktTVClient.shared.searchShow(searchTerm) { (shows: [SearchResult]?, pagination: Pagination?, error: TraktError?) -> Void in
            if let shows = shows
            {
                shows.forEach({ print("-> \($0.show.title)") })
            }
        }
    }
}
