//
//  SearchableMultiSelectViewController.swift
//  TrendPlay
//
//  Created by Chelsea Smith on 9/2/17.
//  Copyright © 2017 Trending Productions LLC. All rights reserved.
//

import UIKit
import MaterialComponents
import Floaty

class SearchableMultiSelectViewController: UIViewController, UITableViewDataSource, UISearchResultsUpdating {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var buttonView: UIButton!
    
    var alertTitle: String = ""
    var buttonText: String = ""
    var buttonTextMutableString = NSMutableAttributedString()
    let char: Character = "\0"
    let spacing = CGFloat(-0.6)
    var searchBarController: UISearchController!
    let valuesView = UIView()
    let lineView = UIView()
    let doneButtonImage = UIImage(named: "doneEmpty")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
    let topView = UIView()
    let operators = ["=", "≠", "<", ">", "< >"]
    var headerLabel: String = ""
    var listValues = ["-10000"]
    var filteredListValues: [String]!
    var formListCells: [String : Int] = ["-10000" : -10000]
    var selectedCells: [String] = []
    var selectedCellsMapped: [Int] = []
    var selectedRows: [Int] = []
    var queryEnglishString: String = ""
    var tap: UIGestureRecognizer!
    var multipleSelectionBoolean: Bool!
    var messageString: String = ""
    var titleString: String = ""
    var alertController = MDCAlertController()
    var raisedButton = MDCRaisedButton()
    var team1ButtonLabel: String = ""
    var team2ButtonLabel: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let floatActionButton = Floaty()
        let floatyItem = FloatyItem()
        let action = MDCAlertAction(title:"OK") { (action) in print("OK") }
        alertController = MDCAlertController(title: titleString, message: messageString)
        alertController.addAction(action)
        alertController.buttonTitleColor = orangeColor
        alertController.buttonFont = fifteenBlackRoboto
        alertController.view.backgroundColor = lightGreyColor.withAlphaComponent(0.8)
        alertController.titleFont = sixteenBoldRobotoCondensed
        alertController.messageFont = fifteenRegularRobotoCondensed
        alertController.titleColor = darkGreyColor
        alertController.messageColor = dashboardGreyColor
        
