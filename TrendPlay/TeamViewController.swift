//
//  TeamViewController.swift
//  TrendPlay
// 
//  Created by Chelsea Smith on 1/9/17.
//  Copyright © 2017 Trending Productions LLC. All rights reserved.
//

import UIKit
import Foundation
import Eureka
import Floaty
import MaterialComponents
import FMDB
import SwiftRangeSlider

extension CustomTableViewCell {
    var indexPath: IndexPath? {
        return (superview as? UITableView)?.indexPath(for: self)
    }
}

extension Collection where Iterator.Element == String {
    var doubleArray: [Double] {
        return compactMap{ Double($0) }
    }
    var floatArray: [Float] {
        return compactMap{ Float($0) }
    }
}
extension Dictionary where Value: Equatable {
    func allKeys(forValue val: Value) -> [Key] {
        return self.filter { $1 == val }.map { $0.0 }
    }
}

public var searchBarStatus: String = "INACTIVE"
public var screenSize = UIScreen.main.bounds
public var screenWidth = screenSize.width
public var screenHeight = screenSize.height
public var rowdictionary = [
    "TEAM" : "TEAM",
    "OPPONENT" : "OPPONENT",
    "HOME TEAM" : "HOME TEAM",
    "FAVORITE" : "FAVORITE",
    "TEAM: PLAYERS" : "PLAYERS, TEAM",
	"OPPONENT: PLAYERS" : "PLAYERS, OPPONENT",
    "DAY" : "DAY",
    "STADIUM" : "STADIUM",
    "SURFACE" : "SURFACE",
    "TEAM: STREAK" : "STREAK, TEAM",
    "OPPONENT: STREAK" : "STREAK, OPPONENT",
    "TEAM: SEASON WIN %" : "SEASON WIN %, TEAM",
    "OPPONENT: SEASON WIN %" : "SEASON WIN %, OPPONENT",
    "SEASON" : "SEASON",
    "WEEK" : "WEEK",
    "GAME NUMBER" : "GAME NUMBER",
    "TEAM: SPREAD" : "SPREAD, TEAM",
    "OVER/UNDER" : "OVER/UNDER",
    "TEMPERATURE (F)" : "TEMPERATURE (F)",
    "TEAM: TOTAL POINTS" : "TOTAL POINTS, TEAM",
    "OPPONENT: TOTAL POINTS" : "TOTAL POINTS, OPPONENT",
    "TEAM: TOUCHDOWNS" : "TOUCHDOWNS, TEAM",
    "OPPONENT: TOUCHDOWNS" : "TOUCHDOWNS, OPPONENT",
    "TEAM: TURNOVERS" : "TURNOVERS, TEAM",
    "OPPONENT: TURNOVERS" : "TURNOVERS, OPPONENT",
    "TEAM: PENALTIES" : "PENALTIES, TEAM",
    "OPPONENT: PENALTIES" : "PENALTIES, OPPONENT",
    "TEAM: OFFENSIVE TOUCHDOWNS" : "OFFENSIVE TOUCHDOWNS, TEAM",
    "OPPONENT: OFFENSIVE TOUCHDOWNS" : "OFFENSIVE TOUCHDOWNS, OPPONENT",
    "TEAM: TOTAL YARDS" : "TOTAL YARDS, TEAM",
    "OPPONENT: TOTAL YARDS" : "TOTAL YARDS, OPPONENT",
    "TEAM: PASSING YARDS" : "PASSING YARDS, TEAM",
    "OPPONENT: PASSING YARDS" : "PASSING YARDS, OPPONENT",
    "TEAM: RUSHING YARDS" : "RUSHING YARDS, TEAM",
    "OPPONENT: RUSHING YARDS" : "RUSHING YARDS, OPPONENT",
    "TEAM: QUARTERBACK RATING" : "QUARTERBACK RATING, TEAM",
    "OPPONENT: QUARTERBACK RATING" : "QUARTERBACK RATING, OPPONENT",
    "TEAM: TIMES SACKED" : "TIMES SACKED, TEAM",
    "OPPONENT: TIMES SACKED" : "TIMES SACKED, OPPONENT",
    "TEAM: INTERCEPTIONS THROWN" : "INTERCEPTIONS THROWN, TEAM",
    "OPPONENT: INTERCEPTIONS THROWN" : "INTERCEPTIONS THROWN, OPPONENT",
    "TEAM: OFFENSIVE PLAYS" : "OFFENSIVE PLAYS, TEAM",
    "OPPONENT: OFFENSIVE PLAYS" : "OFFENSIVE PLAYS, OPPONENT",
    "TEAM: DEFENSIVE TOUCHDOWNS" : "DEFENSIVE TOUCHDOWNS, TEAM",
    "OPPONENT: DEFENSIVE TOUCHDOWNS" : "DEFENSIVE TOUCHDOWNS, OPPONENT",
    "TEAM: YARDS/OFFENSIVE PLAY" : "YARDS/OFFENSIVE PLAY, TEAM",
    "OPPONENT: YARDS/OFFENSIVE PLAY" : "YARDS/OFFENSIVE PLAY, OPPONENT",
    "TEAM: SACKS" : "SACKS, TEAM",
    "OPPONENT: SACKS" : "SACKS, OPPONENT",
    "TEAM: INTERCEPTIONS" : "INTERCEPTIONS, TEAM",
    "OPPONENT: INTERCEPTIONS" : "INTERCEPTIONS, OPPONENT",
    "TEAM: SAFETIES" : "SAFETIES, TEAM",
    "OPPONENT: SAFETIES" : "SAFETIES, OPPONENT",
    "TEAM: DEFENSIVE PLAYS" : "DEFENSIVE PLAYS, TEAM",
    "OPPONENT: DEFENSIVE PLAYS" : "DEFENSIVE PLAYS, OPPONENT",
    "TEAM: YARDS/DEFENSIVE PLAY" : "YARDS/DEFENSIVE PLAY, TEAM",
    "OPPONENT: YARDS/DEFENSIVE PLAY" : "YARDS/DEFENSIVE PLAY, OPPONENT",
    "TEAM: EXTRA POINT ATTEMPTS" : "EXTRA POINT ATTEMPTS, TEAM",
    "OPPONENT: EXTRA POINT ATTEMPTS" : "EXTRA POINT ATTEMPTS, OPPONENT",
    "TEAM: EXTRA POINTS MADE" : "EXTRA POINTS MADE, TEAM",
    "OPPONENT: EXTRA POINTS MADE" : "EXTRA POINTS MADE, OPPONENT",
    "TEAM: FIELD GOAL ATTEMPTS" : "FIELD GOAL ATTEMPTS, TEAM",
    "OPPONENT: FIELD GOAL ATTEMPTS" : "FIELD GOAL ATTEMPTS, OPPONENT",
    "TEAM: FIELD GOALS MADE" : "FIELD GOALS MADE, TEAM",
    "OPPONENT: FIELD GOALS MADE" : "FIELD GOALS MADE, OPPONENT",
    "TEAM: PUNTS" : "PUNTS, TEAM",
    "OPPONENT: PUNTS" : "PUNTS, OPPONENT",
    "TEAM: PUNT YARDS" : "PUNT YARDS, TEAM",
    "OPPONENT: PUNT YARDS" : "PUNT YARDS, OPPONENT"
]
public var team1Label: String = ""
public var team2Label: String = ""


class TeamViewController: FormViewController, FloatyDelegate {
    let floatActionButton = Floaty()
    let floatyItem = FloatyItem()
    let teamNavigationController = TeamNavigationController(nibName: nil, bundle: nil)
    lazy var clearIndicator = String()
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TeamVC viewDidLoad()")
        if teamPlayerIndicator == "TEAM" {
            tagText = "tagText"
            NotificationCenter.default.addObserver(self, selector: #selector(TeamViewController.reloadRow), name: NSNotification.Name(rawValue: "sliderNotification"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(TeamViewController.reloadRow), name: NSNotification.Name(rawValue: "searchableMultiSelectNotification"), object: nil)
            let teamDashboardViewController = storyboard?.instantiateViewController(withIdentifier: "TeamDashboardViewController") as! TeamDashboardViewController
            self.view.backgroundColor = darkGreyColor
            self.tableView.backgroundColor = darkGreyColor
            self.tableView.separatorStyle = .singleLine
            self.tableView.separatorColor = lightMediumGreyColor
            self.tableView.separatorInset = UIEdgeInsetsMake(2, 0, 2, 0)
            self.navigationController?.navigationBar.isHidden = true
            self.navigationController?.toolbar.isHidden = true
            let editButtonImage = UIImage(named: "edit")?.withRenderingMode(
                UIImageRenderingMode.alwaysTemplate)
            let deleteSweepItemImage = UIImage(named: "deleteSweep")?.withRenderingMode(
                UIImageRenderingMode.alwaysTemplate)
            floatActionButton.buttonImage = editButtonImage
            floatActionButton.buttonColor = lightMediumGreyColor.withAlphaComponent(0.85)
            floatActionButton.openAnimationType = .slideLeft
            floatActionButton.overlayColor = dashboardGreyColor.withAlphaComponent(0.75)
            floatyItem.title = "CLEAR SELECTIONS"
            floatyItem.titleColor = lightGreyColor
            floatyItem.titleLabel.font = thirteenBlackRoboto
            floatyItem.titleLabel.textAlignment = .right
            floatyItem.buttonColor = lightMediumGreyColor
            floatyItem.tintColor = lightGreyColor
            floatyItem.size = CGFloat(52)
            floatyItem.frame = CGRect(x: 0, y: 0, width: 52, height: 52)
            floatyItem.imageSize = CGSize(width: 30, height: 30)
            floatyItem.icon = deleteSweepItemImage
            let deleteSweepHandler: (FloatyItem) -> Void = { item in
                self.clearSelections()
            }
            floatyItem.handler = deleteSweepHandler
            floatActionButton.friendlyTap = true
            floatActionButton.addItem(item: floatyItem)
            self.view.addSubview(floatActionButton)
        
            ButtonRow.defaultCellSetup = { cell, row in
                cell.tintColor = orangeColorDarker
                cell.backgroundColor = darkGreyColor
                cell.textLabel?.font = twelveBoldSFCompact //twelveBold
                cell.textLabel?.text = " "
                cell.textLabel?.addTextSpacing(spacing: -0.3)
                //cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                cell.textLabel?.textColor = lightGreyColor
                cell.detailTextLabel?.font = twelveThinSFCompact
                cell.detailTextLabel?.textColor = lightGreyColor
                cell.height = ({return 35.0})
            }
        
            ButtonRow.defaultCellUpdate = { cell, row in
                cell.tintColor = orangeColorDarker
                cell.backgroundColor = darkGreyColor
                cell.textLabel?.font = twelveBoldSFCompact //twelveBold
                cell.textLabel?.addTextSpacing(spacing: -0.3)
                //cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                cell.textLabel?.textColor = lightGreyColor
                cell.detailTextLabel?.font = twelveThinSFCompact //elevenAndAHalfRegular
                cell.detailTextLabel?.textColor = lightGreyColor
                //cell.detailTextLabel?.textColor = orangeColorDarker
                cell.height = ({return 35.0})
            }
     
            form +++
            
                ///  MATCH-UP  ///
                Section("MATCH-UP"){ section in
                    var header = HeaderFooterView<UILabel>(.class)
                    header.height = { 30.0 }
                    header.onSetupView = { view, _ in
                        view.textColor = lightMediumGreyColor
                        view.text = "   MATCH-UP"
                        view.font = thirteenBlackRoboto
                        view.baselineAdjustment = .alignCenters
                    }
                    section.header = header
                }

                <<< ButtonRow("TEAM") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "Team1Segue", onDismiss: nil)
                    row.cell.textLabel?.font = twelveSemiboldSFCompact
                    row.cell.detailTextLabel?.font = twelveThinSFCompact
                    } .cellUpdate { cell, row in
                        if team1ListValue == ["-10000"] || team1ListValue == [] {
                            teamDashboardViewController.team1LabelText = "TEAM"
                            cell.detailTextLabel?.text = "IS ANY"
                        } else {
                            teamDashboardViewController.team1LabelText = team1ListValue.last!
                            cell.detailTextLabel?.text = team1OperatorText + "THE " + team1ListValue.last!
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                        cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                        //print("team1OperatorValue: " + team1OperatorValue)
                        //print("team1ListValue: ")
                        //print(team1ListValue)
                }
     
                <<< ButtonRow("OPPONENT") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "Team2Segue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if team2ListValue == ["-10000"] || team2ListValue == [] || team2ListValue.count == 32 {
                            teamDashboardViewController.team2LabelText = "OPPONENT"
                            cell.detailTextLabel?.text = "IS ANY"
                        } else {
                            if team2ListValue.count > 1 {
                                teamDashboardViewController.team2LabelText = "OPPONENT"
                                cell.detailTextLabel?.text = team2OperatorText + "THE " + team2ListValue.sorted().joined(separator: ", ")
                            } else {
                                teamDashboardViewController.team2LabelText = team2ListValue.sorted().joined(separator: ", ")
                                cell.detailTextLabel?.text = team2OperatorText + "THE " + team2ListValue.sorted().joined(separator: ", ")
                            }
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                        cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                        //print(row.tag! + team2OperatorText + team2ListValue.sorted().joined(separator: ", "))
                        //print("team2OperatorValue: " + team2OperatorValue)
                        //print("team2ListValue: ")
                        //print(team2ListValue)
                }
                
                ///  GAME SETTING  ///
                +++ Section("GAME SETTING"){ section in
                    var header = HeaderFooterView<UILabel>(.class)
                    header.height = { 30.0 }
                    header.onSetupView = {view, _ in
                        view.textColor = lightMediumGreyColor
                        view.text = "   GAME SETTING"
                        view.font = thirteenBlackRoboto
                        view.baselineAdjustment = .alignCenters
                    }
                    section.header = header
                }
                
