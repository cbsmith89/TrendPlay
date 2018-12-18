//
//  PlayerSearchableMultiSelectViewController.swift
//  TrendPlay
//
//  Created by Chelsea Smith on 9/2/17.
//  Copyright © 2017 Trending Productions LLC. All rights reserved.
//

import UIKit
import MaterialComponents
import Floaty

class PlayerSearchableMultiSelectViewController: UIViewController, UITableViewDataSource, UISearchResultsUpdating {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var buttonView: UIButton!
    
    var alertTitlePlayer: String = ""
    var buttonTextPlayer: String = ""
    var buttonTextPlayerMutableString = NSMutableAttributedString()
    let char: Character = "\0"
    let spacing = CGFloat(-0.6)
    var searchBarControllerPlayer: UISearchController!
    let valuesViewPlayer = UIView()
    let lineView = UIView()
    let doneButtonImage = UIImage(named: "doneEmpty")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
    let topView = UIView()
    let operators = ["=", "≠", "<", ">", "< >"]
    var headerLabelPlayer: String = ""
    var listValuePlayers = ["-10000"]
    var filteredListValuePlayers: [String]!
    var formListCellsPlayer: [String : Int] = ["-10000" : -10000]
    var selectedCellsPlayer: [String] = []
    var selectedCellsMappedPlayer: [Int] = []
    var selectedRowsPlayer: [Int] = []
    var queryEnglishStringPlayer: String = ""
    var tapPlayer: UIGestureRecognizer!
    var multipleSelectionBooleanPlayer: Bool!
    var messageStringPlayer: String = ""
    var titleStringPlayer: String = ""
    var alertControllerPlayer = MDCAlertController()
    var raisedButtonPlayer = MDCRaisedButton()
    var team1ButtonLabelPlayer: String = ""
    var team2ButtonLabelPlayer: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("PlayerSearchableMultiSelectViewController")
        let floatActionButton = Floaty()
        let floatyItem = FloatyItem()
        let action = MDCAlertAction(title:"OK") { (action) in print("OK") }
        alertControllerPlayer = MDCAlertController(title: titleStringPlayer, message: messageStringPlayer)
        alertControllerPlayer.addAction(action)
        alertControllerPlayer.buttonTitleColor = orangeColor
        alertControllerPlayer.buttonFont = fifteenBlackRoboto
        alertControllerPlayer.view.backgroundColor = lightGreyColor.withAlphaComponent(0.8)
        alertControllerPlayer.titleFont = sixteenBoldRobotoCondensed
        alertControllerPlayer.messageFont = fifteenRegularRobotoCondensed
        alertControllerPlayer.titleColor = darkGreyColor
        alertControllerPlayer.messageColor = dashboardGreyColor
        raisedButtonPlayer.setElevation(ShadowElevation(rawValue: 2), for: .normal)
        raisedButtonPlayer.setTitleColor(silverColor, for: .normal)
        raisedButtonPlayer.setTitleColor(silverColor, for: .selected)
        raisedButtonPlayer.addTarget(self, action: #selector(PlayerSearchableMultiSelectViewController.labelTappedPlayer), for: .touchUpInside)
        buttonView = raisedButtonPlayer
    
        let editButtonImage = UIImage(named: "edit")?.withRenderingMode(
            UIImageRenderingMode.alwaysTemplate)
        let resetItemImage = UIImage(named: "reset")?.withRenderingMode(
            UIImageRenderingMode.alwaysTemplate)
        floatActionButton.buttonImage = editButtonImage
        floatActionButton.buttonColor = lightMediumGreyColor.withAlphaComponent(0.85)
        floatActionButton.openAnimationType = .slideLeft
        floatActionButton.overlayColor = dashboardGreyColor.withAlphaComponent(0.75)
        floatyItem.title = "RESET SELECTION"
        floatyItem.titleColor = lightGreyColor
        floatyItem.titleLabel.font = thirteenBlackRoboto
        floatyItem.titleLabel.textAlignment = .right
        floatyItem.buttonColor = lightMediumGreyColor
        floatyItem.tintColor = lightGreyColor
        floatyItem.size = CGFloat(52)
        floatyItem.frame = CGRect(x: 0, y: 0, width: 52, height: 52)
        floatyItem.imageSize = CGSize(width: 35, height: 35)
        floatyItem.icon = resetItemImage
        let deleteHandler: (FloatyItem) -> Void = { item in
            self.clearMultiSelectSelections()
        }
        floatyItem.handler = deleteHandler
        floatActionButton.friendlyTap = true
        floatActionButton.addItem(item: floatyItem)
        self.view.addSubview(floatActionButton)
        
        switch (tagTextPlayer) {
        case "PLAYER":
            titleStringPlayer = tagTextPlayer
            headerLabelPlayer = tagTextPlayer
            listValuePlayers = playerValuesPlayer
            formListValuePlayer = playerListValuePlayer
            multipleSelectionBoolPlayer = playerMultipleSelectionBoolPlayer
            formOperatorValuePlayer = playerOperatorValuePlayer
            formOperatorTextPlayer = playerOperatorTextPlayer
            formListCellsPlayer = playerListCellsPlayer
            segmentedControl.isHidden = true
        case "OPPONENT":
            titleStringPlayer = tagTextPlayer
            headerLabelPlayer = tagTextPlayer
            listValuePlayers = team2Values
            formListValuePlayer = team2ListValuePlayer
            multipleSelectionBoolPlayer = team2MultipleSelectionBoolPlayer
            formOperatorValuePlayer = team2OperatorValuePlayer
            formOperatorTextPlayer = team2OperatorTextPlayer
            formListCellsPlayer = team2ListCellsPlayer
            segmentedControl.isHidden = false
        case "PLAYER TEAM":
            titleStringPlayer = tagTextPlayer
            headerLabelPlayer = tagTextPlayer
            listValuePlayers = team1Values
            formListValuePlayer = team1ListValuePlayer
            multipleSelectionBoolPlayer = team1MultipleSelectionBoolPlayer
            formOperatorValuePlayer = team1OperatorValuePlayer
            formOperatorTextPlayer = team1OperatorTextPlayer
            formListCellsPlayer = team1ListCellsPlayer
            segmentedControl.isHidden = true
        case "HOME TEAM":
            titleStringPlayer = tagTextPlayer
            headerLabelPlayer = tagTextPlayer
            listValuePlayers = homeTeamValues
            formListValuePlayer = homeTeamListValuePlayer
            multipleSelectionBoolPlayer = homeTeamMultipleSelectionBoolPlayer
            formOperatorValuePlayer = homeTeamOperatorValuePlayer
            formOperatorTextPlayer = homeTeamOperatorTextPlayer
            formListCellsPlayer = homeTeamListCellsPlayer
            segmentedControl.isHidden = true
        case "FAVORITE":
            titleStringPlayer = tagTextPlayer
            headerLabelPlayer = tagTextPlayer
            listValuePlayers = favoriteValues
            formListValuePlayer = favoriteListValuePlayer
            multipleSelectionBoolPlayer = favoriteMultipleSelectionBoolPlayer
            formOperatorValuePlayer = favoriteOperatorValuePlayer
            formOperatorTextPlayer = favoriteOperatorTextPlayer
            formListCellsPlayer = favoriteListCellsPlayer
            segmentedControl.isHidden = true
        case "PLAYER TEAM: PLAYERS":
            titleStringPlayer = tagTextPlayer
            var rowTitle = tagTextPlayer
            var rowTitleTextArray = rowTitle.components(separatedBy: ": ")
            rowTitle = rowTitleTextArray[1]
            if team1ListValuePlayer == ["-10000"] || team1ListValuePlayer == [] {
                headerLabelPlayer = tagTextPlayer
            } else {
                if team1ListValuePlayer[0] == "NEW YORK GIANTS" {
                    team1ButtonLabelPlayer = "NEW YORK (G)"
                } else if team1ListValuePlayer[0] == "NEW YORK JETS" {
                    team1ButtonLabelPlayer = "NEW YORK (J)"
                } else if team1ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                    team1ButtonLabelPlayer = "LOS ANGELES (C)"
                } else if team1ListValuePlayer[0] == "LOS ANGELES RAMS" {
                    team1ButtonLabelPlayer = "LOS ANGELES (R)"
                } else {
                    team1ButtonLabelPlayer = team1ListValuePlayer[0]
                    var team1TextArray = team1ButtonLabelPlayer.components(separatedBy: " ")
                    let team1TextArrayLength = team1TextArray.count
                    team1TextArray.remove(at: team1TextArrayLength - 1)
                    team1ButtonLabelPlayer = team1TextArray.joined(separator: " ")
                }
                headerLabelPlayer = team1ButtonLabelPlayer + ": " + rowTitle
            }
            listValuePlayers = playerValuesPlayer
            formListValuePlayer = playerListValuePlayer
            multipleSelectionBoolPlayer = playerTeamMultipleSelectionBoolPlayer
            formOperatorValuePlayer = playerOperatorValuePlayer
            formOperatorTextPlayer = playerOperatorTextPlayer
            formListCellsPlayer = playerListCells
            segmentedControl.isHidden = false
        case "OPPONENT: PLAYERS":
            titleStringPlayer = tagTextPlayer
            var rowTitle = tagTextPlayer
            var rowTitleTextArray = rowTitle.components(separatedBy: ": ")
            rowTitle = rowTitleTextArray[1]
            if team2ListValuePlayer == ["-10000"] || team2ListValuePlayer == [] {
                headerLabelPlayer = tagTextPlayer
            } else {
                if team2ListValuePlayer[0] == "NEW YORK GIANTS" {
                    team2ButtonLabelPlayer = "NEW YORK (G)"
                } else if team2ListValuePlayer[0] == "NEW YORK JETS" {
                    team2ButtonLabelPlayer = "NEW YORK (J)"
                } else if team2ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                    team2ButtonLabelPlayer = "LOS ANGELES (C)"
                } else if team2ListValuePlayer[0] == "LOS ANGELES RAMS" {
                    team2ButtonLabelPlayer = "LOS ANGELES (R)"
                } else {
                    team2ButtonLabelPlayer = team2ListValuePlayer[0]
                    var team2TextArray = team2ButtonLabelPlayer.components(separatedBy: " ")
                    let team2TextArrayLength = team2TextArray.count
                    team2TextArray.remove(at: team2TextArrayLength - 1)
                    team2ButtonLabelPlayer = team2TextArray.joined(separator: " ")
                }
                headerLabelPlayer = team2ButtonLabelPlayer + ": " + rowTitle
            }
            listValuePlayers = playerOpponentValues
            formListValuePlayer = playerOpponentListValuePlayer
            multipleSelectionBoolPlayer = playerOpponentMultipleSelectionBoolPlayer
            formOperatorValuePlayer = playerOpponentOperatorValuePlayer
            formOperatorTextPlayer = playerOpponentOperatorTextPlayer
            formListCellsPlayer = playerOpponentListCellsPlayer
            segmentedControl.isHidden = false
        case "DAY":
            titleStringPlayer = tagTextPlayer
            headerLabelPlayer = tagTextPlayer
            listValuePlayers = dayValues
            formListValuePlayer = dayListValuePlayer
            multipleSelectionBoolPlayer = dayMultipleSelectionBoolPlayer
            formOperatorValuePlayer = dayOperatorValuePlayer
            formOperatorTextPlayer = dayOperatorTextPlayer
            formListCellsPlayer = dayListCellsPlayer
            segmentedControl.isHidden = true
        case "STADIUM":
            titleStringPlayer = tagTextPlayer
            headerLabelPlayer = tagTextPlayer
            listValuePlayers = stadiumValues
            formListValuePlayer = stadiumListValuePlayer
            multipleSelectionBoolPlayer = stadiumMultipleSelectionBoolPlayer
            formOperatorValuePlayer = stadiumOperatorValuePlayer
            formOperatorTextPlayer = stadiumOperatorTextPlayer
            formListCellsPlayer = stadiumListCellsPlayer
            segmentedControl.isHidden = true
        case "SURFACE":
            titleStringPlayer = tagTextPlayer
            headerLabelPlayer = tagTextPlayer
            listValuePlayers = surfaceValues
            formListValuePlayer = surfaceListValuePlayer
            multipleSelectionBoolPlayer = surfaceMultipleSelectionBoolPlayer
            formOperatorValuePlayer = surfaceOperatorValuePlayer
            formOperatorTextPlayer = surfaceOperatorTextPlayer
            formListCellsPlayer = surfaceListCellsPlayer
            segmentedControl.isHidden = true
        default:
            titleStringPlayer = tagTextPlayer
            headerLabelPlayer = tagTextPlayer
            listValuePlayers = team1Values
            formListValuePlayer = team1ListValuePlayer
            formOperatorValuePlayer = team1OperatorValuePlayer
            formOperatorTextPlayer = team1OperatorTextPlayer
            formListCellsPlayer = team1ListCellsPlayer
            segmentedControl.isHidden = false
        }
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.toolbar.isHidden = true
        self.title = nil
        self.view.addSubview(segmentedControl)
        segmentedControl.tintColor = lightGreyColor
        segmentedControl.backgroundColor = UIColor.clear
        segmentedControl.setTitleTextAttributes([NSAttributedStringKey.font: sixteenLightRoboto!], for: UIControlState.normal)
        segmentedControl.setTitleTextAttributes([NSAttributedStringKey.font: sixteenBoldRoboto!], for: UIControlState.selected)
        switch(tagTextPlayer) {
        case "PLAYER TEAM":
            switch(selectedOperatorValuePlayerTeam) {
            case "=":
                segmentedControl.selectedSegmentIndex = 0
            case "≠":
                segmentedControl.selectedSegmentIndex = 1
            default:
                segmentedControl.selectedSegmentIndex = 0
            }
        case "OPPONENT":
            switch(selectedOperatorValuePlayerOpponent) {
            case "=":
                segmentedControl.selectedSegmentIndex = 0
            case "≠":
                segmentedControl.selectedSegmentIndex = 1
            default:
                segmentedControl.selectedSegmentIndex = 0
            }
        case "PLAYER TEAM: PLAYERS":
            switch(selectedOperatorValuePlayerTeam) {
            case "=":
                segmentedControl.selectedSegmentIndex = 0
            case "≠":
                segmentedControl.selectedSegmentIndex = 1
            default:
                segmentedControl.selectedSegmentIndex = 0
            }
        case "OPPONENT: PLAYERS":
            switch(selectedOperatorValuePlayerOpponent) {
            case "=":
                segmentedControl.selectedSegmentIndex = 0
            case "≠":
                segmentedControl.selectedSegmentIndex = 1
            default:
                segmentedControl.selectedSegmentIndex = 0
            }
        default:
            print("")
        }
        

        buttonView.titleLabel?.textColor = lightMediumGreyColor
        buttonView.frame = CGRect(x: 20.0, y: screenHeight * 0.01, width: screenWidth - 40.0, height: 38.0)
        buttonView.backgroundColor = mediumGreyColor
        buttonView.titleLabel?.textColor = lightGreyColorButton
        buttonView.titleLabel?.contentMode = .center
        buttonView?.titleLabel?.textAlignment = .center
        buttonView.titleLabel?.lineBreakMode = .byTruncatingTail
        self.view.addSubview(buttonView)
        self.view.backgroundColor = darkGreyColor
        self.tableView.backgroundColor = darkGreyColor
        self.tableView.tableFooterView?.backgroundColor = darkGreyColor
        self.tableView.separatorStyle = .singleLine
        self.tableView.separatorColor = lightMediumGreyColor
        self.tableView.separatorInset = UIEdgeInsetsMake(3, 0, 3, 0)
        if segmentedControl.isHidden {
            self.tableView.frame = CGRect(x: 0, y: buttonView.frame.maxY + 10.0, width: screenWidth, height: self.view.frame.height / 2.75)
        } else {
            self.segmentedControl.frame = CGRect(x: (screenWidth - (screenWidth / 4.0)) / 2.0, y: buttonView.frame.maxY + 10.0, width: screenWidth / 4, height: 28.0)
            self.tableView.frame = CGRect(x: 0, y: segmentedControl.frame.maxY + 10.0, width: screenWidth, height: self.view.frame.height / 2.95)
        }
        
        self.tableView.dataSource = self
        self.tableView.delegate = self as? UITableViewDelegate
        self.tableView.allowsMultipleSelection = true
        filteredListValuePlayers = listValuePlayers
        self.tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "TableCell")
        self.tableView.rowHeight = 34.0
        searchBarControllerPlayer = UISearchController(searchResultsController: nil)
        searchBarControllerPlayer.searchResultsUpdater = self as UISearchResultsUpdating
        searchBarControllerPlayer.dimsBackgroundDuringPresentation = false
        searchBarControllerPlayer.searchBar.sizeToFit()
        self.tableView.tableHeaderView = searchBarControllerPlayer.searchBar
        searchBarControllerPlayer.searchBar.tintColor = lightGreyColor
        searchBarControllerPlayer.searchBar.barTintColor = darkGreyColor
        searchBarControllerPlayer.searchBar.autocapitalizationType = .allCharacters
        searchBarControllerPlayer.searchBar.backgroundColor = darkGreyColor
        if let searchBarTextField = searchBarControllerPlayer.searchBar.value(forKey: "_searchField") as? UITextField {
            searchBarTextField.font = thirteenRegularSFCompact!
            searchBarTextField.textColor = lightGreyColor
            searchBarTextField.backgroundColor = mediumGreyColor
            searchBarTextField.borderStyle = .roundedRect
            searchBarTextField.isOpaque = false
        }
        searchBarControllerPlayer.searchBar.barStyle = .default
        let cancelButtonAttributes = [
            NSAttributedStringKey.foregroundColor: lightGreyColor,
            NSAttributedStringKey.font: thirteenRegularSFCompact!
        ]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(cancelButtonAttributes, for: .normal)
        searchBarControllerPlayer.searchBar.setValue(" DONE   ", forKey:"_cancelButtonText")
        definesPresentationContext = true
        //switch (formListValuePlayer.joined(separator: ", ")) {
        //print("viewDidLoad formListValuePlayer: ")
        //print(formListValuePlayer)
        switch (formListValuePlayer) {
        case (["-10000"]) :
            switch(tagTextPlayer) {
            case "PLAYER":
                buttonTextPlayer = self.headerLabelPlayer + "\0" + " IS ANY"
                let lineBreakIndex = buttonTextPlayer.indexDistance(of: char)
                buttonTextPlayerMutableString = NSMutableAttributedString(string: buttonTextPlayer, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.normal)
                buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.selected)
                listValuePlayer = " IS ANY"
            case "PLAYER TEAM":
                buttonTextPlayer = self.headerLabelPlayer + "\0" + " IS ANY TEAM"
                let lineBreakIndex = buttonTextPlayer.indexDistance(of: char)
                buttonTextPlayerMutableString = NSMutableAttributedString(string: buttonTextPlayer, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.normal)
                buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.selected)
                listValuePlayer = " IS ANY TEAM"
            case "OPPONENT":
                buttonTextPlayer = self.headerLabelPlayer + "\0" + " IS ANY TEAM"
                let lineBreakIndex = buttonTextPlayer.indexDistance(of: char)
                buttonTextPlayerMutableString = NSMutableAttributedString(string: buttonTextPlayer, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.normal)
                buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.selected)
                listValuePlayer = " IS ANY TEAM"
            case "HOME TEAM":
                buttonTextPlayer = self.headerLabelPlayer + "\0" + " IS ANY"
                let lineBreakIndex = buttonTextPlayer.indexDistance(of: char)
                buttonTextPlayerMutableString = NSMutableAttributedString(string: buttonTextPlayer, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.normal)
                buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.selected)
                listValuePlayer = " IS ANY"
                self.selectedRowsPlayer = [0, 1, 2]
            case "FAVORITE":
                buttonTextPlayer = self.headerLabelPlayer + "\0" + " IS ANY"
                let lineBreakIndex = buttonTextPlayer.indexDistance(of: char)
                buttonTextPlayerMutableString = NSMutableAttributedString(string: buttonTextPlayer, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.normal)
                buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.selected)
                listValuePlayer = " IS ANY"
                self.selectedRowsPlayer = [0, 1, 2]
            case "PLAYER TEAM: PLAYERS":
                buttonTextPlayer = self.headerLabelPlayer + "\0" + " INCLUDE ANY"
                let lineBreakIndex = buttonTextPlayer.indexDistance(of: char)
                buttonTextPlayerMutableString = NSMutableAttributedString(string: buttonTextPlayer, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.normal)
                buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.selected)
                listValuePlayer = " INCLUDE ANY"
            case "OPPONENT: PLAYERS":
                buttonTextPlayer = self.headerLabelPlayer + "\0" + " INCLUDE ANY"
                let lineBreakIndex = buttonTextPlayer.indexDistance(of: char)
                buttonTextPlayerMutableString = NSMutableAttributedString(string: buttonTextPlayer, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.normal)
                buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.selected)
                listValuePlayer = " INCLUDE ANY"
            case "DAY":
                buttonTextPlayer = self.headerLabelPlayer + "\0" + " IS ANY"
                let lineBreakIndex = buttonTextPlayer.indexDistance(of: char)
                buttonTextPlayerMutableString = NSMutableAttributedString(string: buttonTextPlayer, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.normal)
                buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.selected)
                listValuePlayer = " IS ANY"
            case "STADIUM":
                buttonTextPlayer = self.headerLabelPlayer + "\0" + " IS ANY"
                let lineBreakIndex = buttonTextPlayer.indexDistance(of: char)
                buttonTextPlayerMutableString = NSMutableAttributedString(string: buttonTextPlayer, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.normal)
                buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.selected)
                listValuePlayer = " IS ANY"
                self.selectedRowsPlayer = [0, 1, 2]
            case "SURFACE":
                buttonTextPlayer = self.headerLabelPlayer + "\0" + " IS ANY"
                let lineBreakIndex = buttonTextPlayer.indexDistance(of: char)
                buttonTextPlayerMutableString = NSMutableAttributedString(string: buttonTextPlayer, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.normal)
                buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.selected)
                listValuePlayer = " IS ANY"
                self.selectedRowsPlayer = [0, 1]
            default:
                buttonTextPlayer = self.headerLabelPlayer + "\0" + " IS ANY"
                let lineBreakIndex = buttonTextPlayer.indexDistance(of: char)
                buttonTextPlayerMutableString = NSMutableAttributedString(string: buttonTextPlayer, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
                listValuePlayer = " IS ANY"
            }
        case ([]):
            switch(tagTextPlayer) {
            case "PLAYER":
                buttonTextPlayer = self.headerLabelPlayer + "\0" + " IS ANY"
                let lineBreakIndex = buttonTextPlayer.indexDistance(of: char)
                buttonTextPlayerMutableString = NSMutableAttributedString(string: buttonTextPlayer, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.normal)
                buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.selected)
                listValuePlayer = " IS ANY"
            case "PLAYER TEAM":
                buttonTextPlayer = self.headerLabelPlayer + "\0" + " IS ANY TEAM"
                let lineBreakIndex = buttonTextPlayer.indexDistance(of: char)
                buttonTextPlayerMutableString = NSMutableAttributedString(string: buttonTextPlayer, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.normal)
                buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.selected)
                listValuePlayer = " IS ANY TEAM"
            case "OPPONENT":
                buttonTextPlayer = self.headerLabelPlayer + "\0" + " IS ANY TEAM"
                let lineBreakIndex = buttonTextPlayer.indexDistance(of: char)
                buttonTextPlayerMutableString = NSMutableAttributedString(string: buttonTextPlayer, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.normal)
                buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.selected)
                listValuePlayer = " IS ANY TEAM"
            case "HOME TEAM":
                buttonTextPlayer = self.headerLabelPlayer + "\0" + " IS ANY"
                let lineBreakIndex = buttonTextPlayer.indexDistance(of: char)
                buttonTextPlayerMutableString = NSMutableAttributedString(string: buttonTextPlayer, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.normal)
                buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.selected)
                listValuePlayer = " IS ANY"
                self.selectedRowsPlayer = [0, 1, 2]
            case "FAVORITE":
                buttonTextPlayer = self.headerLabelPlayer + "\0" + " IS ANY"
                let lineBreakIndex = buttonTextPlayer.indexDistance(of: char)
                buttonTextPlayerMutableString = NSMutableAttributedString(string: buttonTextPlayer, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.normal)
                buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.selected)
                listValuePlayer = " IS ANY"
                self.selectedRowsPlayer = [0, 1, 2]
            case "PLAYER TEAM: PLAYERS":
                buttonTextPlayer = self.headerLabelPlayer + "\0" + " INCLUDE ANY"
                let lineBreakIndex = buttonTextPlayer.indexDistance(of: char)
                buttonTextPlayerMutableString = NSMutableAttributedString(string: buttonTextPlayer, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.normal)
                buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.selected)
                listValuePlayer = " INCLUDE ANY"
            case "OPPONENT: PLAYERS":
                buttonTextPlayer = self.headerLabelPlayer + "\0" + " INCLUDE ANY"
                let lineBreakIndex = buttonTextPlayer.indexDistance(of: char)
                buttonTextPlayerMutableString = NSMutableAttributedString(string: buttonTextPlayer, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.normal)
                buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.selected)
                listValuePlayer = " INCLUDE ANY"
            case "DAY":
                buttonTextPlayer = self.headerLabelPlayer + "\0" + " IS ANY"
                let lineBreakIndex = buttonTextPlayer.indexDistance(of: char)
                buttonTextPlayerMutableString = NSMutableAttributedString(string: buttonTextPlayer, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.normal)
                buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.selected)
                listValuePlayer = " IS ANY"
            case "STADIUM":
                buttonTextPlayer = self.headerLabelPlayer + "\0" + " IS ANY"
                let lineBreakIndex = buttonTextPlayer.indexDistance(of: char)
                buttonTextPlayerMutableString = NSMutableAttributedString(string: buttonTextPlayer, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.normal)
                buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.selected)
                listValuePlayer = " IS ANY"
                self.selectedRowsPlayer = [0, 1, 2]
            case "SURFACE":
                buttonTextPlayer = self.headerLabelPlayer + "\0" + " IS ANY"
                let lineBreakIndex = buttonTextPlayer.indexDistance(of: char)
                buttonTextPlayerMutableString = NSMutableAttributedString(string: buttonTextPlayer, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.normal)
                buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.selected)
                listValuePlayer = " IS ANY"
                self.selectedRowsPlayer = [0, 1]
            default:
                buttonTextPlayer = self.headerLabelPlayer + "\0" + " IS ANY"
                let lineBreakIndex = buttonTextPlayer.indexDistance(of: char)
                buttonTextPlayerMutableString = NSMutableAttributedString(string: buttonTextPlayer, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.normal)
                buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.selected)
                listValuePlayer = " IS ANY"
            }
        case (["OUTDOORS", "DOME", "RETRACTABLE ROOF"]):
            buttonTextPlayer = self.headerLabelPlayer + "\0" + " IS ANY"
            let lineBreakIndex = buttonTextPlayer.indexDistance(of: char)
            buttonTextPlayerMutableString = NSMutableAttributedString(string: buttonTextPlayer, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:lineBreakIndex!))
            buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
            buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.selected)
            listValuePlayer = " IS ANY"
            self.selectedRowsPlayer = [0, 1, 2]
        default:
            switch(tagTextPlayer) {
            case "PLAYER TEAM":
                buttonTextPlayer = self.headerLabelPlayer + "\0" + team1OperatorTextPlayer + "THE " + formListValuePlayer.sorted().joined(separator: ", ")
                listValuePlayer = team1OperatorTextPlayer + formListValuePlayer.sorted().joined(separator: ", ")
            case "OPPONENT":
                buttonTextPlayer = self.headerLabelPlayer + "\0" + team2OperatorTextPlayer + "THE " + formListValuePlayer.sorted().joined(separator: ", ")
                listValuePlayer = team2OperatorTextPlayer + formListValuePlayer.sorted().joined(separator: ", ")
            case "PLAYER TEAM: PLAYERS":
                buttonTextPlayer = self.headerLabelPlayer + "\0" + playerOperatorTextPlayer + formListValuePlayer.sorted().joined(separator: ", ")
                listValuePlayer = playerOperatorTextPlayer + formListValuePlayer.sorted().joined(separator: ", ")
            case "OPPONENET: PLAYERS":
                buttonTextPlayer = self.headerLabelPlayer + "\0" + playerOpponentOperatorTextPlayer + formListValuePlayer.sorted().joined(separator: ", ")
                listValuePlayer = playerOpponentOperatorTextPlayer + formListValuePlayer.sorted().joined(separator: ", ")
            default:
                buttonTextPlayer = self.headerLabelPlayer + "\0" + " IS " + formListValuePlayer.sorted().joined(separator: ", ")
                listValuePlayer = " IS " + formListValuePlayer.sorted().joined(separator: ", ")
            }
            for formListValuePlayerKey in formListValuePlayer {
                if self.selectedRowsPlayer.contains(formListCellsPlayer[formListValuePlayerKey]!) {
                } else {
                    self.selectedRowsPlayer.append(formListCellsPlayer[formListValuePlayerKey]!)
                }
            }
            if buttonTextPlayer.count > 50 {
                let lineBreakIndex = buttonTextPlayer.indexDistance(of: char)
                buttonTextPlayerMutableString = NSMutableAttributedString(string: buttonTextPlayer, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonTextPlayer.count))
                buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.normal)
                buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.selected)
            } else if buttonTextPlayer.count > 40 {
                let lineBreakIndex = buttonTextPlayer.indexDistance(of: char)
                buttonTextPlayerMutableString = NSMutableAttributedString(string: buttonTextPlayer, attributes: [NSAttributedStringKey.font : twelveThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonTextPlayer.count))
                buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.normal)
                buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.selected)
            } else if buttonTextPlayer.count > 35 {
                let lineBreakIndex = buttonTextPlayer.indexDistance(of: char)
                buttonTextPlayerMutableString = NSMutableAttributedString(string: buttonTextPlayer, attributes: [NSAttributedStringKey.font : twelveAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonTextPlayer.count))
                buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.font, value: twelveAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.normal)
                buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.selected)
            } else {
                let lineBreakIndex = buttonTextPlayer.indexDistance(of: char)
                buttonTextPlayerMutableString = NSMutableAttributedString(string: buttonTextPlayer, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.3, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.normal)
                buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.selected)
            }
        }
        tapPlayer = UITapGestureRecognizer(target: self, action: #selector(handleTapPlayer))
        tapPlayer.cancelsTouchesInView = false
        self.tableView!.addGestureRecognizer(tapPlayer)
        self.segmentedControl.addTarget(self, action: #selector(PlayerSearchableMultiSelectViewController.reloadRowValuePlayer), for: .valueChanged)
        topView.frame = CGRect(x: 0, y: -480, width: screenWidth, height: 480)
        topView.backgroundColor = darkGreyColor
        self.tableView.addSubview(topView)
        self.tableView.allowsMultipleSelection = multipleSelectionBoolPlayer
        if self.selectedRowsPlayer != [] {
            makeOriginalSelectionsPlayer()
        }
        searchBarControllerPlayer.loadViewIfNeeded()
    }
    
    deinit {
        searchBarControllerPlayer.loadViewIfNeeded()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! CustomTableViewCell
        cell.isSelected = tableView.indexPathsForSelectedRows?.contains(indexPath) ?? false
        cell.textLabel?.text = filteredListValuePlayers[indexPath.row]
        cell.textLabel?.textColor = lightGreyColor
        cell.textLabel?.font = elevenAndAHalfRegular
        cell.backgroundColor = darkGreyColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
        tableView.cellForRow(at: indexPath)?.selectionStyle = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("filteredListValuePlayers.count")
        //print(filteredListValuePlayers.count)
        return filteredListValuePlayers.count
    }
    
    func makeOriginalSelectionsPlayer() {
        print("makeOriginalSelectionsPlayer")
        let mainQueue = DispatchQueue.main
        let deadline = DispatchTime.now() + .milliseconds(1)
        mainQueue.asyncAfter(deadline: deadline) {
            //print("1 millisecond has passed")
            //print("makeOriginalSelectionsPlayer selectedRowsPlayer: ")
            //print(self.selectedRowsPlayer)
            self.tableView.reloadData()
            //self.reselectSelectionsPlayer()
            //print("reselectSelectionsPlayer()")
            for listOptionsIndexPlayer in self.selectedRowsPlayer {
                //print("listOptionsIndexPlayer: " + String(listOptionsIndexPlayer))
                let listCellIndexKeysPlayer = self.formListCellsPlayer.allKeys(forValue: listOptionsIndexPlayer)
                //print("listCellIndexKeysPlayer: ")
                //print(listCellIndexKeysPlayer as Any)
                let listCellIndexPlayers = listCellIndexKeysPlayer[0]
                //print("listCellIndexPlayers: " + String(listCellIndexPlayers))
                let filteredListValuePlayersIndex = self.filteredListValuePlayers.index(of: listCellIndexPlayers)
                if filteredListValuePlayersIndex != nil {
                    //print("filteredListValuePlayersIndex: " + String(describing: filteredListValuePlayersIndex))
                    let filteredListValuePlayersIndexPath = IndexPath(row: filteredListValuePlayersIndex!, section: 0)
                    self.tableView.selectRow(at: filteredListValuePlayersIndexPath, animated: false, scrollPosition: .none)
                }
            }
            //print("selectedRowsPlayer: ")
            //print(self.selectedRowsPlayer)
        }
    }
    
    func reselectSelectionsPlayer() {
        //print("reselectSelectionsPlayer()")
        for listOptionsIndexPlayer in selectedRowsPlayer {
            //print("listOptionsIndexPlayer: " + String(listOptionsIndexPlayer))
            let listCellIndexKeysPlayer = formListCellsPlayer.allKeys(forValue: listOptionsIndexPlayer)
            //print("listCellIndexKeysPlayer: ")
            //print(listCellIndexKeysPlayer as Any)
            let listCellIndexPlayers = listCellIndexKeysPlayer[0]
            //print("listCellIndexPlayers: " + String(listCellIndexPlayers))
            let filteredListValuePlayersIndex = filteredListValuePlayers.index(of: listCellIndexPlayers)
            if filteredListValuePlayersIndex != nil {
                //print("filteredListValuePlayersIndex: " + String(describing: filteredListValuePlayersIndex))
                let filteredListValuePlayersIndexPath = IndexPath(row: filteredListValuePlayersIndex!, section: 0)
                self.tableView.selectRow(at: filteredListValuePlayersIndexPath, animated: false, scrollPosition: .none)
            }
        }
        //print("selectedRowsPlayer: ")
        //print(selectedRowsPlayer)
        reloadRowValuePlayer()
    }
    ////////////////////////////
    func storeSelectionsPlayer() {
        //print("storeSelectionsPlayer()")
        //print("selectedRowsPlayer: ")
        //print(selectedRowsPlayer)
        tapPlayer.removeTarget(self, action: #selector(handleTapPlayer))
        var cellIndexPath: IndexPath
        //print("filteredListValuePlayers: ")
        //print(filteredListValuePlayers)
        if filteredListValuePlayers.count > 0 {
            for index in 0...filteredListValuePlayers.count - 1 {
                cellIndexPath = IndexPath(row: index, section: 0)
                //let checkedOption = filteredListValuePlayers[cellIndexPath.row]
                //print("Checked option: ")
                //print(checkedOption)
                //print(self.tableView.cellForRow(at: cellIndexPath)?.isSelected ?? false)
                if self.tableView.cellForRow(at: cellIndexPath)?.accessoryType == .checkmark {
                    if selectedRowsPlayer.contains(formListCellsPlayer[filteredListValuePlayers[cellIndexPath.row]]!) {
                        //print("Cell already exists in selection array")
                    } else {
                        selectedRowsPlayer.append(formListCellsPlayer[filteredListValuePlayers[cellIndexPath.row]]!)
                    }
                } else {
                    //print("Cell does not yet exist in selection array.")
                }
            }
        }
        
        selectedCellsPlayer.removeAll()
        
        switch (tagTextPlayer) {
        
        case ("PLAYER"):
            if selectedRowsPlayer == [] {
                selectedRowsPlayer = []
            } else {
                selectedRowsPlayer = [selectedRowsPlayer.last!]
            }
            for dictionaryValue in selectedRowsPlayer {
                for dictionaryKey in formListCellsPlayer.allKeys(forValue: dictionaryValue) {
                    if selectedCellsPlayer.contains(dictionaryKey) {
                        print(dictionaryKey + " dictionaryKey already exists in selectedCellsPlayer")
                    } else {
                        selectedCellsPlayer.append(dictionaryKey)
                    }
                }
            }
            playerListValuePlayer = selectedCellsPlayer
            playerOperatorValuePlayer = "="
            playerOperatorTextPlayer = " IS "
            formListValuePlayer = playerListValuePlayer
            formOperatorValuePlayer = playerOperatorValuePlayer
            formOperatorTextPlayer = playerOperatorTextPlayer
            if formListValuePlayer == ["-10000"] || formListValuePlayer == [] {
                listValuePlayer = formOperatorTextPlayer + "ANY"
            } else {
                listValuePlayer = formOperatorTextPlayer + formListValuePlayer.sorted().joined(separator: ", ")
            }
            
        case ("PLAYER TEAM"):
            for dictionaryValue in selectedRowsPlayer {
                for dictionaryKey in formListCellsPlayer.allKeys(forValue: dictionaryValue) {
                    if selectedCellsPlayer.contains(dictionaryKey) {
                        print(dictionaryKey + " dictionaryKey already exists in selectedCellsPlayer")
                    } else {
                        selectedCellsPlayer.append(dictionaryKey)
                    }
                }
            }
            team1ListValuePlayer = selectedCellsPlayer
            team1OperatorValuePlayer = selectedOperatorValuePlayerTeam
            team1OperatorTextPlayer = " IS "
            formListValuePlayer = team1ListValuePlayer
            formOperatorValuePlayer = team1OperatorValuePlayer
            formOperatorTextPlayer = team1OperatorTextPlayer
            listValuePlayer = formOperatorTextPlayer + formListValuePlayer.sorted().joined(separator: ", ")
            if formListValuePlayer == ["-10000"] || formListValuePlayer == [] {
                listValuePlayer = formOperatorTextPlayer + "ANY TEAM"
            } else {
                listValuePlayer = formOperatorTextPlayer + "THE " + formListValuePlayer.joined(separator: ", ")
            }
        case ("OPPONENT"):
            selectedOperatorValuePlayerOpponent = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)!
            switch(selectedOperatorValuePlayerOpponent) {
            case "=":
                team2OperatorTextPlayer = " IS "
            case "≠":
                team2OperatorTextPlayer = " IS NOT "
            default:
                team2OperatorTextPlayer = " IS "
            }
            for dictionaryValue in selectedRowsPlayer {
                for dictionaryKey in formListCellsPlayer.allKeys(forValue: dictionaryValue) {
                    if selectedCellsPlayer.contains(dictionaryKey) {
                        print(dictionaryKey + " dictionaryKey already exists in selectedCellsPlayer")
                    } else {
                        selectedCellsPlayer.append(dictionaryKey)
                    }
                }
            }
            team2ListValuePlayer = selectedCellsPlayer
            team2OperatorValuePlayer = selectedOperatorValuePlayerOpponent
            //team2OperatorTextPlayer = operatorText
            formListValuePlayer = team2ListValuePlayer
            formOperatorValuePlayer = team2OperatorValuePlayer
            formOperatorTextPlayer = team2OperatorTextPlayer
            if formListValuePlayer == ["-10000"] || formListValuePlayer == [] {
                if selectedOperatorValuePlayerOpponent == "=" {
                    listValuePlayer = " IS ANY TEAM"
                } else {
                    listValuePlayer = " IS NOT ANY TEAM"
                }
            } else {
                listValuePlayer = formOperatorTextPlayer + "THE " + formListValuePlayer.sorted().joined(separator: ", ")
            }
            
        case ("HOME TEAM"):
            for dictionaryValue in selectedRowsPlayer {
                for dictionaryKey in formListCellsPlayer.allKeys(forValue: dictionaryValue) {
                    if selectedCellsPlayer.contains(dictionaryKey) {
                        print(dictionaryKey + " dictionaryKey already exists in selectedCellsPlayer")
                    } else {
                        selectedCellsPlayer.append(dictionaryKey)
                    }
                }
            }
            homeTeamListValuePlayer = selectedCellsPlayer
            homeTeamOperatorValuePlayer = "="
            //operatorText = " IS "
            homeTeamOperatorTextPlayer = " IS "
            formListValuePlayer = homeTeamListValuePlayer
            formOperatorValuePlayer = homeTeamOperatorValuePlayer
            formOperatorTextPlayer = homeTeamOperatorTextPlayer
            if formListValuePlayer == ["-10000"] || formListValuePlayer == [] || formListValuePlayer.count == 3 {
                listValuePlayer = formOperatorTextPlayer + "ANY"
            } else {
                listValuePlayer = formOperatorTextPlayer + formListValuePlayer.sorted().joined(separator: ", ")
            }
        case ("FAVORITE"):
            for dictionaryValue in selectedRowsPlayer {
                for dictionaryKey in formListCellsPlayer.allKeys(forValue: dictionaryValue) {
                    if selectedCellsPlayer.contains(dictionaryKey) {
                        print(dictionaryKey + " dictionaryKey already exists in selectedCellsPlayer")
                    } else {
                        selectedCellsPlayer.append(dictionaryKey)
                    }
                }
            }
            favoriteListValuePlayer = selectedCellsPlayer
            favoriteOperatorValuePlayer = "="
            favoriteOperatorTextPlayer = " IS "
            formListValuePlayer = favoriteListValuePlayer
            formOperatorValuePlayer = favoriteOperatorValuePlayer
            formOperatorTextPlayer = favoriteOperatorTextPlayer
            if formListValuePlayer == ["-10000"] || formListValuePlayer == [] || formListValuePlayer.count == 3 {
                listValuePlayer = formOperatorTextPlayer + "ANY"
            } else {
                listValuePlayer = formOperatorTextPlayer + formListValuePlayer.sorted().joined(separator: ", ")
            }
        case ("PLAYER TEAM: PLAYERS"):
            selectedOperatorValuePlayerTeam = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)!
            switch(selectedOperatorValuePlayerTeam) {
            case "=":
                playerOperatorTextPlayer = " INCLUDE "
            case "≠":
                playerOperatorTextPlayer = " DO NOT INCLUDE "
            default:
                playerOperatorTextPlayer = " INCLUDE "
            }
            for dictionaryValue in selectedRowsPlayer {
                for dictionaryKey in formListCellsPlayer.allKeys(forValue: dictionaryValue) {
                    if selectedCellsPlayer.contains(dictionaryKey) {
                        print(dictionaryKey + " dictionaryKey already exists in selectedCellsPlayer")
                    } else {
                        selectedCellsPlayer.append(dictionaryKey)
                    }
                }
            }
            playerListValuePlayer = selectedCellsPlayer
            playerOperatorValuePlayer = selectedOperatorValuePlayerTeam
            formListValuePlayer = playerListValuePlayer
            formOperatorValuePlayer = playerOperatorValuePlayer
            formOperatorTextPlayer = playerOperatorTextPlayer
            if formListValuePlayer == ["-10000"] || formListValuePlayer == [] {
                listValuePlayer = formOperatorTextPlayer + "ANY"
            } else {
                listValuePlayer = formOperatorTextPlayer + formListValuePlayer.sorted().joined(separator: ", ")
            }
        case ("OPPONENT: PLAYERS"):
            selectedOperatorValuePlayerOpponent = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)!
            switch(selectedOperatorValuePlayerOpponent) {
            case "=":
                playerOpponentOperatorTextPlayer = " INCLUDE "
            case "≠":
                playerOpponentOperatorTextPlayer = " DO NOT INCLUDE "
            default:
                playerOpponentOperatorTextPlayer = " INCLUDE "
            }
            for dictionaryValue in selectedRowsPlayer {
                for dictionaryKey in formListCellsPlayer.allKeys(forValue: dictionaryValue) {
                    if selectedCellsPlayer.contains(dictionaryKey) {
                        print(dictionaryKey + " dictionaryKey already exists in selectedCellsPlayer")
                    } else {
                        selectedCellsPlayer.append(dictionaryKey)
                    }
                }
            }
            playerOpponentListValuePlayer = selectedCellsPlayer
            playerOpponentOperatorValuePlayer = selectedOperatorValuePlayerOpponent
            formListValuePlayer = playerOpponentListValuePlayer
            formOperatorValuePlayer = playerOpponentOperatorValuePlayer
            formOperatorTextPlayer = playerOpponentOperatorTextPlayer
            if formListValuePlayer == ["-10000"] || formListValuePlayer == [] {
                listValuePlayer = formOperatorTextPlayer + "ANY"
            } else {
                listValuePlayer = formOperatorTextPlayer + formListValuePlayer.sorted().joined(separator: ", ")
            }
        case ("DAY"):
            for dictionaryValue in selectedRowsPlayer {
                for dictionaryKey in formListCellsPlayer.allKeys(forValue: dictionaryValue) {
                    if selectedCellsPlayer.contains(dictionaryKey) {
                        print(dictionaryKey + " dictionaryKey already exists in selectedCellsPlayer")
                    } else {
                        selectedCellsPlayer.append(dictionaryKey)
                    }
                }
            }
            dayListValuePlayer = selectedCellsPlayer
            dayOperatorValuePlayer = "="
            dayOperatorTextPlayer = " IS "
            formListValuePlayer = dayListValuePlayer
            formOperatorValuePlayer = dayOperatorValuePlayer
            formOperatorTextPlayer = dayOperatorTextPlayer
            if formListValuePlayer == ["-10000"] || formListValuePlayer == [] {
                listValuePlayer = formOperatorTextPlayer + "ANY"
            } else {
                listValuePlayer = formOperatorTextPlayer + formListValuePlayer.joined(separator: ", ")
            }
        case ("STADIUM"):
            for dictionaryValue in selectedRowsPlayer {
                for dictionaryKey in formListCellsPlayer.allKeys(forValue: dictionaryValue) {
                    if selectedCellsPlayer.contains(dictionaryKey) {
                        print(dictionaryKey + " dictionaryKey already exists in selectedCellsPlayer")
                    } else {
                        selectedCellsPlayer.append(dictionaryKey)
                    }
                }
            }
            stadiumListValuePlayer = selectedCellsPlayer
            stadiumOperatorValuePlayer = "="
            stadiumOperatorTextPlayer = " IS "
            formListValuePlayer = stadiumListValuePlayer
            formOperatorValuePlayer = stadiumOperatorValuePlayer
            formOperatorTextPlayer = stadiumOperatorTextPlayer
            if formListValuePlayer == ["-10000"] || formListValuePlayer == [] || formListValuePlayer.count == 3 {
                listValuePlayer = formOperatorTextPlayer + "ANY"
            } else {
                listValuePlayer = formOperatorTextPlayer + formListValuePlayer.sorted().joined(separator: ", ")
            }
        case ("SURFACE"):
            for dictionaryValue in selectedRowsPlayer {
                for dictionaryKey in formListCellsPlayer.allKeys(forValue: dictionaryValue) {
                    if selectedCellsPlayer.contains(dictionaryKey) {
                        print(dictionaryKey + " dictionaryKey already exists in selectedCellsPlayer")
                    } else {
                        selectedCellsPlayer.append(dictionaryKey)
                    }
                }
            }
            surfaceListValuePlayer = selectedCellsPlayer
            surfaceOperatorValuePlayer = "="
            surfaceOperatorTextPlayer = " IS "
            formListValuePlayer = surfaceListValuePlayer
            formOperatorValuePlayer = surfaceOperatorValuePlayer
            formOperatorTextPlayer = surfaceOperatorTextPlayer
            if formListValuePlayer == ["-10000"] || formListValuePlayer == [] || formListValuePlayer.count == 2 {
                listValuePlayer = formOperatorTextPlayer + "ANY"
            } else {
                listValuePlayer = formOperatorTextPlayer + formListValuePlayer.sorted().joined(separator: ", ")
            }
            
        default:
            //operatorText = " IS "
            formListValuePlayer = team1ListValuePlayer
            formOperatorValuePlayer = team1OperatorValuePlayer
            formOperatorTextPlayer = team1OperatorTextPlayer
            if formListValuePlayer == ["-10000"] || formListValuePlayer == [] {
                listValuePlayer = formOperatorTextPlayer + "ANY"
            } else {
                listValuePlayer = formOperatorTextPlayer + "THE " + formListValuePlayer.sorted().joined(separator: ", ")
            }
        }
        buttonTextPlayer = headerLabelPlayer + "\0" + listValuePlayer
        if buttonTextPlayer.count > 50 {
            let lineBreakIndex = buttonTextPlayer.indexDistance(of: char)
            buttonTextPlayerMutableString = NSMutableAttributedString(string: buttonTextPlayer, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonTextPlayer.count))
            buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
            buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.selected)
        } else if buttonTextPlayer.count > 40 {
            let lineBreakIndex = buttonTextPlayer.indexDistance(of: char)
            buttonTextPlayerMutableString = NSMutableAttributedString(string: buttonTextPlayer, attributes: [NSAttributedStringKey.font : twelveThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonTextPlayer.count))
            buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
            buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.selected)
        } else if buttonTextPlayer.count > 35 {
            let lineBreakIndex = buttonTextPlayer.indexDistance(of: char)
            buttonTextPlayerMutableString = NSMutableAttributedString(string: buttonTextPlayer, attributes: [NSAttributedStringKey.font : twelveAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonTextPlayer.count))
            buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.font, value: twelveAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
            buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.selected)
        } else {
            let lineBreakIndex = buttonTextPlayer.indexDistance(of: char)
            buttonTextPlayerMutableString = NSMutableAttributedString(string: buttonTextPlayer, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.3, range: NSRange(location: 0, length:lineBreakIndex!))
            buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
            buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.selected)
        }
        /*if formListValuePlayer.count > 2 {
         //print("more than 2x")
         let lineBreakIndex = buttonTextPlayer.indexDistance(of: char)
         buttonTextPlayerMutableString = NSMutableAttributedString(string: buttonTextPlayer, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
         buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:lineBreakIndex!))
         buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
         buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.normal)
         buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.selected)
         } else {
         if formListValuePlayer.count > 1 {
         //print("more than 1x")
         let lineBreakIndex = buttonTextPlayer.indexDistance(of: char)
         buttonTextPlayerMutableString = NSMutableAttributedString(string: buttonTextPlayer, attributes: [NSAttributedStringKey.font : twelveThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
         buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:lineBreakIndex!))
         buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
         buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.normal)
         buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.selected)
         } else {
         //print("1x")
         let lineBreakIndex = buttonTextPlayer.indexDistance(of: char)
         buttonTextPlayerMutableString = NSMutableAttributedString(string: buttonTextPlayer, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
         buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:lineBreakIndex!))
         buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
         buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.normal)
         buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.selected)
         }
         }*/
        
        //print("headerLabelPlayer/tagTextPlayer: \(headerLabelPlayer)")
        //print("listValuePlayer: \(listValuePlayer)")
        //print("formOperatorValuePlayer: " + formOperatorValuePlayer)
        //print("formOperatorTextPlayer: " + formOperatorTextPlayer)
        //print("formListValuePlayer.sorted().joined(): " + formListValuePlayer.sorted().joined(separator: ", "))
    }
    
    //////////////////////////////////////////////////////////////////
    /*@objc func closeButton() {
     floatButtonSearchableMultiSelectViewController.close()
     }*/
    //////////////////////////////////////////////////////////////////
    @objc func reloadRowValuePlayer() {
        print("reloadRowValuePlayer()")
        selectedCellsPlayer.removeAll()
        switch (tagTextPlayer) {
        case ("PLAYER"):
            for dictionaryValue in selectedRowsPlayer {
                for dictionaryKey in formListCellsPlayer.allKeys(forValue: dictionaryValue) {
                    if selectedCellsPlayer.contains(dictionaryKey) {
                        print(dictionaryKey + " dictionaryKey already exists in selectedCellsPlayer")
                    } else {
                        selectedCellsPlayer.append(dictionaryKey)
                    }
                }
            }
            playerListValuePlayer = selectedCellsPlayer
            playerOperatorValuePlayer = "="
            playerOperatorTextPlayer = " IS "
            formListValuePlayer = playerListValuePlayer
            formOperatorValuePlayer = playerOperatorValuePlayer
            formOperatorTextPlayer = playerOperatorTextPlayer
            if formListValuePlayer == ["-10000"] || formListValuePlayer == [] {
                listValuePlayer = formOperatorTextPlayer + "ANY"
            } else {
                listValuePlayer = formOperatorTextPlayer + formListValuePlayer.sorted().joined(separator: ", ")
            }
        case ("PLAYER TEAM"):
            if selectedRowsPlayer == [] {
                selectedRowsPlayer = []
            } else {
                selectedRowsPlayer = [selectedRowsPlayer.last!]
            }
            for dictionaryValue in selectedRowsPlayer {
                for dictionaryKey in formListCellsPlayer.allKeys(forValue: dictionaryValue) {
                    if selectedCellsPlayer.contains(dictionaryKey) {
                        print(dictionaryKey + " dictionaryKey already exists in selectedCellsPlayer")
                    } else {
                        selectedCellsPlayer.append(dictionaryKey)
                    }
                }
            }
            team1ListValuePlayer = selectedCellsPlayer
            team1OperatorValuePlayer = "="
            team1OperatorTextPlayer = " IS "
            formListValuePlayer = team1ListValuePlayer
            formOperatorValuePlayer = team1OperatorValuePlayer
            formOperatorTextPlayer = team1OperatorTextPlayer
            listValuePlayer = formOperatorTextPlayer + formListValuePlayer.sorted().joined(separator: ", ")
            if formListValuePlayer == ["-10000"] || formListValuePlayer == [] {
                listValuePlayer = formOperatorTextPlayer + "ANY TEAM"
            } else {
                listValuePlayer = formOperatorTextPlayer + "THE " + formListValuePlayer.joined(separator: ", ")
            }
        case ("OPPONENT"):
            selectedOperatorValuePlayerOpponent = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)!
            switch(selectedOperatorValuePlayerOpponent) {
            case "=":
                team2OperatorTextPlayer = " IS "
            case "≠":
                team2OperatorTextPlayer = " IS NOT "
            default:
                team2OperatorTextPlayer = " IS "
            }
            for dictionaryValue in selectedRowsPlayer {
                for dictionaryKey in formListCellsPlayer.allKeys(forValue: dictionaryValue) {
                    if selectedCellsPlayer.contains(dictionaryKey) {
                        print(dictionaryKey + " dictionaryKey already exists in selectedCellsPlayer")
                    } else {
                        selectedCellsPlayer.append(dictionaryKey)
                    }
                }
            }
            team2ListValuePlayer = selectedCellsPlayer
            team2OperatorValuePlayer = selectedOperatorValuePlayerOpponent
            //team2OperatorTextPlayer = operatorText
            formListValuePlayer = team2ListValuePlayer
            formOperatorValuePlayer = team2OperatorValuePlayer
            formOperatorTextPlayer = team2OperatorTextPlayer
            if formListValuePlayer == ["-10000"] || formListValuePlayer == [] {
                if selectedOperatorValuePlayerOpponent == "=" {
                    listValuePlayer = " IS ANY TEAM"
                } else {
                    listValuePlayer = " IS NOT ANY TEAM"
                }
            } else {
                listValuePlayer = formOperatorTextPlayer + "THE " + formListValuePlayer.sorted().joined(separator: ", ")
            }
            
        case ("HOME TEAM"):
            for dictionaryValue in selectedRowsPlayer {
                for dictionaryKey in formListCellsPlayer.allKeys(forValue: dictionaryValue) {
                    if selectedCellsPlayer.contains(dictionaryKey) {
                        print(dictionaryKey + " dictionaryKey already exists in selectedCellsPlayer")
                    } else {
                        selectedCellsPlayer.append(dictionaryKey)
                    }
                }
            }
            homeTeamListValuePlayer = selectedCellsPlayer
            homeTeamOperatorValuePlayer = "="
            homeTeamOperatorTextPlayer = " IS "
            formListValuePlayer = homeTeamListValuePlayer
            formOperatorValuePlayer = homeTeamOperatorValuePlayer
            formOperatorTextPlayer = homeTeamOperatorTextPlayer
            if formListValuePlayer == ["-10000"] || formListValuePlayer == [] || formListValuePlayer.count == 3 {
                listValuePlayer = formOperatorTextPlayer + "ANY"
            } else {
                listValuePlayer = formOperatorTextPlayer + formListValuePlayer.sorted().joined(separator: ", ")
            }
        case ("FAVORITE"):
            for dictionaryValue in selectedRowsPlayer {
                for dictionaryKey in formListCellsPlayer.allKeys(forValue: dictionaryValue) {
                    if selectedCellsPlayer.contains(dictionaryKey) {
                        print(dictionaryKey + " dictionaryKey already exists in selectedCellsPlayer")
                    } else {
                        selectedCellsPlayer.append(dictionaryKey)
                    }
                }
            }
            favoriteListValuePlayer = selectedCellsPlayer
            favoriteOperatorValuePlayer = "="
            favoriteOperatorTextPlayer = " IS "
            formListValuePlayer = favoriteListValuePlayer
            formOperatorValuePlayer = favoriteOperatorValuePlayer
            formOperatorTextPlayer = favoriteOperatorTextPlayer
            if formListValuePlayer == ["-10000"] || formListValuePlayer == [] || formListValuePlayer.count == 3 {
                listValuePlayer = formOperatorTextPlayer + "ANY"
            } else {
                listValuePlayer = formOperatorTextPlayer + formListValuePlayer.sorted().joined(separator: ", ")
            }
        case ("PLAYER TEAM: PLAYERS"):
            selectedOperatorValuePlayerTeam = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)!
            switch(selectedOperatorValuePlayerTeam) {
            case "=":
                playerOperatorTextPlayer = " INCLUDE "
            case "≠":
                playerOperatorTextPlayer = " DO NOT INCLUDE "
            default:
                playerOperatorTextPlayer = " INCLUDE "
            }
            for dictionaryValue in selectedRowsPlayer {
                for dictionaryKey in formListCellsPlayer.allKeys(forValue: dictionaryValue) {
                    if selectedCellsPlayer.contains(dictionaryKey) {
                        print(dictionaryKey + " dictionaryKey already exists in selectedCellsPlayer")
                    } else {
                        selectedCellsPlayer.append(dictionaryKey)
                    }
                }
            }
            playerListValuePlayer = selectedCellsPlayer
            playerOperatorValuePlayer = selectedOperatorValuePlayerTeam
            formListValuePlayer = playerListValuePlayer
            formOperatorValuePlayer = playerOperatorValuePlayer
            formOperatorTextPlayer = playerOperatorTextPlayer
            if formListValuePlayer == ["-10000"] || formListValuePlayer == [] {
                listValuePlayer = formOperatorTextPlayer + "ANY"
            } else {
                listValuePlayer = formOperatorTextPlayer + formListValuePlayer.sorted().joined(separator: ", ")
            }
        case ("OPPONENT: PLAYERS"):
            selectedOperatorValuePlayerOpponent = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)!
            switch(selectedOperatorValuePlayerOpponent) {
            case "=":
                playerOpponentOperatorTextPlayer = " INCLUDE "
            case "≠":
                playerOpponentOperatorTextPlayer = " DO NOT INCLUDE "
            default:
                playerOpponentOperatorTextPlayer = " INCLUDE "
            }
            for dictionaryValue in selectedRowsPlayer {
                for dictionaryKey in formListCellsPlayer.allKeys(forValue: dictionaryValue) {
                    if selectedCellsPlayer.contains(dictionaryKey) {
                        print(dictionaryKey + " dictionaryKey already exists in selectedCellsPlayer")
                    } else {
                        selectedCellsPlayer.append(dictionaryKey)
                    }
                }
            }
            playerOpponentListValuePlayer = selectedCellsPlayer
            playerOpponentOperatorValuePlayer = selectedOperatorValuePlayerOpponent
            formListValuePlayer = playerOpponentListValuePlayer
            formOperatorValuePlayer = playerOpponentOperatorValuePlayer
            formOperatorTextPlayer = playerOpponentOperatorTextPlayer
            if formListValuePlayer == ["-10000"] || formListValuePlayer == [] {
                listValuePlayer = formOperatorTextPlayer + "ANY"
            } else {
                listValuePlayer = formOperatorTextPlayer + formListValuePlayer.sorted().joined(separator: ", ")
            }
        case ("DAY"):
            for dictionaryValue in selectedRowsPlayer {
                for dictionaryKey in formListCellsPlayer.allKeys(forValue: dictionaryValue) {
                    if selectedCellsPlayer.contains(dictionaryKey) {
                        print(dictionaryKey + " dictionaryKey already exists in selectedCellsPlayer")
                    } else {
                        selectedCellsPlayer.append(dictionaryKey)
                    }
                }
            }
            dayListValuePlayer = selectedCellsPlayer
            dayOperatorValuePlayer = "="
            dayOperatorTextPlayer = " IS "
            formListValuePlayer = dayListValuePlayer
            formOperatorValuePlayer = dayOperatorValuePlayer
            formOperatorTextPlayer = dayOperatorTextPlayer
            if formListValuePlayer == ["-10000"] || formListValuePlayer == [] {
                listValuePlayer = formOperatorTextPlayer + "ANY"
            } else {
                listValuePlayer = formOperatorTextPlayer + formListValuePlayer.joined(separator: ", ")
            }
        case ("STADIUM"):
            for dictionaryValue in selectedRowsPlayer {
                for dictionaryKey in formListCellsPlayer.allKeys(forValue: dictionaryValue) {
                    if selectedCellsPlayer.contains(dictionaryKey) {
                        print(dictionaryKey + " dictionaryKey already exists in selectedCellsPlayer")
                    } else {
                        selectedCellsPlayer.append(dictionaryKey)
                    }
                }
            }
            stadiumListValuePlayer = selectedCellsPlayer
            stadiumOperatorValuePlayer = "="
            stadiumOperatorTextPlayer = " IS "
            formListValuePlayer = stadiumListValuePlayer
            formOperatorValuePlayer = stadiumOperatorValuePlayer
            formOperatorTextPlayer = stadiumOperatorTextPlayer
            if formListValuePlayer == ["-10000"] || formListValuePlayer == [] || formListValuePlayer.count == 3 {
                listValuePlayer = formOperatorTextPlayer + "ANY"
            } else {
                listValuePlayer = formOperatorTextPlayer + formListValuePlayer.sorted().joined(separator: ", ")
            }
        case ("SURFACE"):
            for dictionaryValue in selectedRowsPlayer {
                for dictionaryKey in formListCellsPlayer.allKeys(forValue: dictionaryValue) {
                    if selectedCellsPlayer.contains(dictionaryKey) {
                        print(dictionaryKey + " dictionaryKey already exists in selectedCellsPlayer")
                    } else {
                        selectedCellsPlayer.append(dictionaryKey)
                    }
                }
            }
            surfaceListValuePlayer = selectedCellsPlayer
            surfaceOperatorValuePlayer = "="
            surfaceOperatorTextPlayer = " IS "
            formListValuePlayer = surfaceListValuePlayer
            formOperatorValuePlayer = surfaceOperatorValuePlayer
            formOperatorTextPlayer = surfaceOperatorTextPlayer
            if formListValuePlayer == ["-10000"] || formListValuePlayer == [] || formListValuePlayer.count == 2 {
                listValuePlayer = formOperatorTextPlayer + "ANY"
            } else {
                listValuePlayer = formOperatorTextPlayer + formListValuePlayer.sorted().joined(separator: ", ")
            }
            
        default:
            //operatorText = " IS "
            formListValuePlayer = team1ListValuePlayer
            formOperatorValuePlayer = team1OperatorValuePlayer
            formOperatorTextPlayer = team1OperatorTextPlayer
            if formListValuePlayer == ["-10000"] || formListValuePlayer == [] {
                listValuePlayer = formOperatorTextPlayer + "ANY"
            } else {
                listValuePlayer = formOperatorTextPlayer + "THE " + formListValuePlayer.sorted().joined(separator: ", ")
            }
        }
        buttonTextPlayer = headerLabelPlayer + "\0" + listValuePlayer
        if buttonTextPlayer.count > 50 {
            let lineBreakIndex = buttonTextPlayer.indexDistance(of: char)
            buttonTextPlayerMutableString = NSMutableAttributedString(string: buttonTextPlayer, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonTextPlayer.count))
            buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
            buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.selected)
        } else if buttonTextPlayer.count > 40 {
            let lineBreakIndex = buttonTextPlayer.indexDistance(of: char)
            buttonTextPlayerMutableString = NSMutableAttributedString(string: buttonTextPlayer, attributes: [NSAttributedStringKey.font : twelveThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonTextPlayer.count))
            buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
            buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.selected)
        } else if buttonTextPlayer.count > 35 {
            let lineBreakIndex = buttonTextPlayer.indexDistance(of: char)
            buttonTextPlayerMutableString = NSMutableAttributedString(string: buttonTextPlayer, attributes: [NSAttributedStringKey.font : twelveAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonTextPlayer.count))
            buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.font, value: twelveAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
            buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.selected)
        } else {
            let lineBreakIndex = buttonTextPlayer.indexDistance(of: char)
            buttonTextPlayerMutableString = NSMutableAttributedString(string: buttonTextPlayer, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.3, range: NSRange(location: 0, length:lineBreakIndex!))
            buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
            buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.selected)
        }
        /*if formListValuePlayer.count > 2 {
         if headerLabelPlayer != "STADIUM" && headerLabelPlayer != "FAVORITE" && headerLabelPlayer != "SURFACE" && headerLabelPlayer != "HOME TEAM" {
         let lineBreakIndex = buttonTextPlayer.indexDistance(of: char)
         buttonTextPlayerMutableString = NSMutableAttributedString(string: buttonTextPlayer, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
         buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:lineBreakIndex!))
         buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
         buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.normal)
         buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.selected)
         } else {
         let lineBreakIndex = buttonTextPlayer.indexDistance(of: char)
         buttonTextPlayerMutableString = NSMutableAttributedString(string: buttonTextPlayer, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
         buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:lineBreakIndex!))
         buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
         buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.normal)
         buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.selected)
         }
         } else {
         if formListValuePlayer.count > 1 {
         let lineBreakIndex = buttonTextPlayer.indexDistance(of: char)
         buttonTextPlayerMutableString = NSMutableAttributedString(string: buttonTextPlayer, attributes: [NSAttributedStringKey.font : twelveThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
         buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:lineBreakIndex!))
         buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
         buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.normal)
         buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.selected)
         } else {
         let lineBreakIndex = buttonTextPlayer.indexDistance(of: char)
         buttonTextPlayerMutableString = NSMutableAttributedString(string: buttonTextPlayer, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
         buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:lineBreakIndex!))
         buttonTextPlayerMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
         buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.normal)
         buttonView?.setAttributedTitle(buttonTextPlayerMutableString, for: UIControlState.selected)
         }
         }*/
        
        //print("headerLabelPlayer/tagTextPlayer: \(headerLabelPlayer)")
        //print("listValuePlayer: \(listValuePlayer)")
        //print("formOperatorValuePlayer: " + formOperatorValuePlayer)
        //print("formOperatorTextPlayer: " + formOperatorTextPlayer)
        //print("formListValuePlayer.sorted().joined(): " + formListValuePlayer.sorted().joined(separator: ", "))
        //print("formListValuePlayer: \(formListValuePlayer)")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "playerSearchableMultiSelectNotification"), object: nil)
        
    }
    
    ///////////////////
    @available(iOS 8.0, *)
    func updateSearchResults(for searchController: UISearchController) {
        //print("updateSearchResults()")
        storeSelectionsPlayer()
        if !searchController.isActive {
            print("Search bar exited")
            playerSearchBarStatus = "INACTIVE"
            tapPlayer.addTarget(self, action: #selector(handleTapPlayer))
            print("playerSearchBarStatus: " + playerSearchBarStatus)
            playerSearchBarStatus = "INACTIVE"
        } else {
            playerSearchBarStatus = "ACTIVE"
        }
        if let searchText = searchBarControllerPlayer.searchBar.text {
            //print("Search bar active")
            //playerSearchBarStatus = "ACTIVE"
            print("playerSearchBarStatus: " + playerSearchBarStatus)
            filteredListValuePlayers = searchText.isEmpty ? listValuePlayers : listValuePlayers.filter { (dataString: String) -> Bool in
                return dataString.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            }
            self.tableView.reloadData()
            reselectSelectionsPlayer()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.backgroundColor = darkGreyColor
        self.view.backgroundColor = darkGreyColor
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.toolbar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //print("viewWillDisappear")
        //storeSelectionsPlayer()
        //reselectSelectionsPlayer()
        super.viewWillDisappear(animated)
        self.tableView.backgroundColor = darkGreyColor
        self.view.backgroundColor = darkGreyColor
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.toolbar.isHidden = true
    }
    
    @objc func handleTapPlayer() {
        //print("tapPlayerped")
        let mainQueue = DispatchQueue.main
        let deadline = DispatchTime.now() + .milliseconds(5)
        mainQueue.asyncAfter(deadline: deadline) {
            switch (self.tableView.indexPathsForSelectedRows.map({$0.map{$0.row}})) {
            case nil:
                self.selectedRowsPlayer = []
            default:
                self.selectedRowsPlayer = self.tableView.indexPathsForSelectedRows.map({$0.map{$0.row}})!
            }
            //print(self.selectedRowsPlayer)
            self.reloadRowValuePlayer()
        }
    }
    
    @objc func labelTappedPlayer() {
        //print("labelTappedPlayer()")
        if formListValuePlayer == ["-10000"] || formListValuePlayer == [] {
            switch(tagTextPlayer) {
            case "PLAYER":
                messageStringPlayer = "ANY"
                if playerOperatorValuePlayer == "-10000" {
                    titleStringPlayer = tagTextPlayer + " ="
                } else {
                    titleStringPlayer = tagTextPlayer + " " + playerOperatorValuePlayer
                }
            case "PLAYER TEAM":
                messageStringPlayer = "ANY TEAM"
                if team1OperatorValuePlayer == "-10000" {
                    titleStringPlayer = tagTextPlayer + " ="
                } else {
                    titleStringPlayer = tagTextPlayer + " " + team1OperatorValuePlayer
                }
            case "OPPONENT":
                messageStringPlayer = "ANY TEAM"
                if team2OperatorValuePlayer == "-10000" {
                    titleStringPlayer = tagTextPlayer + " ="
                } else {
                    titleStringPlayer = tagTextPlayer + " " + team2OperatorValuePlayer
                }
            case "HOME TEAM":
                messageStringPlayer = "ANY"
                if homeTeamOperatorValuePlayer == "-10000" {
                    titleStringPlayer = tagTextPlayer + " ="
                } else {
                    titleStringPlayer = tagTextPlayer + " " + homeTeamOperatorValuePlayer
                }
            case "FAVORITE":
                messageStringPlayer = "ANY"
                if favoriteOperatorValuePlayer == "-10000" {
                    titleStringPlayer = tagTextPlayer + " ="
                } else {
                    titleStringPlayer = tagTextPlayer + " " + favoriteOperatorValuePlayer
                }
            case "DAY":
                messageStringPlayer = "ANY"
                if dayOperatorValuePlayer == "-10000" {
                    titleStringPlayer = tagTextPlayer + " ="
                } else {
                    titleStringPlayer = tagTextPlayer + " " + dayOperatorValuePlayer
                }
            case "STADIUM":
                messageStringPlayer = "ANY"
                if stadiumOperatorValuePlayer == "-10000" {
                    titleStringPlayer = tagTextPlayer + " ="
                } else {
                    titleStringPlayer = tagTextPlayer + " " + stadiumOperatorValuePlayer
                }
            case "SURFACE":
                messageStringPlayer = "ANY"
                if surfaceOperatorValuePlayer == "-10000" {
                    titleStringPlayer = tagTextPlayer + " ="
                } else {
                    titleStringPlayer = tagTextPlayer + " " + surfaceOperatorValuePlayer
                }
            default:
                messageStringPlayer = "ANY"
                titleStringPlayer = tagTextPlayer + " " + "="
            }
        } else {
            messageStringPlayer = formListValuePlayer.sorted().joined(separator: "\n")
            switch(tagTextPlayer) {
            case "PLAYER":
                if playerOperatorValuePlayer == "-10000" {
                    titleStringPlayer = tagTextPlayer + " ="
                } else {
                    titleStringPlayer = tagTextPlayer + " " + playerOperatorValuePlayer
                }
            case "PLAYER TEAM":
                if team1OperatorValuePlayer == "-10000" {
                    titleStringPlayer = tagTextPlayer + " ="
                } else {
                    titleStringPlayer = tagTextPlayer + " " + team1OperatorValuePlayer
                }
            case "OPPONENT":
                if team2OperatorValuePlayer == "-10000" {
                    titleStringPlayer = tagTextPlayer + " ="
                } else {
                    titleStringPlayer = tagTextPlayer + " " + team2OperatorValuePlayer
                }
            case "HOME TEAM":
                if homeTeamOperatorValuePlayer == "-10000" {
                    titleStringPlayer = tagTextPlayer + " ="
                } else {
                    titleStringPlayer = tagTextPlayer + " " + homeTeamOperatorValuePlayer
                }
            case "FAVORITE":
                if favoriteOperatorValuePlayer == "-10000" {
                    titleStringPlayer = tagTextPlayer + " ="
                } else {
                    titleStringPlayer = tagTextPlayer + " " + favoriteOperatorValuePlayer
                }
            case "PLAYER TEAM: PLAYERS":
                if playerOperatorValuePlayer == "-10000" {
                    titleStringPlayer = tagTextPlayer + " ="
                } else {
                    titleStringPlayer = tagTextPlayer + " " + playerOperatorValuePlayer
                }
            case "OPPONENT: PLAYERS":
                if playerOpponentOperatorValuePlayer == "-10000" {
                    titleStringPlayer = tagTextPlayer + " ="
                } else {
                    titleStringPlayer = tagTextPlayer + " " + playerOpponentOperatorValuePlayer
                }
            case "DAY":
                if dayOperatorValuePlayer == "-10000" {
                    titleStringPlayer = tagTextPlayer + " ="
                } else {
                    titleStringPlayer = tagTextPlayer + " " + dayOperatorValuePlayer
                }
            case "STADIUM":
                if stadiumOperatorValuePlayer == "-10000" {
                    titleStringPlayer = tagTextPlayer + " ="
                } else {
                    titleStringPlayer = tagTextPlayer + " " + stadiumOperatorValuePlayer
                }
            case "SURFACE":
                if surfaceOperatorValuePlayer == "-10000" {
                    titleStringPlayer = tagTextPlayer + " ="
                } else {
                    titleStringPlayer = tagTextPlayer + " " + surfaceOperatorValuePlayer
                }
            default:
                titleStringPlayer = tagTextPlayer + " " + "="
            }
        }
        self.alertControllerPlayer.title = titleStringPlayer
        self.alertControllerPlayer.message = messageStringPlayer
        self.alertControllerPlayer.buttonTitleColor = orangeColor
        self.alertControllerPlayer.buttonFont = fifteenBlackRoboto
        self.alertControllerPlayer.view.backgroundColor = lightGreyColor.withAlphaComponent(0.8)
        self.alertControllerPlayer.titleFont = sixteenBoldRobotoCondensed
        self.alertControllerPlayer.messageFont = fifteenRegularRobotoCondensed
        self.alertControllerPlayer.titleColor = darkGreyColor
        self.alertControllerPlayer.messageColor = dashboardGreyColor
        self.present(alertControllerPlayer, animated: true) {
            //print("present(alertControllerPlayer()")
        }
    }
    
    @objc func clearMultiSelectSelections() {
        print("-------clearMultiSelectSelections() STARTED-------")
        clearMultiSelectIndicatorPlayer = tagTextPlayer
        selectedCellsPlayer.removeAll()
        selectedOperatorValuePlayerTeam = "="
        selectedOperatorValuePlayerOpponent = "="
        selectedOperatorValuePlayerTeam = "="
        selectedOperatorValuePlayerOpponent = "="
        switch (tagTextPlayer) {
        case "PLAYER":
            self.selectedRowsPlayer = []
            formListValuePlayer = ["-10000"]
            makeOriginalSelectionsPlayer()
            clearMultiSelectIndicatorPlayer = ""
            reloadRowValuePlayer()
        case "PLAYER TEAM":
            self.selectedRowsPlayer = []
            formListValuePlayer = ["-10000"]
            makeOriginalSelectionsPlayer()
            clearMultiSelectIndicatorPlayer = ""
            reloadRowValuePlayer()
        case "OPPONENT":
            self.selectedRowsPlayer = []
            team2OperatorTextPlayer = " IS "
            formListValuePlayer = ["-10000"]
            makeOriginalSelectionsPlayer()
            self.segmentedControl.selectedSegmentIndex = 0
            self.segmentedControl.sendActions(for: .valueChanged)
        case "HOME TEAM":
            self.selectedRowsPlayer = [0, 1, 2]
            formListValuePlayer = ["-10000"]
            makeOriginalSelectionsPlayer()
            clearMultiSelectIndicatorPlayer = ""
            reloadRowValuePlayer()
        case "FAVORITE":
            self.selectedRowsPlayer = [0, 1, 2]
            formListValuePlayer = ["-10000"]
            makeOriginalSelectionsPlayer()
            clearMultiSelectIndicatorPlayer = ""
            reloadRowValuePlayer()
        case "GAME NUMBER":
            self.selectedRowsPlayer = []
            formListValuePlayer = ["-10000"]
            makeOriginalSelectionsPlayer()
            clearMultiSelectIndicatorPlayer = ""
            reloadRowValuePlayer()
        case "PLAYER TEAM: PLAYERS":
            self.selectedRowsPlayer = []
            playerOperatorTextPlayer = " INCLUDE "
            formListValuePlayer = ["-10000"]
            makeOriginalSelectionsPlayer()
            clearMultiSelectIndicatorPlayer = ""
            self.segmentedControl.selectedSegmentIndex = 0
            self.segmentedControl.sendActions(for: .valueChanged)
        case "OPPONENT: PLAYERS":
            self.selectedRowsPlayer = []
            playerOpponentOperatorTextPlayer = " INCLUDE "
            formListValuePlayer = ["-10000"]
            makeOriginalSelectionsPlayer()
            clearMultiSelectIndicatorPlayer = ""
            self.segmentedControl.selectedSegmentIndex = 0
            self.segmentedControl.sendActions(for: .valueChanged)
        case "STADIUM":
            self.selectedRowsPlayer = [0, 1, 2]
            formListValuePlayer = ["-10000"]
            makeOriginalSelectionsPlayer()
            clearMultiSelectIndicatorPlayer = ""
            reloadRowValuePlayer()
        case "SURFACE":
            self.selectedRowsPlayer = [0, 1]
            formListValuePlayer = ["-10000"]
            makeOriginalSelectionsPlayer()
            clearMultiSelectIndicatorPlayer = ""
            reloadRowValuePlayer()
        default:
            self.selectedRowsPlayer = []
            formListValuePlayer = ["-10000"]
            makeOriginalSelectionsPlayer()
            clearMultiSelectIndicatorPlayer = ""
            reloadRowValuePlayer()
        }
        print("-------clearMultiSelectSelections() FINISHED-------")
    }
}