        raisedButton.setElevation(ShadowElevation(rawValue: 2), for: .normal)
        raisedButton.setTitleColor(silverColor, for: .normal)
        raisedButton.setTitleColor(silverColor, for: .selected)
        raisedButton.addTarget(self, action: #selector(SearchableMultiSelectViewController.labelTapped), for: .touchUpInside)
        buttonView = raisedButton
        
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
        
        switch (tagText) {
        case "TEAM":
            titleString = tagText
            headerLabel = tagText
            listValues = team1Values
            formListValue = team1ListValue
            multipleSelectionBool = team1MultipleSelectionBool
            formOperatorValue = team1OperatorValue
            formOperatorText = team1OperatorText
            formListCells = team1ListCells
            segmentedControl.isHidden = true
        case "OPPONENT":
            titleString = tagText
            headerLabel = tagText
            listValues = team2Values
            formListValue = team2ListValue
            multipleSelectionBool = team2MultipleSelectionBool
            formOperatorValue = team2OperatorValue
            formOperatorText = team2OperatorText
            formListCells = team2ListCells
            segmentedControl.isHidden = false
        case "HOME TEAM":
            titleString = tagText
            headerLabel = tagText
            listValues = homeTeamValues
            formListValue = homeTeamListValue
            multipleSelectionBool = homeTeamMultipleSelectionBool
            formOperatorValue = homeTeamOperatorValue
            formOperatorText = homeTeamOperatorText
            formListCells = homeTeamListCells
            segmentedControl.isHidden = true
        case "FAVORITE":
            titleString = tagText
            headerLabel = tagText
            listValues = favoriteValues
            formListValue = favoriteListValue
            multipleSelectionBool = favoriteMultipleSelectionBool
            formOperatorValue = favoriteOperatorValue
            formOperatorText = favoriteOperatorText
            formListCells = favoriteListCells
            segmentedControl.isHidden = true
        case "TEAM: PLAYERS":
            titleString = tagText
            var rowTitle = tagText
            var rowTitleTextArray = rowTitle.components(separatedBy: ": ")
            rowTitle = rowTitleTextArray[1]
            if team1ListValue == ["-10000"] || team1ListValue == [] {
                headerLabel = tagText
            } else {
                if team1ListValue[0] == "NEW YORK GIANTS" {
                    team1ButtonLabel = "NEW YORK (G)"
                } else if team1ListValue[0] == "NEW YORK JETS" {
                    team1ButtonLabel = "NEW YORK (J)"
                } else if team1ListValue[0] == "LOS ANGELES CHARGERS" {
                    team1ButtonLabel = "LOS ANGELES (C)"
                } else if team1ListValue[0] == "LOS ANGELES RAMS" {
                    team1ButtonLabel = "LOS ANGELES (R)"
                } else {
                    team1ButtonLabel = team1ListValue[0]
                    var team1TextArray = team1ButtonLabel.components(separatedBy: " ")
                    let team1TextArrayLength = team1TextArray.count
                    team1TextArray.remove(at: team1TextArrayLength - 1)
                    team1ButtonLabel = team1TextArray.joined(separator: " ")
                }
                headerLabel = team1ButtonLabel + ": " + rowTitle
            }
            listValues = playerValues
            formListValue = playerListValue
            multipleSelectionBool = playerMultipleSelectionBool
            formOperatorValue = playerOperatorValue
            formOperatorText = playerOperatorText
            formListCells = playerListCells
            segmentedControl.isHidden = false
        case "OPPONENT: PLAYERS":
            titleString = tagText
            var rowTitle = tagText
            var rowTitleTextArray = rowTitle.components(separatedBy: ": ")
            rowTitle = rowTitleTextArray[1]
            if team2ListValue == ["-10000"] || team2ListValue == [] {
                headerLabel = tagText
            } else {
                if team2ListValue[0] == "NEW YORK GIANTS" {
                    team2ButtonLabel = "NEW YORK (G)"
                } else if team2ListValue[0] == "NEW YORK JETS" {
                    team2ButtonLabel = "NEW YORK (J)"
                } else if team2ListValue[0] == "LOS ANGELES CHARGERS" {
                    team2ButtonLabel = "LOS ANGELES (C)"
                } else if team2ListValue[0] == "LOS ANGELES RAMS" {
                    team2ButtonLabel = "LOS ANGELES (R)"
                } else {
                    team2ButtonLabel = team2ListValue[0]
                    var team2TextArray = team2ButtonLabel.components(separatedBy: " ")
                    let team2TextArrayLength = team2TextArray.count
                    team2TextArray.remove(at: team2TextArrayLength - 1)
                    team2ButtonLabel = team2TextArray.joined(separator: " ")
                }
                headerLabel = team2ButtonLabel + ": " + rowTitle
            }
            listValues = playerOpponentValues
            formListValue = playerOpponentListValue
            multipleSelectionBool = playerOpponentMultipleSelectionBool
            formOperatorValue = playerOpponentOperatorValue
            formOperatorText = playerOpponentOperatorText
            formListCells = playerOpponentListCells
            segmentedControl.isHidden = false
        case "DAY":
            titleString = tagText
            headerLabel = tagText
            listValues = dayValues
            formListValue = dayListValue
            multipleSelectionBool = dayMultipleSelectionBool
            formOperatorValue = dayOperatorValue
            formOperatorText = dayOperatorText
            formListCells = dayListCells
            segmentedControl.isHidden = true
        case "STADIUM":
            titleString = tagText
            headerLabel = tagText
            listValues = stadiumValues
            formListValue = stadiumListValue
            multipleSelectionBool = stadiumMultipleSelectionBool
            formOperatorValue = stadiumOperatorValue
            formOperatorText = stadiumOperatorText
            formListCells = stadiumListCells
            segmentedControl.isHidden = true
        case "SURFACE":
            titleString = tagText
            headerLabel = tagText
            listValues = surfaceValues
            formListValue = surfaceListValue
            multipleSelectionBool = surfaceMultipleSelectionBool
            formOperatorValue = surfaceOperatorValue
            formOperatorText = surfaceOperatorText
            formListCells = surfaceListCells
            segmentedControl.isHidden = true
        default:
            titleString = tagText
            headerLabel = tagText
            listValues = team1Values
            formListValue = team1ListValue
            formOperatorValue = team1OperatorValue
            formOperatorText = team1OperatorText
            formListCells = team1ListCells
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
        switch(tagText) {
        case "TEAM":
            switch(selectedOperatorValueTeam) {
            case "=":
                segmentedControl.selectedSegmentIndex = 0
            case "≠":
                segmentedControl.selectedSegmentIndex = 1
            default:
                segmentedControl.selectedSegmentIndex = 0
            }
        case "OPPONENT":
            switch(selectedOperatorValueOpponent) {
            case "=":
                segmentedControl.selectedSegmentIndex = 0
            case "≠":
                segmentedControl.selectedSegmentIndex = 1
            default:
                segmentedControl.selectedSegmentIndex = 0
            }
        case "TEAM: PLAYERS":
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
        filteredListValues = listValues
        self.tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "TableCell")
        self.tableView.rowHeight = 34.0
        searchBarController = UISearchController(searchResultsController: nil)
        searchBarController.searchResultsUpdater = self as UISearchResultsUpdating
        searchBarController.dimsBackgroundDuringPresentation = false
        searchBarController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = searchBarController.searchBar
        searchBarController.searchBar.tintColor = lightGreyColor
        searchBarController.searchBar.barTintColor = darkGreyColor
        searchBarController.searchBar.autocapitalizationType = .allCharacters
        searchBarController.searchBar.backgroundColor = darkGreyColor
        if let searchBarTextField = searchBarController.searchBar.value(forKey: "_searchField") as? UITextField {
            searchBarTextField.font = thirteenRegularSFCompact!
            searchBarTextField.textColor = lightGreyColor
            searchBarTextField.backgroundColor = mediumGreyColor
            searchBarTextField.borderStyle = .roundedRect
            searchBarTextField.isOpaque = false
        }
        searchBarController.searchBar.barStyle = .default
        let cancelButtonAttributes = [
            NSAttributedStringKey.foregroundColor: lightGreyColor,
            NSAttributedStringKey.font: thirteenRegularSFCompact!,
        ]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(cancelButtonAttributes, for: .normal)
        searchBarController.searchBar.setValue(" DONE   ", forKey:"_cancelButtonText")
        definesPresentationContext = true
        //switch (formListValue.joined(separator: ", ")) {
        //print("viewDidLoad formListValue: ")
        //print(formListValue)
        switch (formListValue) {
        case (["-10000"]) :
            switch(tagText) {
            case "TEAM":
                buttonText = self.headerLabel + "\0" + " IS ANY TEAM"
                let lineBreakIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
                buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
                listValue = " IS ANY TEAM"
            case "OPPONENT":
                buttonText = self.headerLabel + "\0" + " IS ANY TEAM"
                let lineBreakIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
                buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
                listValue = " IS ANY TEAM"
            case "HOME TEAM":
                buttonText = self.headerLabel + "\0" + " IS ANY"
                let lineBreakIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
                buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
                listValue = " IS ANY"
                self.selectedRows = [0, 1, 2]
            case "FAVORITE":
                buttonText = self.headerLabel + "\0" + " IS ANY"
                let lineBreakIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
                buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
                listValue = " IS ANY"
                self.selectedRows = [0, 1, 2]
            case "TEAM: PLAYERS":
                buttonText = self.headerLabel + "\0" + " INCLUDE ANY"
                let lineBreakIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
                buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
                listValue = " INCLUDE ANY"
            case "OPPONENT: PLAYERS":
                buttonText = self.headerLabel + "\0" + " INCLUDE ANY"
                let lineBreakIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
                buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
                listValue = " INCLUDE ANY"
            case "DAY":
                buttonText = self.headerLabel + "\0" + " IS ANY"
                let lineBreakIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
                buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
                listValue = " IS ANY"
            case "STADIUM":
                buttonText = self.headerLabel + "\0" + " IS ANY"
                let lineBreakIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
                buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
                listValue = " IS ANY"
                self.selectedRows = [0, 1, 2]
            case "SURFACE":
                buttonText = self.headerLabel + "\0" + " IS ANY"
                let lineBreakIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
                buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
                listValue = " IS ANY"
                self.selectedRows = [0, 1]
            default:
                buttonText = self.headerLabel + "\0" + " IS ANY"
                let lineBreakIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
                listValue = " IS ANY"
            }
        case ([]):
            switch(tagText) {
            case "TEAM":
                buttonText = self.headerLabel + "\0" + " IS ANY TEAM"
                let lineBreakIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
                buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
                listValue = " IS ANY TEAM"
                //self.selectedRows = [5]
            case "OPPONENT":
                buttonText = self.headerLabel + "\0" + " IS ANY TEAM"
                let lineBreakIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
                buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
                listValue = " IS ANY TEAM"
            case "HOME TEAM":
                buttonText = self.headerLabel + "\0" + " IS ANY"
                let lineBreakIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
                buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
                listValue = " IS ANY"
                self.selectedRows = [0, 1, 2]
            case "FAVORITE":
                buttonText = self.headerLabel + "\0" + " IS ANY"
                let lineBreakIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
                buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
                listValue = " IS ANY"
                self.selectedRows = [0, 1, 2]
            case "TEAM: PLAYERS":
                buttonText = self.headerLabel + "\0" + " INCLUDE ANY"
                let lineBreakIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
                buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
                listValue = " INCLUDE ANY"
            case "OPPONENT: PLAYERS":
                buttonText = self.headerLabel + "\0" + " INCLUDE ANY"
                let lineBreakIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
                buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
                listValue = " INCLUDE ANY"
            case "DAY":
                buttonText = self.headerLabel + "\0" + " IS ANY"
                let lineBreakIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
                buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
                listValue = " IS ANY"
            case "STADIUM":
                buttonText = self.headerLabel + "\0" + " IS ANY"
                let lineBreakIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
                buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
                listValue = " IS ANY"
                self.selectedRows = [0, 1, 2]
            case "SURFACE":
                buttonText = self.headerLabel + "\0" + " IS ANY"
                let lineBreakIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
                buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
                listValue = " IS ANY"
                self.selectedRows = [0, 1]
            default:
                buttonText = self.headerLabel + "\0" + " IS ANY"
                let lineBreakIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
                buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
                listValue = " IS ANY"
            }
        case (["OUTDOORS", "DOME", "RETRACTABLE ROOF"]):
            buttonText = self.headerLabel + "\0" + " IS ANY"
            let lineBreakIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:lineBreakIndex!))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            listValue = " IS ANY"
            self.selectedRows = [0, 1, 2]
        default:
            switch(tagText) {
            case "TEAM":
                buttonText = self.headerLabel + "\0" + team1OperatorText + "THE " + formListValue.sorted().joined(separator: ", ")
                listValue = team1OperatorText + formListValue.sorted().joined(separator: ", ")
            case "OPPONENT":
                buttonText = self.headerLabel + "\0" + team2OperatorText + "THE " + formListValue.sorted().joined(separator: ", ")
                listValue = team2OperatorText + formListValue.sorted().joined(separator: ", ")
            case "TEAM: PLAYERS":
                buttonText = self.headerLabel + "\0" + playerOperatorText + formListValue.sorted().joined(separator: ", ")
                listValue = playerOperatorText + formListValue.sorted().joined(separator: ", ")
            case "OPPONENET: PLAYERS":
                buttonText = self.headerLabel + "\0" + playerOpponentOperatorText + formListValue.sorted().joined(separator: ", ")
                listValue = playerOpponentOperatorText + formListValue.sorted().joined(separator: ", ")
            default:
                buttonText = self.headerLabel + "\0" + " IS " + formListValue.sorted().joined(separator: ", ")
                listValue = " IS " + formListValue.sorted().joined(separator: ", ")
            }
            for formListValueKey in formListValue {
                if self.selectedRows.contains(formListCells[formListValueKey]!) {
                } else {
                    self.selectedRows.append(formListCells[formListValueKey]!)
                }
            }
            if buttonText.count > 50 {
                let lineBreakIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
                buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            } else if buttonText.count > 40 {
                let lineBreakIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
                buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            } else if buttonText.count > 35 {
                let lineBreakIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
                buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            } else {
                let lineBreakIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.3, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
                buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            }
        }
        tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tap.cancelsTouchesInView = false
        self.tableView!.addGestureRecognizer(tap)
        self.segmentedControl.addTarget(self, action: #selector(SearchableMultiSelectViewController.reloadRowValue), for: .valueChanged)
        topView.frame = CGRect(x: 0, y: -480, width: screenWidth, height: 480)
        topView.backgroundColor = darkGreyColor
        self.tableView.addSubview(topView)
        self.tableView.allowsMultipleSelection = multipleSelectionBool
        if self.selectedRows != [] {
            makeOriginalSelections()
        }
        searchBarController.loadViewIfNeeded()
    }
    