                <<< ButtonRow("HOME TEAM") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "HomeTeamSegue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if homeTeamListValue == ["-10000"] || homeTeamListValue == [] || homeTeamListValue.count == 3 {
                            cell.detailTextLabel?.text = "IS ANY"
                        } else {
                            cell.detailTextLabel?.text = homeTeamOperatorText + homeTeamListValue.sorted().joined(separator: ", ")
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                        cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                }
                
                <<< ButtonRow("SEASON") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "SeasonSegue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if seasonSliderFormValue == "-10000" || (seasonRangeSliderLowerValue == seasonValues.first && seasonRangeSliderUpperValue == seasonValues.last) {
                            cell.detailTextLabel?.text = "IS ANY"
                        } else {
                            cell.detailTextLabel?.text = seasonOperatorText + seasonSliderFormValue
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                        cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                        //print("seasonSliderFormValue: ")
                        //print(seasonSliderFormValue)
                }
                
                <<< ButtonRow("WEEK") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "WeekSegue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if weekSliderFormValue == "-10000" || (weekRangeSliderLowerValue == weekValues.first && weekRangeSliderUpperValue == weekValues.last) {
                            cell.detailTextLabel?.text = "IS ANY"
                        } else {
                            cell.detailTextLabel?.text = weekOperatorText + weekSliderFormValue
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                        cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                }
                
                <<< ButtonRow("GAME NUMBER") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "GameNumberSegue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if gameNumberSliderFormValue == "-10000" || (gameNumberRangeSliderLowerValue == gameNumberValues.first && gameNumberRangeSliderUpperValue == gameNumberValues.last) {
                            cell.detailTextLabel?.text = "IS ANY"
                        } else {
                            cell.detailTextLabel?.text = gameNumberOperatorText + gameNumberSliderFormValue
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                        cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                }
                
                <<< ButtonRow("DAY") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "DayOfWeekSegue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if dayListValue == ["-10000"] || dayListValue == [] || dayListValue.count == 7 {
                            cell.detailTextLabel?.text = "IS ANY"
                        } else {
                            cell.detailTextLabel?.text = dayOperatorText + dayListValue.joined(separator: ", ")
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                        cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                        //print("dayListValue: ")
                        //print(dayListValue)
                }
                
                <<< ButtonRow("STADIUM") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "StadiumSegue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if stadiumListValue == ["-10000"] || stadiumListValue == [] || stadiumListValue.count == 3 {
                            cell.detailTextLabel?.text = "IS ANY"
                        } else {
                            cell.detailTextLabel?.text = stadiumOperatorText + stadiumListValue.sorted().joined(separator: ", ")
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                        cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                        //print("stadiumListValue: ")
                        //print(stadiumListValue)
                }
                
                <<< ButtonRow("SURFACE") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "SurfaceSegue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if surfaceListValue == ["-10000"] || surfaceListValue == [] || surfaceListValue.count == 2 {
                            cell.detailTextLabel?.text = "IS ANY"
                        } else {
                            cell.detailTextLabel?.text = surfaceOperatorText + surfaceListValue.sorted().joined(separator: ", ")
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                        cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                        //print("surfaceListValue: ")
                        //print(surfaceListValue)
                }
                
                <<< ButtonRow("TEMPERATURE (F)") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "TemperatureSegue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if temperatureSliderFormValue == "-10000" || (temperatureRangeSliderLowerValue == temperatureValues.first && temperatureRangeSliderUpperValue == temperatureValues.last) {
                            cell.detailTextLabel?.text = "IS ANY"
                        } else {
                            cell.detailTextLabel?.text = temperatureOperatorText + temperatureSliderFormValue
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                        cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                }
                
                ///  ENTERING GAME  ///
                +++ Section("ENTERING GAME"){ section in
                    var header = HeaderFooterView<UILabel>(.class)
                    header.height = { 30.0 }
                    header.onSetupView = {view, _ in
                        view.textColor = lightMediumGreyColor
                        view.text = "   ENTERING GAME"
                        view.font = thirteenBlackRoboto
                        view.baselineAdjustment = .alignCenters
                    }
                    section.header = header
                }
                
                <<< ButtonRow("FAVORITE") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "FavoriteSegue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if favoriteListValue == ["-10000"] || favoriteListValue == [] || favoriteListValue.count == 3 {
                            cell.detailTextLabel?.text = "IS ANY"
                        } else {
                            cell.detailTextLabel?.text = favoriteOperatorText + favoriteListValue.sorted().joined(separator: ", ")
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }

                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                        cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                        //print("favoriteListValue: ")
                        //print(favoriteListValue)
                }
                
                <<< ButtonRow("SPREAD, TEAM") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "SpreadSegue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if spreadSliderFormValue == "-10000" || (spreadRangeSliderLowerValue == spreadValues.first && spreadRangeSliderUpperValue == spreadValues.last) {
                            cell.detailTextLabel?.text = "IS ANY"
                        } else {
                            cell.detailTextLabel?.text = spreadOperatorText + spreadSliderFormValue
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        var rowTitle = row.tag
                        var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                        rowTitle = rowTitleTextArray?[0]
                        if team1ListValue == ["-10000"] || team1ListValue == [] {
                            cell.textLabel?.text = row.tag
                        } else {
                            if team1ListValue[0] == "NEW YORK GIANTS" {
                                team1Label = "NEW YORK (G)"
                            } else if team1ListValue[0] == "NEW YORK JETS" {
                                team1Label = "NEW YORK (J)"
                            } else if team1ListValue[0] == "LOS ANGELES CHARGERS" {
                                team1Label = "LOS ANGELES (C)"
                            } else if team1ListValue[0] == "LOS ANGELES RAMS" {
                                team1Label = "LOS ANGELES (R)"
                            } else {
                                team1Label = team1ListValue[0]
                                var team1TextArray = team1Label.components(separatedBy: " ")
                                let team1TextArrayLength = team1TextArray.count
                                team1TextArray.remove(at: team1TextArrayLength - 1)
                                team1Label = team1TextArray.joined(separator: " ")
                            }
                            cell.textLabel?.text = rowTitle! + ", " + team1Label
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                        cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                }
            
                <<< ButtonRow("OVER/UNDER") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "OverUnderSegue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if overUnderSliderFormValue == "-10000" || (overUnderRangeSliderLowerValue == overUnderValues.first && overUnderRangeSliderUpperValue == overUnderValues.last) {
                            cell.detailTextLabel?.text = "IS ANY"
                        } else {
                            cell.detailTextLabel?.text = overUnderOperatorText + overUnderSliderFormValue
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                        cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                }
                
                <<< ButtonRow("STREAK, TEAM") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "WinLossStreakTeam1Segue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if winningLosingStreakTeam1SliderFormValue == "-10000" || (winningLosingStreakTeam1RangeSliderLowerValue == winningLosingStreakTeam1Values.first && winningLosingStreakTeam1RangeSliderUpperValue == winningLosingStreakTeam1Values.last) {
                            cell.detailTextLabel?.text = "IS ANY"
                        } else {
                            cell.detailTextLabel?.text = winningLosingStreakTeam1OperatorText + winningLosingStreakTeam1SliderFormValue
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        var rowTitle = row.tag
                        var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                        rowTitle = rowTitleTextArray?[0]
                        if team1ListValue == ["-10000"] || team1ListValue == [] {
                            cell.textLabel?.text = row.tag
                        } else {
                            if team1ListValue[0] == "NEW YORK GIANTS" {
                                team1Label = "NEW YORK (G)"
                            } else if team1ListValue[0] == "NEW YORK JETS" {
                                team1Label = "NEW YORK (J)"
                            } else if team1ListValue[0] == "LOS ANGELES CHARGERS" {
                                team1Label = "LOS ANGELES (C)"
                            } else if team1ListValue[0] == "LOS ANGELES RAMS" {
                                team1Label = "LOS ANGELES (R)"
                            } else {
                                team1Label = team1ListValue[0]
                                var team1TextArray = team1Label.components(separatedBy: " ")
                                let team1TextArrayLength = team1TextArray.count
                                team1TextArray.remove(at: team1TextArrayLength - 1)
                                team1Label = team1TextArray.joined(separator: " ")
                            }
                            cell.textLabel?.text = rowTitle! + ", " + team1Label
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                        cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                        //print("winningLosingStreakTeam1SliderFormValue: ")
                        //print(winningLosingStreakTeam1SliderFormValue)
                    }
                
                <<< ButtonRow("STREAK, OPPONENT") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "WinLossStreakTeam2Segue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if winningLosingStreakTeam2SliderFormValue == "-10000" || (winningLosingStreakTeam2RangeSliderLowerValue == winningLosingStreakTeam2Values.first && winningLosingStreakTeam2RangeSliderUpperValue == winningLosingStreakTeam2Values.last) {
                            cell.detailTextLabel?.text = "IS ANY"
                        } else {
                            cell.detailTextLabel?.text = winningLosingStreakTeam2OperatorText + winningLosingStreakTeam2SliderFormValue
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        var rowTitle = row.tag
                        var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                        rowTitle = rowTitleTextArray?[0]
                        if team2ListValue == ["-10000"] || team2ListValue == [] || team2ListValue.count > 1 {
                            cell.textLabel?.text = row.tag
                        } else {
                            if team2ListValue[0] == "NEW YORK GIANTS" {
                                team2Label = "NEW YORK (G)"
                            } else if team2ListValue[0] == "NEW YORK JETS" {
                                team2Label = "NEW YORK (J)"
                            } else if team2ListValue[0] == "LOS ANGELES CHARGERS" {
                                team2Label = "LOS ANGELES (C)"
                            } else if team2ListValue[0] == "LOS ANGELES RAMS" {
                                team2Label = "LOS ANGELES (R)"
                            } else {
                                team2Label = team2ListValue[0]
                                var team2TextArray = team2Label.components(separatedBy: " ")
                                let team2TextArrayLength = team2TextArray.count
                                team2TextArray.remove(at: team2TextArrayLength - 1)
                                team2Label = team2TextArray.joined(separator: " ")
                            }
                            cell.textLabel?.text = rowTitle! + ", " + team2Label
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                        cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                        //print("winningLosingStreakTeam2SliderFormValue: ")
                        //print(winningLosingStreakTeam2SliderFormValue)
                    }
                
                <<< ButtonRow("SEASON WIN %, TEAM") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "SeasonWinPercentageTeam1Segue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if seasonWinPercentageTeam1SliderFormValue == "-10000" || (seasonWinPercentageTeam1RangeSliderLowerValue == seasonWinPercentageTeam1Values.first && seasonWinPercentageTeam1RangeSliderUpperValue == seasonWinPercentageTeam1Values.last) {
                            cell.detailTextLabel?.text = "IS ANY"
                        } else {
                            cell.detailTextLabel?.text = seasonWinPercentageTeam1OperatorText + seasonWinPercentageTeam1SliderFormValue
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        var rowTitle = row.tag
                        var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                        rowTitle = rowTitleTextArray?[0]
                        if team1ListValue == ["-10000"] || team1ListValue == [] {
                            cell.textLabel?.text = row.tag
                        } else {
                            if team1ListValue[0] == "NEW YORK GIANTS" {
                                team1Label = "NEW YORK (G)"
                            } else if team1ListValue[0] == "NEW YORK JETS" {
                                team1Label = "NEW YORK (J)"
                            } else if team1ListValue[0] == "LOS ANGELES CHARGERS" {
                                team1Label = "LOS ANGELES (C)"
                            } else if team1ListValue[0] == "LOS ANGELES RAMS" {
                                team1Label = "LOS ANGELES (R)"
                            } else {
                                team1Label = team1ListValue[0]
                                var team1TextArray = team1Label.components(separatedBy: " ")
                                let team1TextArrayLength = team1TextArray.count
                                team1TextArray.remove(at: team1TextArrayLength - 1)
                                team1Label = team1TextArray.joined(separator: " ")
                            }
                            cell.textLabel?.text = rowTitle! + ", " + team1Label
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                        cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                        //print("seasonWinPercentageTeam1SliderFormValue: ")
                        //print(seasonWinPercentageTeam1SliderFormValue)
                    }
                
                <<< ButtonRow("SEASON WIN %, OPPONENT") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "SeasonWinPercentageTeam2Segue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if seasonWinPercentageTeam2SliderFormValue == "-10000" || (seasonWinPercentageTeam2RangeSliderLowerValue == seasonWinPercentageTeam2Values.first && seasonWinPercentageTeam2RangeSliderUpperValue == seasonWinPercentageTeam2Values.last) {
                            cell.detailTextLabel?.text = "IS ANY"
                        } else {
                            cell.detailTextLabel?.text = seasonWinPercentageTeam2OperatorText + seasonWinPercentageTeam2SliderFormValue
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        var rowTitle = row.tag
                        var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                        rowTitle = rowTitleTextArray?[0]
                        if team2ListValue == ["-10000"] || team2ListValue == [] || team2ListValue.count > 1 {
                            cell.textLabel?.text = row.tag
                        } else {
                            if team2ListValue[0] == "NEW YORK GIANTS" {
                                team2Label = "NEW YORK (G)"
                            } else if team2ListValue[0] == "NEW YORK JETS" {
                                team2Label = "NEW YORK (J)"
                            } else if team2ListValue[0] == "LOS ANGELES CHARGERS" {
                                team2Label = "LOS ANGELES (C)"
                            } else if team2ListValue[0] == "LOS ANGELES RAMS" {
                                team2Label = "LOS ANGELES (R)"
                            } else {
                                team2Label = team2ListValue[0]
                                var team2TextArray = team2Label.components(separatedBy: " ")
                                let team2TextArrayLength = team2TextArray.count
                                team2TextArray.remove(at: team2TextArrayLength - 1)
                                team2Label = team2TextArray.joined(separator: " ")
                            }
                            cell.textLabel?.text = rowTitle! + ", " + team2Label
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                        cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                        //print("seasonWinPercentageTeam2SliderFormValue: ")
                        //print(seasonWinPercentageTeam2SliderFormValue)
                    }
                
                
                ///  IN-GAME:  PLAYERS  ///
                +++ Section("IN-GAME:  PLAYERS"){ section in
                    var header = HeaderFooterView<UILabel>(.class)
                    header.height = { 30.0 }
                    header.onSetupView = {view, _ in
                        view.textColor = lightMediumGreyColor
                        view.text = "   IN-GAME:  PLAYERS"
                        view.font = thirteenBlackRoboto
                        view.baselineAdjustment = .alignCenters
                    }
                    section.header = header
                }
                
                <<< ButtonRow("PLAYERS, TEAM") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "PlayersSegue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if playerListValue == ["-10000"] || playerListValue == [] {
                            cell.detailTextLabel?.text = "INCLUDE ANY"
                        } else {
                            cell.detailTextLabel?.text = playerOperatorText + playerListValue.sorted().joined(separator: ", ")
                            cell.detailTextLabel?.textColor = orangeColorDarker
                            
                        }
                        var rowTitle = row.tag
                        var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                        rowTitle = rowTitleTextArray?[0]
                        if team1ListValue == ["-10000"] || team1ListValue == [] {
                            cell.textLabel?.text = row.tag
                        } else {
                            if team1ListValue[0] == "NEW YORK GIANTS" {
                                team1Label = "NEW YORK (G)"
                            } else if team1ListValue[0] == "NEW YORK JETS" {
                                team1Label = "NEW YORK (J)"
                            } else if team1ListValue[0] == "LOS ANGELES CHARGERS" {
                                team1Label = "LOS ANGELES (C)"
                            } else if team1ListValue[0] == "LOS ANGELES RAMS" {
                                team1Label = "LOS ANGELES (R)"
                            } else {
                                team1Label = team1ListValue[0]
                                var team1TextArray = team1Label.components(separatedBy: " ")
                                let team1TextArrayLength = team1TextArray.count
                                team1TextArray.remove(at: team1TextArrayLength - 1)
                                team1Label = team1TextArray.joined(separator: " ")
                            }
                            cell.textLabel?.text = rowTitle! + ", " + team1Label
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                        cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                }
                <<< ButtonRow("PLAYERS, OPPONENT") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "PlayerOpponentSegue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if playerOpponentListValue == ["-10000"] || playerOpponentListValue == [] {
                            cell.detailTextLabel?.text = "INCLUDE ANY"
                        } else {
                            cell.detailTextLabel?.text = playerOpponentOperatorText + playerOpponentListValue.sorted().joined(separator: ", ")
                            cell.detailTextLabel?.textColor = orangeColorDarker
                            
                        }
                        var rowTitle = row.tag
                        var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                        rowTitle = rowTitleTextArray?[0]
                        if team2ListValue == ["-10000"] || team2ListValue == [] {
                            cell.textLabel?.text = row.tag
                        } else {
                            if team2ListValue[0] == "NEW YORK GIANTS" {
                                team2Label = "NEW YORK (G)"
                            } else if team2ListValue[0] == "NEW YORK JETS" {
                                team2Label = "NEW YORK (J)"
                            } else if team2ListValue[0] == "LOS ANGELES CHARGERS" {
                                team2Label = "LOS ANGELES (C)"
                            } else if team2ListValue[0] == "LOS ANGELES RAMS" {
                                team2Label = "LOS ANGELES (R)"
                            } else {
                                team2Label = team2ListValue[0]
                                var team2TextArray = team2Label.components(separatedBy: " ")
                                let team2TextArrayLength = team2TextArray.count
                                team2TextArray.remove(at: team2TextArrayLength - 1)
                                team2Label = team2TextArray.joined(separator: " ")
                            }
                            cell.textLabel?.text = rowTitle! + ", " + team2Label
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                        cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                }
                
                ///  IN-GAME:  TEAM  ///
                +++ Section("IN-GAME:  TEAM"){ section in
                    var header = HeaderFooterView<UILabel>(.class)
                    header.height = { 30.0 }
                    header.onSetupView = {view, _ in
                        view.textColor = lightMediumGreyColor
                        view.text = "   IN-GAME:  TEAM"
                        view.font = thirteenBlackRoboto
                        view.baselineAdjustment = .alignCenters
                    }
                    section.header = header
                }
        
                <<< ButtonRow("TOTAL POINTS, TEAM") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "TotalPointsTeam1Segue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if totalPointsTeam1SliderFormValue == "-10000" || (totalPointsTeam1RangeSliderLowerValue == totalPointsTeam1Values.first && totalPointsTeam1RangeSliderUpperValue == totalPointsTeam1Values.last) {
                            cell.detailTextLabel?.text = "EQUAL ANY"
                        } else {
                            cell.detailTextLabel?.text = totalPointsTeam1OperatorText + totalPointsTeam1SliderFormValue
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        var rowTitle = row.tag
                        var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                        rowTitle = rowTitleTextArray?[0]
                        if team1ListValue == ["-10000"] || team1ListValue == [] {
                            cell.textLabel?.text = row.tag
                        } else {
                            if team1ListValue[0] == "NEW YORK GIANTS" {
                                team1Label = "NEW YORK (G)"
                            } else if team1ListValue[0] == "NEW YORK JETS" {
                                team1Label = "NEW YORK (J)"
                            } else if team1ListValue[0] == "LOS ANGELES CHARGERS" {
                                team1Label = "LOS ANGELES (C)"
                            } else if team1ListValue[0] == "LOS ANGELES RAMS" {
                                team1Label = "LOS ANGELES (R)"
                            } else {
                                team1Label = team1ListValue[0]
                                var team1TextArray = team1Label.components(separatedBy: " ")
                                let team1TextArrayLength = team1TextArray.count
                                team1TextArray.remove(at: team1TextArrayLength - 1)
                                team1Label = team1TextArray.joined(separator: " ")
                            }
                            cell.textLabel?.text = rowTitle! + ", " + team1Label
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                        cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                }
                
                <<< ButtonRow("TOTAL POINTS, OPPONENT") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "TotalPointsTeam2Segue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if totalPointsTeam2SliderFormValue == "-10000" || (totalPointsTeam2RangeSliderLowerValue == totalPointsTeam2Values.first && totalPointsTeam2RangeSliderUpperValue == totalPointsTeam2Values.last) {
                            cell.detailTextLabel?.text = "EQUAL ANY"
                        } else {
                            cell.detailTextLabel?.text = totalPointsTeam2OperatorText + totalPointsTeam2SliderFormValue
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        var rowTitle = row.tag
                        var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                        rowTitle = rowTitleTextArray?[0]
                        if team2ListValue == ["-10000"] || team2ListValue == [] || team2ListValue.count > 1 {
                            cell.textLabel?.text = row.tag
                        } else {
                            if team2ListValue[0] == "NEW YORK GIANTS" {
                                team2Label = "NEW YORK (G)"
                            } else if team2ListValue[0] == "NEW YORK JETS" {
                                team2Label = "NEW YORK (J)"
                            } else if team2ListValue[0] == "LOS ANGELES CHARGERS" {
                                team2Label = "LOS ANGELES (C)"
                            } else if team2ListValue[0] == "LOS ANGELES RAMS" {
                                team2Label = "LOS ANGELES (R)"
                            } else {
                                team2Label = team2ListValue[0]
                                var team2TextArray = team2Label.components(separatedBy: " ")
                                let team2TextArrayLength = team2TextArray.count
                                team2TextArray.remove(at: team2TextArrayLength - 1)
                                team2Label = team2TextArray.joined(separator: " ")
                            }
                            cell.textLabel?.text = rowTitle! + ", " + team2Label
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                        cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                }
                
                <<< ButtonRow("TOUCHDOWNS, TEAM") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "TouchdownsTeam1Segue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if touchdownsTeam1SliderFormValue == "-10000" || (touchdownsTeam1RangeSliderLowerValue == touchdownsTeam1Values.first && touchdownsTeam1RangeSliderUpperValue == touchdownsTeam1Values.last) {
                            cell.detailTextLabel?.text = "EQUAL ANY"
                        } else {
                            cell.detailTextLabel?.text = touchdownsTeam1OperatorText + touchdownsTeam1SliderFormValue
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        var rowTitle = row.tag
                        var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                        rowTitle = rowTitleTextArray?[0]
                        if team1ListValue == ["-10000"] || team1ListValue == [] {
                            cell.textLabel?.text = row.tag
                        } else {
                            if team1ListValue[0] == "NEW YORK GIANTS" {
                                team1Label = "NEW YORK (G)"
                            } else if team1ListValue[0] == "NEW YORK JETS" {
                                team1Label = "NEW YORK (J)"
                            } else if team1ListValue[0] == "LOS ANGELES CHARGERS" {
                                team1Label = "LOS ANGELES (C)"
                            } else if team1ListValue[0] == "LOS ANGELES RAMS" {
                                team1Label = "LOS ANGELES (R)"
                            } else {
                                team1Label = team1ListValue[0]
                                var team1TextArray = team1Label.components(separatedBy: " ")
                                let team1TextArrayLength = team1TextArray.count
                                team1TextArray.remove(at: team1TextArrayLength - 1)
                                team1Label = team1TextArray.joined(separator: " ")
                            }
                            cell.textLabel?.text = rowTitle! + ", " + team1Label
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                        cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                }
                
                <<< ButtonRow("TOUCHDOWNS, OPPONENT") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "TouchdownsTeam2Segue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if touchdownsTeam2SliderFormValue == "-10000" || (touchdownsTeam2RangeSliderLowerValue == touchdownsTeam2Values.first && touchdownsTeam2RangeSliderUpperValue == touchdownsTeam2Values.last) {
                            cell.detailTextLabel?.text = "EQUAL ANY"
                        } else {
                            cell.detailTextLabel?.text = touchdownsTeam2OperatorText + touchdownsTeam2SliderFormValue
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        var rowTitle = row.tag
                        var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                        rowTitle = rowTitleTextArray?[0]
                        if team2ListValue == ["-10000"] || team2ListValue == [] || team2ListValue.count > 1 {
                            cell.textLabel?.text = row.tag
                        } else {
                            if team2ListValue[0] == "NEW YORK GIANTS" {
                                team2Label = "NEW YORK (G)"
                            } else if team2ListValue[0] == "NEW YORK JETS" {
                                team2Label = "NEW YORK (J)"
                            } else if team2ListValue[0] == "LOS ANGELES CHARGERS" {
                                team2Label = "LOS ANGELES (C)"
                            } else if team2ListValue[0] == "LOS ANGELES RAMS" {
                                team2Label = "LOS ANGELES (R)"
                            } else {
                                team2Label = team2ListValue[0]
                                var team2TextArray = team2Label.components(separatedBy: " ")
                                let team2TextArrayLength = team2TextArray.count
                                team2TextArray.remove(at: team2TextArrayLength - 1)
                                team2Label = team2TextArray.joined(separator: " ")
                            }
                            cell.textLabel?.text = rowTitle! + ", " + team2Label
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                        cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                }
                
                <<< ButtonRow("TURNOVERS, TEAM") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "TurnoversCommittedTeam1Segue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        cell.textLabel?.font = twelveBold
                        if turnoversCommittedTeam1SliderFormValue == "-10000" || (turnoversCommittedTeam1RangeSliderLowerValue == turnoversCommittedTeam1Values.first && turnoversCommittedTeam1RangeSliderUpperValue == turnoversCommittedTeam1Values.last) {
                            cell.detailTextLabel?.text = "EQUAL ANY"
                        } else {
                            cell.detailTextLabel?.text = turnoversCommittedTeam1OperatorText + turnoversCommittedTeam1SliderFormValue
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        var rowTitle = row.tag
                        var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                        rowTitle = rowTitleTextArray?[0]
                        if team1ListValue == ["-10000"] || team1ListValue == [] {
                            cell.textLabel?.text = row.tag
                        } else {
                            if team1ListValue[0] == "NEW YORK GIANTS" {
                                team1Label = "NEW YORK (G)"
                            } else if team1ListValue[0] == "NEW YORK JETS" {
                                team1Label = "NEW YORK (J)"
                            } else if team1ListValue[0] == "LOS ANGELES CHARGERS" {
                                team1Label = "LOS ANGELES (C)"
                            } else if team1ListValue[0] == "LOS ANGELES RAMS" {
                                team1Label = "LOS ANGELES (R)"
                            } else {
                                team1Label = team1ListValue[0]
                                var team1TextArray = team1Label.components(separatedBy: " ")
                                let team1TextArrayLength = team1TextArray.count
                                team1TextArray.remove(at: team1TextArrayLength - 1)
                                team1Label = team1TextArray.joined(separator: " ")
                            }
                            cell.textLabel?.text = rowTitle! + ", " + team1Label
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                        cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                }
                
                <<< ButtonRow("TURNOVERS, OPPONENT") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "TurnoversCommittedTeam2Segue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if turnoversCommittedTeam2SliderFormValue == "-10000" || (turnoversCommittedTeam2RangeSliderLowerValue == turnoversCommittedTeam2Values.first && turnoversCommittedTeam2RangeSliderUpperValue == turnoversCommittedTeam2Values.last) {
                            cell.detailTextLabel?.text = "EQUAL ANY"
                        } else {
                            cell.detailTextLabel?.text = turnoversCommittedTeam2OperatorText + turnoversCommittedTeam2SliderFormValue
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        var rowTitle = row.tag
                        var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                        rowTitle = rowTitleTextArray?[0]
                        if team2ListValue == ["-10000"] || team2ListValue == [] || team2ListValue.count > 1 {
                            cell.textLabel?.text = row.tag
                        } else {
                            if team2ListValue[0] == "NEW YORK GIANTS" {
                                team2Label = "NEW YORK (G)"
                            } else if team2ListValue[0] == "NEW YORK JETS" {
                                team2Label = "NEW YORK (J)"
                            } else if team2ListValue[0] == "LOS ANGELES CHARGERS" {
                                team2Label = "LOS ANGELES (C)"
                            } else if team2ListValue[0] == "LOS ANGELES RAMS" {
                                team2Label = "LOS ANGELES (R)"
                            } else {
                                team2Label = team2ListValue[0]
                                var team2TextArray = team2Label.components(separatedBy: " ")
                                let team2TextArrayLength = team2TextArray.count
                                team2TextArray.remove(at: team2TextArrayLength - 1)
                                team2Label = team2TextArray.joined(separator: " ")
                            }
                            cell.textLabel?.text = rowTitle! + ", " + team2Label
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                        cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                }
                
                <<< ButtonRow("PENALTIES, TEAM") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "PenaltiesCommittedTeam1Segue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if penaltiesCommittedTeam1SliderFormValue == "-10000" || (penaltiesCommittedTeam1RangeSliderLowerValue == penaltiesCommittedTeam1Values.first && penaltiesCommittedTeam1RangeSliderUpperValue == penaltiesCommittedTeam1Values.last) {
                            cell.detailTextLabel?.text = "EQUAL ANY"
                        } else {
                            cell.detailTextLabel?.text = penaltiesCommittedTeam1OperatorText + penaltiesCommittedTeam1SliderFormValue
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        var rowTitle = row.tag
                        var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                        rowTitle = rowTitleTextArray?[0]
                        if team1ListValue == ["-10000"] || team1ListValue == [] {
                            cell.textLabel?.text = row.tag
                        } else {
                            if team1ListValue[0] == "NEW YORK GIANTS" {
                                team1Label = "NEW YORK (G)"
                            } else if team1ListValue[0] == "NEW YORK JETS" {
                                team1Label = "NEW YORK (J)"
                            } else if team1ListValue[0] == "LOS ANGELES CHARGERS" {
                                team1Label = "LOS ANGELES (C)"
                            } else if team1ListValue[0] == "LOS ANGELES RAMS" {
                                team1Label = "LOS ANGELES (R)"
                            } else {
                                team1Label = team1ListValue[0]
                                var team1TextArray = team1Label.components(separatedBy: " ")
                                let team1TextArrayLength = team1TextArray.count
                                team1TextArray.remove(at: team1TextArrayLength - 1)
                                team1Label = team1TextArray.joined(separator: " ")
                            }
                            cell.textLabel?.text = rowTitle! + ", " + team1Label
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                        cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                }
                
                <<< ButtonRow("PENALTIES, OPPONENT") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "PenaltiesCommittedTeam2Segue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if penaltiesCommittedTeam2SliderFormValue == "-10000" || (penaltiesCommittedTeam2RangeSliderLowerValue == penaltiesCommittedTeam2Values.first && penaltiesCommittedTeam2RangeSliderUpperValue == penaltiesCommittedTeam2Values.last) {
                            cell.detailTextLabel?.text = "EQUAL ANY"
                        } else {
                            cell.detailTextLabel?.text = penaltiesCommittedTeam2OperatorText + penaltiesCommittedTeam2SliderFormValue
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        var rowTitle = row.tag
                        var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                        rowTitle = rowTitleTextArray?[0]
                        if team2ListValue == ["-10000"] || team2ListValue == [] || team2ListValue.count > 1 {
                            cell.textLabel?.text = row.tag
                        } else {
                            if team2ListValue[0] == "NEW YORK GIANTS" {
                                team2Label = "NEW YORK (G)"
                            } else if team2ListValue[0] == "NEW YORK JETS" {
                                team2Label = "NEW YORK (J)"
                            } else if team2ListValue[0] == "LOS ANGELES CHARGERS" {
                                team2Label = "LOS ANGELES (C)"
                            } else if team2ListValue[0] == "LOS ANGELES RAMS" {
                                team2Label = "LOS ANGELES (R)"
                            } else {
                                team2Label = team2ListValue[0]
                                var team2TextArray = team2Label.components(separatedBy: " ")
                                let team2TextArrayLength = team2TextArray.count
                                team2TextArray.remove(at: team2TextArrayLength - 1)
                                team2Label = team2TextArray.joined(separator: " ")
                            }
                            cell.textLabel?.text = rowTitle! + ", " + team2Label
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                        cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                }
                
                ///  IN-GAME:  OFFENSE  ///
                +++ Section("IN-GAME:  OFFENSE"){ section in
                    var header = HeaderFooterView<UILabel>(.class)
                    header.height = { 30.0 }
                    header.onSetupView = {view, _ in
                        view.textColor = lightMediumGreyColor
                        view.text = "   IN-GAME:  OFFENSE"
                        view.font = thirteenBlackRoboto
                        view.baselineAdjustment = .alignCenters
                    }
                    section.header = header
                }
                
                <<< ButtonRow("OFFENSIVE TOUCHDOWNS, TEAM") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "OffensiveTouchdownsTeam1Segue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if offensiveTouchdownsTeam1SliderFormValue == "-10000" || (offensiveTouchdownsTeam1RangeSliderLowerValue == offensiveTouchdownsTeam1Values.first && offensiveTouchdownsTeam1RangeSliderUpperValue == offensiveTouchdownsTeam1Values.last) {
                            cell.detailTextLabel?.text = "EQUAL ANY"
                        } else {
                            cell.detailTextLabel?.text = offensiveTouchdownsTeam1OperatorText + offensiveTouchdownsTeam1SliderFormValue
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        var rowTitle = row.tag
                        var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                        rowTitle = rowTitleTextArray?[0]
                        if team1ListValue == ["-10000"] || team1ListValue == [] {
                            cell.textLabel?.text = row.tag
                        } else {
                            if team1ListValue[0] == "NEW YORK GIANTS" {
                                team1Label = "NEW YORK (G)"
                            } else if team1ListValue[0] == "NEW YORK JETS" {
                                team1Label = "NEW YORK (J)"
                            } else if team1ListValue[0] == "LOS ANGELES CHARGERS" {
                                team1Label = "LOS ANGELES (C)"
                            } else if team1ListValue[0] == "LOS ANGELES RAMS" {
                                team1Label = "LOS ANGELES (R)"
                            } else {
                                team1Label = team1ListValue[0]
                                var team1TextArray = team1Label.components(separatedBy: " ")
                                let team1TextArrayLength = team1TextArray.count
                                team1TextArray.remove(at: team1TextArrayLength - 1)
                                team1Label = team1TextArray.joined(separator: " ")
                            }
                            cell.textLabel?.text = rowTitle! + ", " + team1Label
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                        cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                }
                
                <<< ButtonRow("OFFENSIVE TOUCHDOWNS, OPPONENT") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "OffensiveTouchdownsTeam2Segue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if offensiveTouchdownsTeam2SliderFormValue == "-10000" || (offensiveTouchdownsTeam2RangeSliderLowerValue == offensiveTouchdownsTeam2Values.first && offensiveTouchdownsTeam2RangeSliderUpperValue == offensiveTouchdownsTeam2Values.last) {
                            cell.detailTextLabel?.text = "EQUAL ANY"
                        } else {
                            cell.detailTextLabel?.text = offensiveTouchdownsTeam2OperatorText + offensiveTouchdownsTeam2SliderFormValue
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        var rowTitle = row.tag
                        var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                        rowTitle = rowTitleTextArray?[0]
                        if team1ListValue == ["-10000"] || team1ListValue == [] {
                            cell.textLabel?.text = row.tag
                        } else {
                            if team1ListValue[0] == "NEW YORK GIANTS" {
                                team1Label = "NEW YORK (G)"
                            } else if team1ListValue[0] == "NEW YORK JETS" {
                                team1Label = "NEW YORK (J)"
                            } else if team1ListValue[0] == "LOS ANGELES CHARGERS" {
                                team1Label = "LOS ANGELES (C)"
                            } else if team1ListValue[0] == "LOS ANGELES RAMS" {
                                team1Label = "LOS ANGELES (R)"
                            } else {
                                team1Label = team1ListValue[0]
                                var team1TextArray = team1Label.components(separatedBy: " ")
                                let team1TextArrayLength = team1TextArray.count
                                team1TextArray.remove(at: team1TextArrayLength - 1)
                                team1Label = team1TextArray.joined(separator: " ")
                            }
                            cell.textLabel?.text = rowTitle! + ", " + team1Label
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                        cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                }
                
                <<< ButtonRow("TOTAL YARDS, TEAM") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "TotalYardsTeam1Segue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if totalYardsTeam1SliderFormValue == "-10000" || (totalYardsTeam1RangeSliderLowerValue == totalYardsTeam1Values.first && totalYardsTeam1RangeSliderUpperValue == totalYardsTeam1Values.last) {
                            cell.detailTextLabel?.text = "EQUAL ANY"
                        } else {
                            cell.detailTextLabel?.text = totalYardsTeam1OperatorText + totalYardsTeam1SliderFormValue
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        var rowTitle = row.tag
                        var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                        rowTitle = rowTitleTextArray?[0]
                        if team1ListValue == ["-10000"] || team1ListValue == [] {
                            cell.textLabel?.text = row.tag
                        } else {
                            if team1ListValue[0] == "NEW YORK GIANTS" {
                                team1Label = "NEW YORK (G)"
                            } else if team1ListValue[0] == "NEW YORK JETS" {
                                team1Label = "NEW YORK (J)"
                            } else if team1ListValue[0] == "LOS ANGELES CHARGERS" {
                                team1Label = "LOS ANGELES (C)"
                            } else if team1ListValue[0] == "LOS ANGELES RAMS" {
                                team1Label = "LOS ANGELES (R)"
                            } else {
                                team1Label = team1ListValue[0]
                                var team1TextArray = team1Label.components(separatedBy: " ")
                                let team1TextArrayLength = team1TextArray.count
                                team1TextArray.remove(at: team1TextArrayLength - 1)
                                team1Label = team1TextArray.joined(separator: " ")
                            }
                            cell.textLabel?.text = rowTitle! + ", " + team1Label
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                        cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                }
                
                <<< ButtonRow("TOTAL YARDS, OPPONENT") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "TotalYardsTeam2Segue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if totalYardsTeam2SliderFormValue == "-10000" || (totalYardsTeam2RangeSliderLowerValue == totalYardsTeam2Values.first && totalYardsTeam2RangeSliderUpperValue == totalYardsTeam2Values.last) {
                            cell.detailTextLabel?.text = "EQUAL ANY"
                        } else {
                            cell.detailTextLabel?.text = totalYardsTeam2OperatorText + totalYardsTeam2SliderFormValue
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        var rowTitle = row.tag
                        var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                        rowTitle = rowTitleTextArray?[0]
                        if team2ListValue == ["-10000"] || team2ListValue == [] || team2ListValue.count > 1 {
                            cell.textLabel?.text = row.tag
                        } else {
                            if team2ListValue[0] == "NEW YORK GIANTS" {
                                team2Label = "NEW YORK (G)"
                            } else if team2ListValue[0] == "NEW YORK JETS" {
                                team2Label = "NEW YORK (J)"
                            } else if team2ListValue[0] == "LOS ANGELES CHARGERS" {
                                team2Label = "LOS ANGELES (C)"
                            } else if team2ListValue[0] == "LOS ANGELES RAMS" {
                                team2Label = "LOS ANGELES (R)"
                            } else {
                                team2Label = team2ListValue[0]
                                var team2TextArray = team2Label.components(separatedBy: " ")
                                let team2TextArrayLength = team2TextArray.count
                                team2TextArray.remove(at: team2TextArrayLength - 1)
                                team2Label = team2TextArray.joined(separator: " ")
                            }
                            cell.textLabel?.text = rowTitle! + ", " + team2Label
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                        cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                }
                
                <<< ButtonRow("PASSING YARDS, TEAM") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "PassingYardsTeam1Segue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if passingYardsTeam1SliderFormValue == "-10000" || (passingYardsTeam1RangeSliderLowerValue == passingYardsTeam1Values.first && passingYardsTeam1RangeSliderUpperValue == passingYardsTeam1Values.last) {
                            cell.detailTextLabel?.text = "EQUAL ANY"
                        } else {
                            cell.detailTextLabel?.text = passingYardsTeam1OperatorText + passingYardsTeam1SliderFormValue
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        var rowTitle = row.tag
                        var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                        rowTitle = rowTitleTextArray?[0]
                        if team1ListValue == ["-10000"] || team1ListValue == [] {
                            cell.textLabel?.text = row.tag
                        } else {
                            if team1ListValue[0] == "NEW YORK GIANTS" {
                                team1Label = "NEW YORK (G)"
                            } else if team1ListValue[0] == "NEW YORK JETS" {
                                team1Label = "NEW YORK (J)"
                            } else if team1ListValue[0] == "LOS ANGELES CHARGERS" {
                                team1Label = "LOS ANGELES (C)"
                            } else if team1ListValue[0] == "LOS ANGELES RAMS" {
                                team1Label = "LOS ANGELES (R)"
                            } else {
                                team1Label = team1ListValue[0]
                                var team1TextArray = team1Label.components(separatedBy: " ")
                                let team1TextArrayLength = team1TextArray.count
                                team1TextArray.remove(at: team1TextArrayLength - 1)
                                team1Label = team1TextArray.joined(separator: " ")
                            }
                            cell.textLabel?.text = rowTitle! + ", " + team1Label
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                        cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                }
                
                <<< ButtonRow("PASSING YARDS, OPPONENT") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "PassingYardsTeam2Segue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if passingYardsTeam2SliderFormValue == "-10000" || (passingYardsTeam2RangeSliderLowerValue == passingYardsTeam2Values.first && passingYardsTeam2RangeSliderUpperValue == passingYardsTeam2Values.last) {
                            cell.detailTextLabel?.text = "EQUAL ANY"
                        } else {
                            cell.detailTextLabel?.text = passingYardsTeam2OperatorText + passingYardsTeam2SliderFormValue
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        var rowTitle = row.tag
                        var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                        rowTitle = rowTitleTextArray?[0]
                        if team2ListValue == ["-10000"] || team2ListValue == [] || team2ListValue.count > 1 {
                            cell.textLabel?.text = row.tag
                        } else {
                            if team2ListValue[0] == "NEW YORK GIANTS" {
                                team2Label = "NEW YORK (G)"
                            } else if team2ListValue[0] == "NEW YORK JETS" {
                                team2Label = "NEW YORK (J)"
                            } else if team2ListValue[0] == "LOS ANGELES CHARGERS" {
                                team2Label = "LOS ANGELES (C)"
                            } else if team2ListValue[0] == "LOS ANGELES RAMS" {
                                team2Label = "LOS ANGELES (R)"
                            } else {
                                team2Label = team2ListValue[0]
                                var team2TextArray = team2Label.components(separatedBy: " ")
                                let team2TextArrayLength = team2TextArray.count
                                team2TextArray.remove(at: team2TextArrayLength - 1)
                                team2Label = team2TextArray.joined(separator: " ")
                            }
                            cell.textLabel?.text = rowTitle! + ", " + team2Label
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                        cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                }
                
                <<< ButtonRow("RUSHING YARDS, TEAM") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "RushingYardsTeam1Segue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if rushingYardsTeam1SliderFormValue == "-10000" || (rushingYardsTeam1RangeSliderLowerValue == rushingYardsTeam1Values.first && rushingYardsTeam1RangeSliderUpperValue == rushingYardsTeam1Values.last) {
                            cell.detailTextLabel?.text = "EQUAL ANY"
                        } else {
                            cell.detailTextLabel?.text = rushingYardsTeam1OperatorText + rushingYardsTeam1SliderFormValue
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        var rowTitle = row.tag
                        var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                        rowTitle = rowTitleTextArray?[0]
                        if team1ListValue == ["-10000"] || team1ListValue == [] {
                            cell.textLabel?.text = row.tag
                        } else {
                            if team1ListValue[0] == "NEW YORK GIANTS" {
                                team1Label = "NEW YORK (G)"
                            } else if team1ListValue[0] == "NEW YORK JETS" {
                                team1Label = "NEW YORK (J)"
                            } else if team1ListValue[0] == "LOS ANGELES CHARGERS" {
                                team1Label = "LOS ANGELES (C)"
                            } else if team1ListValue[0] == "LOS ANGELES RAMS" {
                                team1Label = "LOS ANGELES (R)"
                            } else {
                                team1Label = team1ListValue[0]
                                var team1TextArray = team1Label.components(separatedBy: " ")
                                let team1TextArrayLength = team1TextArray.count
                                team1TextArray.remove(at: team1TextArrayLength - 1)
                                team1Label = team1TextArray.joined(separator: " ")
                            }
                            cell.textLabel?.text = rowTitle! + ", " + team1Label
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                        cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                }
                
                <<< ButtonRow("RUSHING YARDS, OPPONENT") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "RushingYardsTeam2Segue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if rushingYardsTeam2SliderFormValue == "-10000" || (rushingYardsTeam2RangeSliderLowerValue == rushingYardsTeam2Values.first && rushingYardsTeam2RangeSliderUpperValue == rushingYardsTeam2Values.last) {
                            cell.detailTextLabel?.text = "EQUAL ANY"
                        } else {
                            cell.detailTextLabel?.text = rushingYardsTeam2OperatorText + rushingYardsTeam2SliderFormValue
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        var rowTitle = row.tag
                        var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                        rowTitle = rowTitleTextArray?[0]
                        if team2ListValue == ["-10000"] || team2ListValue == [] || team2ListValue.count > 1 {
                            cell.textLabel?.text = row.tag
                        } else {
                            if team2ListValue[0] == "NEW YORK GIANTS" {
                                team2Label = "NEW YORK (G)"
                            } else if team2ListValue[0] == "NEW YORK JETS" {
                                team2Label = "NEW YORK (J)"
                            } else if team2ListValue[0] == "LOS ANGELES CHARGERS" {
                                team2Label = "LOS ANGELES (C)"
                            } else if team2ListValue[0] == "LOS ANGELES RAMS" {
                                team2Label = "LOS ANGELES (R)"
                            } else {
                                team2Label = team2ListValue[0]
                                var team2TextArray = team2Label.components(separatedBy: " ")
                                let team2TextArrayLength = team2TextArray.count
                                team2TextArray.remove(at: team2TextArrayLength - 1)
                                team2Label = team2TextArray.joined(separator: " ")
                            }
                            cell.textLabel?.text = rowTitle! + ", " + team2Label
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                        cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                }
                
                <<< ButtonRow("QUARTERBACK RATING, TEAM") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "QuarterbackRatingTeam1Segue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if quarterbackRatingTeam1SliderFormValue == "-10000" || (quarterbackRatingTeam1RangeSliderLowerValue == quarterbackRatingTeam1Values.first && quarterbackRatingTeam1RangeSliderUpperValue == quarterbackRatingTeam1Values.last) {
                            cell.detailTextLabel?.text = "EQUAL ANY"
                        } else {
                            cell.detailTextLabel?.text = quarterbackRatingTeam1OperatorText + quarterbackRatingTeam1SliderFormValue
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        var rowTitle = row.tag
                        var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                        rowTitle = rowTitleTextArray?[0]
                        if team1ListValue == ["-10000"] || team1ListValue == [] {
                            cell.textLabel?.text = row.tag
                        } else {
                            if team1ListValue[0] == "NEW YORK GIANTS" {
                                team1Label = "NEW YORK (G)"
                            } else if team1ListValue[0] == "NEW YORK JETS" {
                                team1Label = "NEW YORK (J)"
                            } else if team1ListValue[0] == "LOS ANGELES CHARGERS" {
                                team1Label = "LOS ANGELES (C)"
                            } else if team1ListValue[0] == "LOS ANGELES RAMS" {
                                team1Label = "LOS ANGELES (R)"
                            } else {
                                team1Label = team1ListValue[0]
                                var team1TextArray = team1Label.components(separatedBy: " ")
                                let team1TextArrayLength = team1TextArray.count
                                team1TextArray.remove(at: team1TextArrayLength - 1)
                                team1Label = team1TextArray.joined(separator: " ")
                            }
                            cell.textLabel?.text = rowTitle! + ", " + team1Label
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                        cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                }
                
                <<< ButtonRow("QUARTERBACK RATING, OPPONENT") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "QuarterbackRatingTeam2Segue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if quarterbackRatingTeam2SliderFormValue == "-10000" || (quarterbackRatingTeam2RangeSliderLowerValue == quarterbackRatingTeam2Values.first && quarterbackRatingTeam2RangeSliderUpperValue == quarterbackRatingTeam2Values.last) {
                            cell.detailTextLabel?.text = "EQUAL ANY"
                        } else {
                            cell.detailTextLabel?.text = quarterbackRatingTeam2OperatorText + quarterbackRatingTeam2SliderFormValue
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        var rowTitle = row.tag
                        var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                        rowTitle = rowTitleTextArray?[0]
                        if team2ListValue == ["-10000"] || team2ListValue == [] || team2ListValue.count > 1 {
                            cell.textLabel?.text = row.tag
                        } else {
                            if team2ListValue[0] == "NEW YORK GIANTS" {
                                team2Label = "NEW YORK (G)"
                            } else if team2ListValue[0] == "NEW YORK JETS" {
                                team2Label = "NEW YORK (J)"
                            } else if team2ListValue[0] == "LOS ANGELES CHARGERS" {
                                team2Label = "LOS ANGELES (C)"
                            } else if team2ListValue[0] == "LOS ANGELES RAMS" {
                                team2Label = "LOS ANGELES (R)"
                            } else {
                                team2Label = team2ListValue[0]
                                var team2TextArray = team2Label.components(separatedBy: " ")
                                let team2TextArrayLength = team2TextArray.count
                                team2TextArray.remove(at: team2TextArrayLength - 1)
                                team2Label = team2TextArray.joined(separator: " ")
                            }
                            cell.textLabel?.text = rowTitle! + ", " + team2Label
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                        cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                }
                
                /*<<< ButtonRow("TIMES SACKED, TEAM") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "TimesSackedTeam1Segue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if timesSackedTeam1SliderFormValue == "-10000" || (timesSackedTeam1RangeSliderLowerValue == timesSackedTeam1Values.first && timesSackedTeam1RangeSliderUpperValue == timesSackedTeam1Values.last) {
                            cell.detailTextLabel?.text = "EQUAL ANY"
                        } else {
                            cell.detailTextLabel?.text = timesSackedTeam1OperatorText + timesSackedTeam1SliderFormValue
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        var rowTitle = row.tag
                        var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                        rowTitle = rowTitleTextArray?[0]
                        if team1ListValue == ["-10000"] || team1ListValue == [] {
                            cell.textLabel?.text = row.tag
                        } else {
                            if team1ListValue[0] == "NEW YORK GIANTS" {
                                team1Label = "NEW YORK (G)"
                            } else if team1ListValue[0] == "NEW YORK JETS" {
                                team1Label = "NEW YORK (J)"
                            } else if team1ListValue[0] == "LOS ANGELES CHARGERS" {
                                team1Label = "LOS ANGELES (C)"
                            } else if team1ListValue[0] == "LOS ANGELES RAMS" {
                                team1Label = "LOS ANGELES (R)"
                            } else {
                                team1Label = team1ListValue[0]
                                var team1TextArray = team1Label.components(separatedBy: " ")
                                let team1TextArrayLength = team1TextArray.count
                                team1TextArray.remove(at: team1TextArrayLength - 1)
                                team1Label = team1TextArray.joined(separator: " ")
                            }
                            cell.textLabel?.text = rowTitle! + ", " + team1Label
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                }
                
                <<< ButtonRow("TIMES SACKED, OPPONENT") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "TimesSackedTeam2Segue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if timesSackedTeam2SliderFormValue == "-10000" || (timesSackedTeam2RangeSliderLowerValue == timesSackedTeam2Values.first && timesSackedTeam2RangeSliderUpperValue == timesSackedTeam2Values.last) {
                            cell.detailTextLabel?.text = "EQUAL ANY"
                        } else {
                            cell.detailTextLabel?.text = timesSackedTeam2OperatorText + timesSackedTeam2SliderFormValue
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        var rowTitle = row.tag
                        var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                        rowTitle = rowTitleTextArray?[0]
                        if team2ListValue == ["-10000"] || team2ListValue == [] || team2ListValue.count > 1 {
                            cell.textLabel?.text = row.tag
                        } else {
                            if team2ListValue[0] == "NEW YORK GIANTS" {
                                team2Label = "NEW YORK (G)"
                            } else if team2ListValue[0] == "NEW YORK JETS" {
                                team2Label = "NEW YORK (J)"
                            } else if team2ListValue[0] == "LOS ANGELES CHARGERS" {
                                team2Label = "LOS ANGELES (C)"
                            } else if team2ListValue[0] == "LOS ANGELES RAMS" {
                                team2Label = "LOS ANGELES (R)"
                            } else {
                                team2Label = team2ListValue[0]
                                var team2TextArray = team2Label.components(separatedBy: " ")
                                let team2TextArrayLength = team2TextArray.count
                                team2TextArray.remove(at: team2TextArrayLength - 1)
                                team2Label = team2TextArray.joined(separator: " ")
                            }
                            cell.textLabel?.text = rowTitle! + ", " + team2Label
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                }
            
                <<< ButtonRow("INTERCEPTIONS THROWN, TEAM") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "InterceptionsThrownTeam1Segue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if interceptionsThrownTeam1SliderFormValue == "-10000" || (interceptionsThrownTeam1RangeSliderLowerValue == interceptionsThrownTeam1Values.first && interceptionsThrownTeam1RangeSliderUpperValue == interceptionsThrownTeam1Values.last) {
                            cell.detailTextLabel?.text = "EQUAL ANY"
                        } else {
                            cell.detailTextLabel?.text = interceptionsThrownTeam1OperatorText + interceptionsThrownTeam1SliderFormValue
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        var rowTitle = row.tag
                        var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                        rowTitle = rowTitleTextArray?[0]
                        if team1ListValue == ["-10000"] || team1ListValue == [] {
                            cell.textLabel?.text = row.tag
                        } else {
                            if team1ListValue[0] == "NEW YORK GIANTS" {
                                team1Label = "NEW YORK (G)"
                            } else if team1ListValue[0] == "NEW YORK JETS" {
                                team1Label = "NEW YORK (J)"
                            } else if team1ListValue[0] == "LOS ANGELES CHARGERS" {
                                team1Label = "LOS ANGELES (C)"
                            } else if team1ListValue[0] == "LOS ANGELES RAMS" {
                                team1Label = "LOS ANGELES (R)"
                            } else {
                                team1Label = team1ListValue[0]
                                var team1TextArray = team1Label.components(separatedBy: " ")
                                let team1TextArrayLength = team1TextArray.count
                                team1TextArray.remove(at: team1TextArrayLength - 1)
                                team1Label = team1TextArray.joined(separator: " ")
                            }
                            cell.textLabel?.text = rowTitle! + ", " + team1Label
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                }
                
                <<< ButtonRow("INTERCEPTIONS THROWN, OPPONENT") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "InterceptionsThrownTeam2Segue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if interceptionsThrownTeam2SliderFormValue == "-10000" || (interceptionsThrownTeam2RangeSliderLowerValue == interceptionsThrownTeam2Values.first && interceptionsThrownTeam2RangeSliderUpperValue == interceptionsThrownTeam2Values.last) {
                            cell.detailTextLabel?.text = "EQUAL ANY"
                        } else {
                            cell.detailTextLabel?.text = interceptionsThrownTeam2OperatorText + interceptionsThrownTeam2SliderFormValue
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        var rowTitle = row.tag
                        var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                        rowTitle = rowTitleTextArray?[0]
                        if team2ListValue == ["-10000"] || team2ListValue == [] || team2ListValue.count > 1 {
                            cell.textLabel?.text = row.tag
                        } else {
                            if team2ListValue[0] == "NEW YORK GIANTS" {
                                team2Label = "NEW YORK (G)"
                            } else if team2ListValue[0] == "NEW YORK JETS" {
                                team2Label = "NEW YORK (J)"
                            } else if team2ListValue[0] == "LOS ANGELES CHARGERS" {
                                team2Label = "LOS ANGELES (C)"
                            } else if team2ListValue[0] == "LOS ANGELES RAMS" {
                                team2Label = "LOS ANGELES (R)"
                            } else {
                                team2Label = team2ListValue[0]
                                var team2TextArray = team2Label.components(separatedBy: " ")
                                let team2TextArrayLength = team2TextArray.count
                                team2TextArray.remove(at: team2TextArrayLength - 1)
                                team2Label = team2TextArray.joined(separator: " ")
                            }
                            cell.textLabel?.text = rowTitle! + ", " + team2Label
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                }
                */
                
                <<< ButtonRow("OFFENSIVE PLAYS, TEAM") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "OffensivePlaysTeam1Segue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if offensivePlaysTeam1SliderFormValue == "-10000" || (offensivePlaysTeam1RangeSliderLowerValue == offensivePlaysTeam1Values.first && offensivePlaysTeam1RangeSliderUpperValue == offensivePlaysTeam1Values.last) {
                            cell.detailTextLabel?.text = "EQUAL ANY"
                        } else {
                            cell.detailTextLabel?.text = offensivePlaysTeam1OperatorText + offensivePlaysTeam1SliderFormValue
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        var rowTitle = row.tag
                        var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                        rowTitle = rowTitleTextArray?[0]
                        if team1ListValue == ["-10000"] || team1ListValue == [] {
                            cell.textLabel?.text = row.tag
                        } else {
                            if team1ListValue[0] == "NEW YORK GIANTS" {
                                team1Label = "NEW YORK (G)"
                            } else if team1ListValue[0] == "NEW YORK JETS" {
                                team1Label = "NEW YORK (J)"
                            } else if team1ListValue[0] == "LOS ANGELES CHARGERS" {
                                team1Label = "LOS ANGELES (C)"
                            } else if team1ListValue[0] == "LOS ANGELES RAMS" {
                                team1Label = "LOS ANGELES (R)"
                            } else {
                                team1Label = team1ListValue[0]
                                var team1TextArray = team1Label.components(separatedBy: " ")
                                let team1TextArrayLength = team1TextArray.count
                                team1TextArray.remove(at: team1TextArrayLength - 1)
                                team1Label = team1TextArray.joined(separator: " ")
                            }
                            cell.textLabel?.text = rowTitle! + ", " + team1Label
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                        cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                }
                
                <<< ButtonRow("OFFENSIVE PLAYS, OPPONENT") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "OffensivePlaysTeam2Segue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if offensivePlaysTeam2SliderFormValue == "-10000" || (offensivePlaysTeam2RangeSliderLowerValue == offensivePlaysTeam2Values.first && offensivePlaysTeam2RangeSliderUpperValue == offensivePlaysTeam2Values.last) {
                            cell.detailTextLabel?.text = "EQUAL ANY"
                        } else {
                            cell.detailTextLabel?.text = offensivePlaysTeam2OperatorText + offensivePlaysTeam2SliderFormValue
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        
                        var rowTitle = row.tag
                        var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                        rowTitle = rowTitleTextArray?[0]
                        if team2ListValue == ["-10000"] || team2ListValue == [] || team2ListValue.count > 1 {
                            cell.textLabel?.text = row.tag
                        } else {
                            if team2ListValue[0] == "NEW YORK GIANTS" {
                                team2Label = "NEW YORK (G)"
                            } else if team2ListValue[0] == "NEW YORK JETS" {
                                team2Label = "NEW YORK (J)"
                            } else if team2ListValue[0] == "LOS ANGELES CHARGERS" {
                                team2Label = "LOS ANGELES (C)"
                            } else if team2ListValue[0] == "LOS ANGELES RAMS" {
                                team2Label = "LOS ANGELES (R)"
                            } else {
                                team2Label = team2ListValue[0]
                                var team2TextArray = team2Label.components(separatedBy: " ")
                                let team2TextArrayLength = team2TextArray.count
                                team2TextArray.remove(at: team2TextArrayLength - 1)
                                team2Label = team2TextArray.joined(separator: " ")
                            }
                            cell.textLabel?.text = rowTitle! + ", " + team2Label
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                        cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
    
                }
                
                <<< ButtonRow("YARDS/OFFENSIVE PLAY, TEAM") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "YardsPerOffensivePlayTeam1Segue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if yardsPerOffensivePlayTeam1SliderFormValue == "-10000" || (yardsPerOffensivePlayTeam1RangeSliderLowerValue == yardsPerOffensivePlayTeam1Values.first && yardsPerOffensivePlayTeam1RangeSliderUpperValue == yardsPerOffensivePlayTeam1Values.last) {
                            cell.detailTextLabel?.text = "EQUAL ANY"
                        } else {
                            cell.detailTextLabel?.text = yardsPerOffensivePlayTeam1OperatorText + yardsPerOffensivePlayTeam1SliderFormValue
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        var rowTitle = row.tag
                        var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                        rowTitle = rowTitleTextArray?[0]
                        if team1ListValue == ["-10000"] || team1ListValue == [] {
                            cell.textLabel?.text = row.tag
                        } else {
                            if team1ListValue[0] == "NEW YORK GIANTS" {
                                team1Label = "NEW YORK (G)"
                            } else if team1ListValue[0] == "NEW YORK JETS" {
                                team1Label = "NEW YORK (J)"
                            } else if team1ListValue[0] == "LOS ANGELES CHARGERS" {
                                team1Label = "LOS ANGELES (C)"
                            } else if team1ListValue[0] == "LOS ANGELES RAMS" {
                                team1Label = "LOS ANGELES (R)"
                            } else {
                                team1Label = team1ListValue[0]
                                var team1TextArray = team1Label.components(separatedBy: " ")
                                let team1TextArrayLength = team1TextArray.count
                                team1TextArray.remove(at: team1TextArrayLength - 1)
                                team1Label = team1TextArray.joined(separator: " ")
                            }
                            cell.textLabel?.text = rowTitle! + ", " + team1Label
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                        cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                }
                
                <<< ButtonRow("YARDS/OFFENSIVE PLAY, OPPONENT") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "YardsPerOffensivePlayTeam2Segue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if yardsPerOffensivePlayTeam2SliderFormValue == "-10000" || (yardsPerOffensivePlayTeam2RangeSliderLowerValue == yardsPerOffensivePlayTeam2Values.first && yardsPerOffensivePlayTeam2RangeSliderUpperValue == yardsPerOffensivePlayTeam2Values.last) {
                            cell.detailTextLabel?.text = "EQUAL ANY"
                        } else {
                            cell.detailTextLabel?.text = yardsPerOffensivePlayTeam2OperatorText + yardsPerOffensivePlayTeam2SliderFormValue
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        var rowTitle = row.tag
                        var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                        rowTitle = rowTitleTextArray?[0]
                        if team2ListValue == ["-10000"] || team2ListValue == [] || team2ListValue.count > 1 {
                            cell.textLabel?.text = row.tag
                        } else {
                            if team2ListValue[0] == "NEW YORK GIANTS" {
                                team2Label = "NEW YORK (G)"
                            } else if team2ListValue[0] == "NEW YORK JETS" {
                                team2Label = "NEW YORK (J)"
                            } else if team2ListValue[0] == "LOS ANGELES CHARGERS" {
                                team2Label = "LOS ANGELES (C)"
                            } else if team2ListValue[0] == "LOS ANGELES RAMS" {
                                team2Label = "LOS ANGELES (R)"
                            } else {
                                team2Label = team2ListValue[0]
                                var team2TextArray = team2Label.components(separatedBy: " ")
                                let team2TextArrayLength = team2TextArray.count
                                team2TextArray.remove(at: team2TextArrayLength - 1)
                                team2Label = team2TextArray.joined(separator: " ")
                            }
                            cell.textLabel?.text = rowTitle! + ", " + team2Label
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                        cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                }
                
                ///  IN-GAME:  DEFENSE  ///
                +++ Section("IN-GAME:  DEFENSE"){ section in
                    var header = HeaderFooterView<UILabel>(.class)
                    header.height = { 30.0 }
                    header.onSetupView = {view, _ in
                        view.textColor = lightMediumGreyColor
                        view.text = "   IN-GAME:  DEFENSE"
                        view.font = thirteenBlackRoboto
                        view.baselineAdjustment = .alignCenters
                    }
                    section.header = header
                }
                
                <<< ButtonRow("DEFENSIVE TOUCHDOWNS, TEAM") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "DefensiveTouchdownsTeam1Segue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if defensiveTouchdownsTeam1SliderFormValue == "-10000" || (defensiveTouchdownsTeam1RangeSliderLowerValue == defensiveTouchdownsTeam1Values.first && defensiveTouchdownsTeam1RangeSliderUpperValue == defensiveTouchdownsTeam1Values.last) {
                            cell.detailTextLabel?.text = "EQUAL ANY"
                        } else {
                            cell.detailTextLabel?.text = defensiveTouchdownsTeam1OperatorText + defensiveTouchdownsTeam1SliderFormValue
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        var rowTitle = row.tag
                        var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                        rowTitle = rowTitleTextArray?[0]
                        if team1ListValue == ["-10000"] || team1ListValue == [] {
                            cell.textLabel?.text = row.tag
                        } else {
                            if team1ListValue[0] == "NEW YORK GIANTS" {
                                team1Label = "NEW YORK (G)"
                            } else if team1ListValue[0] == "NEW YORK JETS" {
                                team1Label = "NEW YORK (J)"
                            } else if team1ListValue[0] == "LOS ANGELES CHARGERS" {
                                team1Label = "LOS ANGELES (C)"
                            } else if team1ListValue[0] == "LOS ANGELES RAMS" {
                                team1Label = "LOS ANGELES (R)"
                            } else {
                                team1Label = team1ListValue[0]
                                var team1TextArray = team1Label.components(separatedBy: " ")
                                let team1TextArrayLength = team1TextArray.count
                                team1TextArray.remove(at: team1TextArrayLength - 1)
                                team1Label = team1TextArray.joined(separator: " ")
                            }
                            cell.textLabel?.text = rowTitle! + ", " + team1Label
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                        cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                }
                
                <<< ButtonRow("DEFENSIVE TOUCHDOWNS, OPPONENT") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "DefensiveTouchdownsTeam2Segue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if defensiveTouchdownsTeam2SliderFormValue == "-10000" || (defensiveTouchdownsTeam2RangeSliderLowerValue == defensiveTouchdownsTeam2Values.first && defensiveTouchdownsTeam2RangeSliderUpperValue == defensiveTouchdownsTeam2Values.last) {
                            cell.detailTextLabel?.text = "EQUAL ANY"
                        } else {
                            cell.detailTextLabel?.text = defensiveTouchdownsTeam2OperatorText + defensiveTouchdownsTeam2SliderFormValue
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        var rowTitle = row.tag
                        var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                        rowTitle = rowTitleTextArray?[0]
                        if team1ListValue == ["-10000"] || team1ListValue == [] {
                            cell.textLabel?.text = row.tag
                        } else {
                            if team1ListValue[0] == "NEW YORK GIANTS" {
                                team1Label = "NEW YORK (G)"
                            } else if team1ListValue[0] == "NEW YORK JETS" {
                                team1Label = "NEW YORK (J)"
                            } else if team1ListValue[0] == "LOS ANGELES CHARGERS" {
                                team1Label = "LOS ANGELES (C)"
                            } else if team1ListValue[0] == "LOS ANGELES RAMS" {
                                team1Label = "LOS ANGELES (R)"
                            } else {
                                team1Label = team1ListValue[0]
                                var team1TextArray = team1Label.components(separatedBy: " ")
                                let team1TextArrayLength = team1TextArray.count
                                team1TextArray.remove(at: team1TextArrayLength - 1)
                                team1Label = team1TextArray.joined(separator: " ")
                            }
                            cell.textLabel?.text = rowTitle! + ", " + team1Label
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                        cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                }
                
                <<< ButtonRow("SACKS, TEAM") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "DefensiveSacksTeam1Segue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if sacksTeam1SliderFormValue == "-10000" || (sacksTeam1RangeSliderLowerValue == sacksTeam1Values.first && sacksTeam1RangeSliderUpperValue == sacksTeam1Values.last) {
                            cell.detailTextLabel?.text = "EQUAL ANY"
                        } else {
                            cell.detailTextLabel?.text = sacksTeam1OperatorText + sacksTeam1SliderFormValue
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        var rowTitle = row.tag
                        var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                        rowTitle = rowTitleTextArray?[0]
                        if team1ListValue == ["-10000"] || team1ListValue == [] {
                            cell.textLabel?.text = row.tag
                        } else {
                            if team1ListValue[0] == "NEW YORK GIANTS" {
                                team1Label = "NEW YORK (G)"
                            } else if team1ListValue[0] == "NEW YORK JETS" {
                                team1Label = "NEW YORK (J)"
                            } else if team1ListValue[0] == "LOS ANGELES CHARGERS" {
                                team1Label = "LOS ANGELES (C)"
                            } else if team1ListValue[0] == "LOS ANGELES RAMS" {
                                team1Label = "LOS ANGELES (R)"
                            } else {
                                team1Label = team1ListValue[0]
                                var team1TextArray = team1Label.components(separatedBy: " ")
                                let team1TextArrayLength = team1TextArray.count
                                team1TextArray.remove(at: team1TextArrayLength - 1)
                                team1Label = team1TextArray.joined(separator: " ")
                            }
                            cell.textLabel?.text = rowTitle! + ", " + team1Label
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                        cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                }
                
                <<< ButtonRow("SACKS, OPPONENT") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "DefensiveSacksTeam2Segue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if sacksTeam2SliderFormValue == "-10000" || (sacksTeam2RangeSliderLowerValue == sacksTeam2Values.first && sacksTeam2RangeSliderUpperValue == sacksTeam2Values.last) {
                            cell.detailTextLabel?.text = "EQUAL ANY"
                        } else {
                            cell.detailTextLabel?.text = sacksTeam2OperatorText + sacksTeam2SliderFormValue
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        var rowTitle = row.tag
                        var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                        rowTitle = rowTitleTextArray?[0]
                        if team2ListValue == ["-10000"] || team2ListValue == [] || team2ListValue.count > 1 {
                            cell.textLabel?.text = row.tag
                        } else {
                            if team2ListValue[0] == "NEW YORK GIANTS" {
                                team2Label = "NEW YORK (G)"
                            } else if team2ListValue[0] == "NEW YORK JETS" {
                                team2Label = "NEW YORK (J)"
                            } else if team2ListValue[0] == "LOS ANGELES CHARGERS" {
                                team2Label = "LOS ANGELES (C)"
                            } else if team2ListValue[0] == "LOS ANGELES RAMS" {
                                team2Label = "LOS ANGELES (R)"
                            } else {
                                team2Label = team2ListValue[0]
                                var team2TextArray = team2Label.components(separatedBy: " ")
                                let team2TextArrayLength = team2TextArray.count
                                team2TextArray.remove(at: team2TextArrayLength - 1)
                                team2Label = team2TextArray.joined(separator: " ")
                            }
                            cell.textLabel?.text = rowTitle! + ", " + team2Label
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                        cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                }
                
                <<< ButtonRow("INTERCEPTIONS, TEAM") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "DefensiveInterceptionsTeam1Segue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if interceptionsTeam1SliderFormValue == "-10000" || (interceptionsTeam1RangeSliderLowerValue == interceptionsTeam1Values.first && interceptionsTeam1RangeSliderUpperValue == interceptionsTeam1Values.last) {
                            cell.detailTextLabel?.text = "EQUAL ANY"
                        } else {
                            cell.detailTextLabel?.text = interceptionsTeam1OperatorText + interceptionsTeam1SliderFormValue
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        var rowTitle = row.tag
                        var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                        rowTitle = rowTitleTextArray?[0]
                        if team1ListValue == ["-10000"] || team1ListValue == [] {
                            cell.textLabel?.text = row.tag
                        } else {
                            if team1ListValue[0] == "NEW YORK GIANTS" {
                                team1Label = "NEW YORK (G)"
                            } else if team1ListValue[0] == "NEW YORK JETS" {
                                team1Label = "NEW YORK (J)"
                            } else if team1ListValue[0] == "LOS ANGELES CHARGERS" {
                                team1Label = "LOS ANGELES (C)"
                            } else if team1ListValue[0] == "LOS ANGELES RAMS" {
                                team1Label = "LOS ANGELES (R)"
                            } else {
                                team1Label = team1ListValue[0]
                                var team1TextArray = team1Label.components(separatedBy: " ")
                                let team1TextArrayLength = team1TextArray.count
                                team1TextArray.remove(at: team1TextArrayLength - 1)
                                team1Label = team1TextArray.joined(separator: " ")
                            }
                            cell.textLabel?.text = rowTitle! + ", " + team1Label
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                        cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                }
                
                <<< ButtonRow("INTERCEPTIONS, OPPONENT") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "DefensiveInterceptionsTeam2Segue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if interceptionsTeam2SliderFormValue == "-10000" || (interceptionsTeam2RangeSliderLowerValue == interceptionsTeam2Values.first && interceptionsTeam2RangeSliderUpperValue == interceptionsTeam2Values.last) {
                            cell.detailTextLabel?.text = "EQUAL ANY"
                        } else {
                            cell.detailTextLabel?.text = interceptionsTeam2OperatorText + interceptionsTeam2SliderFormValue
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        var rowTitle = row.tag
                        var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                        rowTitle = rowTitleTextArray?[0]
                        if team2ListValue == ["-10000"] || team2ListValue == [] || team2ListValue.count > 1 {
                            cell.textLabel?.text = row.tag
                        } else {
                            if team2ListValue[0] == "NEW YORK GIANTS" {
                                team2Label = "NEW YORK (G)"
                            } else if team2ListValue[0] == "NEW YORK JETS" {
                                team2Label = "NEW YORK (J)"
                            } else if team2ListValue[0] == "LOS ANGELES CHARGERS" {
                                team2Label = "LOS ANGELES (C)"
                            } else if team2ListValue[0] == "LOS ANGELES RAMS" {
                                team2Label = "LOS ANGELES (R)"
                            } else {
                                team2Label = team2ListValue[0]
                                var team2TextArray = team2Label.components(separatedBy: " ")
                                let team2TextArrayLength = team2TextArray.count
                                team2TextArray.remove(at: team2TextArrayLength - 1)
                                team2Label = team2TextArray.joined(separator: " ")
                            }
                            cell.textLabel?.text = rowTitle! + ", " + team2Label
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                        cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                }
                
                <<< ButtonRow("SAFETIES, TEAM") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "SafetiesTeam1Segue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if safetiesTeam1SliderFormValue == "-10000" || (safetiesTeam1RangeSliderLowerValue == safetiesTeam1Values.first && safetiesTeam1RangeSliderUpperValue == safetiesTeam1Values.last) {
                            cell.detailTextLabel?.text = "EQUAL ANY"
                        } else {
                            cell.detailTextLabel?.text = safetiesTeam1OperatorText + safetiesTeam1SliderFormValue
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        var rowTitle = row.tag
                        var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                        rowTitle = rowTitleTextArray?[0]
                        if team1ListValue == ["-10000"] || team1ListValue == [] {
                            cell.textLabel?.text = row.tag
                        } else {
                            if team1ListValue[0] == "NEW YORK GIANTS" {
                                team1Label = "NEW YORK (G)"
                            } else if team1ListValue[0] == "NEW YORK JETS" {
                                team1Label = "NEW YORK (J)"
                            } else if team1ListValue[0] == "LOS ANGELES CHARGERS" {
                                team1Label = "LOS ANGELES (C)"
                            } else if team1ListValue[0] == "LOS ANGELES RAMS" {
                                team1Label = "LOS ANGELES (R)"
                            } else {
                                team1Label = team1ListValue[0]
                                var team1TextArray = team1Label.components(separatedBy: " ")
                                let team1TextArrayLength = team1TextArray.count
                                team1TextArray.remove(at: team1TextArrayLength - 1)
                                team1Label = team1TextArray.joined(separator: " ")
                            }
                            cell.textLabel?.text = rowTitle! + ", " + team1Label
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                        cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                }
                
                <<< ButtonRow("SAFETIES, OPPONENT") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "SafetiesTeam2Segue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if safetiesTeam2SliderFormValue == "-10000" || (safetiesTeam2RangeSliderLowerValue == safetiesTeam2Values.first && safetiesTeam2RangeSliderUpperValue == safetiesTeam2Values.last) {
                            cell.detailTextLabel?.text = "EQUAL ANY"
                        } else {
                            cell.detailTextLabel?.text = safetiesTeam2OperatorText + safetiesTeam2SliderFormValue
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        var rowTitle = row.tag
                        var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                        rowTitle = rowTitleTextArray?[0]
                        if team2ListValue == ["-10000"] || team2ListValue == [] || team2ListValue.count > 1 {
                            cell.textLabel?.text = row.tag
                        } else {
                            if team2ListValue[0] == "NEW YORK GIANTS" {
                                team2Label = "NEW YORK (G)"
                            } else if team2ListValue[0] == "NEW YORK JETS" {
                                team2Label = "NEW YORK (J)"
                            } else if team2ListValue[0] == "LOS ANGELES CHARGERS" {
                                team2Label = "LOS ANGELES (C)"
                            } else if team2ListValue[0] == "LOS ANGELES RAMS" {
                                team2Label = "LOS ANGELES (R)"
                            } else {
                                team2Label = team2ListValue[0]
                                var team2TextArray = team2Label.components(separatedBy: " ")
                                let team2TextArrayLength = team2TextArray.count
                                team2TextArray.remove(at: team2TextArrayLength - 1)
                                team2Label = team2TextArray.joined(separator: " ")
                            }
                            cell.textLabel?.text = rowTitle! + ", " + team2Label
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                        cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                }
                /*
                <<< ButtonRow("DEFENSIVE PLAYS, TEAM") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "DefensivePlaysTeam1Segue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if defensivePlaysTeam1SliderFormValue == "-10000" || (defensivePlaysTeam1RangeSliderLowerValue == defensivePlaysTeam1Values.first && defensivePlaysTeam1RangeSliderUpperValue == defensivePlaysTeam1Values.last) {
                            cell.detailTextLabel?.text = "EQUAL ANY"
                        } else {
                            cell.detailTextLabel?.text = defensivePlaysTeam1OperatorText + defensivePlaysTeam1SliderFormValue
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        var rowTitle = row.tag
                        var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                        rowTitle = rowTitleTextArray?[0]
                        if team1ListValue == ["-10000"] || team1ListValue == [] {
                            cell.textLabel?.text = row.tag
                        } else {
                            if team1ListValue[0] == "NEW YORK GIANTS" {
                                team1Label = "NEW YORK (G)"
                            } else if team1ListValue[0] == "NEW YORK JETS" {
                                team1Label = "NEW YORK (J)"
                            } else if team1ListValue[0] == "LOS ANGELES CHARGERS" {
                                team1Label = "LOS ANGELES (C)"
                            } else if team1ListValue[0] == "LOS ANGELES RAMS" {
                                team1Label = "LOS ANGELES (R)"
                            } else {
                                team1Label = team1ListValue[0]
                                var team1TextArray = team1Label.components(separatedBy: " ")
                                let team1TextArrayLength = team1TextArray.count
                                team1TextArray.remove(at: team1TextArrayLength - 1)
                                team1Label = team1TextArray.joined(separator: " ")
                            }
                            cell.textLabel?.text = rowTitle! + ", " + team1Label
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                }
                
                <<< ButtonRow("DEFENSIVE PLAYS, OPPONENT") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "DefensivePlaysTeam2Segue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if defensivePlaysTeam2SliderFormValue == "-10000" || (defensivePlaysTeam2RangeSliderLowerValue == defensivePlaysTeam2Values.first && defensivePlaysTeam2RangeSliderUpperValue == defensivePlaysTeam2Values.last) {
                            cell.detailTextLabel?.text = "EQUAL ANY"
                        } else {
                            cell.detailTextLabel?.text = defensivePlaysTeam2OperatorText + defensivePlaysTeam2SliderFormValue
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        var rowTitle = row.tag
                        var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                        rowTitle = rowTitleTextArray?[0]
                        if team2ListValue == ["-10000"] || team2ListValue == [] || team2ListValue.count > 1 {
                            cell.textLabel?.text = row.tag
                        } else {
                            if team2ListValue[0] == "NEW YORK GIANTS" {
                                team2Label = "NEW YORK (G)"
                            } else if team2ListValue[0] == "NEW YORK JETS" {
                                team2Label = "NEW YORK (J)"
                            } else if team2ListValue[0] == "LOS ANGELES CHARGERS" {
                                team2Label = "LOS ANGELES (C)"
                            } else if team2ListValue[0] == "LOS ANGELES RAMS" {
                                team2Label = "LOS ANGELES (R)"
                            } else {
                                team2Label = team2ListValue[0]
                                var team2TextArray = team2Label.components(separatedBy: " ")
                                let team2TextArrayLength = team2TextArray.count
                                team2TextArray.remove(at: team2TextArrayLength - 1)
                                team2Label = team2TextArray.joined(separator: " ")
                            }
                            cell.textLabel?.text = rowTitle! + ", " + team2Label
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                }
                
                <<< ButtonRow("YARDS/DEFENSIVE PLAY, TEAM") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "YardsPerDefensivePlayTeam1Segue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if yardsPerDefensivePlayTeam1SliderFormValue == "-10000" || (yardsPerDefensivePlayTeam1RangeSliderLowerValue == yardsPerDefensivePlayTeam1Values.first && yardsPerDefensivePlayTeam1RangeSliderUpperValue == yardsPerDefensivePlayTeam1Values.last) {
                            cell.detailTextLabel?.text = "EQUAL ANY"
                        } else {
                            cell.detailTextLabel?.text = yardsPerDefensivePlayTeam1OperatorText + yardsPerDefensivePlayTeam1SliderFormValue
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        var rowTitle = row.tag
                        var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                        rowTitle = rowTitleTextArray?[0]
                        if team1ListValue == ["-10000"] || team1ListValue == [] {
                            cell.textLabel?.text = row.tag
                        } else {
                            if team1ListValue[0] == "NEW YORK GIANTS" {
                                team1Label = "NEW YORK (G)"
                            } else if team1ListValue[0] == "NEW YORK JETS" {
                                team1Label = "NEW YORK (J)"
                            } else if team1ListValue[0] == "LOS ANGELES CHARGERS" {
                                team1Label = "LOS ANGELES (C)"
                            } else if team1ListValue[0] == "LOS ANGELES RAMS" {
                                team1Label = "LOS ANGELES (R)"
                            } else {
                                team1Label = team1ListValue[0]
                                var team1TextArray = team1Label.components(separatedBy: " ")
                                let team1TextArrayLength = team1TextArray.count
                                team1TextArray.remove(at: team1TextArrayLength - 1)
                                team1Label = team1TextArray.joined(separator: " ")
                            }
                            cell.textLabel?.text = rowTitle! + ", " + team1Label
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                }
                
                <<< ButtonRow("YARDS/DEFENSIVE PLAY, OPPONENT") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "YardsPerDefensivePlayTeam2Segue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if yardsPerDefensivePlayTeam2SliderFormValue == "-10000" || (yardsPerDefensivePlayTeam2RangeSliderLowerValue == yardsPerDefensivePlayTeam2Values.first && yardsPerDefensivePlayTeam2RangeSliderUpperValue == yardsPerDefensivePlayTeam2Values.last) {
                            cell.detailTextLabel?.text = "EQUAL ANY"
                        } else {
                            cell.detailTextLabel?.text = yardsPerDefensivePlayTeam2OperatorText + yardsPerDefensivePlayTeam2SliderFormValue
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        var rowTitle = row.tag
                        var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                        rowTitle = rowTitleTextArray?[0]
                        if team2ListValue == ["-10000"] || team2ListValue == [] || team2ListValue.count > 1 {
                            cell.textLabel?.text = row.tag
                        } else {
                            if team2ListValue[0] == "NEW YORK GIANTS" {
                                team2Label = "NEW YORK (G)"
                            } else if team2ListValue[0] == "NEW YORK JETS" {
                                team2Label = "NEW YORK (J)"
                            } else if team2ListValue[0] == "LOS ANGELES CHARGERS" {
                                team2Label = "LOS ANGELES (C)"
                            } else if team2ListValue[0] == "LOS ANGELES RAMS" {
                                team2Label = "LOS ANGELES (R)"
                            } else {
                                team2Label = team2ListValue[0]
                                var team2TextArray = team2Label.components(separatedBy: " ")
                                let team2TextArrayLength = team2TextArray.count
                                team2TextArray.remove(at: team2TextArrayLength - 1)
                                team2Label = team2TextArray.joined(separator: " ")
                            }
                            cell.textLabel?.text = rowTitle! + ", " + team2Label
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                }*/

                ///  IN-GAME:  SPECIAL TEAMS  ///
                +++ Section("IN-GAME:  SPECIAL TEAMS"){ section in
                    var header = HeaderFooterView<UILabel>(.class)
                    header.height = { 30.0 }
                    header.onSetupView = {view, _ in
                        view.textColor = lightMediumGreyColor
                        view.text = "   IN-GAME:  SPECIAL TEAMS"
                        view.font = thirteenBlackRoboto
                        view.baselineAdjustment = .alignCenters
                    }
                    section.header = header
                }
                
                /*<<< ButtonRow("EXTRA POINT ATTEMPTS, TEAM") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "ExtraPointAttemptsTeam1Segue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if extraPointAttemptsTeam1SliderFormValue == "-10000" || (extraPointAttemptsTeam1RangeSliderLowerValue == extraPointAttemptsTeam1Values.first && extraPointAttemptsTeam1RangeSliderUpperValue == extraPointAttemptsTeam1Values.last) {
                            cell.detailTextLabel?.text = " EQUAL " + "ANY"
                        } else {
                            cell.detailTextLabel?.text = extraPointAttemptsTeam1OperatorText + extraPointAttemptsTeam1SliderFormValue
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                }
                
                <<< ButtonRow("EXTRA POINT ATTEMPTS, OPPONENT") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "ExtraPointAttemptsTeam2Segue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if extraPointAttemptsTeam2SliderFormValue == "-10000" || (extraPointAttemptsTeam2RangeSliderLowerValue == extraPointAttemptsTeam2Values.first && extraPointAttemptsTeam2RangeSliderUpperValue == extraPointAttemptsTeam2Values.last) {
                            cell.detailTextLabel?.text = " EQUAL " + "ANY"
                        } else {
                            cell.detailTextLabel?.text = extraPointAttemptsTeam2OperatorText + extraPointAttemptsTeam2SliderFormValue
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                }*/
                
                /*<<< ButtonRow("EXTRA POINTS MADE, TEAM") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "ExtraPointsMadeTeam1Segue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if extraPointsMadeTeam1SliderFormValue == "-10000" || (extraPointsMadeTeam1RangeSliderLowerValue == extraPointsMadeTeam1Values.first && extraPointsMadeTeam1RangeSliderUpperValue == extraPointsMadeTeam1Values.last) {
                            cell.detailTextLabel?.text = "EQUAL ANY"
                        } else {
                            cell.detailTextLabel?.text = extraPointsMadeTeam1OperatorText + extraPointsMadeTeam1SliderFormValue
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        var rowTitle = row.tag
                        var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                        rowTitle = rowTitleTextArray?[0]
                        if team1ListValue == ["-10000"] || team1ListValue == [] {
                            cell.textLabel?.text = row.tag
                        } else {
                            if team1ListValue[0] == "NEW YORK GIANTS" {
                                team1Label = "NEW YORK (G)"
                            } else if team1ListValue[0] == "NEW YORK JETS" {
                                team1Label = "NEW YORK (J)"
                            } else if team1ListValue[0] == "LOS ANGELES CHARGERS" {
                                team1Label = "LOS ANGELES (C)"
                            } else if team1ListValue[0] == "LOS ANGELES RAMS" {
                                team1Label = "LOS ANGELES (R)"
                            } else {
                                team1Label = team1ListValue[0]
                                var team1TextArray = team1Label.components(separatedBy: " ")
                                let team1TextArrayLength = team1TextArray.count
                                team1TextArray.remove(at: team1TextArrayLength - 1)
                                team1Label = team1TextArray.joined(separator: " ")
                            }
                            cell.textLabel?.text = rowTitle! + ", " + team1Label
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                }
                
                <<< ButtonRow("EXTRA POINTS MADE, OPPONENT") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "ExtraPointsMadeTeam2Segue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if extraPointsMadeTeam2SliderFormValue == "-10000" || (extraPointsMadeTeam2RangeSliderLowerValue == extraPointsMadeTeam2Values.first && extraPointsMadeTeam2RangeSliderUpperValue == extraPointsMadeTeam2Values.last) {
                            cell.detailTextLabel?.text = "EQUAL ANY"
                        } else {
                            cell.detailTextLabel?.text = extraPointsMadeTeam2OperatorText + extraPointsMadeTeam2SliderFormValue
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        var rowTitle = row.tag
                        var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                        rowTitle = rowTitleTextArray?[0]
                        if team2ListValue == ["-10000"] || team2ListValue == [] || team2ListValue.count > 1 {
                            cell.textLabel?.text = row.tag
                        } else {
                            if team2ListValue[0] == "NEW YORK GIANTS" {
                                team2Label = "NEW YORK (G)"
                            } else if team2ListValue[0] == "NEW YORK JETS" {
                                team2Label = "NEW YORK (J)"
                            } else if team2ListValue[0] == "LOS ANGELES CHARGERS" {
                                team2Label = "LOS ANGELES (C)"
                            } else if team2ListValue[0] == "LOS ANGELES RAMS" {
                                team2Label = "LOS ANGELES (R)"
                            } else {
                                team2Label = team2ListValue[0]
                                var team2TextArray = team2Label.components(separatedBy: " ")
                                let team2TextArrayLength = team2TextArray.count
                                team2TextArray.remove(at: team2TextArrayLength - 1)
                                team2Label = team2TextArray.joined(separator: " ")
                            }
                            cell.textLabel?.text = rowTitle! + ", " + team2Label
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                }
                */
                
                
                <<< ButtonRow("FIELD GOAL ATTEMPTS, TEAM") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "FieldGoalAttemptsTeam1Segue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if fieldGoalAttemptsTeam1SliderFormValue == "-10000" || (fieldGoalAttemptsTeam1RangeSliderLowerValue == fieldGoalAttemptsTeam1Values.first && fieldGoalAttemptsTeam1RangeSliderUpperValue == fieldGoalAttemptsTeam1Values.last) {
                            cell.detailTextLabel?.text = "EQUAL ANY"
                        } else {
                            cell.detailTextLabel?.text = fieldGoalAttemptsTeam1OperatorText + fieldGoalAttemptsTeam1SliderFormValue
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        var rowTitle = row.tag
                        var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                        rowTitle = rowTitleTextArray?[0]
                        if team1ListValue == ["-10000"] || team1ListValue == [] {
                            cell.textLabel?.text = row.tag
                        } else {
                            if team1ListValue[0] == "NEW YORK GIANTS" {
                                team1Label = "NEW YORK (G)"
                            } else if team1ListValue[0] == "NEW YORK JETS" {
                                team1Label = "NEW YORK (J)"
                            } else if team1ListValue[0] == "LOS ANGELES CHARGERS" {
                                team1Label = "LOS ANGELES (C)"
                            } else if team1ListValue[0] == "LOS ANGELES RAMS" {
                                team1Label = "LOS ANGELES (R)"
                            } else {
                                team1Label = team1ListValue[0]
                                var team1TextArray = team1Label.components(separatedBy: " ")
                                let team1TextArrayLength = team1TextArray.count
                                team1TextArray.remove(at: team1TextArrayLength - 1)
                                team1Label = team1TextArray.joined(separator: " ")
                            }
                            cell.textLabel?.text = rowTitle! + ", " + team1Label
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                        cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                }
                
                <<< ButtonRow("FIELD GOAL ATTEMPTS, OPPONENT") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "FieldGoalAttemptsTeam2Segue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if fieldGoalAttemptsTeam2SliderFormValue == "-10000" || (fieldGoalAttemptsTeam2RangeSliderLowerValue == fieldGoalAttemptsTeam2Values.first && fieldGoalAttemptsTeam2RangeSliderUpperValue == fieldGoalAttemptsTeam2Values.last) {
                            cell.detailTextLabel?.text = "EQUAL ANY"
                        } else {
                            cell.detailTextLabel?.text = fieldGoalAttemptsTeam2OperatorText + fieldGoalAttemptsTeam2SliderFormValue
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        var rowTitle = row.tag
                        var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                        rowTitle = rowTitleTextArray?[0]
                        if team2ListValue == ["-10000"] || team2ListValue == [] || team2ListValue.count > 1 {
                            cell.textLabel?.text = row.tag
                        } else {
                            if team2ListValue[0] == "NEW YORK GIANTS" {
                                team2Label = "NEW YORK (G)"
                            } else if team2ListValue[0] == "NEW YORK JETS" {
                                team2Label = "NEW YORK (J)"
                            } else if team2ListValue[0] == "LOS ANGELES CHARGERS" {
                                team2Label = "LOS ANGELES (C)"
                            } else if team2ListValue[0] == "LOS ANGELES RAMS" {
                                team2Label = "LOS ANGELES (R)"
                            } else {
                                team2Label = team2ListValue[0]
                                var team2TextArray = team2Label.components(separatedBy: " ")
                                let team2TextArrayLength = team2TextArray.count
                                team2TextArray.remove(at: team2TextArrayLength - 1)
                                team2Label = team2TextArray.joined(separator: " ")
                            }
                            cell.textLabel?.text = rowTitle! + ", " + team2Label
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                        cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                }
                
                <<< ButtonRow("FIELD GOALS MADE, TEAM") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "FieldGoalsMadeTeam1Segue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if fieldGoalsMadeTeam1SliderFormValue == "-10000" || (fieldGoalsMadeTeam1RangeSliderLowerValue == fieldGoalsMadeTeam1Values.first && fieldGoalsMadeTeam1RangeSliderUpperValue == fieldGoalsMadeTeam1Values.last) {
                            cell.detailTextLabel?.text = "EQUAL ANY"
                        } else {
                            cell.detailTextLabel?.text = fieldGoalsMadeTeam1OperatorText + fieldGoalsMadeTeam1SliderFormValue
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        var rowTitle = row.tag
                        var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                        rowTitle = rowTitleTextArray?[0]
                        if team1ListValue == ["-10000"] || team1ListValue == [] {
                            cell.textLabel?.text = row.tag
                        } else {
                            if team1ListValue[0] == "NEW YORK GIANTS" {
                                team1Label = "NEW YORK (G)"
                            } else if team1ListValue[0] == "NEW YORK JETS" {
                                team1Label = "NEW YORK (J)"
                            } else if team1ListValue[0] == "LOS ANGELES CHARGERS" {
                                team1Label = "LOS ANGELES (C)"
                            } else if team1ListValue[0] == "LOS ANGELES RAMS" {
                                team1Label = "LOS ANGELES (R)"
                            } else {
                                team1Label = team1ListValue[0]
                                var team1TextArray = team1Label.components(separatedBy: " ")
                                let team1TextArrayLength = team1TextArray.count
                                team1TextArray.remove(at: team1TextArrayLength - 1)
                                team1Label = team1TextArray.joined(separator: " ")
                            }
                            cell.textLabel?.text = rowTitle! + ", " + team1Label
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                        cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                }
                
                <<< ButtonRow("FIELD GOALS MADE, OPPONENT") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "FieldGoalsMadeTeam2Segue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if fieldGoalsMadeTeam2SliderFormValue == "-10000" || (fieldGoalsMadeTeam2RangeSliderLowerValue == fieldGoalsMadeTeam2Values.first && fieldGoalsMadeTeam2RangeSliderUpperValue == fieldGoalsMadeTeam2Values.last) {
                            cell.detailTextLabel?.text = "EQUAL ANY"
                        } else {
                            cell.detailTextLabel?.text = fieldGoalsMadeTeam2OperatorText + fieldGoalsMadeTeam2SliderFormValue
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        var rowTitle = row.tag
                        var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                        rowTitle = rowTitleTextArray?[0]
                        if team2ListValue == ["-10000"] || team2ListValue == [] || team2ListValue.count > 1 {
                            cell.textLabel?.text = row.tag
                        } else {
                            if team2ListValue[0] == "NEW YORK GIANTS" {
                                team2Label = "NEW YORK (G)"
                            } else if team2ListValue[0] == "NEW YORK JETS" {
                                team2Label = "NEW YORK (J)"
                            } else if team2ListValue[0] == "LOS ANGELES CHARGERS" {
                                team2Label = "LOS ANGELES (C)"
                            } else if team2ListValue[0] == "LOS ANGELES RAMS" {
                                team2Label = "LOS ANGELES (R)"
                            } else {
                                team2Label = team2ListValue[0]
                                var team2TextArray = team2Label.components(separatedBy: " ")
                                let team2TextArrayLength = team2TextArray.count
                                team2TextArray.remove(at: team2TextArrayLength - 1)
                                team2Label = team2TextArray.joined(separator: " ")
                            }
                            cell.textLabel?.text = rowTitle! + ", " + team2Label
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                        cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                }
                
                <<< ButtonRow("PUNTS, TEAM") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "PuntsTeam1Segue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if puntsTeam1SliderFormValue == "-10000" || (puntsTeam1RangeSliderLowerValue == puntsTeam1Values.first && puntsTeam1RangeSliderUpperValue == puntsTeam1Values.last) {
                            cell.detailTextLabel?.text = "EQUAL ANY"
                        } else {
                            cell.detailTextLabel?.text = puntsTeam1OperatorText + puntsTeam1SliderFormValue
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        var rowTitle = row.tag
                        var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                        rowTitle = rowTitleTextArray?[0]
                        if team1ListValue == ["-10000"] || team1ListValue == [] {
                            cell.textLabel?.text = row.tag
                        } else {
                            if team1ListValue[0] == "NEW YORK GIANTS" {
                                team1Label = "NEW YORK (G)"
                            } else if team1ListValue[0] == "NEW YORK JETS" {
                                team1Label = "NEW YORK (J)"
                            } else if team1ListValue[0] == "LOS ANGELES CHARGERS" {
                                team1Label = "LOS ANGELES (C)"
                            } else if team1ListValue[0] == "LOS ANGELES RAMS" {
                                team1Label = "LOS ANGELES (R)"
                            } else {
                                team1Label = team1ListValue[0]
                                var team1TextArray = team1Label.components(separatedBy: " ")
                                let team1TextArrayLength = team1TextArray.count
                                team1TextArray.remove(at: team1TextArrayLength - 1)
                                team1Label = team1TextArray.joined(separator: " ")
                            }
                            cell.textLabel?.text = rowTitle! + ", " + team1Label
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                        cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                }
                
                <<< ButtonRow("PUNTS, OPPONENT") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "PuntsTeam2Segue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if puntsTeam2SliderFormValue == "-10000" || (puntsTeam2RangeSliderLowerValue == puntsTeam2Values.first && puntsTeam2RangeSliderUpperValue == puntsTeam2Values.last) {
                            cell.detailTextLabel?.text = "EQUAL ANY"
                        } else {
                            cell.detailTextLabel?.text = puntsTeam2OperatorText + puntsTeam2SliderFormValue
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        var rowTitle = row.tag
                        var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                        rowTitle = rowTitleTextArray?[0]
                        if team2ListValue == ["-10000"] || team2ListValue == [] || team2ListValue.count > 1 {
                            cell.textLabel?.text = row.tag
                        } else {
                            if team2ListValue[0] == "NEW YORK GIANTS" {
                                team2Label = "NEW YORK (G)"
                            } else if team2ListValue[0] == "NEW YORK JETS" {
                                team2Label = "NEW YORK (J)"
                            } else if team2ListValue[0] == "LOS ANGELES CHARGERS" {
                                team2Label = "LOS ANGELES (C)"
                            } else if team2ListValue[0] == "LOS ANGELES RAMS" {
                                team2Label = "LOS ANGELES (R)"
                            } else {
                                team2Label = team2ListValue[0]
                                var team2TextArray = team2Label.components(separatedBy: " ")
                                let team2TextArrayLength = team2TextArray.count
                                team2TextArray.remove(at: team2TextArrayLength - 1)
                                team2Label = team2TextArray.joined(separator: " ")
                            }
                            cell.textLabel?.text = rowTitle! + ", " + team2Label
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                        cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                }
            
                <<< ButtonRow("PUNT YARDS, TEAM") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "PuntYardsTeam1Segue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if puntYardsTeam1SliderFormValue == "-10000" || (puntYardsTeam1RangeSliderLowerValue == puntYardsTeam1Values.first && puntYardsTeam1RangeSliderUpperValue == puntYardsTeam1Values.last) {
                            cell.detailTextLabel?.text = "EQUAL ANY"
                        } else {
                            cell.detailTextLabel?.text = puntYardsTeam1OperatorText + puntYardsTeam1SliderFormValue
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        var rowTitle = row.tag
                        var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                        rowTitle = rowTitleTextArray?[0]
                        if team1ListValue == ["-10000"] || team1ListValue == [] {
                            cell.textLabel?.text = row.tag
                        } else {
                            if team1ListValue[0] == "NEW YORK GIANTS" {
                                team1Label = "NEW YORK (G)"
                            } else if team1ListValue[0] == "NEW YORK JETS" {
                                team1Label = "NEW YORK (J)"
                            } else if team1ListValue[0] == "LOS ANGELES CHARGERS" {
                                team1Label = "LOS ANGELES (C)"
                            } else if team1ListValue[0] == "LOS ANGELES RAMS" {
                                team1Label = "LOS ANGELES (R)"
                            } else {
                                team1Label = team1ListValue[0]
                                var team1TextArray = team1Label.components(separatedBy: " ")
                                let team1TextArrayLength = team1TextArray.count
                                team1TextArray.remove(at: team1TextArrayLength - 1)
                                team1Label = team1TextArray.joined(separator: " ")
                            }
                            cell.textLabel?.text = rowTitle! + ", " + team1Label
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                        cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                }
                
                <<< ButtonRow("PUNT YARDS, OPPONENT") { row in
                    row.title = row.tag
                    row.presentationMode = .segueName(segueName: "PuntYardsTeam2Segue", onDismiss: nil)
                    } .cellUpdate { cell, row in
                        if puntYardsTeam2SliderFormValue == "-10000" || (puntYardsTeam2RangeSliderLowerValue == puntYardsTeam2Values.first && puntYardsTeam2RangeSliderUpperValue == puntYardsTeam2Values.last) {
                            cell.detailTextLabel?.text = "EQUAL ANY"
                        } else {
                            cell.detailTextLabel?.text = puntYardsTeam2OperatorText + puntYardsTeam2SliderFormValue
                            cell.detailTextLabel?.textColor = orangeColorDarker
                        }
                        var rowTitle = row.tag
                        var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                        rowTitle = rowTitleTextArray?[0]
                        if team2ListValue == ["-10000"] || team2ListValue == [] || team2ListValue.count > 1 {
                            cell.textLabel?.text = row.tag
                        } else {
                            if team2ListValue[0] == "NEW YORK GIANTS" {
                                team2Label = "NEW YORK (G)"
                            } else if team2ListValue[0] == "NEW YORK JETS" {
                                team2Label = "NEW YORK (J)"
                            } else if team2ListValue[0] == "LOS ANGELES CHARGERS" {
                                team2Label = "LOS ANGELES (C)"
                            } else if team2ListValue[0] == "LOS ANGELES RAMS" {
                                team2Label = "LOS ANGELES (R)"
                            } else {
                                team2Label = team2ListValue[0]
                                var team2TextArray = team2Label.components(separatedBy: " ")
                                let team2TextArrayLength = team2TextArray.count
                                team2TextArray.remove(at: team2TextArrayLength - 1)
                                team2Label = team2TextArray.joined(separator: " ")
                            }
                            cell.textLabel?.text = rowTitle! + ", " + team2Label
                        }
                        cell.textLabel?.font = twelveSemiboldSFCompact
                        cell.detailTextLabel?.font = twelveThinSFCompact
                        cell.textLabel?.addTextSpacing(spacing: -0.3)
                        cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                }
            
        } else {
            print("TeamViewController teamPlayerIndicator: ")
            print(teamPlayerIndicator)
        }
    }