    deinit {
        searchBarController.loadViewIfNeeded()
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! CustomTableViewCell
        cell.isSelected = tableView.indexPathsForSelectedRows?.contains(indexPath) ?? false
        cell.textLabel?.text = filteredListValues[indexPath.row]
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
        //print("filteredListValues.count")
        //print(filteredListValues.count)
        return filteredListValues.count
    }
    
    func makeOriginalSelections() {
        print("makeOriginalSelections")
        let mainQueue = DispatchQueue.main
        let deadline = DispatchTime.now() + .milliseconds(1)
        mainQueue.asyncAfter(deadline: deadline) {
            //print("1 millisecond has passed")
            //print("makeOriginalSelections selectedRows: ")
            //print(self.selectedRows)
            self.tableView.reloadData()
            for listOptionsIndex in self.selectedRows {
                //print("listOptionsIndex: " + String(listOptionsIndex))
                let listCellIndexKeys = self.formListCells.allKeys(forValue: listOptionsIndex)
                //print("listCellIndexKeys: ")
                //print(listCellIndexKeys as Any)
                let listCellIndex = listCellIndexKeys[0]
                //print("listCellIndex: " + String(listCellIndex))
                let filteredListValuesIndex = self.filteredListValues.index(of: listCellIndex)
                if filteredListValuesIndex != nil {
                    //print("filteredListValuesIndex: " + String(describing: filteredListValuesIndex))
                    let filteredListValuesIndexPath = IndexPath(row: filteredListValuesIndex!, section: 0)
                    self.tableView.selectRow(at: filteredListValuesIndexPath, animated: false, scrollPosition: .none)
                }
            }
            //print("selectedRows: ")
            //print(self.selectedRows)
        }
    }
    