////////////////////////////////////////////////////////////////////////////////////////////////////////
    @objc func reloadRow() {
        if tagText == "tagText" {
            print("Nothing to reload.")
        } else {
            let rowTagText = rowdictionary[tagText]!
             print("Row updated for: " + rowTagText)
            self.form.rowBy(tag: rowTagText)?.reload()
        }
        self.tableView.reloadData()
        if searchBarStatus == "INACTIVE" {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "teamDashboardNotification"), object: nil)
        } else {
            print("Dashboard pending search bar exit")
        }
        
    }
////////////////////////////////////////////////////////////////////////////////////////////////////////
    func updateDashboardAfterClearSelections() {
        //print("updateDashboardAfterClearSelections()")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "teamDashboardNotification"), object: nil)
    }
////////////////////////////////////////////////////////////////////////////////////////////////////////
    func clearSelections() {
        //print("clearSelections()")
        ////////// LIST VALUES //////////
        team1ListValue = ["-10000"]
        team2ListValue = ["-10000"]
        homeTeamListValue = ["-10000"]
        favoriteListValue = ["-10000"]
        playerListValue = ["-10000"]
		playerOpponentListValue = ["-10000"]
        dayListValue = ["-10000"]
        stadiumListValue = ["-10000"]
        surfaceListValue = ["-10000"]
        ////////// MULTI-SELECTION BOOLEAN //////////
        team1MultipleSelectionBool = false
        team2MultipleSelectionBool = true
        homeTeamMultipleSelectionBool = true
        favoriteMultipleSelectionBool = true
        playerMultipleSelectionBool = true
		playerOpponentMultipleSelectionBool = true
        dayMultipleSelectionBool = true
        stadiumMultipleSelectionBool = true
        surfaceMultipleSelectionBool = true
        ////////// SLIDER VALUES //////////
        winningLosingStreakTeam1SliderValue =  Float(-10000)
        winningLosingStreakTeam2SliderValue =  Float(-10000)
        seasonWinPercentageTeam1SliderValue =  Float(-10000)
        seasonWinPercentageTeam2SliderValue =  Float(-10000)
        seasonSliderValue =  Float(-10000)
        gameNumberSliderValue =  Float(-10000)
        temperatureSliderValue =  Float(-10000)
        totalPointsTeam1SliderValue =  Float(-10000)
        totalPointsTeam2SliderValue =  Float(-10000)
        touchdownsTeam1SliderValue =  Float(-10000)
        touchdownsTeam2SliderValue =  Float(-10000)
        offensiveTouchdownsTeam1SliderValue =  Float(-10000)
        offensiveTouchdownsTeam2SliderValue =  Float(-10000)
        defensiveTouchdownsTeam1SliderValue =  Float(-10000)
        defensiveTouchdownsTeam2SliderValue =  Float(-10000)
        turnoversCommittedTeam1SliderValue =  Float(-10000)
        turnoversCommittedTeam2SliderValue =  Float(-10000)
        penaltiesCommittedTeam1SliderValue =  Float(-10000)
        penaltiesCommittedTeam2SliderValue =  Float(-10000)
        totalYardsTeam1SliderValue =  Float(-10000)
        totalYardsTeam2SliderValue =  Float(-10000)
        passingYardsTeam1SliderValue =  Float(-10000)
        passingYardsTeam2SliderValue =  Float(-10000)
        rushingYardsTeam1SliderValue =  Float(-10000)
        rushingYardsTeam2SliderValue =  Float(-10000)
        quarterbackRatingTeam1SliderValue =  Float(-10000)
        quarterbackRatingTeam2SliderValue =  Float(-10000)
        timesSackedTeam1SliderValue =  Float(-10000)
        timesSackedTeam2SliderValue =  Float(-10000)
        interceptionsThrownTeam1SliderValue =  Float(-10000)
        interceptionsThrownTeam2SliderValue =  Float(-10000)
        offensivePlaysTeam1SliderValue =  Float(-10000)
        offensivePlaysTeam2SliderValue =  Float(-10000)
        yardsPerOffensivePlayTeam1SliderValue =  Float(-10000)
        yardsPerOffensivePlayTeam2SliderValue =  Float(-10000)
        sacksTeam1SliderValue =  Float(-10000)
        sacksTeam2SliderValue =  Float(-10000)
        interceptionsTeam1SliderValue =  Float(-10000)
        interceptionsTeam2SliderValue =  Float(-10000)
        safetiesTeam1SliderValue =  Float(-10000)
        safetiesTeam2SliderValue =  Float(-10000)
        defensivePlaysTeam1SliderValue =  Float(-10000)
        defensivePlaysTeam2SliderValue =  Float(-10000)
        yardsPerDefensivePlayTeam1SliderValue =  Float(-10000)
        yardsPerDefensivePlayTeam2SliderValue =  Float(-10000)
        extraPointAttemptsTeam1SliderValue =  Float(-10000)
        extraPointAttemptsTeam2SliderValue =  Float(-10000)
        extraPointsMadeTeam1SliderValue =  Float(-10000)
        extraPointsMadeTeam2SliderValue =  Float(-10000)
        fieldGoalAttemptsTeam1SliderValue =  Float(-10000)
        fieldGoalAttemptsTeam2SliderValue =  Float(-10000)
        fieldGoalsMadeTeam1SliderValue =  Float(-10000)
        fieldGoalsMadeTeam2SliderValue =  Float(-10000)
        puntsTeam1SliderValue =  Float(-10000)
        puntsTeam2SliderValue =  Float(-10000)
        puntYardsTeam1SliderValue =  Float(-10000)
        puntYardsTeam2SliderValue =  Float(-10000)
        ////////// RANGE SLIDER LOWER VALUE VALUES //////////
        winningLosingStreakTeam1RangeSliderLowerValue =  Float(-10000)
        winningLosingStreakTeam2RangeSliderLowerValue =  Float(-10000)
        seasonWinPercentageTeam1RangeSliderLowerValue =  Float(-10000)
        seasonWinPercentageTeam2RangeSliderLowerValue =  Float(-10000)
        seasonRangeSliderLowerValue =  Float(-10000)
        gameNumberRangeSliderLowerValue =  Float(-10000)
        temperatureRangeSliderLowerValue =  Float(-10000)
        totalPointsTeam1RangeSliderLowerValue =  Float(-10000)
        totalPointsTeam2RangeSliderLowerValue =  Float(-10000)
        touchdownsTeam1RangeSliderLowerValue =  Float(-10000)
        touchdownsTeam2RangeSliderLowerValue =  Float(-10000)
        offensiveTouchdownsTeam1RangeSliderLowerValue =  Float(-10000)
        offensiveTouchdownsTeam2RangeSliderLowerValue =  Float(-10000)
        defensiveTouchdownsTeam1RangeSliderLowerValue =  Float(-10000)
        defensiveTouchdownsTeam2RangeSliderLowerValue =  Float(-10000)
        turnoversCommittedTeam1RangeSliderLowerValue =  Float(-10000)
        turnoversCommittedTeam2RangeSliderLowerValue =  Float(-10000)
        penaltiesCommittedTeam1RangeSliderLowerValue =  Float(-10000)
        penaltiesCommittedTeam2RangeSliderLowerValue =  Float(-10000)
        totalYardsTeam1RangeSliderLowerValue =  Float(-10000)
        totalYardsTeam2RangeSliderLowerValue =  Float(-10000)
        passingYardsTeam1RangeSliderLowerValue =  Float(-10000)
        passingYardsTeam2RangeSliderLowerValue =  Float(-10000)
        rushingYardsTeam1RangeSliderLowerValue =  Float(-10000)
        rushingYardsTeam2RangeSliderLowerValue =  Float(-10000)
        quarterbackRatingTeam1RangeSliderLowerValue =  Float(-10000)
        quarterbackRatingTeam2RangeSliderLowerValue =  Float(-10000)
        timesSackedTeam1RangeSliderLowerValue =  Float(-10000)
        timesSackedTeam2RangeSliderLowerValue =  Float(-10000)
        interceptionsThrownTeam1RangeSliderLowerValue =  Float(-10000)
        interceptionsThrownTeam2RangeSliderLowerValue =  Float(-10000)
        offensivePlaysTeam1RangeSliderLowerValue =  Float(-10000)
        offensivePlaysTeam2RangeSliderLowerValue =  Float(-10000)
        yardsPerOffensivePlayTeam1RangeSliderLowerValue =  Float(-10000)
        yardsPerOffensivePlayTeam2RangeSliderLowerValue =  Float(-10000)
        sacksTeam1RangeSliderLowerValue =  Float(-10000)
        sacksTeam2RangeSliderLowerValue =  Float(-10000)
        interceptionsTeam1RangeSliderLowerValue =  Float(-10000)
        interceptionsTeam2RangeSliderLowerValue =  Float(-10000)
        safetiesTeam1RangeSliderLowerValue =  Float(-10000)
        safetiesTeam2RangeSliderLowerValue =  Float(-10000)
        defensivePlaysTeam1RangeSliderLowerValue =  Float(-10000)
        defensivePlaysTeam2RangeSliderLowerValue =  Float(-10000)
        yardsPerDefensivePlayTeam1RangeSliderLowerValue =  Float(-10000)
        yardsPerDefensivePlayTeam2RangeSliderLowerValue =  Float(-10000)
        extraPointAttemptsTeam1RangeSliderLowerValue =  Float(-10000)
        extraPointAttemptsTeam2RangeSliderLowerValue =  Float(-10000)
        extraPointsMadeTeam1RangeSliderLowerValue =  Float(-10000)
        extraPointsMadeTeam2RangeSliderLowerValue =  Float(-10000)
        fieldGoalAttemptsTeam1RangeSliderLowerValue =  Float(-10000)
        fieldGoalAttemptsTeam2RangeSliderLowerValue =  Float(-10000)
        fieldGoalsMadeTeam1RangeSliderLowerValue =  Float(-10000)
        fieldGoalsMadeTeam2RangeSliderLowerValue =  Float(-10000)
        puntsTeam1RangeSliderLowerValue =  Float(-10000)
        puntsTeam2RangeSliderLowerValue =  Float(-10000)
        puntYardsTeam1RangeSliderLowerValue =  Float(-10000)
        puntYardsTeam2RangeSliderLowerValue =  Float(-10000)
        ////////// RANGE SLIDER UPPER VALUE VALUES //////////
        winningLosingStreakTeam1RangeSliderUpperValue =  Float(-10000)
        winningLosingStreakTeam2RangeSliderUpperValue =  Float(-10000)
        seasonWinPercentageTeam1RangeSliderUpperValue =  Float(-10000)
        seasonWinPercentageTeam2RangeSliderUpperValue =  Float(-10000)
        seasonRangeSliderUpperValue =  Float(-10000)
        gameNumberRangeSliderUpperValue =  Float(-10000)
        temperatureRangeSliderUpperValue =  Float(-10000)
        totalPointsTeam1RangeSliderUpperValue =  Float(-10000)
        totalPointsTeam2RangeSliderUpperValue =  Float(-10000)
        touchdownsTeam1RangeSliderUpperValue =  Float(-10000)
        touchdownsTeam2RangeSliderUpperValue =  Float(-10000)
        offensiveTouchdownsTeam1RangeSliderUpperValue =  Float(-10000)
        offensiveTouchdownsTeam2RangeSliderUpperValue =  Float(-10000)
        defensiveTouchdownsTeam1RangeSliderUpperValue =  Float(-10000)
        defensiveTouchdownsTeam2RangeSliderUpperValue =  Float(-10000)
        turnoversCommittedTeam1RangeSliderUpperValue =  Float(-10000)
        turnoversCommittedTeam2RangeSliderUpperValue =  Float(-10000)
        penaltiesCommittedTeam1RangeSliderUpperValue =  Float(-10000)
        penaltiesCommittedTeam2RangeSliderUpperValue =  Float(-10000)
        totalYardsTeam1RangeSliderUpperValue =  Float(-10000)
        totalYardsTeam2RangeSliderUpperValue =  Float(-10000)
        passingYardsTeam1RangeSliderUpperValue =  Float(-10000)
        passingYardsTeam2RangeSliderUpperValue =  Float(-10000)
        rushingYardsTeam1RangeSliderUpperValue =  Float(-10000)
        rushingYardsTeam2RangeSliderUpperValue =  Float(-10000)
        quarterbackRatingTeam1RangeSliderUpperValue =  Float(-10000)
        quarterbackRatingTeam2RangeSliderUpperValue =  Float(-10000)
        timesSackedTeam1RangeSliderUpperValue =  Float(-10000)
        timesSackedTeam2RangeSliderUpperValue =  Float(-10000)
        interceptionsThrownTeam1RangeSliderUpperValue =  Float(-10000)
        interceptionsThrownTeam2RangeSliderUpperValue =  Float(-10000)
        offensivePlaysTeam1RangeSliderUpperValue =  Float(-10000)
        offensivePlaysTeam2RangeSliderUpperValue =  Float(-10000)
        yardsPerOffensivePlayTeam1RangeSliderUpperValue =  Float(-10000)
        yardsPerOffensivePlayTeam2RangeSliderUpperValue =  Float(-10000)
        sacksTeam1RangeSliderUpperValue =  Float(-10000)
        sacksTeam2RangeSliderUpperValue =  Float(-10000)
        interceptionsTeam1RangeSliderUpperValue =  Float(-10000)
        interceptionsTeam2RangeSliderUpperValue =  Float(-10000)
        safetiesTeam1RangeSliderUpperValue =  Float(-10000)
        safetiesTeam2RangeSliderUpperValue =  Float(-10000)
        defensivePlaysTeam1RangeSliderUpperValue =  Float(-10000)
        defensivePlaysTeam2RangeSliderUpperValue =  Float(-10000)
        yardsPerDefensivePlayTeam1RangeSliderUpperValue =  Float(-10000)
        yardsPerDefensivePlayTeam2RangeSliderUpperValue =  Float(-10000)
        extraPointAttemptsTeam1RangeSliderUpperValue =  Float(-10000)
        extraPointAttemptsTeam2RangeSliderUpperValue =  Float(-10000)
        extraPointsMadeTeam1RangeSliderUpperValue =  Float(-10000)
        extraPointsMadeTeam2RangeSliderUpperValue =  Float(-10000)
        fieldGoalAttemptsTeam1RangeSliderUpperValue =  Float(-10000)
        fieldGoalAttemptsTeam2RangeSliderUpperValue =  Float(-10000)
        fieldGoalsMadeTeam1RangeSliderUpperValue =  Float(-10000)
        fieldGoalsMadeTeam2RangeSliderUpperValue =  Float(-10000)
        puntsTeam1RangeSliderUpperValue =  Float(-10000)
        puntsTeam2RangeSliderUpperValue =  Float(-10000)
        puntYardsTeam1RangeSliderUpperValue =  Float(-10000)
        puntYardsTeam2RangeSliderUpperValue =  Float(-10000)
        ////////// OPERATOR VALUES //////////
        team1OperatorValue = "-10000"
        team2OperatorValue = "-10000"
        winningLosingStreakTeam1OperatorValue = "-10000"
        winningLosingStreakTeam2OperatorValue = "-10000"
        seasonWinPercentageTeam1OperatorValue = "-10000"
        seasonWinPercentageTeam2OperatorValue = "-10000"
        homeTeamOperatorValue = "-10000"
        favoriteOperatorValue = "-10000"
        playerOperatorValue = "-10000"
		playerOpponentOperatorValue = "-10000"
        seasonOperatorValue = "-10000"
        gameNumberOperatorValue = "-10000"
        dayOperatorValue = "-10000"
        stadiumOperatorValue = "-10000"
        surfaceOperatorValue = "-10000"
        temperatureOperatorValue = "-10000"
        totalPointsTeam1OperatorValue = "-10000"
        totalPointsTeam2OperatorValue = "-10000"
        touchdownsTeam1OperatorValue = "-10000"
        touchdownsTeam2OperatorValue = "-10000"
        offensiveTouchdownsTeam1OperatorValue = "-10000"
        offensiveTouchdownsTeam2OperatorValue = "-10000"
        defensiveTouchdownsTeam1OperatorValue = "-10000"
        defensiveTouchdownsTeam2OperatorValue = "-10000"
        turnoversCommittedTeam1OperatorValue = "-10000"
        turnoversCommittedTeam2OperatorValue = "-10000"
        penaltiesCommittedTeam1OperatorValue = "-10000"
        penaltiesCommittedTeam2OperatorValue = "-10000"
        totalYardsTeam1OperatorValue = "-10000"
        totalYardsTeam2OperatorValue = "-10000"
        passingYardsTeam1OperatorValue = "-10000"
        passingYardsTeam2OperatorValue = "-10000"
        rushingYardsTeam1OperatorValue = "-10000"
        rushingYardsTeam2OperatorValue = "-10000"
        quarterbackRatingTeam1OperatorValue = "-10000"
        quarterbackRatingTeam2OperatorValue = "-10000"
        timesSackedTeam1OperatorValue = "-10000"
        timesSackedTeam2OperatorValue = "-10000"
        interceptionsThrownTeam1OperatorValue = "-10000"
        interceptionsThrownTeam2OperatorValue = "-10000"
        offensivePlaysTeam1OperatorValue = "-10000"
        offensivePlaysTeam2OperatorValue = "-10000"
        yardsPerOffensivePlayTeam1OperatorValue = "-10000"
        yardsPerOffensivePlayTeam2OperatorValue = "-10000"
        sacksTeam1OperatorValue = "-10000"
        sacksTeam2OperatorValue = "-10000"
        interceptionsTeam1OperatorValue = "-10000"
        interceptionsTeam2OperatorValue = "-10000"
        safetiesTeam1OperatorValue = "-10000"
        safetiesTeam2OperatorValue = "-10000"
        defensivePlaysTeam1OperatorValue = "-10000"
        defensivePlaysTeam2OperatorValue = "-10000"
        yardsPerDefensivePlayTeam1OperatorValue = "-10000"
        yardsPerDefensivePlayTeam2OperatorValue = "-10000"
        extraPointAttemptsTeam1OperatorValue = "-10000"
        extraPointAttemptsTeam2OperatorValue = "-10000"
        extraPointsMadeTeam1OperatorValue = "-10000"
        extraPointsMadeTeam2OperatorValue = "-10000"
        fieldGoalAttemptsTeam1OperatorValue = "-10000"
        fieldGoalAttemptsTeam2OperatorValue = "-10000"
        fieldGoalsMadeTeam1OperatorValue = "-10000"
        fieldGoalsMadeTeam2OperatorValue = "-10000"
        puntsTeam1OperatorValue = "-10000"
        puntsTeam2OperatorValue = "-10000"
        puntYardsTeam1OperatorValue = "-10000"
        puntYardsTeam2OperatorValue = "-10000"
        ////////// SLIDER FORM VALUES //////////
        winningLosingStreakTeam1SliderFormValue = "-10000"
        winningLosingStreakTeam2SliderFormValue = "-10000"
        seasonWinPercentageTeam1SliderFormValue = "-10000"
        seasonWinPercentageTeam2SliderFormValue = "-10000"
        seasonSliderFormValue = "-10000"
        gameNumberSliderFormValue = "-10000"
        temperatureSliderFormValue = "-10000"
        totalPointsTeam1SliderFormValue = "-10000"
        totalPointsTeam2SliderFormValue = "-10000"
        touchdownsTeam1SliderFormValue = "-10000"
        touchdownsTeam2SliderFormValue = "-10000"
        offensiveTouchdownsTeam1SliderFormValue = "-10000"
        offensiveTouchdownsTeam2SliderFormValue = "-10000"
        defensiveTouchdownsTeam1SliderFormValue = "-10000"
        defensiveTouchdownsTeam2SliderFormValue = "-10000"
        turnoversCommittedTeam1SliderFormValue = "-10000"
        turnoversCommittedTeam2SliderFormValue = "-10000"
        penaltiesCommittedTeam1SliderFormValue = "-10000"
        penaltiesCommittedTeam2SliderFormValue = "-10000"
        totalYardsTeam1SliderFormValue = "-10000"
        totalYardsTeam2SliderFormValue = "-10000"
        passingYardsTeam1SliderFormValue = "-10000"
        passingYardsTeam2SliderFormValue = "-10000"
        rushingYardsTeam1SliderFormValue = "-10000"
        rushingYardsTeam2SliderFormValue = "-10000"
        quarterbackRatingTeam1SliderFormValue = "-10000"
        quarterbackRatingTeam2SliderFormValue = "-10000"
        timesSackedTeam1SliderFormValue = "-10000"
        timesSackedTeam2SliderFormValue = "-10000"
        interceptionsThrownTeam1SliderFormValue = "-10000"
        interceptionsThrownTeam2SliderFormValue = "-10000"
        offensivePlaysTeam1SliderFormValue = "-10000"
        offensivePlaysTeam2SliderFormValue = "-10000"
        yardsPerOffensivePlayTeam1SliderFormValue = "-10000"
        yardsPerOffensivePlayTeam2SliderFormValue = "-10000"
        sacksTeam1SliderFormValue = "-10000"
        sacksTeam2SliderFormValue = "-10000"
        interceptionsTeam1SliderFormValue = "-10000"
        interceptionsTeam2SliderFormValue = "-10000"
        safetiesTeam1SliderFormValue = "-10000"
        safetiesTeam2SliderFormValue = "-10000"
        defensivePlaysTeam1SliderFormValue = "-10000"
        defensivePlaysTeam2SliderFormValue = "-10000"
        yardsPerDefensivePlayTeam1SliderFormValue = "-10000"
        yardsPerDefensivePlayTeam2SliderFormValue = "-10000"
        extraPointAttemptsTeam1SliderFormValue = "-10000"
        extraPointAttemptsTeam2SliderFormValue = "-10000"
        extraPointsMadeTeam1SliderFormValue = "-10000"
        extraPointsMadeTeam2SliderFormValue = "-10000"
        fieldGoalAttemptsTeam1SliderFormValue = "-10000"
        fieldGoalAttemptsTeam2SliderFormValue = "-10000"
        fieldGoalsMadeTeam1SliderFormValue = "-10000"
        fieldGoalsMadeTeam2SliderFormValue = "-10000"
        puntsTeam1SliderFormValue = "-10000"
        puntsTeam2SliderFormValue = "-10000"
        puntYardsTeam1SliderFormValue = "-10000"
        puntYardsTeam2SliderFormValue = "-10000"
        //////////////////// FORM VALUES ////////////////////
        formListValue = ["-10000"]
        formSliderValue = Float(-10000)
        sliderValue = "-10000"
        formRangeSliderLowerValue = Float(-10000)
        formRangeSliderUpperValue = Float(-10000)
        formOperatorValue = "-10000"
        selectedOperatorValue = "-10000"
        //////////////////////////////////////////////////////
        weekSliderValue = Float(-10000)
        weekRangeSliderLowerValue = Float(-10000)
        weekRangeSliderUpperValue = Float(-10000)
        weekOperatorValue = "-10000"
        weekSliderFormValue = "-10000"
        spreadSliderValue = Float(-10000)
        spreadRangeSliderLowerValue = Float(-10000)
        spreadRangeSliderUpperValue = Float(-10000)
        spreadOperatorValue = "-10000"
        spreadSliderFormValue = "-10000"
        overUnderSliderValue = Float(-10000)
        overUnderRangeSliderLowerValue = Float(-10000)
        overUnderRangeSliderUpperValue = Float(-10000)
        overUnderOperatorValue = "-10000"
        overUnderSliderFormValue = "-10000"
        //////////////////////////////////////////////////////
        self.tableView.reloadData()
        updateDashboardAfterClearSelections()
    }