    func reselectSelections() {
        //print("reselectSelections()")
        for listOptionsIndex in selectedRows {
            //print("listOptionsIndex: " + String(listOptionsIndex))
            let listCellIndexKeys = formListCells.allKeys(forValue: listOptionsIndex)
            //print("listCellIndexKeys: ")
            //print(listCellIndexKeys as Any)
            let listCellIndex = listCellIndexKeys[0]
            //print("listCellIndex: " + String(listCellIndex))
            let filteredListValueIndex = self.filteredListValues.index(of: listCellIndex)
            if filteredListValueIndex != nil {
                let filteredListValueIndexPath = IndexPath(row: filteredListValueIndex!, section: 0)
                if self.tableView.cellForRow(at: filteredListValueIndexPath)?.accessoryType == .checkmark {
                    print("reselectSelections(): checkmark TRUE")
                    self.tableView.deselectRow(at: filteredListValueIndexPath, animated: false)
                    self.tableView.cellForRow(at: filteredListValueIndexPath)?.accessoryType = .none
                } else {
                    print("reselectSelections(): checkmark FALSE")
                    self.tableView.selectRow(at: filteredListValueIndexPath, animated: false, scrollPosition: .none)
                }
                
            }
        }
        //print("selectedRows: ")
        //print(selectedRows)
        reloadRowValue()
    }
////////////////////////////
    func storeSelections() {
        //print("storeSelections()")
        //print("selectedRows: ")
        //print(selectedRows)
        tap.removeTarget(self, action: #selector(handleTap))
        var cellIndexPath: IndexPath
        //print("filteredListValues: ")
        //print(filteredListValues)
        if filteredListValues.count > 0 {
            for index in 0...filteredListValues.count - 1 {
                cellIndexPath = IndexPath(row: index, section: 0)
                //let checkedOption = filteredListValues[cellIndexPath.row]
                //print("Checked option: ")
                //print(checkedOption)
                //print(self.tableView.cellForRow(at: cellIndexPath)?.isSelected ?? false)
                if self.tableView.cellForRow(at: cellIndexPath)?.accessoryType == .checkmark {
                    if selectedRows.contains(formListCells[filteredListValues[cellIndexPath.row]]!) {
                        //print("Cell already exists in selection array")
                    } else {
                        selectedRows.append(formListCells[filteredListValues[cellIndexPath.row]]!)
                    }
                } else {
                    //print("Cell does not yet exist in selection array.")
                }
            }
        }
        //print("selectedRows: ")
        //print(selectedRows)
        
        selectedCells.removeAll()
        
        switch (tagText) {
        case ("TEAM"):
            selectedOperatorValueTeam = "="
            //operatorText = " IS "
            if selectedRows == [] {
                selectedRows = []
            } else {
                selectedRows = [selectedRows.last!]
            }
            for dictionaryValue in selectedRows {
                for dictionaryKey in formListCells.allKeys(forValue: dictionaryValue) {
                    if selectedCells.contains(dictionaryKey) {
                        print(dictionaryKey + " dictionaryKey already exists in selectedCells")
                    } else {
                        selectedCells.append(dictionaryKey)
                    }
                }
            }
            team1ListValue = selectedCells
            team1OperatorValue = selectedOperatorValueTeam
            team1OperatorText = " IS "
            formListValue = team1ListValue
            formOperatorValue = team1OperatorValue
            formOperatorText = team1OperatorText
            listValue = formOperatorText + formListValue.sorted().joined(separator: ", ")
            if formListValue == ["-10000"] || formListValue == [] {
                listValue = formOperatorText + "ANY TEAM"
            } else {
                listValue = formOperatorText + "THE " + formListValue.joined(separator: ", ")
            }
        case ("OPPONENT"):
            selectedOperatorValueOpponent = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)!
            switch(selectedOperatorValueOpponent) {
            case "=":
                team2OperatorText = " IS "
            case "≠":
                team2OperatorText = " IS NOT "
            default:
                team2OperatorText = " IS "
            }
            for dictionaryValue in selectedRows {
                for dictionaryKey in formListCells.allKeys(forValue: dictionaryValue) {
                    if selectedCells.contains(dictionaryKey) {
                        print(dictionaryKey + " dictionaryKey already exists in selectedCells")
                    } else {
                        selectedCells.append(dictionaryKey)
                    }
                }
            }
            team2ListValue = selectedCells
            team2OperatorValue = selectedOperatorValueOpponent
            //team2OperatorText = operatorText
            formListValue = team2ListValue
            formOperatorValue = team2OperatorValue
            formOperatorText = team2OperatorText
            if formListValue == ["-10000"] || formListValue == [] {
                if selectedOperatorValueOpponent == "=" {
                    listValue = " IS ANY TEAM"
                } else {
                    listValue = " IS NOT ANY TEAM"
                }
            } else {
                listValue = formOperatorText + "THE " + formListValue.sorted().joined(separator: ", ")
            }
            
        case ("HOME TEAM"):
            for dictionaryValue in selectedRows {
                for dictionaryKey in formListCells.allKeys(forValue: dictionaryValue) {
                    if selectedCells.contains(dictionaryKey) {
                        print(dictionaryKey + " dictionaryKey already exists in selectedCells")
                    } else {
                        selectedCells.append(dictionaryKey)
                    }
                }
            }
            homeTeamListValue = selectedCells
            homeTeamOperatorValue = "="
            //operatorText = " IS "
            homeTeamOperatorText = " IS "
            formListValue = homeTeamListValue
            formOperatorValue = homeTeamOperatorValue
            formOperatorText = homeTeamOperatorText
            if formListValue == ["-10000"] || formListValue == [] || formListValue.count == 3 {
                listValue = formOperatorText + "ANY"
            } else {
                listValue = formOperatorText + formListValue.sorted().joined(separator: ", ")
            }
        case ("FAVORITE"):
            for dictionaryValue in selectedRows {
                for dictionaryKey in formListCells.allKeys(forValue: dictionaryValue) {
                    if selectedCells.contains(dictionaryKey) {
                        print(dictionaryKey + " dictionaryKey already exists in selectedCells")
                    } else {
                        selectedCells.append(dictionaryKey)
                    }
                }
            }
            favoriteListValue = selectedCells
            favoriteOperatorValue = "="
            favoriteOperatorText = " IS "
            formListValue = favoriteListValue
            formOperatorValue = favoriteOperatorValue
            formOperatorText = favoriteOperatorText
            if formListValue == ["-10000"] || formListValue == [] || formListValue.count == 3 {
                listValue = formOperatorText + "ANY"
            } else {
                listValue = formOperatorText + formListValue.sorted().joined(separator: ", ")
            }
        case ("TEAM: PLAYERS"):
            selectedOperatorValuePlayerTeam = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)!
            switch(selectedOperatorValuePlayerTeam) {
            case "=":
                playerOperatorText = " INCLUDE "
            case "≠":
                playerOperatorText = " DO NOT INCLUDE "
            default:
                playerOperatorText = " INCLUDE "
            }
            for dictionaryValue in selectedRows {
                for dictionaryKey in formListCells.allKeys(forValue: dictionaryValue) {
                    if selectedCells.contains(dictionaryKey) {
                        print(dictionaryKey + " dictionaryKey already exists in selectedCells")
                    } else {
                        selectedCells.append(dictionaryKey)
                    }
                }
            }
            playerListValue = selectedCells
            playerOperatorValue = selectedOperatorValuePlayerTeam
            formListValue = playerListValue
            formOperatorValue = playerOperatorValue
            formOperatorText = playerOperatorText
            if formListValue == ["-10000"] || formListValue == [] {
                listValue = formOperatorText + "ANY"
            } else {
                listValue = formOperatorText + formListValue.sorted().joined(separator: ", ")
            }
        case ("OPPONENT: PLAYERS"):
            selectedOperatorValuePlayerOpponent = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)!
            switch(selectedOperatorValuePlayerOpponent) {
            case "=":
                playerOpponentOperatorText = " INCLUDE "
            case "≠":
                playerOpponentOperatorText = " DO NOT INCLUDE "
            default:
                playerOpponentOperatorText = " INCLUDE "
            }
            for dictionaryValue in selectedRows {
                for dictionaryKey in formListCells.allKeys(forValue: dictionaryValue) {
                    if selectedCells.contains(dictionaryKey) {
                        print(dictionaryKey + " dictionaryKey already exists in selectedCells")
                    } else {
                        selectedCells.append(dictionaryKey)
                    }
                }
            }
            playerOpponentListValue = selectedCells
            playerOpponentOperatorValue = selectedOperatorValuePlayerOpponent
            formListValue = playerOpponentListValue
            formOperatorValue = playerOpponentOperatorValue
            formOperatorText = playerOpponentOperatorText
            if formListValue == ["-10000"] || formListValue == [] {
                listValue = formOperatorText + "ANY"
            } else {
                listValue = formOperatorText + formListValue.sorted().joined(separator: ", ")
            }
        case ("DAY"):
            for dictionaryValue in selectedRows {
                for dictionaryKey in formListCells.allKeys(forValue: dictionaryValue) {
                    if selectedCells.contains(dictionaryKey) {
                        print(dictionaryKey + " dictionaryKey already exists in selectedCells")
                    } else {
                        selectedCells.append(dictionaryKey)
                    }
                }
            }
            dayListValue = selectedCells
            dayOperatorValue = "="
            dayOperatorText = " IS "
            formListValue = dayListValue
            formOperatorValue = dayOperatorValue
            formOperatorText = dayOperatorText
            if formListValue == ["-10000"] || formListValue == [] {
                listValue = formOperatorText + "ANY"
            } else {
                listValue = formOperatorText + formListValue.joined(separator: ", ")
            }
        case ("STADIUM"):
            for dictionaryValue in selectedRows {
                for dictionaryKey in formListCells.allKeys(forValue: dictionaryValue) {
                    if selectedCells.contains(dictionaryKey) {
                        print(dictionaryKey + " dictionaryKey already exists in selectedCells")
                    } else {
                        selectedCells.append(dictionaryKey)
                    }
                }
            }
            stadiumListValue = selectedCells
            stadiumOperatorValue = "="
            stadiumOperatorText = " IS "
            formListValue = stadiumListValue
            formOperatorValue = stadiumOperatorValue
            formOperatorText = stadiumOperatorText
            if formListValue == ["-10000"] || formListValue == [] || formListValue.count == 3 {
                listValue = formOperatorText + "ANY"
            } else {
                listValue = formOperatorText + formListValue.sorted().joined(separator: ", ")
            }
        case ("SURFACE"):
            for dictionaryValue in selectedRows {
                for dictionaryKey in formListCells.allKeys(forValue: dictionaryValue) {
                    if selectedCells.contains(dictionaryKey) {
                        print(dictionaryKey + " dictionaryKey already exists in selectedCells")
                    } else {
                        selectedCells.append(dictionaryKey)
                    }
                }
            }
            surfaceListValue = selectedCells
            surfaceOperatorValue = "="
            surfaceOperatorText = " IS "
            formListValue = surfaceListValue
            formOperatorValue = surfaceOperatorValue
            formOperatorText = surfaceOperatorText
            if formListValue == ["-10000"] || formListValue == [] || formListValue.count == 2 {
                listValue = formOperatorText + "ANY"
            } else {
                listValue = formOperatorText + formListValue.sorted().joined(separator: ", ")
            }
            
        default:
            //operatorText = " IS "
            formListValue = team1ListValue
            formOperatorValue = team1OperatorValue
            formOperatorText = team1OperatorText
            if formListValue == ["-10000"] || formListValue == [] {
                listValue = formOperatorText + "ANY"
            } else {
                listValue = formOperatorText + "THE " + formListValue.sorted().joined(separator: ", ")
            }
        }
        buttonText = headerLabel + "\0" + listValue
        if buttonText.count > 50 {
            let lineBreakIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
        } else if buttonText.count > 40 {
            let lineBreakIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
        } else if buttonText.count > 35 {
            let lineBreakIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
        } else {
            let lineBreakIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.3, range: NSRange(location: 0, length:lineBreakIndex!))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
        }
        /*if formListValue.count > 2 {
            //print("more than 2x")
            let lineBreakIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:lineBreakIndex!))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
        } else {
            if formListValue.count > 1 {
                //print("more than 1x")
                let lineBreakIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
                buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            } else {
                //print("1x")
                let lineBreakIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
                buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            }
        }*/
        
        //print("headerLabel/tagText: \(headerLabel)")
        //print("listValue: \(listValue)")
        //print("formOperatorValue: " + formOperatorValue)
        //print("formOperatorText: " + formOperatorText)
        //print("formListValue.sorted().joined(): " + formListValue.sorted().joined(separator: ", "))
    }
    
//////////////////////////////////////////////////////////////////
    /*@objc func closeButton() {
        floatButtonSearchableMultiSelectViewController.close()
    }*/