////////////////////////////////////////////////////////////////////////////////////////////////////////
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //--------------------PICKERS----------------------//
        //////////// MATCH - UP ////////////
        if segue.identifier == "Team1Segue" {
            tagText = "TEAM"
            print("New Row Selected: " + tagText)
        }
        if segue.identifier == "Team2Segue" {
            tagText = "OPPONENT"
            print("New Row Selected: " + tagText)
        }
        //////////// GAME SETTING ////////////
        if segue.identifier == "HomeTeamSegue" {
            tagText = "HOME TEAM"
            print("New Row Selected: " + tagText)
        }
        if segue.identifier == "DayOfWeekSegue" {
            tagText = "DAY"
            print("New Row Selected: " + tagText)
        }
        if segue.identifier == "StadiumSegue" {
            tagText = "STADIUM"
            print("New Row Selected: " + tagText)
        }
        if segue.identifier == "SurfaceSegue" {
            tagText = "SURFACE"
            print("New Row Selected: " + tagText)
        }
        //////////// ENTERING GAME ////////////
        if segue.identifier == "FavoriteSegue" {
            tagText = "FAVORITE"
            print("New Row Selected: " + tagText)
        }
        if segue.identifier == "PlayersSegue" {
            tagText = "TEAM: PLAYERS"
            print("New Row Selected: " + tagText)
        }
        if segue.identifier == "PlayerOpponentSegue" {
            tagText = "OPPONENT: PLAYERS"
            print("New Row Selected: " + tagText)
        }
        //--------------------SLIDERS----------------------//
        ////////////  GAME SETTING  ////////////
        if segue.identifier == "SeasonSegue" {
            let sliderViewController = segue.destination as! SliderViewController
            tagText = "SEASON"
            sliderViewController.headerLabel = tagText
            print("New Row Selected: " + tagText)
        }
        if segue.identifier == "WeekSegue" {
            let sliderViewController = segue.destination as! SliderViewController
            tagText = "WEEK"
            sliderViewController.headerLabel = tagText
            print("New Row Selected: " + tagText)
        }
        if segue.identifier == "GameNumberSegue" {
            let sliderViewController = segue.destination as! SliderViewController
            tagText = "GAME NUMBER"
            sliderViewController.headerLabel = tagText
            print("New Row Selected: " + tagText)
        }
        if segue.identifier == "TemperatureSegue" {
            let sliderViewController = segue.destination as! SliderViewController
            tagText = "TEMPERATURE (F)"
            sliderViewController.headerLabel = tagText
            print("New Row Selected: " + tagText)
        }
        //////////// ENTERING GAME ////////////
        if segue.identifier == "SpreadSegue" {
            let sliderViewController = segue.destination as! SliderViewController
            tagText = "TEAM: SPREAD"
            sliderViewController.headerLabel = tagText
            print("New Row Selected: " + tagText)
        }
        if segue.identifier == "OverUnderSegue" {
            let sliderViewController = segue.destination as! SliderViewController
            tagText = "OVER/UNDER"
            sliderViewController.headerLabel = tagText
            print("New Row Selected: " + tagText)
        }
        if segue.identifier == "WinLossStreakTeam1Segue" {
            let sliderViewController = segue.destination as! SliderViewController
            tagText = "TEAM: STREAK"
            sliderViewController.headerLabel = tagText
            print("New Row Selected: " + tagText)
        }
        if segue.identifier == "WinLossStreakTeam2Segue" {
            let sliderViewController = segue.destination as! SliderViewController
            tagText = "OPPONENT: STREAK"
            sliderViewController.headerLabel = tagText
            print("New Row Selected: " + tagText)
        }
        if segue.identifier == "SeasonWinPercentageTeam1Segue" {
            let sliderViewController = segue.destination as! SliderViewController
            tagText = "TEAM: SEASON WIN %"
            sliderViewController.headerLabel = tagText
            print("New Row Selected: " + tagText)
        }
        if segue.identifier == "SeasonWinPercentageTeam2Segue" {
            let sliderViewController = segue.destination as! SliderViewController
            tagText = "OPPONENT: SEASON WIN %"
            sliderViewController.headerLabel = tagText
            print("New Row Selected: " + tagText)
        }
        //////////// TEAM ////////////
        if segue.identifier == "TotalPointsTeam1Segue" {
            let sliderViewController = segue.destination as! SliderViewController
            tagText = "TEAM: TOTAL POINTS"
            sliderViewController.headerLabel = tagText
            print("New Row Selected: " + tagText)
        }
        if segue.identifier == "TotalPointsTeam2Segue" {
            let sliderViewController = segue.destination as! SliderViewController
            tagText = "OPPONENT: TOTAL POINTS"
            sliderViewController.headerLabel = tagText
            print("New Row Selected: " + tagText)
        }
        if segue.identifier == "TouchdownsTeam1Segue" {
            let sliderViewController = segue.destination as! SliderViewController
            tagText = "TEAM: TOUCHDOWNS"
            sliderViewController.headerLabel = tagText
            print("New Row Selected: " + tagText)
        }
        if segue.identifier == "TouchdownsTeam2Segue" {
            let sliderViewController = segue.destination as! SliderViewController
            tagText = "OPPONENT: TOUCHDOWNS"
            sliderViewController.headerLabel = tagText
            print("New Row Selected: " + tagText)
        }
        if segue.identifier == "TurnoversCommittedTeam1Segue" {
            let sliderViewController = segue.destination as! SliderViewController
            tagText = "TEAM: TURNOVERS"
            sliderViewController.headerLabel = tagText
            print("New Row Selected: " + tagText)
        }
        if segue.identifier == "TurnoversCommittedTeam2Segue" {
            let sliderViewController = segue.destination as! SliderViewController
            tagText = "OPPONENT: TURNOVERS"
            sliderViewController.headerLabel = tagText
            print("New Row Selected: " + tagText)
        }
        if segue.identifier == "PenaltiesCommittedTeam1Segue" {
            let sliderViewController = segue.destination as! SliderViewController
            tagText = "TEAM: PENALTIES"
            sliderViewController.headerLabel = tagText
            print("New Row Selected: " + tagText)
        }
        if segue.identifier == "PenaltiesCommittedTeam2Segue" {
            let sliderViewController = segue.destination as! SliderViewController
            tagText = "OPPONENT: PENALTIES"
            sliderViewController.headerLabel = tagText
            print("New Row Selected: " + tagText)
        }
        //////////// OFFENSE ////////////
        if segue.identifier == "OffensiveTouchdownsTeam1Segue" {
            let sliderViewController = segue.destination as! SliderViewController
            tagText = "TEAM: OFFENSIVE TOUCHDOWNS"
            sliderViewController.headerLabel = tagText
            print("New Row Selected: " + tagText)
        }
        if segue.identifier == "OffensiveTouchdownsTeam2Segue" {
            let sliderViewController = segue.destination as! SliderViewController
            tagText = "OPPONENT: OFFENSIVE TOUCHDOWNS"
            sliderViewController.headerLabel = tagText
            print("New Row Selected: " + tagText)
        }
        if segue.identifier == "TotalYardsTeam1Segue" {
            let sliderViewController = segue.destination as! SliderViewController
            tagText = "TEAM: TOTAL YARDS"
            sliderViewController.headerLabel = tagText
            print("New Row Selected: " + tagText)
        }
        if segue.identifier == "TotalYardsTeam2Segue" {
            let sliderViewController = segue.destination as! SliderViewController
            tagText = "OPPONENT: TOTAL YARDS"
            sliderViewController.headerLabel = tagText
            print("New Row Selected: " + tagText)
        }
        if segue.identifier == "PassingYardsTeam1Segue" {
            let sliderViewController = segue.destination as! SliderViewController
            tagText = "TEAM: PASSING YARDS"
            sliderViewController.headerLabel = tagText
            print("New Row Selected: " + tagText)
        }
        if segue.identifier == "PassingYardsTeam2Segue" {
            let sliderViewController = segue.destination as! SliderViewController
            tagText = "OPPONENT: PASSING YARDS"
            sliderViewController.headerLabel = tagText
            print("New Row Selected: " + tagText)
        }
        if segue.identifier == "RushingYardsTeam1Segue" {
            let sliderViewController = segue.destination as! SliderViewController
            tagText = "TEAM: RUSHING YARDS"
            sliderViewController.headerLabel = tagText
            print("New Row Selected: " + tagText)
        }
        if segue.identifier == "RushingYardsTeam2Segue" {
            let sliderViewController = segue.destination as! SliderViewController
            tagText = "OPPONENT: RUSHING YARDS"
            sliderViewController.headerLabel = tagText
            print("New Row Selected: " + tagText)
        }
        if segue.identifier == "QuarterbackRatingTeam1Segue" {
            let sliderViewController = segue.destination as! SliderViewController
            tagText = "TEAM: QUARTERBACK RATING"
            sliderViewController.headerLabel = tagText
            print("New Row Selected: " + tagText)
        }
        if segue.identifier == "QuarterbackRatingTeam2Segue" {
            let sliderViewController = segue.destination as! SliderViewController
            tagText = "OPPONENT: QUARTERBACK RATING"
            sliderViewController.headerLabel = tagText
            print("New Row Selected: " + tagText)
        }
        if segue.identifier == "TimesSackedTeam1Segue" {
            let sliderViewController = segue.destination as! SliderViewController
            tagText = "TEAM: TIMES SACKED"
            sliderViewController.headerLabel = tagText
            print("New Row Selected: " + tagText)
        }
        if segue.identifier == "TimesSackedTeam2Segue" {
            let sliderViewController = segue.destination as! SliderViewController
            tagText = "OPPONENT: TIMES SACKED"
            sliderViewController.headerLabel = tagText
            print("New Row Selected: " + tagText)
        }
        if segue.identifier == "InterceptionsThrownTeam1Segue" {
            let sliderViewController = segue.destination as! SliderViewController
            tagText = "TEAM: INTERCEPTIONS THROWN"
            sliderViewController.headerLabel = tagText
            print("New Row Selected: " + tagText)
        }
        if segue.identifier == "InterceptionsThrownTeam2Segue" {
            let sliderViewController = segue.destination as! SliderViewController
            tagText = "OPPONENT: INTERCEPTIONS THROWN"
            sliderViewController.headerLabel = tagText
            print("New Row Selected: " + tagText)
        }
        if segue.identifier == "OffensivePlaysTeam1Segue" {
            let sliderViewController = segue.destination as! SliderViewController
            tagText = "TEAM: OFFENSIVE PLAYS"
            sliderViewController.headerLabel = tagText
            print("New Row Selected: " + tagText)
        }
        if segue.identifier == "OffensivePlaysTeam2Segue" {
            let sliderViewController = segue.destination as! SliderViewController
            tagText = "OPPONENT: OFFENSIVE PLAYS"
            sliderViewController.headerLabel = tagText
            print("New Row Selected: " + tagText)
        }
        if segue.identifier == "YardsPerOffensivePlayTeam1Segue" {
            let sliderViewController = segue.destination as! SliderViewController
            tagText = "TEAM: YARDS/OFFENSIVE PLAY"
            sliderViewController.headerLabel = tagText
            print("New Row Selected: " + tagText)
        }
        if segue.identifier == "YardsPerOffensivePlayTeam2Segue" {
            let sliderViewController = segue.destination as! SliderViewController
            tagText = "OPPONENT: YARDS/OFFENSIVE PLAY"
            sliderViewController.headerLabel = tagText
            print("New Row Selected: " + tagText)
        }
        //////////// DEFENSE ////////////
        if segue.identifier == "DefensiveTouchdownsTeam1Segue" {
            let sliderViewController = segue.destination as! SliderViewController
            tagText = "TEAM: DEFENSIVE TOUCHDOWNS"
            sliderViewController.headerLabel = tagText
            print("New Row Selected: " + tagText)
        }
        if segue.identifier == "DefensiveTouchdownsTeam2Segue" {
            let sliderViewController = segue.destination as! SliderViewController
            tagText = "OPPONENT: DEFENSIVE TOUCHDOWNS"
            sliderViewController.headerLabel = tagText
            print("New Row Selected: " + tagText)
        }
        if segue.identifier == "DefensiveSacksTeam1Segue" {
            let sliderViewController = segue.destination as! SliderViewController
            tagText = "TEAM: SACKS"
            sliderViewController.headerLabel = tagText
            print("New Row Selected: " + tagText)
        }
        if segue.identifier == "DefensiveSacksTeam2Segue" {
            let sliderViewController = segue.destination as! SliderViewController
            tagText = "OPPONENT: SACKS"
            sliderViewController.headerLabel = tagText
            print("New Row Selected: " + tagText)
        }
        if segue.identifier == "DefensiveInterceptionsTeam1Segue" {
            let sliderViewController = segue.destination as! SliderViewController
            tagText = "TEAM: INTERCEPTIONS"
            sliderViewController.headerLabel = tagText
            print("New Row Selected: " + tagText)
        }
        if segue.identifier == "DefensiveInterceptionsTeam2Segue" {
            let sliderViewController = segue.destination as! SliderViewController
            tagText = "OPPONENT: INTERCEPTIONS"
            sliderViewController.headerLabel = tagText
            print("New Row Selected: " + tagText)
        }
        if segue.identifier == "SafetiesTeam1Segue" {
            let sliderViewController = segue.destination as! SliderViewController
            tagText = "TEAM: SAFETIES"
            sliderViewController.headerLabel = tagText
            print("New Row Selected: " + tagText)
        }
        if segue.identifier == "SafetiesTeam2Segue" {
            let sliderViewController = segue.destination as! SliderViewController
            tagText = "OPPONENT: SAFETIES"
            sliderViewController.headerLabel = tagText
            print("New Row Selected: " + tagText)
        }
        if segue.identifier == "DefensivePlaysTeam1Segue" {
            let sliderViewController = segue.destination as! SliderViewController
            tagText = "TEAM: DEFENSIVE PLAYS"
            sliderViewController.headerLabel = tagText
            print("New Row Selected: " + tagText)
        }
        if segue.identifier == "DefensivePlaysTeam2Segue" {
            let sliderViewController = segue.destination as! SliderViewController
            tagText = "OPPONENT: DEFENSIVE PLAYS"
            sliderViewController.headerLabel = tagText
            print("New Row Selected: " + tagText)
        }
        if segue.identifier == "YardsPerDefensivePlayTeam1Segue" {
            let sliderViewController = segue.destination as! SliderViewController
            tagText = "TEAM: YARDS/DEFENSIVE PLAY"
            sliderViewController.headerLabel = tagText
            print("New Row Selected: " + tagText)
        }
        if segue.identifier == "YardsPerDefensivePlayTeam2Segue" {
            let sliderViewController = segue.destination as! SliderViewController
            tagText = "OPPONENT: YARDS/DEFENSIVE PLAY"
            sliderViewController.headerLabel = tagText
            print("New Row Selected: " + tagText)
        }
        //////////// SPECIAL TEAMS ////////////
        if segue.identifier == "ExtraPointAttemptsTeam1Segue" {
            let sliderViewController = segue.destination as! SliderViewController
            tagText = "TEAM: EXTRA POINT ATTEMPTS"
            sliderViewController.headerLabel = tagText
            print("New Row Selected: " + tagText)
        }
        if segue.identifier == "ExtraPointAttemptsTeam2Segue" {
            let sliderViewController = segue.destination as! SliderViewController
            tagText = "OPPONENT: EXTRA POINT ATTEMPTS"
            sliderViewController.headerLabel = tagText
            print("New Row Selected: " + tagText)
        }
        if segue.identifier == "ExtraPointsMadeTeam1Segue" {
            let sliderViewController = segue.destination as! SliderViewController
            tagText = "TEAM: EXTRA POINTS MADE"
            sliderViewController.headerLabel = tagText
            print("New Row Selected: " + tagText)
        }
        if segue.identifier == "ExtraPointsMadeTeam2Segue" {
            let sliderViewController = segue.destination as! SliderViewController
            tagText = "OPPONENT: EXTRA POINTS MADE"
            sliderViewController.headerLabel = tagText
            print("New Row Selected: " + tagText)
        }
        if segue.identifier == "FieldGoalAttemptsTeam1Segue" {
            let sliderViewController = segue.destination as! SliderViewController
            tagText = "TEAM: FIELD GOAL ATTEMPTS"
            sliderViewController.headerLabel = tagText
            print("New Row Selected: " + tagText)
        }
        if segue.identifier == "FieldGoalAttemptsTeam2Segue" {
            let sliderViewController = segue.destination as! SliderViewController
            tagText = "OPPONENT: FIELD GOAL ATTEMPTS"
            sliderViewController.headerLabel = tagText
            print("New Row Selected: " + tagText)
        }
        if segue.identifier == "FieldGoalsMadeTeam1Segue" {
            let sliderViewController = segue.destination as! SliderViewController
            tagText = "TEAM: FIELD GOALS MADE"
            sliderViewController.headerLabel = tagText
            print("New Row Selected: " + tagText)
        }
        if segue.identifier == "FieldGoalsMadeTeam2Segue" {
            let sliderViewController = segue.destination as! SliderViewController
            tagText = "OPPONENT: FIELD GOALS MADE"
            sliderViewController.headerLabel = tagText
            print("New Row Selected: " + tagText)
        }
        if segue.identifier == "PuntsTeam1Segue" {
            let sliderViewController = segue.destination as! SliderViewController
            tagText = "TEAM: PUNTS"
            sliderViewController.headerLabel = tagText
            print("New Row Selected: " + tagText)
        }
        if segue.identifier == "PuntsTeam2Segue" {
            let sliderViewController = segue.destination as! SliderViewController
            tagText = "OPPONENT: PUNTS"
            sliderViewController.headerLabel = tagText
            print("New Row Selected: " + tagText)
        }
        if segue.identifier == "PuntYardsTeam1Segue" {
            let sliderViewController = segue.destination as! SliderViewController
            tagText = "TEAM: PUNT YARDS"
            sliderViewController.headerLabel = tagText
            print("New Row Selected: " + tagText)
        }
        if segue.identifier == "PuntYardsTeam2Segue" {
            let sliderViewController = segue.destination as! SliderViewController
            tagText = "OPPONENT: PUNT YARDS"
            sliderViewController.headerLabel = tagText
            print("New Row Selected: " + tagText)
        }
        
    }