//////////////////////////////////////////////////////////////////
    @objc func reloadRowValue() {
        print("reloadRowValue()")
        selectedCells.removeAll()
        switch (tagText) {
        case ("TEAM"):
            if selectedRows == [] {
                selectedRows = []
            } else {
                selectedRows = [selectedRows.last!]
            }
            for dictionaryValue in selectedRows {
                for dictionaryKey in formListCells.allKeys(forValue: dictionaryValue) {
                    if selectedCells.contains(dictionaryKey) {
                        print(dictionaryKey + " dictionaryKey already exists in selectedCells")
                    } else {
                        selectedCells.append(dictionaryKey)
                    }
                }
            }
            team1ListValue = selectedCells
            team1OperatorValue = "="
            team1OperatorText = " IS "
            formListValue = team1ListValue
            formOperatorValue = team1OperatorValue
            formOperatorText = team1OperatorText
            listValue = formOperatorText + formListValue.sorted().joined(separator: ", ")
            if formListValue == ["-10000"] || formListValue == [] {
                listValue = formOperatorText + "ANY TEAM"
            } else {
                listValue = formOperatorText + "THE " + formListValue.joined(separator: ", ")
            }
        case ("OPPONENT"):
            selectedOperatorValueOpponent = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)!
            switch(selectedOperatorValueOpponent) {
            case "=":
                team2OperatorText = " IS "
            case "≠":
                team2OperatorText = " IS NOT "
            default:
                team2OperatorText = " IS "
            }
            for dictionaryValue in selectedRows {
                for dictionaryKey in formListCells.allKeys(forValue: dictionaryValue) {
                    if selectedCells.contains(dictionaryKey) {
                        print(dictionaryKey + " dictionaryKey already exists in selectedCells")
                    } else {
                        selectedCells.append(dictionaryKey)
                    }
                }
            }
            team2ListValue = selectedCells
            team2OperatorValue = selectedOperatorValueOpponent
            //team2OperatorText = operatorText
            formListValue = team2ListValue
            formOperatorValue = team2OperatorValue
            formOperatorText = team2OperatorText
            if formListValue == ["-10000"] || formListValue == [] {
                if selectedOperatorValueOpponent == "=" {
                    listValue = " IS ANY TEAM"
                } else {
                    listValue = " IS NOT ANY TEAM"
                }
            } else {
                listValue = formOperatorText + "THE " + formListValue.sorted().joined(separator: ", ")
            }
            
        case ("HOME TEAM"):
            for dictionaryValue in selectedRows {
                for dictionaryKey in formListCells.allKeys(forValue: dictionaryValue) {
                    if selectedCells.contains(dictionaryKey) {
                        print(dictionaryKey + " dictionaryKey already exists in selectedCells")
                    } else {
                        selectedCells.append(dictionaryKey)
                    }
                }
            }
            homeTeamListValue = selectedCells
            homeTeamOperatorValue = "="
            homeTeamOperatorText = " IS "
            formListValue = homeTeamListValue
            formOperatorValue = homeTeamOperatorValue
            formOperatorText = homeTeamOperatorText
            if formListValue == ["-10000"] || formListValue == [] || formListValue.count == 3 {
                listValue = formOperatorText + "ANY"
            } else {
                listValue = formOperatorText + formListValue.sorted().joined(separator: ", ")
            }
        case ("FAVORITE"):
            for dictionaryValue in selectedRows {
                for dictionaryKey in formListCells.allKeys(forValue: dictionaryValue) {
                    if selectedCells.contains(dictionaryKey) {
                        print(dictionaryKey + " dictionaryKey already exists in selectedCells")
                    } else {
                        selectedCells.append(dictionaryKey)
                    }
                }
            }
            favoriteListValue = selectedCells
            favoriteOperatorValue = "="
            favoriteOperatorText = " IS "
            formListValue = favoriteListValue
            formOperatorValue = favoriteOperatorValue
            formOperatorText = favoriteOperatorText
            if formListValue == ["-10000"] || formListValue == [] || formListValue.count == 3 {
                listValue = formOperatorText + "ANY"
            } else {
                listValue = formOperatorText + formListValue.sorted().joined(separator: ", ")
            }
        case ("TEAM: PLAYERS"):
            selectedOperatorValuePlayerTeam = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)!
            switch(selectedOperatorValuePlayerTeam) {
            case "=":
                playerOperatorText = " INCLUDE "
            case "≠":
                playerOperatorText = " DO NOT INCLUDE "
            default:
                playerOperatorText = " INCLUDE "
            }
            for dictionaryValue in selectedRows {
                for dictionaryKey in formListCells.allKeys(forValue: dictionaryValue) {
                    if selectedCells.contains(dictionaryKey) {
                        print(dictionaryKey + " dictionaryKey already exists in selectedCells")
                    } else {
                        selectedCells.append(dictionaryKey)
                    }
                }
            }
            playerListValue = selectedCells
            playerOperatorValue = selectedOperatorValuePlayerTeam
            formListValue = playerListValue
            formOperatorValue = playerOperatorValue
            formOperatorText = playerOperatorText
            if formListValue == ["-10000"] || formListValue == [] {
                listValue = formOperatorText + "ANY"
            } else {
                listValue = formOperatorText + formListValue.sorted().joined(separator: ", ")
            }
        case ("OPPONENT: PLAYERS"):
            selectedOperatorValuePlayerOpponent = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)!
            switch(selectedOperatorValuePlayerOpponent) {
            case "=":
                playerOpponentOperatorText = " INCLUDE "
            case "≠":
                playerOpponentOperatorText = " DO NOT INCLUDE "
            default:
                playerOpponentOperatorText = " INCLUDE "
            }
            for dictionaryValue in selectedRows {
                for dictionaryKey in formListCells.allKeys(forValue: dictionaryValue) {
                    if selectedCells.contains(dictionaryKey) {
                        print(dictionaryKey + " dictionaryKey already exists in selectedCells")
                    } else {
                        selectedCells.append(dictionaryKey)
                    }
                }
            }
            playerOpponentListValue = selectedCells
            playerOpponentOperatorValue = selectedOperatorValuePlayerOpponent
            formListValue = playerOpponentListValue
            formOperatorValue = playerOpponentOperatorValue
            formOperatorText = playerOpponentOperatorText
            if formListValue == ["-10000"] || formListValue == [] {
                listValue = formOperatorText + "ANY"
            } else {
                listValue = formOperatorText + formListValue.sorted().joined(separator: ", ")
            }
        case ("DAY"):
            for dictionaryValue in selectedRows {
                for dictionaryKey in formListCells.allKeys(forValue: dictionaryValue) {
                    if selectedCells.contains(dictionaryKey) {
                        print(dictionaryKey + " dictionaryKey already exists in selectedCells")
                    } else {
                        selectedCells.append(dictionaryKey)
                    }
                }
            }
            dayListValue = selectedCells
            dayOperatorValue = "="
            dayOperatorText = " IS "
            formListValue = dayListValue
            formOperatorValue = dayOperatorValue
            formOperatorText = dayOperatorText
            if formListValue == ["-10000"] || formListValue == [] {
                listValue = formOperatorText + "ANY"
            } else {
                listValue = formOperatorText + formListValue.joined(separator: ", ")
            }
        case ("STADIUM"):
            for dictionaryValue in selectedRows {
                for dictionaryKey in formListCells.allKeys(forValue: dictionaryValue) {
                    if selectedCells.contains(dictionaryKey) {
                        print(dictionaryKey + " dictionaryKey already exists in selectedCells")
                    } else {
                        selectedCells.append(dictionaryKey)
                    }
                }
            }
            stadiumListValue = selectedCells
            stadiumOperatorValue = "="
            stadiumOperatorText = " IS "
            formListValue = stadiumListValue
            formOperatorValue = stadiumOperatorValue
            formOperatorText = stadiumOperatorText
            if formListValue == ["-10000"] || formListValue == [] || formListValue.count == 3 {
                listValue = formOperatorText + "ANY"
            } else {
                listValue = formOperatorText + formListValue.sorted().joined(separator: ", ")
            }
        case ("SURFACE"):
            for dictionaryValue in selectedRows {
                for dictionaryKey in formListCells.allKeys(forValue: dictionaryValue) {
                    if selectedCells.contains(dictionaryKey) {
                        print(dictionaryKey + " dictionaryKey already exists in selectedCells")
                    } else {
                        selectedCells.append(dictionaryKey)
                    }
                }
            }
            surfaceListValue = selectedCells
            surfaceOperatorValue = "="
            surfaceOperatorText = " IS "
            formListValue = surfaceListValue
            formOperatorValue = surfaceOperatorValue
            formOperatorText = surfaceOperatorText
            if formListValue == ["-10000"] || formListValue == [] || formListValue.count == 2 {
                listValue = formOperatorText + "ANY"
            } else {
                listValue = formOperatorText + formListValue.sorted().joined(separator: ", ")
            }
            
        default:
            //operatorText = " IS "
            formListValue = team1ListValue
            formOperatorValue = team1OperatorValue
            formOperatorText = team1OperatorText
            if formListValue == ["-10000"] || formListValue == [] {
                listValue = formOperatorText + "ANY"
            } else {
                listValue = formOperatorText + "THE " + formListValue.sorted().joined(separator: ", ")
            }
        }
        buttonText = headerLabel + "\0" + listValue
        if buttonText.count > 50 {
            let lineBreakIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
        } else if buttonText.count > 40 {
            let lineBreakIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
        } else if buttonText.count > 35 {
            let lineBreakIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveAndAHalfThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.4, range: NSRange(location: 0, length: buttonText.count))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
        } else {
            let lineBreakIndex = buttonText.indexDistance(of: char)
            buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
            buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: -0.3, range: NSRange(location: 0, length:lineBreakIndex!))
            buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
            buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
        }
        /*if formListValue.count > 2 {
            if headerLabel != "STADIUM" && headerLabel != "FAVORITE" && headerLabel != "SURFACE" && headerLabel != "HOME TEAM" {
                let lineBreakIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : elevenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: elevenAndAHalfSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
                buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            } else {
                let lineBreakIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
                buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            }
        } else {
            if formListValue.count > 1 {
                let lineBreakIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : twelveThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: twelveSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
                buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            } else {
                let lineBreakIndex = buttonText.indexDistance(of: char)
                buttonTextMutableString = NSMutableAttributedString(string: buttonText, attributes: [NSAttributedStringKey.font : thirteenThinSFCompact!, NSAttributedStringKey.foregroundColor : silverColor])
                buttonTextMutableString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonTextMutableString.addAttribute(NSAttributedStringKey.font, value: thirteenSemiboldSFCompact!, range: NSRange(location: 0, length:lineBreakIndex!))
                buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.normal)
                buttonView?.setAttributedTitle(buttonTextMutableString, for: UIControlState.selected)
            }
        }*/
        
        //print("headerLabel/tagText: \(headerLabel)")
        //print("listValue: \(listValue)")
        //print("formOperatorValue: " + formOperatorValue)
        //print("formOperatorText: " + formOperatorText)
        //print("formListValue.sorted().joined(): " + formListValue.sorted().joined(separator: ", "))
        //print("formListValue: \(formListValue)")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "searchableMultiSelectNotification"), object: nil)
        
    }
	