////////////////////////////////////////////////////////////////////////////////////////////////////////
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
////////////////////////////////////////////////////////////////////////////////////////////////////////
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.backgroundView = nil
        self.tableView.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.toolbar.isHidden = true
    }
////////////////////////////////////////////////////////////////////////////////////////////////////////
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tableView.backgroundView = nil
        self.tableView.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.toolbar.isHidden = true
////////////////////////////////////////////////////////////////////////////////////////////////////////
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////
class CustomRangeSlider: RangeSlider {
    override func getLabelText(forValue value: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = nil
        //print("CustomRangeSlider tagText: " + tagText)
        //print("CustomRangeSlider teamPlayerIndicator: " + teamPlayerIndicator)
        if teamPlayerIndicator == "TEAM" {
            switch (tagText) {
            case "TEAM: SEASON WIN %":
                numberFormatter.positiveSuffix = "%"
            case "OPPONENT: SEASON WIN %":
                numberFormatter.positiveSuffix = "%"
            case "TEMPERATURE (F)":
                numberFormatter.positiveSuffix = "°"
                numberFormatter.negativeSuffix = "°"
            case "TEAM: SPREAD":
                numberFormatter.allowsFloats = true
                numberFormatter.numberStyle = .decimal
                numberFormatter.minimumFractionDigits = 1
            case "OVER/UNDER":
                numberFormatter.allowsFloats = true
                numberFormatter.numberStyle = .decimal
                numberFormatter.minimumFractionDigits = 1
            case "TEAM: STREAK":
                numberFormatter.positivePrefix = "+"
                numberFormatter.negativePrefix = "-"
            case "OPPONENT: STREAK":
                numberFormatter.positivePrefix = "+"
                numberFormatter.negativePrefix = "-"
            default:
                numberFormatter.positiveSuffix = nil
            }
        } else {
            switch (tagTextPlayer) {
            case "PLAYER TEAM: SEASON WIN %":
                numberFormatter.positiveSuffix = "%"
            case "OPPONENT: SEASON WIN %":
                numberFormatter.positiveSuffix = "%"
            case "TEMPERATURE (F)":
                numberFormatter.positiveSuffix = "°"
                numberFormatter.negativeSuffix = "°"
            case "PLAYER TEAM: SPREAD":
                numberFormatter.allowsFloats = true
                numberFormatter.numberStyle = .decimal
                numberFormatter.minimumFractionDigits = 1
            case "OVER/UNDER":
                numberFormatter.allowsFloats = true
                numberFormatter.numberStyle = .decimal
                numberFormatter.minimumFractionDigits = 1
            case "PLAYER TEAM: STREAK":
                numberFormatter.positivePrefix = "+"
                numberFormatter.negativePrefix = "-"
            case "OPPONENT: STREAK":
                numberFormatter.positivePrefix = "+"
                numberFormatter.negativePrefix = "-"
            default:
                numberFormatter.positiveSuffix = nil
            }
        }
        guard let labelText = numberFormatter.string(from: NSNumber(value: value)) else { return "" }
        //print("CustomRangeSlider tagText: " + tagText)
        return labelText
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
}