///////////////////
    @available(iOS 8.0, *)
    func updateSearchResults(for searchController: UISearchController) {
        //print("updateSearchResults()")
        storeSelections()
        if !searchController.isActive {
            print("Search bar exited")
            searchBarStatus = "INACTIVE"
            tap.addTarget(self, action: #selector(handleTap))
            print("searchBarStatus: " + searchBarStatus)
            searchBarStatus = "INACTIVE"
        } else {
            searchBarStatus = "ACTIVE"
        }
        if let searchText = searchBarController.searchBar.text {
            //print("Search bar active")
            //searchBarStatus = "ACTIVE"
            print("searchBarStatus: " + searchBarStatus)
            filteredListValues = searchText.isEmpty ? listValues : listValues.filter { (dataString: String) -> Bool in
                return dataString.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            }
            self.tableView.reloadData()
            reselectSelections()
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
        //storeSelections()
        super.viewWillDisappear(animated)
        self.tableView.backgroundColor = darkGreyColor
        self.view.backgroundColor = darkGreyColor
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.toolbar.isHidden = true
    }
    
    @objc func handleTap() {
        //print("Tapped")
        let mainQueue = DispatchQueue.main
        let deadline = DispatchTime.now() + .milliseconds(5)
        mainQueue.asyncAfter(deadline: deadline) {
            switch (self.tableView.indexPathsForSelectedRows.map({$0.map{$0.row}})) {
                case nil:
                    self.selectedRows = []
                default:
                    self.selectedRows = self.tableView.indexPathsForSelectedRows.map({$0.map{$0.row}})!
            }
            //print(self.selectedRows)
            self.reloadRowValue()
        }
    }
    
    @objc func labelTapped() {
        //print("labelTapped()")
        if formListValue == ["-10000"] || formListValue == [] {
            switch(tagText) {
            case "TEAM":
                messageString = "ANY TEAM"
                if team1OperatorValue == "-10000" {
                    titleString = tagText + " ="
                } else {
                    titleString = tagText + " " + team1OperatorValue
                }
            case "OPPONENT":
                messageString = "ANY TEAM"
                if team2OperatorValue == "-10000" {
                    titleString = tagText + " ="
                } else {
                    titleString = tagText + " " + team2OperatorValue
                }
            case "HOME TEAM":
                messageString = "ANY"
                if homeTeamOperatorValue == "-10000" {
                    titleString = tagText + " ="
                } else {
                    titleString = tagText + " " + homeTeamOperatorValue
                }
            case "FAVORITE":
                messageString = "ANY"
                if favoriteOperatorValue == "-10000" {
                    titleString = tagText + " ="
                } else {
                    titleString = tagText + " " + favoriteOperatorValue
                }
            case "DAY":
                messageString = "ANY"
                if dayOperatorValue == "-10000" {
                    titleString = tagText + " ="
                } else {
                    titleString = tagText + " " + dayOperatorValue
                }
            case "STADIUM":
                messageString = "ANY"
                if stadiumOperatorValue == "-10000" {
                    titleString = tagText + " ="
                } else {
                    titleString = tagText + " " + stadiumOperatorValue
                }
            case "SURFACE":
                messageString = "ANY"
                if surfaceOperatorValue == "-10000" {
                    titleString = tagText + " ="
                } else {
                    titleString = tagText + " " + surfaceOperatorValue
                }
            default:
                messageString = "ANY"
                titleString = tagText + " " + "="
            }
        } else {
            messageString = formListValue.sorted().joined(separator: "\n")
            switch(tagText) {
            case "TEAM":
                if team1OperatorValue == "-10000" {
                    titleString = tagText + " ="
                } else {
                    titleString = tagText + " " + team1OperatorValue
                }
            case "OPPONENT":
                if team2OperatorValue == "-10000" {
                    titleString = tagText + " ="
                } else {
                    titleString = tagText + " " + team2OperatorValue
                }
            case "HOME TEAM":
                if homeTeamOperatorValue == "-10000" {
                    titleString = tagText + " ="
                } else {
                    titleString = tagText + " " + homeTeamOperatorValue
                }
            case "FAVORITE":
                if favoriteOperatorValue == "-10000" {
                    titleString = tagText + " ="
                } else {
                    titleString = tagText + " " + favoriteOperatorValue
                }
            case "TEAM: PLAYERS":
                if playerOperatorValue == "-10000" {
                    titleString = tagText + " ="
                } else {
                    titleString = tagText + " " + playerOperatorValue
                }
            case "OPPONENT: PLAYERS":
                if playerOpponentOperatorValue == "-10000" {
                    titleString = tagText + " ="
                } else {
                    titleString = tagText + " " + playerOpponentOperatorValue
                }
            case "DAY":
                if dayOperatorValue == "-10000" {
                    titleString = tagText + " ="
                } else {
                    titleString = tagText + " " + dayOperatorValue
                }
            case "STADIUM":
                if stadiumOperatorValue == "-10000" {
                    titleString = tagText + " ="
                } else {
                    titleString = tagText + " " + stadiumOperatorValue
                }
            case "SURFACE":
                if surfaceOperatorValue == "-10000" {
                    titleString = tagText + " ="
                } else {
                    titleString = tagText + " " + surfaceOperatorValue
                }
            default:
                titleString = tagText + " " + "="
            }
        }
        self.alertController.title = titleString
        self.alertController.message = messageString
        self.alertController.buttonTitleColor = orangeColor
        self.alertController.buttonFont = fifteenBlackRoboto
        self.alertController.view.backgroundColor = lightGreyColor.withAlphaComponent(0.8)
        self.alertController.titleFont = sixteenBoldRobotoCondensed
        self.alertController.messageFont = fifteenRegularRobotoCondensed
        self.alertController.titleColor = darkGreyColor
        self.alertController.messageColor = dashboardGreyColor
        self.present(alertController, animated: true) {
            //print("present(alertController()")
        }
    }
    
    @objc func clearMultiSelectSelections() {
        print("-------clearMultiSelectSelections() STARTED-------")
        clearMultiSelectIndicator = tagText
        selectedCells.removeAll()
        selectedOperatorValueTeam = "="
        selectedOperatorValueOpponent = "="
        selectedOperatorValuePlayerTeam = "="
        selectedOperatorValuePlayerOpponent = "="
        switch (tagText) {
        case "TEAM":
            self.selectedRows = []
            formListValue = ["-10000"]
            makeOriginalSelections()
            clearMultiSelectIndicator = ""
            reloadRowValue()
        case "OPPONENT":
            self.selectedRows = []
            team2OperatorText = " IS "
            formListValue = ["-10000"]
            makeOriginalSelections()
            self.segmentedControl.selectedSegmentIndex = 0
            self.segmentedControl.sendActions(for: .valueChanged)
        case "HOME TEAM":
            self.selectedRows = [0, 1, 2]
            formListValue = ["-10000"]
            makeOriginalSelections()
            clearMultiSelectIndicator = ""
            reloadRowValue()
        case "FAVORITE":
            self.selectedRows = [0, 1, 2]
            formListValue = ["-10000"]
            makeOriginalSelections()
            clearMultiSelectIndicator = ""
            reloadRowValue()
        case "TEAM: PLAYERS":
            self.selectedRows = []
            playerOperatorText = " INCLUDE "
            formListValue = ["-10000"]
            makeOriginalSelections()
            clearMultiSelectIndicator = ""
            self.segmentedControl.selectedSegmentIndex = 0
            self.segmentedControl.sendActions(for: .valueChanged)
        case "OPPONENT: PLAYERS":
            self.selectedRows = []
            playerOpponentOperatorText = " INCLUDE "
            formListValue = ["-10000"]
            makeOriginalSelections()
            clearMultiSelectIndicator = ""
            self.segmentedControl.selectedSegmentIndex = 0
            self.segmentedControl.sendActions(for: .valueChanged)
        case "STADIUM":
            self.selectedRows = [0, 1, 2]
            formListValue = ["-10000"]
            makeOriginalSelections()
            clearMultiSelectIndicator = ""
            reloadRowValue()
        case "SURFACE":
            self.selectedRows = [0, 1]
            formListValue = ["-10000"]
            makeOriginalSelections()
            clearMultiSelectIndicator = ""
            reloadRowValue()
        default:
            self.selectedRows = []
            formListValue = ["-10000"]
            makeOriginalSelections()
            clearMultiSelectIndicator = ""
            reloadRowValue()
        }
        print("-------clearMultiSelectSelections() FINISHED-------")
    }
}
