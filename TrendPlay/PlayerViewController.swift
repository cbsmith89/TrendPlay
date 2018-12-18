//
//  PlayerViewController.swift
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

public var playerSearchBarStatus: String = "INACTIVE"
public var playerRowDictionary = [
    "PLAYER" : "PLAYER",
    "OPPONENT" : "OPPONENT",
    "HOME TEAM" : "HOME TEAM",
    "FAVORITE" : "FAVORITE",
    "PLAYER TEAM: PLAYERS" : "PLAYERS, PLAYER TEAM",
	"OPPONENT: PLAYERS" : "PLAYERS, OPPONENT",
    "DAY" : "DAY",
    "STADIUM" : "STADIUM",
    "SURFACE" : "SURFACE",
    "PLAYER TEAM: STREAK" : "STREAK, PLAYER TEAM",
    "OPPONENT: STREAK" : "STREAK, OPPONENT",
    "PLAYER TEAM: SEASON WIN %" : "SEASON WIN %, PLAYER TEAM",
    "OPPONENT: SEASON WIN %" : "SEASON WIN %, OPPONENT",
    "SEASON" : "SEASON",
    "WEEK" : "WEEK",
    "GAME NUMBER" : "GAME NUMBER",
    "PLAYER TEAM: SPREAD" : "SPREAD, PLAYER TEAM",
    "OVER/UNDER" : "OVER/UNDER",
    "TEMPERATURE (F)" : "TEMPERATURE (F)",
    "PLAYER TEAM: TOTAL POINTS" : "TOTAL POINTS, PLAYER TEAM",
    "OPPONENT: TOTAL POINTS" : "TOTAL POINTS, OPPONENT",
    "PLAYER TEAM: TOUCHDOWNS" : "TOUCHDOWNS, PLAYER TEAM",
    "OPPONENT: TOUCHDOWNS" : "TOUCHDOWNS, OPPONENT",
    "PLAYER TEAM: TURNOVERS" : "TURNOVERS, PLAYER TEAM",
    "OPPONENT: TURNOVERS" : "TURNOVERS, OPPONENT",
    "PLAYER TEAM: PENALTIES" : "PENALTIES, PLAYER TEAM",
    "OPPONENT: PENALTIES" : "PENALTIES, OPPONENT",
    "PLAYER TEAM: OFFENSIVE TOUCHDOWNS" : "OFFENSIVE TOUCHDOWNS, PLAYER TEAM",
    "OPPONENT: OFFENSIVE TOUCHDOWNS" : "OFFENSIVE TOUCHDOWNS, OPPONENT",
    "PLAYER TEAM: TOTAL YARDS" : "TOTAL YARDS, PLAYER TEAM",
    "OPPONENT: TOTAL YARDS" : "TOTAL YARDS, OPPONENT",
    "PLAYER TEAM: PASSING YARDS" : "PASSING YARDS, PLAYER TEAM",
    "OPPONENT: PASSING YARDS" : "PASSING YARDS, OPPONENT",
    "PLAYER TEAM: RUSHING YARDS" : "RUSHING YARDS, PLAYER TEAM",
    "OPPONENT: RUSHING YARDS" : "RUSHING YARDS, OPPONENT",
    "PLAYER TEAM: QUARTERBACK RATING" : "QUARTERBACK RATING, PLAYER TEAM",
    "OPPONENT: QUARTERBACK RATING" : "QUARTERBACK RATING, OPPONENT",
    "PLAYER TEAM: TIMES SACKED" : "TIMES SACKED, PLAYER TEAM",
    "OPPONENT: TIMES SACKED" : "TIMES SACKED, OPPONENT",
    "PLAYER TEAM: INTERCEPTIONS THROWN" : "INTERCEPTIONS THROWN, PLAYER TEAM",
    "OPPONENT: INTERCEPTIONS THROWN" : "INTERCEPTIONS THROWN, OPPONENT",
    "PLAYER TEAM: OFFENSIVE PLAYS" : "OFFENSIVE PLAYS, PLAYER TEAM",
    "OPPONENT: OFFENSIVE PLAYS" : "OFFENSIVE PLAYS, OPPONENT",
    "PLAYER TEAM: DEFENSIVE TOUCHDOWNS" : "DEFENSIVE TOUCHDOWNS, PLAYER TEAM",
    "OPPONENT: DEFENSIVE TOUCHDOWNS" : "DEFENSIVE TOUCHDOWNS, OPPONENT",
    "PLAYER TEAM: YARDS/OFFENSIVE PLAY" : "YARDS/OFFENSIVE PLAY, PLAYER TEAM",
    "OPPONENT: YARDS/OFFENSIVE PLAY" : "YARDS/OFFENSIVE PLAY, OPPONENT",
    "PLAYER TEAM: SACKS" : "SACKS, PLAYER TEAM",
    "OPPONENT: SACKS" : "SACKS, OPPONENT",
    "PLAYER TEAM: INTERCEPTIONS" : "INTERCEPTIONS, PLAYER TEAM",
    "OPPONENT: INTERCEPTIONS" : "INTERCEPTIONS, OPPONENT",
    "PLAYER TEAM: SAFETIES" : "SAFETIES, PLAYER TEAM",
    "OPPONENT: SAFETIES" : "SAFETIES, OPPONENT",
    "PLAYER TEAM: DEFENSIVE PLAYS" : "DEFENSIVE PLAYS, PLAYER TEAM",
    "OPPONENT: DEFENSIVE PLAYS" : "DEFENSIVE PLAYS, OPPONENT",
    "PLAYER TEAM: YARDS/DEFENSIVE PLAY" : "YARDS/DEFENSIVE PLAY, PLAYER TEAM",
    "OPPONENT: YARDS/DEFENSIVE PLAY" : "YARDS/DEFENSIVE PLAY, OPPONENT",
    "PLAYER TEAM: EXTRA POINT ATTEMPTS" : "EXTRA POINT ATTEMPTS, PLAYER TEAM",
    "OPPONENT: EXTRA POINT ATTEMPTS" : "EXTRA POINT ATTEMPTS, OPPONENT",
    "PLAYER TEAM: EXTRA POINTS MADE" : "EXTRA POINTS MADE, PLAYER TEAM",
    "OPPONENT: EXTRA POINTS MADE" : "EXTRA POINTS MADE, OPPONENT",
    "PLAYER TEAM: FIELD GOAL ATTEMPTS" : "FIELD GOAL ATTEMPTS, PLAYER TEAM",
    "OPPONENT: FIELD GOAL ATTEMPTS" : "FIELD GOAL ATTEMPTS, OPPONENT",
    "PLAYER TEAM: FIELD GOALS MADE" : "FIELD GOALS MADE, PLAYER TEAM",
    "OPPONENT: FIELD GOALS MADE" : "FIELD GOALS MADE, OPPONENT",
    "PLAYER TEAM: PUNTS" : "PUNTS, PLAYER TEAM",
    "OPPONENT: PUNTS" : "PUNTS, OPPONENT",
    "PLAYER TEAM: PUNT YARDS" : "PUNT YARDS, PLAYER TEAM",
    "OPPONENT: PUNT YARDS" : "PUNT YARDS, OPPONENT"
]
public var team1LabelPlayer: String = ""
public var team2LabelPlayer: String = ""


class PlayerViewController: FormViewController, FloatyDelegate {
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
        print("PlayerVC viewDidLoad()")
        tagTextPlayer = "tagTextPlayer"
        NotificationCenter.default.addObserver(self, selector: #selector(PlayerViewController.reloadRowPlayer), name: NSNotification.Name(rawValue: "playerSliderNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PlayerViewController.reloadRowPlayer), name: NSNotification.Name(rawValue: "playerSearchableMultiSelectNotification"), object: nil)
        let playerDashboardViewController = storyboard?.instantiateViewController(withIdentifier: "PlayerDashboardViewController") as! PlayerDashboardViewController
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
            self.clearSelectionsPlayer()
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
			
            <<< ButtonRow("PLAYER") { row in
                row.title = row.tag
                row.presentationMode = .segueName(segueName: "PlayerSegue", onDismiss: nil)
                } .cellUpdate { cell, row in
                    if playerListValuePlayer == ["-10000"] || playerListValuePlayer == [] {
                        cell.detailTextLabel?.text = "IS ANY"
                    } else {
                        cell.detailTextLabel?.text = playerOperatorTextPlayer + playerListValuePlayer.sorted().joined(separator: ", ")
                        cell.detailTextLabel?.textColor = orangeColorDarker
                        
                    }
                    cell.textLabel?.font = twelveSemiboldSFCompact
                    cell.detailTextLabel?.font = twelveThinSFCompact
                    cell.textLabel?.addTextSpacing(spacing: -0.3)
                    cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
            }

            /*<<< ButplayerSearchableMultiSelectNotificationtonRow("TEAM") { row in
                row.title = row.tag
                row.presentationMode = .segueName(segueName: "Team1Segue", onDismiss: nil)
                row.cell.textLabel?.font = twelveSemiboldSFCompact
                row.cell.detailTextLabel?.font = twelveThinSFCompact
                } .cellUpdate { cell, row in
                    if team1ListValuePlayer == ["-10000"] || team1ListValuePlayer == [] {
                        playerDashboardViewController.team1LabelPlayerText = "TEAM"
                        cell.detailTextLabel?.text = "IS ANY"
                    } else {
                        playerDashboardViewController.team1LabelPlayerText = team1ListValuePlayer.last!
                        cell.detailTextLabel?.text = team1OperatorTextPlayer + "THE " + team1ListValuePlayer.last!
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    cell.textLabel?.font = twelveSemiboldSFCompact
                    cell.detailTextLabel?.font = twelveThinSFCompact
                    cell.textLabel?.addTextSpacing(spacing: -0.3)
                    cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                    //print("team1OperatorValuePlayer: " + team1OperatorValuePlayer)
                    //print("team1ListValuePlayer: ")
                    //print(team1ListValuePlayer)
            }*/
 
            <<< ButtonRow("OPPONENT") { row in
                row.title = row.tag
                row.presentationMode = .segueName(segueName: "Team2Segue", onDismiss: nil)
                } .cellUpdate { cell, row in
                    if team2ListValuePlayer == ["-10000"] || team2ListValuePlayer == [] || team2ListValuePlayer.count == 32 {
                        playerDashboardViewController.opponentLabelText = "OPPONENT"
                        cell.detailTextLabel?.text = "IS ANY"
                    } else {
                        if team2ListValuePlayer.count > 1 {
                            playerDashboardViewController.opponentLabelText = "OPPONENT"
                            cell.detailTextLabel?.text = team2OperatorTextPlayer + "THE " + team2ListValuePlayer.sorted().joined(separator: ", ")
                        } else {
                            playerDashboardViewController.opponentLabelText = team2ListValuePlayer.sorted().joined(separator: ", ")
                            cell.detailTextLabel?.text = team2OperatorTextPlayer + "THE " + team2ListValuePlayer.sorted().joined(separator: ", ")
                        }
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    cell.textLabel?.font = twelveSemiboldSFCompact
                    cell.detailTextLabel?.font = twelveThinSFCompact
                    cell.textLabel?.addTextSpacing(spacing: -0.3)
                    cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                    //print(row.tag! + team2OperatorTextPlayer + team2ListValuePlayer.sorted().joined(separator: ", "))
                    //print("team2OperatorValuePlayer: " + team2OperatorValuePlayer)
                    //print("team2ListValuePlayer: ")
                    //print(team2ListValuePlayer)
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
                    if homeTeamListValuePlayer == ["-10000"] || homeTeamListValuePlayer == [] || homeTeamListValuePlayer.count == 3 {
                        cell.detailTextLabel?.text = "IS ANY"
                    } else {
                        cell.detailTextLabel?.text = homeTeamOperatorTextPlayer + homeTeamListValuePlayer.sorted().joined(separator: ", ")
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
                    if seasonSliderFormValuePlayer == "-10000" || (seasonRangeSliderLowerValuePlayer == seasonValuesPlayer.first && seasonRangeSliderUpperValuePlayer == seasonValuesPlayer.last) {
                        cell.detailTextLabel?.text = "IS ANY"
                    } else {
                        cell.detailTextLabel?.text = seasonOperatorTextPlayer + seasonSliderFormValuePlayer
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    cell.textLabel?.font = twelveSemiboldSFCompact
                    cell.detailTextLabel?.font = twelveThinSFCompact
                    cell.textLabel?.addTextSpacing(spacing: -0.3)
                    cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                    //print("seasonSliderFormValuePlayer: ")
                    //print(seasonSliderFormValuePlayer)
            }
            
            <<< ButtonRow("WEEK") { row in
                row.title = row.tag
                row.presentationMode = .segueName(segueName: "WeekSegue", onDismiss: nil)
                } .cellUpdate { cell, row in
                    if weekSliderFormValuePlayer == "-10000" || (weekRangeSliderLowerValuePlayer == weekValuesPlayer.first && weekRangeSliderUpperValuePlayer == weekValuesPlayer.last) {
                        cell.detailTextLabel?.text = "IS ANY"
                    } else {
                        cell.detailTextLabel?.text = weekOperatorTextPlayer + weekSliderFormValuePlayer
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
                    if gameNumberSliderFormValuePlayer == "-10000" || (gameNumberRangeSliderLowerValuePlayer == gameNumberValuesPlayer.first && gameNumberRangeSliderUpperValuePlayer == gameNumberValuesPlayer.last) {
                        cell.detailTextLabel?.text = "IS ANY"
                    } else {
                        cell.detailTextLabel?.text = gameNumberOperatorTextPlayer + gameNumberSliderFormValuePlayer
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
                    if dayListValuePlayer == ["-10000"] || dayListValuePlayer == [] || dayListValuePlayer.count == 7 {
                        cell.detailTextLabel?.text = "IS ANY"
                    } else {
                        cell.detailTextLabel?.text = dayOperatorTextPlayer + dayListValuePlayer.joined(separator: ", ")
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    cell.textLabel?.font = twelveSemiboldSFCompact
                    cell.detailTextLabel?.font = twelveThinSFCompact
                    cell.textLabel?.addTextSpacing(spacing: -0.3)
                    cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                    //print("dayListValuePlayer: ")
                    //print(dayListValuePlayer)
            }
            
            <<< ButtonRow("STADIUM") { row in
                row.title = row.tag
                row.presentationMode = .segueName(segueName: "StadiumSegue", onDismiss: nil)
                } .cellUpdate { cell, row in
                    if stadiumListValuePlayer == ["-10000"] || stadiumListValuePlayer == [] || stadiumListValuePlayer.count == 3 {
                        cell.detailTextLabel?.text = "IS ANY"
                    } else {
                        cell.detailTextLabel?.text = stadiumOperatorTextPlayer + stadiumListValuePlayer.sorted().joined(separator: ", ")
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    cell.textLabel?.font = twelveSemiboldSFCompact
                    cell.detailTextLabel?.font = twelveThinSFCompact
                    cell.textLabel?.addTextSpacing(spacing: -0.3)
                    cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                    //print("stadiumListValuePlayer: ")
                    //print(stadiumListValuePlayer)
            }
            
            <<< ButtonRow("SURFACE") { row in
                row.title = row.tag
                row.presentationMode = .segueName(segueName: "SurfaceSegue", onDismiss: nil)
                } .cellUpdate { cell, row in
                    if surfaceListValuePlayer == ["-10000"] || surfaceListValuePlayer == [] || surfaceListValuePlayer.count == 2 {
                        cell.detailTextLabel?.text = "IS ANY"
                    } else {
                        cell.detailTextLabel?.text = surfaceOperatorTextPlayer + surfaceListValuePlayer.sorted().joined(separator: ", ")
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    cell.textLabel?.font = twelveSemiboldSFCompact
                    cell.detailTextLabel?.font = twelveThinSFCompact
                    cell.textLabel?.addTextSpacing(spacing: -0.3)
                    cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                    //print("surfaceListValuePlayer: ")
                    //print(surfaceListValuePlayer)
            }
            
            <<< ButtonRow("TEMPERATURE (F)") { row in
                row.title = row.tag
                row.presentationMode = .segueName(segueName: "TemperatureSegue", onDismiss: nil)
                } .cellUpdate { cell, row in
                    if temperatureSliderFormValuePlayer == "-10000" || (temperatureRangeSliderLowerValuePlayer == temperatureValuesPlayer.first && temperatureRangeSliderUpperValuePlayer == temperatureValuesPlayer.last) {
                        cell.detailTextLabel?.text = "IS ANY"
                    } else {
                        cell.detailTextLabel?.text = temperatureOperatorTextPlayer + temperatureSliderFormValuePlayer
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
                    if favoriteListValuePlayer == ["-10000"] || favoriteListValuePlayer == [] || favoriteListValuePlayer.count == 3 {
                        cell.detailTextLabel?.text = "IS ANY"
                    } else {
                        cell.detailTextLabel?.text = favoriteOperatorTextPlayer + favoriteListValuePlayer.sorted().joined(separator: ", ")
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }

                    cell.textLabel?.font = twelveSemiboldSFCompact
                    cell.detailTextLabel?.font = twelveThinSFCompact
                    cell.textLabel?.addTextSpacing(spacing: -0.3)
                    cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                    //print("favoriteListValuePlayer: ")
                    //print(favoriteListValuePlayer)
            }
            
            <<< ButtonRow("SPREAD, PLAYER TEAM") { row in
                row.title = row.tag
                row.presentationMode = .segueName(segueName: "SpreadSegue", onDismiss: nil)
                } .cellUpdate { cell, row in
                    if spreadSliderFormValuePlayer == "-10000" || (spreadRangeSliderLowerValuePlayer == spreadValuesPlayer.first && spreadRangeSliderUpperValuePlayer == spreadValuesPlayer.last) {
                        cell.detailTextLabel?.text = "IS ANY"
                    } else {
                        cell.detailTextLabel?.text = spreadOperatorTextPlayer + spreadSliderFormValuePlayer
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    var rowTitle = row.tag
                    var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                    rowTitle = rowTitleTextArray?[0]
                    if team1ListValuePlayer == ["-10000"] || team1ListValuePlayer == [] {
                        cell.textLabel?.text = row.tag
                    } else {
                        if team1ListValuePlayer[0] == "NEW YORK GIANTS" {
                            team1LabelPlayer = "NEW YORK (G)"
                        } else if team1ListValuePlayer[0] == "NEW YORK JETS" {
                            team1LabelPlayer = "NEW YORK (J)"
                        } else if team1ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                            team1LabelPlayer = "LOS ANGELES (C)"
                        } else if team1ListValuePlayer[0] == "LOS ANGELES RAMS" {
                            team1LabelPlayer = "LOS ANGELES (R)"
                        } else {
                            team1LabelPlayer = team1ListValuePlayer[0]
                            var team1TextArray = team1LabelPlayer.components(separatedBy: " ")
                            let team1TextArrayLength = team1TextArray.count
                            team1TextArray.remove(at: team1TextArrayLength - 1)
                            team1LabelPlayer = team1TextArray.joined(separator: " ")
                        }
                        cell.textLabel?.text = rowTitle! + ", " + team1LabelPlayer
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
                    if overUnderSliderFormValuePlayer == "-10000" || (overUnderRangeSliderLowerValuePlayer == overUnderValuesPlayer.first && overUnderRangeSliderUpperValuePlayer == overUnderValuesPlayer.last) {
                        cell.detailTextLabel?.text = "IS ANY"
                    } else {
                        cell.detailTextLabel?.text = overUnderOperatorTextPlayer + overUnderSliderFormValuePlayer
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    cell.textLabel?.font = twelveSemiboldSFCompact
                    cell.detailTextLabel?.font = twelveThinSFCompact
                    cell.textLabel?.addTextSpacing(spacing: -0.3)
                    cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
            }
            
            <<< ButtonRow("STREAK, PLAYER TEAM") { row in
                row.title = row.tag
                row.presentationMode = .segueName(segueName: "WinLossStreakTeam1Segue", onDismiss: nil)
                } .cellUpdate { cell, row in
                    if winningLosingStreakTeam1SliderFormValuePlayer == "-10000" || (winningLosingStreakTeam1RangeSliderLowerValuePlayer == winningLosingStreakTeam1ValuesPlayer.first && winningLosingStreakTeam1RangeSliderUpperValuePlayer == winningLosingStreakTeam1ValuesPlayer.last) {
                        cell.detailTextLabel?.text = "IS ANY"
                    } else {
                        cell.detailTextLabel?.text = winningLosingStreakTeam1OperatorTextPlayer + winningLosingStreakTeam1SliderFormValuePlayer
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    var rowTitle = row.tag
                    var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                    rowTitle = rowTitleTextArray?[0]
                    if team1ListValuePlayer == ["-10000"] || team1ListValuePlayer == [] {
                        cell.textLabel?.text = row.tag
                    } else {
                        if team1ListValuePlayer[0] == "NEW YORK GIANTS" {
                            team1LabelPlayer = "NEW YORK (G)"
                        } else if team1ListValuePlayer[0] == "NEW YORK JETS" {
                            team1LabelPlayer = "NEW YORK (J)"
                        } else if team1ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                            team1LabelPlayer = "LOS ANGELES (C)"
                        } else if team1ListValuePlayer[0] == "LOS ANGELES RAMS" {
                            team1LabelPlayer = "LOS ANGELES (R)"
                        } else {
                            team1LabelPlayer = team1ListValuePlayer[0]
                            var team1TextArray = team1LabelPlayer.components(separatedBy: " ")
                            let team1TextArrayLength = team1TextArray.count
                            team1TextArray.remove(at: team1TextArrayLength - 1)
                            team1LabelPlayer = team1TextArray.joined(separator: " ")
                        }
                        cell.textLabel?.text = rowTitle! + ", " + team1LabelPlayer
                    }
                    cell.textLabel?.font = twelveSemiboldSFCompact
                    cell.detailTextLabel?.font = twelveThinSFCompact
                    cell.textLabel?.addTextSpacing(spacing: -0.3)
                    cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                    //print("winningLosingStreakTeam1SliderFormValuePlayer: ")
                    //print(winningLosingStreakTeam1SliderFormValuePlayer)
                }
            
            <<< ButtonRow("STREAK, OPPONENT") { row in
                row.title = row.tag
                row.presentationMode = .segueName(segueName: "WinLossStreakTeam2Segue", onDismiss: nil)
                } .cellUpdate { cell, row in
                    if winningLosingStreakTeam2SliderFormValuePlayer == "-10000" || (winningLosingStreakTeam2RangeSliderLowerValuePlayer == winningLosingStreakTeam2ValuesPlayer.first && winningLosingStreakTeam2RangeSliderUpperValuePlayer == winningLosingStreakTeam2ValuesPlayer.last) {
                        cell.detailTextLabel?.text = "IS ANY"
                    } else {
                        cell.detailTextLabel?.text = winningLosingStreakTeam2OperatorTextPlayer + winningLosingStreakTeam2SliderFormValuePlayer
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    var rowTitle = row.tag
                    var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                    rowTitle = rowTitleTextArray?[0]
                    if team2ListValuePlayer == ["-10000"] || team2ListValuePlayer == [] || team2ListValuePlayer.count > 1 {
                        cell.textLabel?.text = row.tag
                    } else {
                        if team2ListValuePlayer[0] == "NEW YORK GIANTS" {
                            team2LabelPlayer = "NEW YORK (G)"
                        } else if team2ListValuePlayer[0] == "NEW YORK JETS" {
                            team2LabelPlayer = "NEW YORK (J)"
                        } else if team2ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                            team2LabelPlayer = "LOS ANGELES (C)"
                        } else if team2ListValuePlayer[0] == "LOS ANGELES RAMS" {
                            team2LabelPlayer = "LOS ANGELES (R)"
                        } else {
                            team2LabelPlayer = team2ListValuePlayer[0]
                            var team2TextArray = team2LabelPlayer.components(separatedBy: " ")
                            let team2TextArrayLength = team2TextArray.count
                            team2TextArray.remove(at: team2TextArrayLength - 1)
                            team2LabelPlayer = team2TextArray.joined(separator: " ")
                        }
                        cell.textLabel?.text = rowTitle! + ", " + team2LabelPlayer
                    }
                    cell.textLabel?.font = twelveSemiboldSFCompact
                    cell.detailTextLabel?.font = twelveThinSFCompact
                    cell.textLabel?.addTextSpacing(spacing: -0.3)
                    cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                    //print("winningLosingStreakTeam2SliderFormValuePlayer: ")
                    //print(winningLosingStreakTeam2SliderFormValuePlayer)
                }
            
            <<< ButtonRow("SEASON WIN %, PLAYER TEAM") { row in
                row.title = row.tag
                row.presentationMode = .segueName(segueName: "SeasonWinPercentageTeam1Segue", onDismiss: nil)
                } .cellUpdate { cell, row in
                    if seasonWinPercentageTeam1SliderFormValuePlayer == "-10000" || (seasonWinPercentageTeam1RangeSliderLowerValuePlayer == seasonWinPercentageTeam1ValuesPlayer.first && seasonWinPercentageTeam1RangeSliderUpperValuePlayer == seasonWinPercentageTeam1ValuesPlayer.last) {
                        cell.detailTextLabel?.text = "IS ANY"
                    } else {
                        cell.detailTextLabel?.text = seasonWinPercentageTeam1OperatorTextPlayer + seasonWinPercentageTeam1SliderFormValuePlayer
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    var rowTitle = row.tag
                    var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                    rowTitle = rowTitleTextArray?[0]
                    if team1ListValuePlayer == ["-10000"] || team1ListValuePlayer == [] {
                        cell.textLabel?.text = row.tag
                    } else {
                        if team1ListValuePlayer[0] == "NEW YORK GIANTS" {
                            team1LabelPlayer = "NEW YORK (G)"
                        } else if team1ListValuePlayer[0] == "NEW YORK JETS" {
                            team1LabelPlayer = "NEW YORK (J)"
                        } else if team1ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                            team1LabelPlayer = "LOS ANGELES (C)"
                        } else if team1ListValuePlayer[0] == "LOS ANGELES RAMS" {
                            team1LabelPlayer = "LOS ANGELES (R)"
                        } else {
                            team1LabelPlayer = team1ListValuePlayer[0]
                            var team1TextArray = team1LabelPlayer.components(separatedBy: " ")
                            let team1TextArrayLength = team1TextArray.count
                            team1TextArray.remove(at: team1TextArrayLength - 1)
                            team1LabelPlayer = team1TextArray.joined(separator: " ")
                        }
                        cell.textLabel?.text = rowTitle! + ", " + team1LabelPlayer
                    }
                    cell.textLabel?.font = twelveSemiboldSFCompact
                    cell.detailTextLabel?.font = twelveThinSFCompact
                    cell.textLabel?.addTextSpacing(spacing: -0.3)
                    cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                    //print("seasonWinPercentageTeam1SliderFormValuePlayer: ")
                    //print(seasonWinPercentageTeam1SliderFormValuePlayer)
                }
            
            <<< ButtonRow("SEASON WIN %, OPPONENT") { row in
                row.title = row.tag
                row.presentationMode = .segueName(segueName: "SeasonWinPercentageTeam2Segue", onDismiss: nil)
                } .cellUpdate { cell, row in
                    if seasonWinPercentageTeam2SliderFormValuePlayer == "-10000" || (seasonWinPercentageTeam2RangeSliderLowerValuePlayer == seasonWinPercentageTeam2ValuesPlayer.first && seasonWinPercentageTeam2RangeSliderUpperValuePlayer == seasonWinPercentageTeam2ValuesPlayer.last) {
                        cell.detailTextLabel?.text = "IS ANY"
                    } else {
                        cell.detailTextLabel?.text = seasonWinPercentageTeam2OperatorTextPlayer + seasonWinPercentageTeam2SliderFormValuePlayer
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    var rowTitle = row.tag
                    var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                    rowTitle = rowTitleTextArray?[0]
                    if team2ListValuePlayer == ["-10000"] || team2ListValuePlayer == [] || team2ListValuePlayer.count > 1 {
                        cell.textLabel?.text = row.tag
                    } else {
                        if team2ListValuePlayer[0] == "NEW YORK GIANTS" {
                            team2LabelPlayer = "NEW YORK (G)"
                        } else if team2ListValuePlayer[0] == "NEW YORK JETS" {
                            team2LabelPlayer = "NEW YORK (J)"
                        } else if team2ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                            team2LabelPlayer = "LOS ANGELES (C)"
                        } else if team2ListValuePlayer[0] == "LOS ANGELES RAMS" {
                            team2LabelPlayer = "LOS ANGELES (R)"
                        } else {
                            team2LabelPlayer = team2ListValuePlayer[0]
                            var team2TextArray = team2LabelPlayer.components(separatedBy: " ")
                            let team2TextArrayLength = team2TextArray.count
                            team2TextArray.remove(at: team2TextArrayLength - 1)
                            team2LabelPlayer = team2TextArray.joined(separator: " ")
                        }
                        cell.textLabel?.text = rowTitle! + ", " + team2LabelPlayer
                    }
                    cell.textLabel?.font = twelveSemiboldSFCompact
                    cell.detailTextLabel?.font = twelveThinSFCompact
                    cell.textLabel?.addTextSpacing(spacing: -0.3)
                    cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
                    //print("seasonWinPercentageTeam2SliderFormValuePlayer: ")
                    //print(seasonWinPercentageTeam2SliderFormValuePlayer)
                }
            
            
            ///  IN-GAME:  PLAYERS  ///
           /* +++ Section("IN-GAME:  PLAYERS"){ section in
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
            
            <<< ButtonRow("PLAYERS, PLAYER TEAM") { row in
                row.title = row.tag
                row.presentationMode = .segueName(segueName: "PlayerTeamSegue", onDismiss: nil)
                } .cellUpdate { cell, row in
                    if playerListValuePlayer == ["-10000"] || playerListValuePlayer == [] {
                        cell.detailTextLabel?.text = "INCLUDE ANY"
                    } else {
                        cell.detailTextLabel?.text = playerOperatorTextPlayer + playerListValuePlayer.sorted().joined(separator: ", ")
                        cell.detailTextLabel?.textColor = orangeColorDarker
                        
                    }
                    var rowTitle = row.tag
                    var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                    rowTitle = rowTitleTextArray?[0]
                    if team1ListValuePlayer == ["-10000"] || team1ListValuePlayer == [] {
                        cell.textLabel?.text = row.tag
                    } else {
                        if team1ListValuePlayer[0] == "NEW YORK GIANTS" {
                            team1LabelPlayer = "NEW YORK (G)"
                        } else if team1ListValuePlayer[0] == "NEW YORK JETS" {
                            team1LabelPlayer = "NEW YORK (J)"
                        } else if team1ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                            team1LabelPlayer = "LOS ANGELES (C)"
                        } else if team1ListValuePlayer[0] == "LOS ANGELES RAMS" {
                            team1LabelPlayer = "LOS ANGELES (R)"
                        } else {
                            team1LabelPlayer = team1ListValuePlayer[0]
                            var team1TextArray = team1LabelPlayer.components(separatedBy: " ")
                            let team1TextArrayLength = team1TextArray.count
                            team1TextArray.remove(at: team1TextArrayLength - 1)
                            team1LabelPlayer = team1TextArray.joined(separator: " ")
                        }
                        cell.textLabel?.text = rowTitle! + ", " + team1LabelPlayer
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
                    if playerOpponentListValuePlayer == ["-10000"] || playerOpponentListValuePlayer == [] {
                        cell.detailTextLabel?.text = "INCLUDE ANY"
                    } else {
                        cell.detailTextLabel?.text = playerOpponentOperatorTextPlayer + playerOpponentListValuePlayer.sorted().joined(separator: ", ")
                        cell.detailTextLabel?.textColor = orangeColorDarker
                        
                    }
                    var rowTitle = row.tag
                    var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                    rowTitle = rowTitleTextArray?[0]
                    if team2ListValuePlayer == ["-10000"] || team2ListValuePlayer == [] {
                        cell.textLabel?.text = row.tag
                    } else {
                        if team2ListValuePlayer[0] == "NEW YORK GIANTS" {
                            team2LabelPlayer = "NEW YORK (G)"
                        } else if team2ListValuePlayer[0] == "NEW YORK JETS" {
                            team2LabelPlayer = "NEW YORK (J)"
                        } else if team2ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                            team2LabelPlayer = "LOS ANGELES (C)"
                        } else if team2ListValuePlayer[0] == "LOS ANGELES RAMS" {
                            team2LabelPlayer = "LOS ANGELES (R)"
                        } else {
                            team2LabelPlayer = team2ListValuePlayer[0]
                            var team2TextArray = team2LabelPlayer.components(separatedBy: " ")
                            let team2TextArrayLength = team2TextArray.count
                            team2TextArray.remove(at: team2TextArrayLength - 1)
                            team2LabelPlayer = team2TextArray.joined(separator: " ")
                        }
                        cell.textLabel?.text = rowTitle! + ", " + team2LabelPlayer
                    }
                    cell.textLabel?.font = twelveSemiboldSFCompact
                    cell.detailTextLabel?.font = twelveThinSFCompact
                    cell.textLabel?.addTextSpacing(spacing: -0.3)
                    cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
            }
            */
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
            <<< ButtonRow("TOTAL POINTS, PLAYER TEAM") { row in
                row.title = row.tag
                row.presentationMode = .segueName(segueName: "TotalPointsTeam1Segue", onDismiss: nil)
                } .cellUpdate { cell, row in
                    if totalPointsTeam1SliderFormValuePlayer == "-10000" || (totalPointsTeam1RangeSliderLowerValuePlayer == totalPointsTeam1ValuesPlayer.first && totalPointsTeam1RangeSliderUpperValuePlayer == totalPointsTeam1ValuesPlayer.last) {
                        cell.detailTextLabel?.text = "EQUAL ANY"
                    } else {
                        cell.detailTextLabel?.text = totalPointsTeam1OperatorTextPlayer + totalPointsTeam1SliderFormValuePlayer
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    var rowTitle = row.tag
                    var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                    rowTitle = rowTitleTextArray?[0]
                    if team1ListValuePlayer == ["-10000"] || team1ListValuePlayer == [] {
                        cell.textLabel?.text = row.tag
                    } else {
                        if team1ListValuePlayer[0] == "NEW YORK GIANTS" {
                            team1LabelPlayer = "NEW YORK (G)"
                        } else if team1ListValuePlayer[0] == "NEW YORK JETS" {
                            team1LabelPlayer = "NEW YORK (J)"
                        } else if team1ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                            team1LabelPlayer = "LOS ANGELES (C)"
                        } else if team1ListValuePlayer[0] == "LOS ANGELES RAMS" {
                            team1LabelPlayer = "LOS ANGELES (R)"
                        } else {
                            team1LabelPlayer = team1ListValuePlayer[0]
                            var team1TextArray = team1LabelPlayer.components(separatedBy: " ")
                            let team1TextArrayLength = team1TextArray.count
                            team1TextArray.remove(at: team1TextArrayLength - 1)
                            team1LabelPlayer = team1TextArray.joined(separator: " ")
                        }
                        cell.textLabel?.text = rowTitle! + ", " + team1LabelPlayer
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
                    if totalPointsTeam2SliderFormValuePlayer == "-10000" || (totalPointsTeam2RangeSliderLowerValuePlayer == totalPointsTeam2ValuesPlayer.first && totalPointsTeam2RangeSliderUpperValuePlayer == totalPointsTeam2ValuesPlayer.last) {
                        cell.detailTextLabel?.text = "EQUAL ANY"
                    } else {
                        cell.detailTextLabel?.text = totalPointsTeam2OperatorTextPlayer + totalPointsTeam2SliderFormValuePlayer
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    var rowTitle = row.tag
                    var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                    rowTitle = rowTitleTextArray?[0]
                    if team2ListValuePlayer == ["-10000"] || team2ListValuePlayer == [] || team2ListValuePlayer.count > 1 {
                        cell.textLabel?.text = row.tag
                    } else {
                        if team2ListValuePlayer[0] == "NEW YORK GIANTS" {
                            team2LabelPlayer = "NEW YORK (G)"
                        } else if team2ListValuePlayer[0] == "NEW YORK JETS" {
                            team2LabelPlayer = "NEW YORK (J)"
                        } else if team2ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                            team2LabelPlayer = "LOS ANGELES (C)"
                        } else if team2ListValuePlayer[0] == "LOS ANGELES RAMS" {
                            team2LabelPlayer = "LOS ANGELES (R)"
                        } else {
                            team2LabelPlayer = team2ListValuePlayer[0]
                            var team2TextArray = team2LabelPlayer.components(separatedBy: " ")
                            let team2TextArrayLength = team2TextArray.count
                            team2TextArray.remove(at: team2TextArrayLength - 1)
                            team2LabelPlayer = team2TextArray.joined(separator: " ")
                        }
                        cell.textLabel?.text = rowTitle! + ", " + team2LabelPlayer
                    }
                    cell.textLabel?.font = twelveSemiboldSFCompact
                    cell.detailTextLabel?.font = twelveThinSFCompact
                    cell.textLabel?.addTextSpacing(spacing: -0.3)
                    cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
            }
            
            <<< ButtonRow("TOUCHDOWNS, PLAYER TEAM") { row in
                row.title = row.tag
                row.presentationMode = .segueName(segueName: "TouchdownsTeam1Segue", onDismiss: nil)
                } .cellUpdate { cell, row in
                    if touchdownsTeam1SliderFormValuePlayer == "-10000" || (touchdownsTeam1RangeSliderLowerValuePlayer == touchdownsTeam1ValuesPlayer.first && touchdownsTeam1RangeSliderUpperValuePlayer == touchdownsTeam1ValuesPlayer.last) {
                        cell.detailTextLabel?.text = "EQUAL ANY"
                    } else {
                        cell.detailTextLabel?.text = touchdownsTeam1OperatorTextPlayer + touchdownsTeam1SliderFormValuePlayer
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    var rowTitle = row.tag
                    var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                    rowTitle = rowTitleTextArray?[0]
                    if team1ListValuePlayer == ["-10000"] || team1ListValuePlayer == [] {
                        cell.textLabel?.text = row.tag
                    } else {
                        if team1ListValuePlayer[0] == "NEW YORK GIANTS" {
                            team1LabelPlayer = "NEW YORK (G)"
                        } else if team1ListValuePlayer[0] == "NEW YORK JETS" {
                            team1LabelPlayer = "NEW YORK (J)"
                        } else if team1ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                            team1LabelPlayer = "LOS ANGELES (C)"
                        } else if team1ListValuePlayer[0] == "LOS ANGELES RAMS" {
                            team1LabelPlayer = "LOS ANGELES (R)"
                        } else {
                            team1LabelPlayer = team1ListValuePlayer[0]
                            var team1TextArray = team1LabelPlayer.components(separatedBy: " ")
                            let team1TextArrayLength = team1TextArray.count
                            team1TextArray.remove(at: team1TextArrayLength - 1)
                            team1LabelPlayer = team1TextArray.joined(separator: " ")
                        }
                        cell.textLabel?.text = rowTitle! + ", " + team1LabelPlayer
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
                    if touchdownsTeam2SliderFormValuePlayer == "-10000" || (touchdownsTeam2RangeSliderLowerValuePlayer == touchdownsTeam2ValuesPlayer.first && touchdownsTeam2RangeSliderUpperValuePlayer == touchdownsTeam2ValuesPlayer.last) {
                        cell.detailTextLabel?.text = "EQUAL ANY"
                    } else {
                        cell.detailTextLabel?.text = touchdownsTeam2OperatorTextPlayer + touchdownsTeam2SliderFormValuePlayer
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    var rowTitle = row.tag
                    var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                    rowTitle = rowTitleTextArray?[0]
                    if team2ListValuePlayer == ["-10000"] || team2ListValuePlayer == [] || team2ListValuePlayer.count > 1 {
                        cell.textLabel?.text = row.tag
                    } else {
                        if team2ListValuePlayer[0] == "NEW YORK GIANTS" {
                            team2LabelPlayer = "NEW YORK (G)"
                        } else if team2ListValuePlayer[0] == "NEW YORK JETS" {
                            team2LabelPlayer = "NEW YORK (J)"
                        } else if team2ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                            team2LabelPlayer = "LOS ANGELES (C)"
                        } else if team2ListValuePlayer[0] == "LOS ANGELES RAMS" {
                            team2LabelPlayer = "LOS ANGELES (R)"
                        } else {
                            team2LabelPlayer = team2ListValuePlayer[0]
                            var team2TextArray = team2LabelPlayer.components(separatedBy: " ")
                            let team2TextArrayLength = team2TextArray.count
                            team2TextArray.remove(at: team2TextArrayLength - 1)
                            team2LabelPlayer = team2TextArray.joined(separator: " ")
                        }
                        cell.textLabel?.text = rowTitle! + ", " + team2LabelPlayer
                    }
                    cell.textLabel?.font = twelveSemiboldSFCompact
                    cell.detailTextLabel?.font = twelveThinSFCompact
                    cell.textLabel?.addTextSpacing(spacing: -0.3)
                    cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
            }
            
            <<< ButtonRow("TURNOVERS, PLAYER TEAM") { row in
                row.title = row.tag
                row.presentationMode = .segueName(segueName: "TurnoversCommittedTeam1Segue", onDismiss: nil)
                } .cellUpdate { cell, row in
                    cell.textLabel?.font = twelveBold
                    if turnoversCommittedTeam1SliderFormValuePlayer == "-10000" || (turnoversCommittedTeam1RangeSliderLowerValuePlayer == turnoversCommittedTeam1ValuesPlayer.first && turnoversCommittedTeam1RangeSliderUpperValuePlayer == turnoversCommittedTeam1ValuesPlayer.last) {
                        cell.detailTextLabel?.text = "EQUAL ANY"
                    } else {
                        cell.detailTextLabel?.text = turnoversCommittedTeam1OperatorTextPlayer + turnoversCommittedTeam1SliderFormValuePlayer
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    var rowTitle = row.tag
                    var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                    rowTitle = rowTitleTextArray?[0]
                    if team1ListValuePlayer == ["-10000"] || team1ListValuePlayer == [] {
                        cell.textLabel?.text = row.tag
                    } else {
                        if team1ListValuePlayer[0] == "NEW YORK GIANTS" {
                            team1LabelPlayer = "NEW YORK (G)"
                        } else if team1ListValuePlayer[0] == "NEW YORK JETS" {
                            team1LabelPlayer = "NEW YORK (J)"
                        } else if team1ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                            team1LabelPlayer = "LOS ANGELES (C)"
                        } else if team1ListValuePlayer[0] == "LOS ANGELES RAMS" {
                            team1LabelPlayer = "LOS ANGELES (R)"
                        } else {
                            team1LabelPlayer = team1ListValuePlayer[0]
                            var team1TextArray = team1LabelPlayer.components(separatedBy: " ")
                            let team1TextArrayLength = team1TextArray.count
                            team1TextArray.remove(at: team1TextArrayLength - 1)
                            team1LabelPlayer = team1TextArray.joined(separator: " ")
                        }
                        cell.textLabel?.text = rowTitle! + ", " + team1LabelPlayer
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
                    if turnoversCommittedTeam2SliderFormValuePlayer == "-10000" || (turnoversCommittedTeam2RangeSliderLowerValuePlayer == turnoversCommittedTeam2ValuesPlayer.first && turnoversCommittedTeam2RangeSliderUpperValuePlayer == turnoversCommittedTeam2ValuesPlayer.last) {
                        cell.detailTextLabel?.text = "EQUAL ANY"
                    } else {
                        cell.detailTextLabel?.text = turnoversCommittedTeam2OperatorTextPlayer + turnoversCommittedTeam2SliderFormValuePlayer
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    var rowTitle = row.tag
                    var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                    rowTitle = rowTitleTextArray?[0]
                    if team2ListValuePlayer == ["-10000"] || team2ListValuePlayer == [] || team2ListValuePlayer.count > 1 {
                        cell.textLabel?.text = row.tag
                    } else {
                        if team2ListValuePlayer[0] == "NEW YORK GIANTS" {
                            team2LabelPlayer = "NEW YORK (G)"
                        } else if team2ListValuePlayer[0] == "NEW YORK JETS" {
                            team2LabelPlayer = "NEW YORK (J)"
                        } else if team2ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                            team2LabelPlayer = "LOS ANGELES (C)"
                        } else if team2ListValuePlayer[0] == "LOS ANGELES RAMS" {
                            team2LabelPlayer = "LOS ANGELES (R)"
                        } else {
                            team2LabelPlayer = team2ListValuePlayer[0]
                            var team2TextArray = team2LabelPlayer.components(separatedBy: " ")
                            let team2TextArrayLength = team2TextArray.count
                            team2TextArray.remove(at: team2TextArrayLength - 1)
                            team2LabelPlayer = team2TextArray.joined(separator: " ")
                        }
                        cell.textLabel?.text = rowTitle! + ", " + team2LabelPlayer
                    }
                    cell.textLabel?.font = twelveSemiboldSFCompact
                    cell.detailTextLabel?.font = twelveThinSFCompact
                    cell.textLabel?.addTextSpacing(spacing: -0.3)
                    cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
            }
            
            <<< ButtonRow("PENALTIES, PLAYER TEAM") { row in
                row.title = row.tag
                row.presentationMode = .segueName(segueName: "PenaltiesCommittedTeam1Segue", onDismiss: nil)
                } .cellUpdate { cell, row in
                    if penaltiesCommittedTeam1SliderFormValuePlayer == "-10000" || (penaltiesCommittedTeam1RangeSliderLowerValuePlayer == penaltiesCommittedTeam1ValuesPlayer.first && penaltiesCommittedTeam1RangeSliderUpperValuePlayer == penaltiesCommittedTeam1ValuesPlayer.last) {
                        cell.detailTextLabel?.text = "EQUAL ANY"
                    } else {
                        cell.detailTextLabel?.text = penaltiesCommittedTeam1OperatorTextPlayer + penaltiesCommittedTeam1SliderFormValuePlayer
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    var rowTitle = row.tag
                    var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                    rowTitle = rowTitleTextArray?[0]
                    if team1ListValuePlayer == ["-10000"] || team1ListValuePlayer == [] {
                        cell.textLabel?.text = row.tag
                    } else {
                        if team1ListValuePlayer[0] == "NEW YORK GIANTS" {
                            team1LabelPlayer = "NEW YORK (G)"
                        } else if team1ListValuePlayer[0] == "NEW YORK JETS" {
                            team1LabelPlayer = "NEW YORK (J)"
                        } else if team1ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                            team1LabelPlayer = "LOS ANGELES (C)"
                        } else if team1ListValuePlayer[0] == "LOS ANGELES RAMS" {
                            team1LabelPlayer = "LOS ANGELES (R)"
                        } else {
                            team1LabelPlayer = team1ListValuePlayer[0]
                            var team1TextArray = team1LabelPlayer.components(separatedBy: " ")
                            let team1TextArrayLength = team1TextArray.count
                            team1TextArray.remove(at: team1TextArrayLength - 1)
                            team1LabelPlayer = team1TextArray.joined(separator: " ")
                        }
                        cell.textLabel?.text = rowTitle! + ", " + team1LabelPlayer
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
                    if penaltiesCommittedTeam2SliderFormValuePlayer == "-10000" || (penaltiesCommittedTeam2RangeSliderLowerValuePlayer == penaltiesCommittedTeam2ValuesPlayer.first && penaltiesCommittedTeam2RangeSliderUpperValuePlayer == penaltiesCommittedTeam2ValuesPlayer.last) {
                        cell.detailTextLabel?.text = "EQUAL ANY"
                    } else {
                        cell.detailTextLabel?.text = penaltiesCommittedTeam2OperatorTextPlayer + penaltiesCommittedTeam2SliderFormValuePlayer
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    var rowTitle = row.tag
                    var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                    rowTitle = rowTitleTextArray?[0]
                    if team2ListValuePlayer == ["-10000"] || team2ListValuePlayer == [] || team2ListValuePlayer.count > 1 {
                        cell.textLabel?.text = row.tag
                    } else {
                        if team2ListValuePlayer[0] == "NEW YORK GIANTS" {
                            team2LabelPlayer = "NEW YORK (G)"
                        } else if team2ListValuePlayer[0] == "NEW YORK JETS" {
                            team2LabelPlayer = "NEW YORK (J)"
                        } else if team2ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                            team2LabelPlayer = "LOS ANGELES (C)"
                        } else if team2ListValuePlayer[0] == "LOS ANGELES RAMS" {
                            team2LabelPlayer = "LOS ANGELES (R)"
                        } else {
                            team2LabelPlayer = team2ListValuePlayer[0]
                            var team2TextArray = team2LabelPlayer.components(separatedBy: " ")
                            let team2TextArrayLength = team2TextArray.count
                            team2TextArray.remove(at: team2TextArrayLength - 1)
                            team2LabelPlayer = team2TextArray.joined(separator: " ")
                        }
                        cell.textLabel?.text = rowTitle! + ", " + team2LabelPlayer
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
            
            <<< ButtonRow("OFFENSIVE TOUCHDOWNS, PLAYER TEAM") { row in
                row.title = row.tag
                row.presentationMode = .segueName(segueName: "OffensiveTouchdownsTeam1Segue", onDismiss: nil)
                } .cellUpdate { cell, row in
                    if offensiveTouchdownsTeam1SliderFormValuePlayer == "-10000" || (offensiveTouchdownsTeam1RangeSliderLowerValuePlayer == offensiveTouchdownsTeam1ValuesPlayer.first && offensiveTouchdownsTeam1RangeSliderUpperValuePlayer == offensiveTouchdownsTeam1ValuesPlayer.last) {
                        cell.detailTextLabel?.text = "EQUAL ANY"
                    } else {
                        cell.detailTextLabel?.text = offensiveTouchdownsTeam1OperatorTextPlayer + offensiveTouchdownsTeam1SliderFormValuePlayer
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    var rowTitle = row.tag
                    var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                    rowTitle = rowTitleTextArray?[0]
                    if team1ListValuePlayer == ["-10000"] || team1ListValuePlayer == [] {
                        cell.textLabel?.text = row.tag
                    } else {
                        if team1ListValuePlayer[0] == "NEW YORK GIANTS" {
                            team1LabelPlayer = "NEW YORK (G)"
                        } else if team1ListValuePlayer[0] == "NEW YORK JETS" {
                            team1LabelPlayer = "NEW YORK (J)"
                        } else if team1ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                            team1LabelPlayer = "LOS ANGELES (C)"
                        } else if team1ListValuePlayer[0] == "LOS ANGELES RAMS" {
                            team1LabelPlayer = "LOS ANGELES (R)"
                        } else {
                            team1LabelPlayer = team1ListValuePlayer[0]
                            var team1TextArray = team1LabelPlayer.components(separatedBy: " ")
                            let team1TextArrayLength = team1TextArray.count
                            team1TextArray.remove(at: team1TextArrayLength - 1)
                            team1LabelPlayer = team1TextArray.joined(separator: " ")
                        }
                        cell.textLabel?.text = rowTitle! + ", " + team1LabelPlayer
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
                    if offensiveTouchdownsTeam2SliderFormValuePlayer == "-10000" || (offensiveTouchdownsTeam2RangeSliderLowerValuePlayer == offensiveTouchdownsTeam2ValuesPlayer.first && offensiveTouchdownsTeam2RangeSliderUpperValuePlayer == offensiveTouchdownsTeam2ValuesPlayer.last) {
                        cell.detailTextLabel?.text = "EQUAL ANY"
                    } else {
                        cell.detailTextLabel?.text = offensiveTouchdownsTeam2OperatorTextPlayer + offensiveTouchdownsTeam2SliderFormValuePlayer
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    var rowTitle = row.tag
                    var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                    rowTitle = rowTitleTextArray?[0]
                    if team1ListValuePlayer == ["-10000"] || team1ListValuePlayer == [] {
                        cell.textLabel?.text = row.tag
                    } else {
                        if team1ListValuePlayer[0] == "NEW YORK GIANTS" {
                            team1LabelPlayer = "NEW YORK (G)"
                        } else if team1ListValuePlayer[0] == "NEW YORK JETS" {
                            team1LabelPlayer = "NEW YORK (J)"
                        } else if team1ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                            team1LabelPlayer = "LOS ANGELES (C)"
                        } else if team1ListValuePlayer[0] == "LOS ANGELES RAMS" {
                            team1LabelPlayer = "LOS ANGELES (R)"
                        } else {
                            team1LabelPlayer = team1ListValuePlayer[0]
                            var team1TextArray = team1LabelPlayer.components(separatedBy: " ")
                            let team1TextArrayLength = team1TextArray.count
                            team1TextArray.remove(at: team1TextArrayLength - 1)
                            team1LabelPlayer = team1TextArray.joined(separator: " ")
                        }
                        cell.textLabel?.text = rowTitle! + ", " + team1LabelPlayer
                    }
                    cell.textLabel?.font = twelveSemiboldSFCompact
                    cell.detailTextLabel?.font = twelveThinSFCompact
                    cell.textLabel?.addTextSpacing(spacing: -0.3)
                    cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
            }
            
            <<< ButtonRow("TOTAL YARDS, PLAYER TEAM") { row in
                row.title = row.tag
                row.presentationMode = .segueName(segueName: "TotalYardsTeam1Segue", onDismiss: nil)
                } .cellUpdate { cell, row in
                    if totalYardsTeam1SliderFormValuePlayer == "-10000" || (totalYardsTeam1RangeSliderLowerValuePlayer == totalYardsTeam1ValuesPlayer.first && totalYardsTeam1RangeSliderUpperValuePlayer == totalYardsTeam1ValuesPlayer.last) {
                        cell.detailTextLabel?.text = "EQUAL ANY"
                    } else {
                        cell.detailTextLabel?.text = totalYardsTeam1OperatorTextPlayer + totalYardsTeam1SliderFormValuePlayer
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    var rowTitle = row.tag
                    var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                    rowTitle = rowTitleTextArray?[0]
                    if team1ListValuePlayer == ["-10000"] || team1ListValuePlayer == [] {
                        cell.textLabel?.text = row.tag
                    } else {
                        if team1ListValuePlayer[0] == "NEW YORK GIANTS" {
                            team1LabelPlayer = "NEW YORK (G)"
                        } else if team1ListValuePlayer[0] == "NEW YORK JETS" {
                            team1LabelPlayer = "NEW YORK (J)"
                        } else if team1ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                            team1LabelPlayer = "LOS ANGELES (C)"
                        } else if team1ListValuePlayer[0] == "LOS ANGELES RAMS" {
                            team1LabelPlayer = "LOS ANGELES (R)"
                        } else {
                            team1LabelPlayer = team1ListValuePlayer[0]
                            var team1TextArray = team1LabelPlayer.components(separatedBy: " ")
                            let team1TextArrayLength = team1TextArray.count
                            team1TextArray.remove(at: team1TextArrayLength - 1)
                            team1LabelPlayer = team1TextArray.joined(separator: " ")
                        }
                        cell.textLabel?.text = rowTitle! + ", " + team1LabelPlayer
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
                    if totalYardsTeam2SliderFormValuePlayer == "-10000" || (totalYardsTeam2RangeSliderLowerValuePlayer == totalYardsTeam2ValuesPlayer.first && totalYardsTeam2RangeSliderUpperValuePlayer == totalYardsTeam2ValuesPlayer.last) {
                        cell.detailTextLabel?.text = "EQUAL ANY"
                    } else {
                        cell.detailTextLabel?.text = totalYardsTeam2OperatorTextPlayer + totalYardsTeam2SliderFormValuePlayer
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    var rowTitle = row.tag
                    var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                    rowTitle = rowTitleTextArray?[0]
                    if team2ListValuePlayer == ["-10000"] || team2ListValuePlayer == [] || team2ListValuePlayer.count > 1 {
                        cell.textLabel?.text = row.tag
                    } else {
                        if team2ListValuePlayer[0] == "NEW YORK GIANTS" {
                            team2LabelPlayer = "NEW YORK (G)"
                        } else if team2ListValuePlayer[0] == "NEW YORK JETS" {
                            team2LabelPlayer = "NEW YORK (J)"
                        } else if team2ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                            team2LabelPlayer = "LOS ANGELES (C)"
                        } else if team2ListValuePlayer[0] == "LOS ANGELES RAMS" {
                            team2LabelPlayer = "LOS ANGELES (R)"
                        } else {
                            team2LabelPlayer = team2ListValuePlayer[0]
                            var team2TextArray = team2LabelPlayer.components(separatedBy: " ")
                            let team2TextArrayLength = team2TextArray.count
                            team2TextArray.remove(at: team2TextArrayLength - 1)
                            team2LabelPlayer = team2TextArray.joined(separator: " ")
                        }
                        cell.textLabel?.text = rowTitle! + ", " + team2LabelPlayer
                    }
                    cell.textLabel?.font = twelveSemiboldSFCompact
                    cell.detailTextLabel?.font = twelveThinSFCompact
                    cell.textLabel?.addTextSpacing(spacing: -0.3)
                    cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
            }
            
            <<< ButtonRow("PASSING YARDS, PLAYER TEAM") { row in
                row.title = row.tag
                row.presentationMode = .segueName(segueName: "PassingYardsTeam1Segue", onDismiss: nil)
                } .cellUpdate { cell, row in
                    if passingYardsTeam1SliderFormValuePlayer == "-10000" || (passingYardsTeam1RangeSliderLowerValuePlayer == passingYardsTeam1ValuesPlayer.first && passingYardsTeam1RangeSliderUpperValuePlayer == passingYardsTeam1ValuesPlayer.last) {
                        cell.detailTextLabel?.text = "EQUAL ANY"
                    } else {
                        cell.detailTextLabel?.text = passingYardsTeam1OperatorTextPlayer + passingYardsTeam1SliderFormValuePlayer
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    var rowTitle = row.tag
                    var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                    rowTitle = rowTitleTextArray?[0]
                    if team1ListValuePlayer == ["-10000"] || team1ListValuePlayer == [] {
                        cell.textLabel?.text = row.tag
                    } else {
                        if team1ListValuePlayer[0] == "NEW YORK GIANTS" {
                            team1LabelPlayer = "NEW YORK (G)"
                        } else if team1ListValuePlayer[0] == "NEW YORK JETS" {
                            team1LabelPlayer = "NEW YORK (J)"
                        } else if team1ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                            team1LabelPlayer = "LOS ANGELES (C)"
                        } else if team1ListValuePlayer[0] == "LOS ANGELES RAMS" {
                            team1LabelPlayer = "LOS ANGELES (R)"
                        } else {
                            team1LabelPlayer = team1ListValuePlayer[0]
                            var team1TextArray = team1LabelPlayer.components(separatedBy: " ")
                            let team1TextArrayLength = team1TextArray.count
                            team1TextArray.remove(at: team1TextArrayLength - 1)
                            team1LabelPlayer = team1TextArray.joined(separator: " ")
                        }
                        cell.textLabel?.text = rowTitle! + ", " + team1LabelPlayer
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
                    if passingYardsTeam2SliderFormValuePlayer == "-10000" || (passingYardsTeam2RangeSliderLowerValuePlayer == passingYardsTeam2ValuesPlayer.first && passingYardsTeam2RangeSliderUpperValuePlayer == passingYardsTeam2ValuesPlayer.last) {
                        cell.detailTextLabel?.text = "EQUAL ANY"
                    } else {
                        cell.detailTextLabel?.text = passingYardsTeam2OperatorTextPlayer + passingYardsTeam2SliderFormValuePlayer
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    var rowTitle = row.tag
                    var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                    rowTitle = rowTitleTextArray?[0]
                    if team2ListValuePlayer == ["-10000"] || team2ListValuePlayer == [] || team2ListValuePlayer.count > 1 {
                        cell.textLabel?.text = row.tag
                    } else {
                        if team2ListValuePlayer[0] == "NEW YORK GIANTS" {
                            team2LabelPlayer = "NEW YORK (G)"
                        } else if team2ListValuePlayer[0] == "NEW YORK JETS" {
                            team2LabelPlayer = "NEW YORK (J)"
                        } else if team2ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                            team2LabelPlayer = "LOS ANGELES (C)"
                        } else if team2ListValuePlayer[0] == "LOS ANGELES RAMS" {
                            team2LabelPlayer = "LOS ANGELES (R)"
                        } else {
                            team2LabelPlayer = team2ListValuePlayer[0]
                            var team2TextArray = team2LabelPlayer.components(separatedBy: " ")
                            let team2TextArrayLength = team2TextArray.count
                            team2TextArray.remove(at: team2TextArrayLength - 1)
                            team2LabelPlayer = team2TextArray.joined(separator: " ")
                        }
                        cell.textLabel?.text = rowTitle! + ", " + team2LabelPlayer
                    }
                    cell.textLabel?.font = twelveSemiboldSFCompact
                    cell.detailTextLabel?.font = twelveThinSFCompact
                    cell.textLabel?.addTextSpacing(spacing: -0.3)
                    cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
            }
            
            <<< ButtonRow("RUSHING YARDS, PLAYER TEAM") { row in
                row.title = row.tag
                row.presentationMode = .segueName(segueName: "RushingYardsTeam1Segue", onDismiss: nil)
                } .cellUpdate { cell, row in
                    if rushingYardsTeam1SliderFormValuePlayer == "-10000" || (rushingYardsTeam1RangeSliderLowerValuePlayer == rushingYardsTeam1ValuesPlayer.first && rushingYardsTeam1RangeSliderUpperValuePlayer == rushingYardsTeam1ValuesPlayer.last) {
                        cell.detailTextLabel?.text = "EQUAL ANY"
                    } else {
                        cell.detailTextLabel?.text = rushingYardsTeam1OperatorTextPlayer + rushingYardsTeam1SliderFormValuePlayer
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    var rowTitle = row.tag
                    var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                    rowTitle = rowTitleTextArray?[0]
                    if team1ListValuePlayer == ["-10000"] || team1ListValuePlayer == [] {
                        cell.textLabel?.text = row.tag
                    } else {
                        if team1ListValuePlayer[0] == "NEW YORK GIANTS" {
                            team1LabelPlayer = "NEW YORK (G)"
                        } else if team1ListValuePlayer[0] == "NEW YORK JETS" {
                            team1LabelPlayer = "NEW YORK (J)"
                        } else if team1ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                            team1LabelPlayer = "LOS ANGELES (C)"
                        } else if team1ListValuePlayer[0] == "LOS ANGELES RAMS" {
                            team1LabelPlayer = "LOS ANGELES (R)"
                        } else {
                            team1LabelPlayer = team1ListValuePlayer[0]
                            var team1TextArray = team1LabelPlayer.components(separatedBy: " ")
                            let team1TextArrayLength = team1TextArray.count
                            team1TextArray.remove(at: team1TextArrayLength - 1)
                            team1LabelPlayer = team1TextArray.joined(separator: " ")
                        }
                        cell.textLabel?.text = rowTitle! + ", " + team1LabelPlayer
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
                    if rushingYardsTeam2SliderFormValuePlayer == "-10000" || (rushingYardsTeam2RangeSliderLowerValuePlayer == rushingYardsTeam2ValuesPlayer.first && rushingYardsTeam2RangeSliderUpperValuePlayer == rushingYardsTeam2ValuesPlayer.last) {
                        cell.detailTextLabel?.text = "EQUAL ANY"
                    } else {
                        cell.detailTextLabel?.text = rushingYardsTeam2OperatorTextPlayer + rushingYardsTeam2SliderFormValuePlayer
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    var rowTitle = row.tag
                    var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                    rowTitle = rowTitleTextArray?[0]
                    if team2ListValuePlayer == ["-10000"] || team2ListValuePlayer == [] || team2ListValuePlayer.count > 1 {
                        cell.textLabel?.text = row.tag
                    } else {
                        if team2ListValuePlayer[0] == "NEW YORK GIANTS" {
                            team2LabelPlayer = "NEW YORK (G)"
                        } else if team2ListValuePlayer[0] == "NEW YORK JETS" {
                            team2LabelPlayer = "NEW YORK (J)"
                        } else if team2ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                            team2LabelPlayer = "LOS ANGELES (C)"
                        } else if team2ListValuePlayer[0] == "LOS ANGELES RAMS" {
                            team2LabelPlayer = "LOS ANGELES (R)"
                        } else {
                            team2LabelPlayer = team2ListValuePlayer[0]
                            var team2TextArray = team2LabelPlayer.components(separatedBy: " ")
                            let team2TextArrayLength = team2TextArray.count
                            team2TextArray.remove(at: team2TextArrayLength - 1)
                            team2LabelPlayer = team2TextArray.joined(separator: " ")
                        }
                        cell.textLabel?.text = rowTitle! + ", " + team2LabelPlayer
                    }
                    cell.textLabel?.font = twelveSemiboldSFCompact
                    cell.detailTextLabel?.font = twelveThinSFCompact
                    cell.textLabel?.addTextSpacing(spacing: -0.3)
                    cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
            }
            
            <<< ButtonRow("QUARTERBACK RATING, PLAYER TEAM") { row in
                row.title = row.tag
                row.presentationMode = .segueName(segueName: "QuarterbackRatingTeam1Segue", onDismiss: nil)
                } .cellUpdate { cell, row in
                    if quarterbackRatingTeam1SliderFormValuePlayer == "-10000" || (quarterbackRatingTeam1RangeSliderLowerValuePlayer == quarterbackRatingTeam1ValuesPlayer.first && quarterbackRatingTeam1RangeSliderUpperValuePlayer == quarterbackRatingTeam1ValuesPlayer.last) {
                        cell.detailTextLabel?.text = "EQUAL ANY"
                    } else {
                        cell.detailTextLabel?.text = quarterbackRatingTeam1OperatorTextPlayer + quarterbackRatingTeam1SliderFormValuePlayer
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    var rowTitle = row.tag
                    var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                    rowTitle = rowTitleTextArray?[0]
                    if team1ListValuePlayer == ["-10000"] || team1ListValuePlayer == [] {
                        cell.textLabel?.text = row.tag
                    } else {
                        if team1ListValuePlayer[0] == "NEW YORK GIANTS" {
                            team1LabelPlayer = "NEW YORK (G)"
                        } else if team1ListValuePlayer[0] == "NEW YORK JETS" {
                            team1LabelPlayer = "NEW YORK (J)"
                        } else if team1ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                            team1LabelPlayer = "LOS ANGELES (C)"
                        } else if team1ListValuePlayer[0] == "LOS ANGELES RAMS" {
                            team1LabelPlayer = "LOS ANGELES (R)"
                        } else {
                            team1LabelPlayer = team1ListValuePlayer[0]
                            var team1TextArray = team1LabelPlayer.components(separatedBy: " ")
                            let team1TextArrayLength = team1TextArray.count
                            team1TextArray.remove(at: team1TextArrayLength - 1)
                            team1LabelPlayer = team1TextArray.joined(separator: " ")
                        }
                        cell.textLabel?.text = rowTitle! + ", " + team1LabelPlayer
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
                    if quarterbackRatingTeam2SliderFormValuePlayer == "-10000" || (quarterbackRatingTeam2RangeSliderLowerValuePlayer == quarterbackRatingTeam2ValuesPlayer.first && quarterbackRatingTeam2RangeSliderUpperValuePlayer == quarterbackRatingTeam2ValuesPlayer.last) {
                        cell.detailTextLabel?.text = "EQUAL ANY"
                    } else {
                        cell.detailTextLabel?.text = quarterbackRatingTeam2OperatorTextPlayer + quarterbackRatingTeam2SliderFormValuePlayer
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    var rowTitle = row.tag
                    var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                    rowTitle = rowTitleTextArray?[0]
                    if team2ListValuePlayer == ["-10000"] || team2ListValuePlayer == [] || team2ListValuePlayer.count > 1 {
                        cell.textLabel?.text = row.tag
                    } else {
                        if team2ListValuePlayer[0] == "NEW YORK GIANTS" {
                            team2LabelPlayer = "NEW YORK (G)"
                        } else if team2ListValuePlayer[0] == "NEW YORK JETS" {
                            team2LabelPlayer = "NEW YORK (J)"
                        } else if team2ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                            team2LabelPlayer = "LOS ANGELES (C)"
                        } else if team2ListValuePlayer[0] == "LOS ANGELES RAMS" {
                            team2LabelPlayer = "LOS ANGELES (R)"
                        } else {
                            team2LabelPlayer = team2ListValuePlayer[0]
                            var team2TextArray = team2LabelPlayer.components(separatedBy: " ")
                            let team2TextArrayLength = team2TextArray.count
                            team2TextArray.remove(at: team2TextArrayLength - 1)
                            team2LabelPlayer = team2TextArray.joined(separator: " ")
                        }
                        cell.textLabel?.text = rowTitle! + ", " + team2LabelPlayer
                    }
                    cell.textLabel?.font = twelveSemiboldSFCompact
                    cell.detailTextLabel?.font = twelveThinSFCompact
                    cell.textLabel?.addTextSpacing(spacing: -0.3)
                    cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
            }
            
            /*<<< ButtonRow("TIMES SACKED, PLAYER TEAM") { row in
                row.title = row.tag
                row.presentationMode = .segueName(segueName: "TimesSackedTeam1Segue", onDismiss: nil)
                } .cellUpdate { cell, row in
                    if timesSackedTeam1SliderFormValuePlayer == "-10000" || (timesSackedTeam1RangeSliderLowerValuePlayer == timesSackedTeam1ValuesPlayer.first && timesSackedTeam1RangeSliderUpperValuePlayer == timesSackedTeam1ValuesPlayer.last) {
                        cell.detailTextLabel?.text = "EQUAL ANY"
                    } else {
                        cell.detailTextLabel?.text = timesSackedTeam1OperatorTextPlayer + timesSackedTeam1SliderFormValuePlayer
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    var rowTitle = row.tag
                    var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                    rowTitle = rowTitleTextArray?[0]
                    if team1ListValuePlayer == ["-10000"] || team1ListValuePlayer == [] {
                        cell.textLabel?.text = row.tag
                    } else {
                        if team1ListValuePlayer[0] == "NEW YORK GIANTS" {
                            team1LabelPlayer = "NEW YORK (G)"
                        } else if team1ListValuePlayer[0] == "NEW YORK JETS" {
                            team1LabelPlayer = "NEW YORK (J)"
                        } else if team1ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                            team1LabelPlayer = "LOS ANGELES (C)"
                        } else if team1ListValuePlayer[0] == "LOS ANGELES RAMS" {
                            team1LabelPlayer = "LOS ANGELES (R)"
                        } else {
                            team1LabelPlayer = team1ListValuePlayer[0]
                            var team1TextArray = team1LabelPlayer.components(separatedBy: " ")
                            let team1TextArrayLength = team1TextArray.count
                            team1TextArray.remove(at: team1TextArrayLength - 1)
                            team1LabelPlayer = team1TextArray.joined(separator: " ")
                        }
                        cell.textLabel?.text = rowTitle! + ", " + team1LabelPlayer
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
                    if timesSackedTeam2SliderFormValuePlayer == "-10000" || (timesSackedTeam2RangeSliderLowerValuePlayer == timesSackedTeam2ValuesPlayer.first && timesSackedTeam2RangeSliderUpperValuePlayer == timesSackedTeam2ValuesPlayer.last) {
                        cell.detailTextLabel?.text = "EQUAL ANY"
                    } else {
                        cell.detailTextLabel?.text = timesSackedTeam2OperatorTextPlayer + timesSackedTeam2SliderFormValuePlayer
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    var rowTitle = row.tag
                    var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                    rowTitle = rowTitleTextArray?[0]
                    if team2ListValuePlayer == ["-10000"] || team2ListValuePlayer == [] || team2ListValuePlayer.count > 1 {
                        cell.textLabel?.text = row.tag
                    } else {
                        if team2ListValuePlayer[0] == "NEW YORK GIANTS" {
                            team2LabelPlayer = "NEW YORK (G)"
                        } else if team2ListValuePlayer[0] == "NEW YORK JETS" {
                            team2LabelPlayer = "NEW YORK (J)"
                        } else if team2ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                            team2LabelPlayer = "LOS ANGELES (C)"
                        } else if team2ListValuePlayer[0] == "LOS ANGELES RAMS" {
                            team2LabelPlayer = "LOS ANGELES (R)"
                        } else {
                            team2LabelPlayer = team2ListValuePlayer[0]
                            var team2TextArray = team2LabelPlayer.components(separatedBy: " ")
                            let team2TextArrayLength = team2TextArray.count
                            team2TextArray.remove(at: team2TextArrayLength - 1)
                            team2LabelPlayer = team2TextArray.joined(separator: " ")
                        }
                        cell.textLabel?.text = rowTitle! + ", " + team2LabelPlayer
                    }
                    cell.textLabel?.font = twelveSemiboldSFCompact
                    cell.detailTextLabel?.font = twelveThinSFCompact
                    cell.textLabel?.addTextSpacing(spacing: -0.3)
                cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
            }
        
            <<< ButtonRow("INTERCEPTIONS THROWN, PLAYER TEAM") { row in
                row.title = row.tag
                row.presentationMode = .segueName(segueName: "InterceptionsThrownTeam1Segue", onDismiss: nil)
                } .cellUpdate { cell, row in
                    if interceptionsThrownTeam1SliderFormValuePlayer == "-10000" || (interceptionsThrownTeam1RangeSliderLowerValuePlayer == interceptionsThrownTeam1ValuesPlayer.first && interceptionsThrownTeam1RangeSliderUpperValuePlayer == interceptionsThrownTeam1ValuesPlayer.last) {
                        cell.detailTextLabel?.text = "EQUAL ANY"
                    } else {
                        cell.detailTextLabel?.text = interceptionsThrownTeam1OperatorTextPlayer + interceptionsThrownTeam1SliderFormValuePlayer
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    var rowTitle = row.tag
                    var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                    rowTitle = rowTitleTextArray?[0]
                    if team1ListValuePlayer == ["-10000"] || team1ListValuePlayer == [] {
                        cell.textLabel?.text = row.tag
                    } else {
                        if team1ListValuePlayer[0] == "NEW YORK GIANTS" {
                            team1LabelPlayer = "NEW YORK (G)"
                        } else if team1ListValuePlayer[0] == "NEW YORK JETS" {
                            team1LabelPlayer = "NEW YORK (J)"
                        } else if team1ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                            team1LabelPlayer = "LOS ANGELES (C)"
                        } else if team1ListValuePlayer[0] == "LOS ANGELES RAMS" {
                            team1LabelPlayer = "LOS ANGELES (R)"
                        } else {
                            team1LabelPlayer = team1ListValuePlayer[0]
                            var team1TextArray = team1LabelPlayer.components(separatedBy: " ")
                            let team1TextArrayLength = team1TextArray.count
                            team1TextArray.remove(at: team1TextArrayLength - 1)
                            team1LabelPlayer = team1TextArray.joined(separator: " ")
                        }
                        cell.textLabel?.text = rowTitle! + ", " + team1LabelPlayer
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
                    if interceptionsThrownTeam2SliderFormValuePlayer == "-10000" || (interceptionsThrownTeam2RangeSliderLowerValuePlayer == interceptionsThrownTeam2ValuesPlayer.first && interceptionsThrownTeam2RangeSliderUpperValuePlayer == interceptionsThrownTeam2ValuesPlayer.last) {
                        cell.detailTextLabel?.text = "EQUAL ANY"
                    } else {
                        cell.detailTextLabel?.text = interceptionsThrownTeam2OperatorTextPlayer + interceptionsThrownTeam2SliderFormValuePlayer
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    var rowTitle = row.tag
                    var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                    rowTitle = rowTitleTextArray?[0]
                    if team2ListValuePlayer == ["-10000"] || team2ListValuePlayer == [] || team2ListValuePlayer.count > 1 {
                        cell.textLabel?.text = row.tag
                    } else {
                        if team2ListValuePlayer[0] == "NEW YORK GIANTS" {
                            team2LabelPlayer = "NEW YORK (G)"
                        } else if team2ListValuePlayer[0] == "NEW YORK JETS" {
                            team2LabelPlayer = "NEW YORK (J)"
                        } else if team2ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                            team2LabelPlayer = "LOS ANGELES (C)"
                        } else if team2ListValuePlayer[0] == "LOS ANGELES RAMS" {
                            team2LabelPlayer = "LOS ANGELES (R)"
                        } else {
                            team2LabelPlayer = team2ListValuePlayer[0]
                            var team2TextArray = team2LabelPlayer.components(separatedBy: " ")
                            let team2TextArrayLength = team2TextArray.count
                            team2TextArray.remove(at: team2TextArrayLength - 1)
                            team2LabelPlayer = team2TextArray.joined(separator: " ")
                        }
                        cell.textLabel?.text = rowTitle! + ", " + team2LabelPlayer
                    }
                    cell.textLabel?.font = twelveSemiboldSFCompact
                    cell.detailTextLabel?.font = twelveThinSFCompact
                    cell.textLabel?.addTextSpacing(spacing: -0.3)
                cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
            }
            */
            
            <<< ButtonRow("OFFENSIVE PLAYS, PLAYER TEAM") { row in
                row.title = row.tag
                row.presentationMode = .segueName(segueName: "OffensivePlaysTeam1Segue", onDismiss: nil)
                } .cellUpdate { cell, row in
                    if offensivePlaysTeam1SliderFormValuePlayer == "-10000" || (offensivePlaysTeam1RangeSliderLowerValuePlayer == offensivePlaysTeam1ValuesPlayer.first && offensivePlaysTeam1RangeSliderUpperValuePlayer == offensivePlaysTeam1ValuesPlayer.last) {
                        cell.detailTextLabel?.text = "EQUAL ANY"
                    } else {
                        cell.detailTextLabel?.text = offensivePlaysTeam1OperatorTextPlayer + offensivePlaysTeam1SliderFormValuePlayer
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    var rowTitle = row.tag
                    var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                    rowTitle = rowTitleTextArray?[0]
                    if team1ListValuePlayer == ["-10000"] || team1ListValuePlayer == [] {
                        cell.textLabel?.text = row.tag
                    } else {
                        if team1ListValuePlayer[0] == "NEW YORK GIANTS" {
                            team1LabelPlayer = "NEW YORK (G)"
                        } else if team1ListValuePlayer[0] == "NEW YORK JETS" {
                            team1LabelPlayer = "NEW YORK (J)"
                        } else if team1ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                            team1LabelPlayer = "LOS ANGELES (C)"
                        } else if team1ListValuePlayer[0] == "LOS ANGELES RAMS" {
                            team1LabelPlayer = "LOS ANGELES (R)"
                        } else {
                            team1LabelPlayer = team1ListValuePlayer[0]
                            var team1TextArray = team1LabelPlayer.components(separatedBy: " ")
                            let team1TextArrayLength = team1TextArray.count
                            team1TextArray.remove(at: team1TextArrayLength - 1)
                            team1LabelPlayer = team1TextArray.joined(separator: " ")
                        }
                        cell.textLabel?.text = rowTitle! + ", " + team1LabelPlayer
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
                    if offensivePlaysTeam2SliderFormValuePlayer == "-10000" || (offensivePlaysTeam2RangeSliderLowerValuePlayer == offensivePlaysTeam2ValuesPlayer.first && offensivePlaysTeam2RangeSliderUpperValuePlayer == offensivePlaysTeam2ValuesPlayer.last) {
                        cell.detailTextLabel?.text = "EQUAL ANY"
                    } else {
                        cell.detailTextLabel?.text = offensivePlaysTeam2OperatorTextPlayer + offensivePlaysTeam2SliderFormValuePlayer
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    
                    var rowTitle = row.tag
                    var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                    rowTitle = rowTitleTextArray?[0]
                    if team2ListValuePlayer == ["-10000"] || team2ListValuePlayer == [] || team2ListValuePlayer.count > 1 {
                        cell.textLabel?.text = row.tag
                    } else {
                        if team2ListValuePlayer[0] == "NEW YORK GIANTS" {
                            team2LabelPlayer = "NEW YORK (G)"
                        } else if team2ListValuePlayer[0] == "NEW YORK JETS" {
                            team2LabelPlayer = "NEW YORK (J)"
                        } else if team2ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                            team2LabelPlayer = "LOS ANGELES (C)"
                        } else if team2ListValuePlayer[0] == "LOS ANGELES RAMS" {
                            team2LabelPlayer = "LOS ANGELES (R)"
                        } else {
                            team2LabelPlayer = team2ListValuePlayer[0]
                            var team2TextArray = team2LabelPlayer.components(separatedBy: " ")
                            let team2TextArrayLength = team2TextArray.count
                            team2TextArray.remove(at: team2TextArrayLength - 1)
                            team2LabelPlayer = team2TextArray.joined(separator: " ")
                        }
                        cell.textLabel?.text = rowTitle! + ", " + team2LabelPlayer
                    }
                    cell.textLabel?.font = twelveSemiboldSFCompact
                    cell.detailTextLabel?.font = twelveThinSFCompact
                    cell.textLabel?.addTextSpacing(spacing: -0.3)
                    cell.detailTextLabel?.addTextSpacing(spacing: -0.2)

            }
            
            <<< ButtonRow("YARDS/OFFENSIVE PLAY, PLAYER TEAM") { row in
                row.title = row.tag
                row.presentationMode = .segueName(segueName: "YardsPerOffensivePlayTeam1Segue", onDismiss: nil)
                } .cellUpdate { cell, row in
                    if yardsPerOffensivePlayTeam1SliderFormValuePlayer == "-10000" || (yardsPerOffensivePlayTeam1RangeSliderLowerValuePlayer == yardsPerOffensivePlayTeam1ValuesPlayer.first && yardsPerOffensivePlayTeam1RangeSliderUpperValuePlayer == yardsPerOffensivePlayTeam1ValuesPlayer.last) {
                        cell.detailTextLabel?.text = "EQUAL ANY"
                    } else {
                        cell.detailTextLabel?.text = yardsPerOffensivePlayTeam1OperatorTextPlayer + yardsPerOffensivePlayTeam1SliderFormValuePlayer
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    var rowTitle = row.tag
                    var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                    rowTitle = rowTitleTextArray?[0]
                    if team1ListValuePlayer == ["-10000"] || team1ListValuePlayer == [] {
                        cell.textLabel?.text = row.tag
                    } else {
                        if team1ListValuePlayer[0] == "NEW YORK GIANTS" {
                            team1LabelPlayer = "NEW YORK (G)"
                        } else if team1ListValuePlayer[0] == "NEW YORK JETS" {
                            team1LabelPlayer = "NEW YORK (J)"
                        } else if team1ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                            team1LabelPlayer = "LOS ANGELES (C)"
                        } else if team1ListValuePlayer[0] == "LOS ANGELES RAMS" {
                            team1LabelPlayer = "LOS ANGELES (R)"
                        } else {
                            team1LabelPlayer = team1ListValuePlayer[0]
                            var team1TextArray = team1LabelPlayer.components(separatedBy: " ")
                            let team1TextArrayLength = team1TextArray.count
                            team1TextArray.remove(at: team1TextArrayLength - 1)
                            team1LabelPlayer = team1TextArray.joined(separator: " ")
                        }
                        cell.textLabel?.text = rowTitle! + ", " + team1LabelPlayer
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
                    if yardsPerOffensivePlayTeam2SliderFormValuePlayer == "-10000" || (yardsPerOffensivePlayTeam2RangeSliderLowerValuePlayer == yardsPerOffensivePlayTeam2ValuesPlayer.first && yardsPerOffensivePlayTeam2RangeSliderUpperValuePlayer == yardsPerOffensivePlayTeam2ValuesPlayer.last) {
                        cell.detailTextLabel?.text = "EQUAL ANY"
                    } else {
                        cell.detailTextLabel?.text = yardsPerOffensivePlayTeam2OperatorTextPlayer + yardsPerOffensivePlayTeam2SliderFormValuePlayer
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    var rowTitle = row.tag
                    var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                    rowTitle = rowTitleTextArray?[0]
                    if team2ListValuePlayer == ["-10000"] || team2ListValuePlayer == [] || team2ListValuePlayer.count > 1 {
                        cell.textLabel?.text = row.tag
                    } else {
                        if team2ListValuePlayer[0] == "NEW YORK GIANTS" {
                            team2LabelPlayer = "NEW YORK (G)"
                        } else if team2ListValuePlayer[0] == "NEW YORK JETS" {
                            team2LabelPlayer = "NEW YORK (J)"
                        } else if team2ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                            team2LabelPlayer = "LOS ANGELES (C)"
                        } else if team2ListValuePlayer[0] == "LOS ANGELES RAMS" {
                            team2LabelPlayer = "LOS ANGELES (R)"
                        } else {
                            team2LabelPlayer = team2ListValuePlayer[0]
                            var team2TextArray = team2LabelPlayer.components(separatedBy: " ")
                            let team2TextArrayLength = team2TextArray.count
                            team2TextArray.remove(at: team2TextArrayLength - 1)
                            team2LabelPlayer = team2TextArray.joined(separator: " ")
                        }
                        cell.textLabel?.text = rowTitle! + ", " + team2LabelPlayer
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
            
            <<< ButtonRow("DEFENSIVE TOUCHDOWNS, PLAYER TEAM") { row in
                row.title = row.tag
                row.presentationMode = .segueName(segueName: "DefensiveTouchdownsTeam1Segue", onDismiss: nil)
                } .cellUpdate { cell, row in
                    if defensiveTouchdownsTeam1SliderFormValuePlayer == "-10000" || (defensiveTouchdownsTeam1RangeSliderLowerValuePlayer == defensiveTouchdownsTeam1ValuesPlayer.first && defensiveTouchdownsTeam1RangeSliderUpperValuePlayer == defensiveTouchdownsTeam1ValuesPlayer.last) {
                        cell.detailTextLabel?.text = "EQUAL ANY"
                    } else {
                        cell.detailTextLabel?.text = defensiveTouchdownsTeam1OperatorTextPlayer + defensiveTouchdownsTeam1SliderFormValuePlayer
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    var rowTitle = row.tag
                    var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                    rowTitle = rowTitleTextArray?[0]
                    if team1ListValuePlayer == ["-10000"] || team1ListValuePlayer == [] {
                        cell.textLabel?.text = row.tag
                    } else {
                        if team1ListValuePlayer[0] == "NEW YORK GIANTS" {
                            team1LabelPlayer = "NEW YORK (G)"
                        } else if team1ListValuePlayer[0] == "NEW YORK JETS" {
                            team1LabelPlayer = "NEW YORK (J)"
                        } else if team1ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                            team1LabelPlayer = "LOS ANGELES (C)"
                        } else if team1ListValuePlayer[0] == "LOS ANGELES RAMS" {
                            team1LabelPlayer = "LOS ANGELES (R)"
                        } else {
                            team1LabelPlayer = team1ListValuePlayer[0]
                            var team1TextArray = team1LabelPlayer.components(separatedBy: " ")
                            let team1TextArrayLength = team1TextArray.count
                            team1TextArray.remove(at: team1TextArrayLength - 1)
                            team1LabelPlayer = team1TextArray.joined(separator: " ")
                        }
                        cell.textLabel?.text = rowTitle! + ", " + team1LabelPlayer
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
                    if defensiveTouchdownsTeam2SliderFormValuePlayer == "-10000" || (defensiveTouchdownsTeam2RangeSliderLowerValuePlayer == defensiveTouchdownsTeam2ValuesPlayer.first && defensiveTouchdownsTeam2RangeSliderUpperValuePlayer == defensiveTouchdownsTeam2ValuesPlayer.last) {
                        cell.detailTextLabel?.text = "EQUAL ANY"
                    } else {
                        cell.detailTextLabel?.text = defensiveTouchdownsTeam2OperatorTextPlayer + defensiveTouchdownsTeam2SliderFormValuePlayer
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    var rowTitle = row.tag
                    var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                    rowTitle = rowTitleTextArray?[0]
                    if team1ListValuePlayer == ["-10000"] || team1ListValuePlayer == [] {
                        cell.textLabel?.text = row.tag
                    } else {
                        if team1ListValuePlayer[0] == "NEW YORK GIANTS" {
                            team1LabelPlayer = "NEW YORK (G)"
                        } else if team1ListValuePlayer[0] == "NEW YORK JETS" {
                            team1LabelPlayer = "NEW YORK (J)"
                        } else if team1ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                            team1LabelPlayer = "LOS ANGELES (C)"
                        } else if team1ListValuePlayer[0] == "LOS ANGELES RAMS" {
                            team1LabelPlayer = "LOS ANGELES (R)"
                        } else {
                            team1LabelPlayer = team1ListValuePlayer[0]
                            var team1TextArray = team1LabelPlayer.components(separatedBy: " ")
                            let team1TextArrayLength = team1TextArray.count
                            team1TextArray.remove(at: team1TextArrayLength - 1)
                            team1LabelPlayer = team1TextArray.joined(separator: " ")
                        }
                        cell.textLabel?.text = rowTitle! + ", " + team1LabelPlayer
                    }
                    cell.textLabel?.font = twelveSemiboldSFCompact
                    cell.detailTextLabel?.font = twelveThinSFCompact
                    cell.textLabel?.addTextSpacing(spacing: -0.3)
                    cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
            }
            
            <<< ButtonRow("SACKS, PLAYER TEAM") { row in
                row.title = row.tag
                row.presentationMode = .segueName(segueName: "DefensiveSacksTeam1Segue", onDismiss: nil)
                } .cellUpdate { cell, row in
                    if sacksTeam1SliderFormValuePlayer == "-10000" || (sacksTeam1RangeSliderLowerValuePlayer == sacksTeam1ValuesPlayer.first && sacksTeam1RangeSliderUpperValuePlayer == sacksTeam1ValuesPlayer.last) {
                        cell.detailTextLabel?.text = "EQUAL ANY"
                    } else {
                        cell.detailTextLabel?.text = sacksTeam1OperatorTextPlayer + sacksTeam1SliderFormValuePlayer
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    var rowTitle = row.tag
                    var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                    rowTitle = rowTitleTextArray?[0]
                    if team1ListValuePlayer == ["-10000"] || team1ListValuePlayer == [] {
                        cell.textLabel?.text = row.tag
                    } else {
                        if team1ListValuePlayer[0] == "NEW YORK GIANTS" {
                            team1LabelPlayer = "NEW YORK (G)"
                        } else if team1ListValuePlayer[0] == "NEW YORK JETS" {
                            team1LabelPlayer = "NEW YORK (J)"
                        } else if team1ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                            team1LabelPlayer = "LOS ANGELES (C)"
                        } else if team1ListValuePlayer[0] == "LOS ANGELES RAMS" {
                            team1LabelPlayer = "LOS ANGELES (R)"
                        } else {
                            team1LabelPlayer = team1ListValuePlayer[0]
                            var team1TextArray = team1LabelPlayer.components(separatedBy: " ")
                            let team1TextArrayLength = team1TextArray.count
                            team1TextArray.remove(at: team1TextArrayLength - 1)
                            team1LabelPlayer = team1TextArray.joined(separator: " ")
                        }
                        cell.textLabel?.text = rowTitle! + ", " + team1LabelPlayer
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
                    if sacksTeam2SliderFormValuePlayer == "-10000" || (sacksTeam2RangeSliderLowerValuePlayer == sacksTeam2ValuesPlayer.first && sacksTeam2RangeSliderUpperValuePlayer == sacksTeam2ValuesPlayer.last) {
                        cell.detailTextLabel?.text = "EQUAL ANY"
                    } else {
                        cell.detailTextLabel?.text = sacksTeam2OperatorTextPlayer + sacksTeam2SliderFormValuePlayer
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    var rowTitle = row.tag
                    var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                    rowTitle = rowTitleTextArray?[0]
                    if team2ListValuePlayer == ["-10000"] || team2ListValuePlayer == [] || team2ListValuePlayer.count > 1 {
                        cell.textLabel?.text = row.tag
                    } else {
                        if team2ListValuePlayer[0] == "NEW YORK GIANTS" {
                            team2LabelPlayer = "NEW YORK (G)"
                        } else if team2ListValuePlayer[0] == "NEW YORK JETS" {
                            team2LabelPlayer = "NEW YORK (J)"
                        } else if team2ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                            team2LabelPlayer = "LOS ANGELES (C)"
                        } else if team2ListValuePlayer[0] == "LOS ANGELES RAMS" {
                            team2LabelPlayer = "LOS ANGELES (R)"
                        } else {
                            team2LabelPlayer = team2ListValuePlayer[0]
                            var team2TextArray = team2LabelPlayer.components(separatedBy: " ")
                            let team2TextArrayLength = team2TextArray.count
                            team2TextArray.remove(at: team2TextArrayLength - 1)
                            team2LabelPlayer = team2TextArray.joined(separator: " ")
                        }
                        cell.textLabel?.text = rowTitle! + ", " + team2LabelPlayer
                    }
                    cell.textLabel?.font = twelveSemiboldSFCompact
                    cell.detailTextLabel?.font = twelveThinSFCompact
                    cell.textLabel?.addTextSpacing(spacing: -0.3)
                    cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
            }
            
            <<< ButtonRow("INTERCEPTIONS, PLAYER TEAM") { row in
                row.title = row.tag
                row.presentationMode = .segueName(segueName: "DefensiveInterceptionsTeam1Segue", onDismiss: nil)
                } .cellUpdate { cell, row in
                    if interceptionsTeam1SliderFormValuePlayer == "-10000" || (interceptionsTeam1RangeSliderLowerValuePlayer == interceptionsTeam1ValuesPlayer.first && interceptionsTeam1RangeSliderUpperValuePlayer == interceptionsTeam1ValuesPlayer.last) {
                        cell.detailTextLabel?.text = "EQUAL ANY"
                    } else {
                        cell.detailTextLabel?.text = interceptionsTeam1OperatorTextPlayer + interceptionsTeam1SliderFormValuePlayer
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    var rowTitle = row.tag
                    var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                    rowTitle = rowTitleTextArray?[0]
                    if team1ListValuePlayer == ["-10000"] || team1ListValuePlayer == [] {
                        cell.textLabel?.text = row.tag
                    } else {
                        if team1ListValuePlayer[0] == "NEW YORK GIANTS" {
                            team1LabelPlayer = "NEW YORK (G)"
                        } else if team1ListValuePlayer[0] == "NEW YORK JETS" {
                            team1LabelPlayer = "NEW YORK (J)"
                        } else if team1ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                            team1LabelPlayer = "LOS ANGELES (C)"
                        } else if team1ListValuePlayer[0] == "LOS ANGELES RAMS" {
                            team1LabelPlayer = "LOS ANGELES (R)"
                        } else {
                            team1LabelPlayer = team1ListValuePlayer[0]
                            var team1TextArray = team1LabelPlayer.components(separatedBy: " ")
                            let team1TextArrayLength = team1TextArray.count
                            team1TextArray.remove(at: team1TextArrayLength - 1)
                            team1LabelPlayer = team1TextArray.joined(separator: " ")
                        }
                        cell.textLabel?.text = rowTitle! + ", " + team1LabelPlayer
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
                    if interceptionsTeam2SliderFormValuePlayer == "-10000" || (interceptionsTeam2RangeSliderLowerValuePlayer == interceptionsTeam2ValuesPlayer.first && interceptionsTeam2RangeSliderUpperValuePlayer == interceptionsTeam2ValuesPlayer.last) {
                        cell.detailTextLabel?.text = "EQUAL ANY"
                    } else {
                        cell.detailTextLabel?.text = interceptionsTeam2OperatorTextPlayer + interceptionsTeam2SliderFormValuePlayer
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    var rowTitle = row.tag
                    var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                    rowTitle = rowTitleTextArray?[0]
                    if team2ListValuePlayer == ["-10000"] || team2ListValuePlayer == [] || team2ListValuePlayer.count > 1 {
                        cell.textLabel?.text = row.tag
                    } else {
                        if team2ListValuePlayer[0] == "NEW YORK GIANTS" {
                            team2LabelPlayer = "NEW YORK (G)"
                        } else if team2ListValuePlayer[0] == "NEW YORK JETS" {
                            team2LabelPlayer = "NEW YORK (J)"
                        } else if team2ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                            team2LabelPlayer = "LOS ANGELES (C)"
                        } else if team2ListValuePlayer[0] == "LOS ANGELES RAMS" {
                            team2LabelPlayer = "LOS ANGELES (R)"
                        } else {
                            team2LabelPlayer = team2ListValuePlayer[0]
                            var team2TextArray = team2LabelPlayer.components(separatedBy: " ")
                            let team2TextArrayLength = team2TextArray.count
                            team2TextArray.remove(at: team2TextArrayLength - 1)
                            team2LabelPlayer = team2TextArray.joined(separator: " ")
                        }
                        cell.textLabel?.text = rowTitle! + ", " + team2LabelPlayer
                    }
                    cell.textLabel?.font = twelveSemiboldSFCompact
                    cell.detailTextLabel?.font = twelveThinSFCompact
                    cell.textLabel?.addTextSpacing(spacing: -0.3)
                    cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
            }
            
            <<< ButtonRow("SAFETIES, PLAYER TEAM") { row in
                row.title = row.tag
                row.presentationMode = .segueName(segueName: "SafetiesTeam1Segue", onDismiss: nil)
                } .cellUpdate { cell, row in
                    if safetiesTeam1SliderFormValuePlayer == "-10000" || (safetiesTeam1RangeSliderLowerValuePlayer == safetiesTeam1ValuesPlayer.first && safetiesTeam1RangeSliderUpperValuePlayer == safetiesTeam1ValuesPlayer.last) {
                        cell.detailTextLabel?.text = "EQUAL ANY"
                    } else {
                        cell.detailTextLabel?.text = safetiesTeam1OperatorTextPlayer + safetiesTeam1SliderFormValuePlayer
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    var rowTitle = row.tag
                    var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                    rowTitle = rowTitleTextArray?[0]
                    if team1ListValuePlayer == ["-10000"] || team1ListValuePlayer == [] {
                        cell.textLabel?.text = row.tag
                    } else {
                        if team1ListValuePlayer[0] == "NEW YORK GIANTS" {
                            team1LabelPlayer = "NEW YORK (G)"
                        } else if team1ListValuePlayer[0] == "NEW YORK JETS" {
                            team1LabelPlayer = "NEW YORK (J)"
                        } else if team1ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                            team1LabelPlayer = "LOS ANGELES (C)"
                        } else if team1ListValuePlayer[0] == "LOS ANGELES RAMS" {
                            team1LabelPlayer = "LOS ANGELES (R)"
                        } else {
                            team1LabelPlayer = team1ListValuePlayer[0]
                            var team1TextArray = team1LabelPlayer.components(separatedBy: " ")
                            let team1TextArrayLength = team1TextArray.count
                            team1TextArray.remove(at: team1TextArrayLength - 1)
                            team1LabelPlayer = team1TextArray.joined(separator: " ")
                        }
                        cell.textLabel?.text = rowTitle! + ", " + team1LabelPlayer
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
                    if safetiesTeam2SliderFormValuePlayer == "-10000" || (safetiesTeam2RangeSliderLowerValuePlayer == safetiesTeam2ValuesPlayer.first && safetiesTeam2RangeSliderUpperValuePlayer == safetiesTeam2ValuesPlayer.last) {
                        cell.detailTextLabel?.text = "EQUAL ANY"
                    } else {
                        cell.detailTextLabel?.text = safetiesTeam2OperatorTextPlayer + safetiesTeam2SliderFormValuePlayer
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    var rowTitle = row.tag
                    var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                    rowTitle = rowTitleTextArray?[0]
                    if team2ListValuePlayer == ["-10000"] || team2ListValuePlayer == [] || team2ListValuePlayer.count > 1 {
                        cell.textLabel?.text = row.tag
                    } else {
                        if team2ListValuePlayer[0] == "NEW YORK GIANTS" {
                            team2LabelPlayer = "NEW YORK (G)"
                        } else if team2ListValuePlayer[0] == "NEW YORK JETS" {
                            team2LabelPlayer = "NEW YORK (J)"
                        } else if team2ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                            team2LabelPlayer = "LOS ANGELES (C)"
                        } else if team2ListValuePlayer[0] == "LOS ANGELES RAMS" {
                            team2LabelPlayer = "LOS ANGELES (R)"
                        } else {
                            team2LabelPlayer = team2ListValuePlayer[0]
                            var team2TextArray = team2LabelPlayer.components(separatedBy: " ")
                            let team2TextArrayLength = team2TextArray.count
                            team2TextArray.remove(at: team2TextArrayLength - 1)
                            team2LabelPlayer = team2TextArray.joined(separator: " ")
                        }
                        cell.textLabel?.text = rowTitle! + ", " + team2LabelPlayer
                    }
                    cell.textLabel?.font = twelveSemiboldSFCompact
                    cell.detailTextLabel?.font = twelveThinSFCompact
                    cell.textLabel?.addTextSpacing(spacing: -0.3)
                    cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
            }
            /*
            <<< ButtonRow("DEFENSIVE PLAYS, PLAYER TEAM") { row in
                row.title = row.tag
                row.presentationMode = .segueName(segueName: "DefensivePlaysTeam1Segue", onDismiss: nil)
                } .cellUpdate { cell, row in
                    if defensivePlaysTeam1SliderFormValuePlayer == "-10000" || (defensivePlaysTeam1RangeSliderLowerValuePlayer == defensivePlaysTeam1ValuesPlayer.first && defensivePlaysTeam1RangeSliderUpperValuePlayer == defensivePlaysTeam1ValuesPlayer.last) {
                        cell.detailTextLabel?.text = "EQUAL ANY"
                    } else {
                        cell.detailTextLabel?.text = defensivePlaysTeam1OperatorTextPlayer + defensivePlaysTeam1SliderFormValuePlayer
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    var rowTitle = row.tag
                    var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                    rowTitle = rowTitleTextArray?[0]
                    if team1ListValuePlayer == ["-10000"] || team1ListValuePlayer == [] {
                        cell.textLabel?.text = row.tag
                    } else {
                        if team1ListValuePlayer[0] == "NEW YORK GIANTS" {
                            team1LabelPlayer = "NEW YORK (G)"
                        } else if team1ListValuePlayer[0] == "NEW YORK JETS" {
                            team1LabelPlayer = "NEW YORK (J)"
                        } else if team1ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                            team1LabelPlayer = "LOS ANGELES (C)"
                        } else if team1ListValuePlayer[0] == "LOS ANGELES RAMS" {
                            team1LabelPlayer = "LOS ANGELES (R)"
                        } else {
                            team1LabelPlayer = team1ListValuePlayer[0]
                            var team1TextArray = team1LabelPlayer.components(separatedBy: " ")
                            let team1TextArrayLength = team1TextArray.count
                            team1TextArray.remove(at: team1TextArrayLength - 1)
                            team1LabelPlayer = team1TextArray.joined(separator: " ")
                        }
                        cell.textLabel?.text = rowTitle! + ", " + team1LabelPlayer
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
                    if defensivePlaysTeam2SliderFormValuePlayer == "-10000" || (defensivePlaysTeam2RangeSliderLowerValuePlayer == defensivePlaysTeam2ValuesPlayer.first && defensivePlaysTeam2RangeSliderUpperValuePlayer == defensivePlaysTeam2ValuesPlayer.last) {
                        cell.detailTextLabel?.text = "EQUAL ANY"
                    } else {
                        cell.detailTextLabel?.text = defensivePlaysTeam2OperatorTextPlayer + defensivePlaysTeam2SliderFormValuePlayer
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    var rowTitle = row.tag
                    var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                    rowTitle = rowTitleTextArray?[0]
                    if team2ListValuePlayer == ["-10000"] || team2ListValuePlayer == [] || team2ListValuePlayer.count > 1 {
                        cell.textLabel?.text = row.tag
                    } else {
                        if team2ListValuePlayer[0] == "NEW YORK GIANTS" {
                            team2LabelPlayer = "NEW YORK (G)"
                        } else if team2ListValuePlayer[0] == "NEW YORK JETS" {
                            team2LabelPlayer = "NEW YORK (J)"
                        } else if team2ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                            team2LabelPlayer = "LOS ANGELES (C)"
                        } else if team2ListValuePlayer[0] == "LOS ANGELES RAMS" {
                            team2LabelPlayer = "LOS ANGELES (R)"
                        } else {
                            team2LabelPlayer = team2ListValuePlayer[0]
                            var team2TextArray = team2LabelPlayer.components(separatedBy: " ")
                            let team2TextArrayLength = team2TextArray.count
                            team2TextArray.remove(at: team2TextArrayLength - 1)
                            team2LabelPlayer = team2TextArray.joined(separator: " ")
                        }
                        cell.textLabel?.text = rowTitle! + ", " + team2LabelPlayer
                    }
                    cell.textLabel?.font = twelveSemiboldSFCompact
                    cell.detailTextLabel?.font = twelveThinSFCompact
                    cell.textLabel?.addTextSpacing(spacing: -0.3)
                cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
            }
            
            <<< ButtonRow("YARDS/DEFENSIVE PLAY, PLAYER TEAM") { row in
                row.title = row.tag
                row.presentationMode = .segueName(segueName: "YardsPerDefensivePlayTeam1Segue", onDismiss: nil)
                } .cellUpdate { cell, row in
                    if yardsPerDefensivePlayTeam1SliderFormValuePlayer == "-10000" || (yardsPerDefensivePlayTeam1RangeSliderLowerValuePlayer == yardsPerDefensivePlayTeam1ValuesPlayer.first && yardsPerDefensivePlayTeam1RangeSliderUpperValuePlayer == yardsPerDefensivePlayTeam1ValuesPlayer.last) {
                        cell.detailTextLabel?.text = "EQUAL ANY"
                    } else {
                        cell.detailTextLabel?.text = yardsPerDefensivePlayTeam1OperatorTextPlayer + yardsPerDefensivePlayTeam1SliderFormValuePlayer
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    var rowTitle = row.tag
                    var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                    rowTitle = rowTitleTextArray?[0]
                    if team1ListValuePlayer == ["-10000"] || team1ListValuePlayer == [] {
                        cell.textLabel?.text = row.tag
                    } else {
                        if team1ListValuePlayer[0] == "NEW YORK GIANTS" {
                            team1LabelPlayer = "NEW YORK (G)"
                        } else if team1ListValuePlayer[0] == "NEW YORK JETS" {
                            team1LabelPlayer = "NEW YORK (J)"
                        } else if team1ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                            team1LabelPlayer = "LOS ANGELES (C)"
                        } else if team1ListValuePlayer[0] == "LOS ANGELES RAMS" {
                            team1LabelPlayer = "LOS ANGELES (R)"
                        } else {
                            team1LabelPlayer = team1ListValuePlayer[0]
                            var team1TextArray = team1LabelPlayer.components(separatedBy: " ")
                            let team1TextArrayLength = team1TextArray.count
                            team1TextArray.remove(at: team1TextArrayLength - 1)
                            team1LabelPlayer = team1TextArray.joined(separator: " ")
                        }
                        cell.textLabel?.text = rowTitle! + ", " + team1LabelPlayer
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
                    if yardsPerDefensivePlayTeam2SliderFormValuePlayer == "-10000" || (yardsPerDefensivePlayTeam2RangeSliderLowerValuePlayer == yardsPerDefensivePlayTeam2ValuesPlayer.first && yardsPerDefensivePlayTeam2RangeSliderUpperValuePlayer == yardsPerDefensivePlayTeam2ValuesPlayer.last) {
                        cell.detailTextLabel?.text = "EQUAL ANY"
                    } else {
                        cell.detailTextLabel?.text = yardsPerDefensivePlayTeam2OperatorTextPlayer + yardsPerDefensivePlayTeam2SliderFormValuePlayer
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    var rowTitle = row.tag
                    var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                    rowTitle = rowTitleTextArray?[0]
                    if team2ListValuePlayer == ["-10000"] || team2ListValuePlayer == [] || team2ListValuePlayer.count > 1 {
                        cell.textLabel?.text = row.tag
                    } else {
                        if team2ListValuePlayer[0] == "NEW YORK GIANTS" {
                            team2LabelPlayer = "NEW YORK (G)"
                        } else if team2ListValuePlayer[0] == "NEW YORK JETS" {
                            team2LabelPlayer = "NEW YORK (J)"
                        } else if team2ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                            team2LabelPlayer = "LOS ANGELES (C)"
                        } else if team2ListValuePlayer[0] == "LOS ANGELES RAMS" {
                            team2LabelPlayer = "LOS ANGELES (R)"
                        } else {
                            team2LabelPlayer = team2ListValuePlayer[0]
                            var team2TextArray = team2LabelPlayer.components(separatedBy: " ")
                            let team2TextArrayLength = team2TextArray.count
                            team2TextArray.remove(at: team2TextArrayLength - 1)
                            team2LabelPlayer = team2TextArray.joined(separator: " ")
                        }
                        cell.textLabel?.text = rowTitle! + ", " + team2LabelPlayer
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
            
            /*<<< ButtonRow("EXTRA POINT ATTEMPTS, PLAYER TEAM") { row in
                row.title = row.tag
                row.presentationMode = .segueName(segueName: "ExtraPointAttemptsTeam1Segue", onDismiss: nil)
                } .cellUpdate { cell, row in
                    if extraPointAttemptsTeam1SliderFormValuePlayer == "-10000" || (extraPointAttemptsTeam1RangeSliderLowerValuePlayer == extraPointAttemptsTeam1ValuesPlayer.first && extraPointAttemptsTeam1RangeSliderUpperValuePlayer == extraPointAttemptsTeam1ValuesPlayer.last) {
                        cell.detailTextLabel?.text = " EQUAL " + "ANY"
                    } else {
                        cell.detailTextLabel?.text = extraPointAttemptsTeam1OperatorTextPlayer + extraPointAttemptsTeam1SliderFormValuePlayer
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    cell.textLabel?.addTextSpacing(spacing: -0.3)
                cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
            }
            
            <<< ButtonRow("EXTRA POINT ATTEMPTS, OPPONENT") { row in
                row.title = row.tag
                row.presentationMode = .segueName(segueName: "ExtraPointAttemptsTeam2Segue", onDismiss: nil)
                } .cellUpdate { cell, row in
                    if extraPointAttemptsTeam2SliderFormValuePlayer == "-10000" || (extraPointAttemptsTeam2RangeSliderLowerValuePlayer == extraPointAttemptsTeam2ValuesPlayer.first && extraPointAttemptsTeam2RangeSliderUpperValuePlayer == extraPointAttemptsTeam2ValuesPlayer.last) {
                        cell.detailTextLabel?.text = " EQUAL " + "ANY"
                    } else {
                        cell.detailTextLabel?.text = extraPointAttemptsTeam2OperatorTextPlayer + extraPointAttemptsTeam2SliderFormValuePlayer
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    cell.textLabel?.addTextSpacing(spacing: -0.3)
                cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
            }*/
            
            <<< ButtonRow("EXTRA POINTS MADE, PLAYER TEAM") { row in
                row.title = row.tag
                row.presentationMode = .segueName(segueName: "ExtraPointsMadeTeam1Segue", onDismiss: nil)
                } .cellUpdate { cell, row in
                    if extraPointsMadeTeam1SliderFormValuePlayer == "-10000" || (extraPointsMadeTeam1RangeSliderLowerValuePlayer == extraPointsMadeTeam1ValuesPlayer.first && extraPointsMadeTeam1RangeSliderUpperValuePlayer == extraPointsMadeTeam1ValuesPlayer.last) {
                        cell.detailTextLabel?.text = "EQUAL ANY"
                    } else {
                        cell.detailTextLabel?.text = extraPointsMadeTeam1OperatorTextPlayer + extraPointsMadeTeam1SliderFormValuePlayer
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    var rowTitle = row.tag
                    var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                    rowTitle = rowTitleTextArray?[0]
                    if team1ListValuePlayer == ["-10000"] || team1ListValuePlayer == [] {
                        cell.textLabel?.text = row.tag
                    } else {
                        if team1ListValuePlayer[0] == "NEW YORK GIANTS" {
                            team1LabelPlayer = "NEW YORK (G)"
                        } else if team1ListValuePlayer[0] == "NEW YORK JETS" {
                            team1LabelPlayer = "NEW YORK (J)"
                        } else if team1ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                            team1LabelPlayer = "LOS ANGELES (C)"
                        } else if team1ListValuePlayer[0] == "LOS ANGELES RAMS" {
                            team1LabelPlayer = "LOS ANGELES (R)"
                        } else {
                            team1LabelPlayer = team1ListValuePlayer[0]
                            var team1TextArray = team1LabelPlayer.components(separatedBy: " ")
                            let team1TextArrayLength = team1TextArray.count
                            team1TextArray.remove(at: team1TextArrayLength - 1)
                            team1LabelPlayer = team1TextArray.joined(separator: " ")
                        }
                        cell.textLabel?.text = rowTitle! + ", " + team1LabelPlayer
                    }
                    cell.textLabel?.font = twelveSemiboldSFCompact
                    cell.detailTextLabel?.font = twelveThinSFCompact
                    cell.textLabel?.addTextSpacing(spacing: -0.3)
                    cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
            }
            
            <<< ButtonRow("EXTRA POINTS MADE, OPPONENT") { row in
                row.title = row.tag
                row.presentationMode = .segueName(segueName: "ExtraPointsMadeTeam2Segue", onDismiss: nil)
                } .cellUpdate { cell, row in
                    if extraPointsMadeTeam2SliderFormValuePlayer == "-10000" || (extraPointsMadeTeam2RangeSliderLowerValuePlayer == extraPointsMadeTeam2ValuesPlayer.first && extraPointsMadeTeam2RangeSliderUpperValuePlayer == extraPointsMadeTeam2ValuesPlayer.last) {
                        cell.detailTextLabel?.text = "EQUAL ANY"
                    } else {
                        cell.detailTextLabel?.text = extraPointsMadeTeam2OperatorTextPlayer + extraPointsMadeTeam2SliderFormValuePlayer
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    var rowTitle = row.tag
                    var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                    rowTitle = rowTitleTextArray?[0]
                    if team2ListValuePlayer == ["-10000"] || team2ListValuePlayer == [] || team2ListValuePlayer.count > 1 {
                        cell.textLabel?.text = row.tag
                    } else {
                        if team2ListValuePlayer[0] == "NEW YORK GIANTS" {
                            team2LabelPlayer = "NEW YORK (G)"
                        } else if team2ListValuePlayer[0] == "NEW YORK JETS" {
                            team2LabelPlayer = "NEW YORK (J)"
                        } else if team2ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                            team2LabelPlayer = "LOS ANGELES (C)"
                        } else if team2ListValuePlayer[0] == "LOS ANGELES RAMS" {
                            team2LabelPlayer = "LOS ANGELES (R)"
                        } else {
                            team2LabelPlayer = team2ListValuePlayer[0]
                            var team2TextArray = team2LabelPlayer.components(separatedBy: " ")
                            let team2TextArrayLength = team2TextArray.count
                            team2TextArray.remove(at: team2TextArrayLength - 1)
                            team2LabelPlayer = team2TextArray.joined(separator: " ")
                        }
                        cell.textLabel?.text = rowTitle! + ", " + team2LabelPlayer
                    }
                    cell.textLabel?.font = twelveSemiboldSFCompact
                    cell.detailTextLabel?.font = twelveThinSFCompact
                    cell.textLabel?.addTextSpacing(spacing: -0.3)
                    cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
            }
            
            
            <<< ButtonRow("FIELD GOAL ATTEMPTS, PLAYER TEAM") { row in
                row.title = row.tag
                row.presentationMode = .segueName(segueName: "FieldGoalAttemptsTeam1Segue", onDismiss: nil)
                } .cellUpdate { cell, row in
                    if fieldGoalAttemptsTeam1SliderFormValuePlayer == "-10000" || (fieldGoalAttemptsTeam1RangeSliderLowerValuePlayer == fieldGoalAttemptsTeam1ValuesPlayer.first && fieldGoalAttemptsTeam1RangeSliderUpperValuePlayer == fieldGoalAttemptsTeam1ValuesPlayer.last) {
                        cell.detailTextLabel?.text = "EQUAL ANY"
                    } else {
                        cell.detailTextLabel?.text = fieldGoalAttemptsTeam1OperatorTextPlayer + fieldGoalAttemptsTeam1SliderFormValuePlayer
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    var rowTitle = row.tag
                    var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                    rowTitle = rowTitleTextArray?[0]
                    if team1ListValuePlayer == ["-10000"] || team1ListValuePlayer == [] {
                        cell.textLabel?.text = row.tag
                    } else {
                        if team1ListValuePlayer[0] == "NEW YORK GIANTS" {
                            team1LabelPlayer = "NEW YORK (G)"
                        } else if team1ListValuePlayer[0] == "NEW YORK JETS" {
                            team1LabelPlayer = "NEW YORK (J)"
                        } else if team1ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                            team1LabelPlayer = "LOS ANGELES (C)"
                        } else if team1ListValuePlayer[0] == "LOS ANGELES RAMS" {
                            team1LabelPlayer = "LOS ANGELES (R)"
                        } else {
                            team1LabelPlayer = team1ListValuePlayer[0]
                            var team1TextArray = team1LabelPlayer.components(separatedBy: " ")
                            let team1TextArrayLength = team1TextArray.count
                            team1TextArray.remove(at: team1TextArrayLength - 1)
                            team1LabelPlayer = team1TextArray.joined(separator: " ")
                        }
                        cell.textLabel?.text = rowTitle! + ", " + team1LabelPlayer
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
                    if fieldGoalAttemptsTeam2SliderFormValuePlayer == "-10000" || (fieldGoalAttemptsTeam2RangeSliderLowerValuePlayer == fieldGoalAttemptsTeam2ValuesPlayer.first && fieldGoalAttemptsTeam2RangeSliderUpperValuePlayer == fieldGoalAttemptsTeam2ValuesPlayer.last) {
                        cell.detailTextLabel?.text = "EQUAL ANY"
                    } else {
                        cell.detailTextLabel?.text = fieldGoalAttemptsTeam2OperatorTextPlayer + fieldGoalAttemptsTeam2SliderFormValuePlayer
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    var rowTitle = row.tag
                    var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                    rowTitle = rowTitleTextArray?[0]
                    if team2ListValuePlayer == ["-10000"] || team2ListValuePlayer == [] || team2ListValuePlayer.count > 1 {
                        cell.textLabel?.text = row.tag
                    } else {
                        if team2ListValuePlayer[0] == "NEW YORK GIANTS" {
                            team2LabelPlayer = "NEW YORK (G)"
                        } else if team2ListValuePlayer[0] == "NEW YORK JETS" {
                            team2LabelPlayer = "NEW YORK (J)"
                        } else if team2ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                            team2LabelPlayer = "LOS ANGELES (C)"
                        } else if team2ListValuePlayer[0] == "LOS ANGELES RAMS" {
                            team2LabelPlayer = "LOS ANGELES (R)"
                        } else {
                            team2LabelPlayer = team2ListValuePlayer[0]
                            var team2TextArray = team2LabelPlayer.components(separatedBy: " ")
                            let team2TextArrayLength = team2TextArray.count
                            team2TextArray.remove(at: team2TextArrayLength - 1)
                            team2LabelPlayer = team2TextArray.joined(separator: " ")
                        }
                        cell.textLabel?.text = rowTitle! + ", " + team2LabelPlayer
                    }
                    cell.textLabel?.font = twelveSemiboldSFCompact
                    cell.detailTextLabel?.font = twelveThinSFCompact
                    cell.textLabel?.addTextSpacing(spacing: -0.3)
                    cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
            }
            
            <<< ButtonRow("FIELD GOALS MADE, PLAYER TEAM") { row in
                row.title = row.tag
                row.presentationMode = .segueName(segueName: "FieldGoalsMadeTeam1Segue", onDismiss: nil)
                } .cellUpdate { cell, row in
                    if fieldGoalsMadeTeam1SliderFormValuePlayer == "-10000" || (fieldGoalsMadeTeam1RangeSliderLowerValuePlayer == fieldGoalsMadeTeam1ValuesPlayer.first && fieldGoalsMadeTeam1RangeSliderUpperValuePlayer == fieldGoalsMadeTeam1ValuesPlayer.last) {
                        cell.detailTextLabel?.text = "EQUAL ANY"
                    } else {
                        cell.detailTextLabel?.text = fieldGoalsMadeTeam1OperatorTextPlayer + fieldGoalsMadeTeam1SliderFormValuePlayer
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    var rowTitle = row.tag
                    var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                    rowTitle = rowTitleTextArray?[0]
                    if team1ListValuePlayer == ["-10000"] || team1ListValuePlayer == [] {
                        cell.textLabel?.text = row.tag
                    } else {
                        if team1ListValuePlayer[0] == "NEW YORK GIANTS" {
                            team1LabelPlayer = "NEW YORK (G)"
                        } else if team1ListValuePlayer[0] == "NEW YORK JETS" {
                            team1LabelPlayer = "NEW YORK (J)"
                        } else if team1ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                            team1LabelPlayer = "LOS ANGELES (C)"
                        } else if team1ListValuePlayer[0] == "LOS ANGELES RAMS" {
                            team1LabelPlayer = "LOS ANGELES (R)"
                        } else {
                            team1LabelPlayer = team1ListValuePlayer[0]
                            var team1TextArray = team1LabelPlayer.components(separatedBy: " ")
                            let team1TextArrayLength = team1TextArray.count
                            team1TextArray.remove(at: team1TextArrayLength - 1)
                            team1LabelPlayer = team1TextArray.joined(separator: " ")
                        }
                        cell.textLabel?.text = rowTitle! + ", " + team1LabelPlayer
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
                    if fieldGoalsMadeTeam2SliderFormValuePlayer == "-10000" || (fieldGoalsMadeTeam2RangeSliderLowerValuePlayer == fieldGoalsMadeTeam2ValuesPlayer.first && fieldGoalsMadeTeam2RangeSliderUpperValuePlayer == fieldGoalsMadeTeam2ValuesPlayer.last) {
                        cell.detailTextLabel?.text = "EQUAL ANY"
                    } else {
                        cell.detailTextLabel?.text = fieldGoalsMadeTeam2OperatorTextPlayer + fieldGoalsMadeTeam2SliderFormValuePlayer
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    var rowTitle = row.tag
                    var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                    rowTitle = rowTitleTextArray?[0]
                    if team2ListValuePlayer == ["-10000"] || team2ListValuePlayer == [] || team2ListValuePlayer.count > 1 {
                        cell.textLabel?.text = row.tag
                    } else {
                        if team2ListValuePlayer[0] == "NEW YORK GIANTS" {
                            team2LabelPlayer = "NEW YORK (G)"
                        } else if team2ListValuePlayer[0] == "NEW YORK JETS" {
                            team2LabelPlayer = "NEW YORK (J)"
                        } else if team2ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                            team2LabelPlayer = "LOS ANGELES (C)"
                        } else if team2ListValuePlayer[0] == "LOS ANGELES RAMS" {
                            team2LabelPlayer = "LOS ANGELES (R)"
                        } else {
                            team2LabelPlayer = team2ListValuePlayer[0]
                            var team2TextArray = team2LabelPlayer.components(separatedBy: " ")
                            let team2TextArrayLength = team2TextArray.count
                            team2TextArray.remove(at: team2TextArrayLength - 1)
                            team2LabelPlayer = team2TextArray.joined(separator: " ")
                        }
                        cell.textLabel?.text = rowTitle! + ", " + team2LabelPlayer
                    }
                    cell.textLabel?.font = twelveSemiboldSFCompact
                    cell.detailTextLabel?.font = twelveThinSFCompact
                    cell.textLabel?.addTextSpacing(spacing: -0.3)
                    cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
            }
            
            <<< ButtonRow("PUNTS, PLAYER TEAM") { row in
                row.title = row.tag
                row.presentationMode = .segueName(segueName: "PuntsTeam1Segue", onDismiss: nil)
                } .cellUpdate { cell, row in
                    if puntsTeam1SliderFormValuePlayer == "-10000" || (puntsTeam1RangeSliderLowerValuePlayer == puntsTeam1ValuesPlayer.first && puntsTeam1RangeSliderUpperValuePlayer == puntsTeam1ValuesPlayer.last) {
                        cell.detailTextLabel?.text = "EQUAL ANY"
                    } else {
                        cell.detailTextLabel?.text = puntsTeam1OperatorTextPlayer + puntsTeam1SliderFormValuePlayer
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    var rowTitle = row.tag
                    var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                    rowTitle = rowTitleTextArray?[0]
                    if team1ListValuePlayer == ["-10000"] || team1ListValuePlayer == [] {
                        cell.textLabel?.text = row.tag
                    } else {
                        if team1ListValuePlayer[0] == "NEW YORK GIANTS" {
                            team1LabelPlayer = "NEW YORK (G)"
                        } else if team1ListValuePlayer[0] == "NEW YORK JETS" {
                            team1LabelPlayer = "NEW YORK (J)"
                        } else if team1ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                            team1LabelPlayer = "LOS ANGELES (C)"
                        } else if team1ListValuePlayer[0] == "LOS ANGELES RAMS" {
                            team1LabelPlayer = "LOS ANGELES (R)"
                        } else {
                            team1LabelPlayer = team1ListValuePlayer[0]
                            var team1TextArray = team1LabelPlayer.components(separatedBy: " ")
                            let team1TextArrayLength = team1TextArray.count
                            team1TextArray.remove(at: team1TextArrayLength - 1)
                            team1LabelPlayer = team1TextArray.joined(separator: " ")
                        }
                        cell.textLabel?.text = rowTitle! + ", " + team1LabelPlayer
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
                    if puntsTeam2SliderFormValuePlayer == "-10000" || (puntsTeam2RangeSliderLowerValuePlayer == puntsTeam2ValuesPlayer.first && puntsTeam2RangeSliderUpperValuePlayer == puntsTeam2ValuesPlayer.last) {
                        cell.detailTextLabel?.text = "EQUAL ANY"
                    } else {
                        cell.detailTextLabel?.text = puntsTeam2OperatorTextPlayer + puntsTeam2SliderFormValuePlayer
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    var rowTitle = row.tag
                    var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                    rowTitle = rowTitleTextArray?[0]
                    if team2ListValuePlayer == ["-10000"] || team2ListValuePlayer == [] || team2ListValuePlayer.count > 1 {
                        cell.textLabel?.text = row.tag
                    } else {
                        if team2ListValuePlayer[0] == "NEW YORK GIANTS" {
                            team2LabelPlayer = "NEW YORK (G)"
                        } else if team2ListValuePlayer[0] == "NEW YORK JETS" {
                            team2LabelPlayer = "NEW YORK (J)"
                        } else if team2ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                            team2LabelPlayer = "LOS ANGELES (C)"
                        } else if team2ListValuePlayer[0] == "LOS ANGELES RAMS" {
                            team2LabelPlayer = "LOS ANGELES (R)"
                        } else {
                            team2LabelPlayer = team2ListValuePlayer[0]
                            var team2TextArray = team2LabelPlayer.components(separatedBy: " ")
                            let team2TextArrayLength = team2TextArray.count
                            team2TextArray.remove(at: team2TextArrayLength - 1)
                            team2LabelPlayer = team2TextArray.joined(separator: " ")
                        }
                        cell.textLabel?.text = rowTitle! + ", " + team2LabelPlayer
                    }
                    cell.textLabel?.font = twelveSemiboldSFCompact
                    cell.detailTextLabel?.font = twelveThinSFCompact
                    cell.textLabel?.addTextSpacing(spacing: -0.3)
                    cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
            }
        
            <<< ButtonRow("PUNT YARDS, PLAYER TEAM") { row in
                row.title = row.tag
                row.presentationMode = .segueName(segueName: "PuntYardsTeam1Segue", onDismiss: nil)
                } .cellUpdate { cell, row in
                    if puntYardsTeam1SliderFormValuePlayer == "-10000" || (puntYardsTeam1RangeSliderLowerValuePlayer == puntYardsTeam1ValuesPlayer.first && puntYardsTeam1RangeSliderUpperValuePlayer == puntYardsTeam1ValuesPlayer.last) {
                        cell.detailTextLabel?.text = "EQUAL ANY"
                    } else {
                        cell.detailTextLabel?.text = puntYardsTeam1OperatorTextPlayer + puntYardsTeam1SliderFormValuePlayer
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    var rowTitle = row.tag
                    var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                    rowTitle = rowTitleTextArray?[0]
                    if team1ListValuePlayer == ["-10000"] || team1ListValuePlayer == [] {
                        cell.textLabel?.text = row.tag
                    } else {
                        if team1ListValuePlayer[0] == "NEW YORK GIANTS" {
                            team1LabelPlayer = "NEW YORK (G)"
                        } else if team1ListValuePlayer[0] == "NEW YORK JETS" {
                            team1LabelPlayer = "NEW YORK (J)"
                        } else if team1ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                            team1LabelPlayer = "LOS ANGELES (C)"
                        } else if team1ListValuePlayer[0] == "LOS ANGELES RAMS" {
                            team1LabelPlayer = "LOS ANGELES (R)"
                        } else {
                            team1LabelPlayer = team1ListValuePlayer[0]
                            var team1TextArray = team1LabelPlayer.components(separatedBy: " ")
                            let team1TextArrayLength = team1TextArray.count
                            team1TextArray.remove(at: team1TextArrayLength - 1)
                            team1LabelPlayer = team1TextArray.joined(separator: " ")
                        }
                        cell.textLabel?.text = rowTitle! + ", " + team1LabelPlayer
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
                    if puntYardsTeam2SliderFormValuePlayer == "-10000" || (puntYardsTeam2RangeSliderLowerValuePlayer == puntYardsTeam2ValuesPlayer.first && puntYardsTeam2RangeSliderUpperValuePlayer == puntYardsTeam2ValuesPlayer.last) {
                        cell.detailTextLabel?.text = "EQUAL ANY"
                    } else {
                        cell.detailTextLabel?.text = puntYardsTeam2OperatorTextPlayer + puntYardsTeam2SliderFormValuePlayer
                        cell.detailTextLabel?.textColor = orangeColorDarker
                    }
                    var rowTitle = row.tag
                    var rowTitleTextArray = rowTitle?.components(separatedBy: ",")
                    rowTitle = rowTitleTextArray?[0]
                    if team2ListValuePlayer == ["-10000"] || team2ListValuePlayer == [] || team2ListValuePlayer.count > 1 {
                        cell.textLabel?.text = row.tag
                    } else {
                        if team2ListValuePlayer[0] == "NEW YORK GIANTS" {
                            team2LabelPlayer = "NEW YORK (G)"
                        } else if team2ListValuePlayer[0] == "NEW YORK JETS" {
                            team2LabelPlayer = "NEW YORK (J)"
                        } else if team2ListValuePlayer[0] == "LOS ANGELES CHARGERS" {
                            team2LabelPlayer = "LOS ANGELES (C)"
                        } else if team2ListValuePlayer[0] == "LOS ANGELES RAMS" {
                            team2LabelPlayer = "LOS ANGELES (R)"
                        } else {
                            team2LabelPlayer = team2ListValuePlayer[0]
                            var team2TextArray = team2LabelPlayer.components(separatedBy: " ")
                            let team2TextArrayLength = team2TextArray.count
                            team2TextArray.remove(at: team2TextArrayLength - 1)
                            team2LabelPlayer = team2TextArray.joined(separator: " ")
                        }
                        cell.textLabel?.text = rowTitle! + ", " + team2LabelPlayer
                    }
                    cell.textLabel?.font = twelveSemiboldSFCompact
                    cell.detailTextLabel?.font = twelveThinSFCompact
                    cell.textLabel?.addTextSpacing(spacing: -0.3)
                    cell.detailTextLabel?.addTextSpacing(spacing: -0.2)
            }
    }
////////////////////////////////////////////////////////////////////////////////////////////////////////
    @objc func reloadRowPlayer() {
        print("PlayerViewController reloadRowPlayer()")
        if tagTextPlayer == "tagTextPlayer" {
            print("Nothing to reload.")
        } else {
            let rowtagTextPlayer = playerRowDictionary[tagTextPlayer]!
            print("Row updated for: " + rowtagTextPlayer)
            self.form.rowBy(tag: rowtagTextPlayer)?.reload()
        }
        self.tableView.reloadData()
        if playerSearchBarStatus == "INACTIVE" {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "playerDashboardNotification"), object: nil)
        } else {
            print("Dashboard pending search bar exit")
        }
        
    }
////////////////////////////////////////////////////////////////////////////////////////////////////////
    func updateDashboardAfterClearSelections() {
        //print("updateDashboardAfterClearSelections()")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "playerDashboardNotification"), object: nil)
    }
////////////////////////////////////////////////////////////////////////////////////////////////////////
    func clearSelectionsPlayer() {
        //print("clearSelectionsPlayer()")
        ////////// LIST VALUES //////////
        team1ListValuePlayer = ["-10000"]
        team2ListValuePlayer = ["-10000"]
        homeTeamListValuePlayer = ["-10000"]
        favoriteListValuePlayer = ["-10000"]
        playerListValuePlayer = ["-10000"]
		playerOpponentListValuePlayer = ["-10000"]
        dayListValuePlayer = ["-10000"]
        stadiumListValuePlayer = ["-10000"]
        surfaceListValuePlayer = ["-10000"]
        ////////// MULTI-SELECTION BOOLEAN //////////
        team1MultipleSelectionBoolPlayer = true
        team2MultipleSelectionBoolPlayer = true
        homeTeamMultipleSelectionBoolPlayer = true
        favoriteMultipleSelectionBoolPlayer = true
        playerMultipleSelectionBoolPlayer = false
        playerTeamMultipleSelectionBoolPlayer = true
		playerOpponentMultipleSelectionBoolPlayer = true
        dayMultipleSelectionBoolPlayer = true
        stadiumMultipleSelectionBoolPlayer = true
        surfaceMultipleSelectionBoolPlayer = true
        ////////// SLIDER VALUES //////////
        winningLosingStreakTeam1SliderValuePlayer =  Float(-10000)
        winningLosingStreakTeam2SliderValuePlayer =  Float(-10000)
        seasonWinPercentageTeam1SliderValuePlayer =  Float(-10000)
        seasonWinPercentageTeam2SliderValuePlayer =  Float(-10000)
        seasonSliderValuePlayer =  Float(-10000)
        gameNumberSliderValuePlayer =  Float(-10000)
        temperatureSliderValuePlayer =  Float(-10000)
        totalPointsTeam1SliderValuePlayer =  Float(-10000)
        totalPointsTeam2SliderValuePlayer =  Float(-10000)
        touchdownsTeam1SliderValuePlayer =  Float(-10000)
        touchdownsTeam2SliderValuePlayer =  Float(-10000)
        offensiveTouchdownsTeam1SliderValuePlayer =  Float(-10000)
        offensiveTouchdownsTeam2SliderValuePlayer =  Float(-10000)
        defensiveTouchdownsTeam1SliderValuePlayer =  Float(-10000)
        defensiveTouchdownsTeam2SliderValuePlayer =  Float(-10000)
        turnoversCommittedTeam1SliderValuePlayer =  Float(-10000)
        turnoversCommittedTeam2SliderValuePlayer =  Float(-10000)
        penaltiesCommittedTeam1SliderValuePlayer =  Float(-10000)
        penaltiesCommittedTeam2SliderValuePlayer =  Float(-10000)
        totalYardsTeam1SliderValuePlayer =  Float(-10000)
        totalYardsTeam2SliderValuePlayer =  Float(-10000)
        passingYardsTeam1SliderValuePlayer =  Float(-10000)
        passingYardsTeam2SliderValuePlayer =  Float(-10000)
        rushingYardsTeam1SliderValuePlayer =  Float(-10000)
        rushingYardsTeam2SliderValuePlayer =  Float(-10000)
        quarterbackRatingTeam1SliderValuePlayer =  Float(-10000)
        quarterbackRatingTeam2SliderValuePlayer =  Float(-10000)
        timesSackedTeam1SliderValuePlayer =  Float(-10000)
        timesSackedTeam2SliderValuePlayer =  Float(-10000)
        interceptionsThrownTeam1SliderValuePlayer =  Float(-10000)
        interceptionsThrownTeam2SliderValuePlayer =  Float(-10000)
        offensivePlaysTeam1SliderValuePlayer =  Float(-10000)
        offensivePlaysTeam2SliderValuePlayer =  Float(-10000)
        yardsPerOffensivePlayTeam1SliderValuePlayer =  Float(-10000)
        yardsPerOffensivePlayTeam2SliderValuePlayer =  Float(-10000)
        sacksTeam1SliderValuePlayer =  Float(-10000)
        sacksTeam2SliderValuePlayer =  Float(-10000)
        interceptionsTeam1SliderValuePlayer =  Float(-10000)
        interceptionsTeam2SliderValuePlayer =  Float(-10000)
        safetiesTeam1SliderValuePlayer =  Float(-10000)
        safetiesTeam2SliderValuePlayer =  Float(-10000)
        defensivePlaysTeam1SliderValuePlayer =  Float(-10000)
        defensivePlaysTeam2SliderValuePlayer =  Float(-10000)
        yardsPerDefensivePlayTeam1SliderValuePlayer =  Float(-10000)
        yardsPerDefensivePlayTeam2SliderValuePlayer =  Float(-10000)
        extraPointAttemptsTeam1SliderValuePlayer =  Float(-10000)
        extraPointAttemptsTeam2SliderValuePlayer =  Float(-10000)
        extraPointsMadeTeam1SliderValuePlayer =  Float(-10000)
        extraPointsMadeTeam2SliderValuePlayer =  Float(-10000)
        fieldGoalAttemptsTeam1SliderValuePlayer =  Float(-10000)
        fieldGoalAttemptsTeam2SliderValuePlayer =  Float(-10000)
        fieldGoalsMadeTeam1SliderValuePlayer =  Float(-10000)
        fieldGoalsMadeTeam2SliderValuePlayer =  Float(-10000)
        puntsTeam1SliderValuePlayer =  Float(-10000)
        puntsTeam2SliderValuePlayer =  Float(-10000)
        puntYardsTeam1SliderValuePlayer =  Float(-10000)
        puntYardsTeam2SliderValuePlayer =  Float(-10000)
        ////////// RANGE SLIDER LOWER VALUE VALUES //////////
        winningLosingStreakTeam1RangeSliderLowerValuePlayer =  Float(-10000)
        winningLosingStreakTeam2RangeSliderLowerValuePlayer =  Float(-10000)
        seasonWinPercentageTeam1RangeSliderLowerValuePlayer =  Float(-10000)
        seasonWinPercentageTeam2RangeSliderLowerValuePlayer =  Float(-10000)
        seasonRangeSliderLowerValuePlayer =  Float(-10000)
        gameNumberRangeSliderLowerValuePlayer =  Float(-10000)
        temperatureRangeSliderLowerValuePlayer =  Float(-10000)
        totalPointsTeam1RangeSliderLowerValuePlayer =  Float(-10000)
        totalPointsTeam2RangeSliderLowerValuePlayer =  Float(-10000)
        touchdownsTeam1RangeSliderLowerValuePlayer =  Float(-10000)
        touchdownsTeam2RangeSliderLowerValuePlayer =  Float(-10000)
        offensiveTouchdownsTeam1RangeSliderLowerValuePlayer =  Float(-10000)
        offensiveTouchdownsTeam2RangeSliderLowerValuePlayer =  Float(-10000)
        defensiveTouchdownsTeam1RangeSliderLowerValuePlayer =  Float(-10000)
        defensiveTouchdownsTeam2RangeSliderLowerValuePlayer =  Float(-10000)
        turnoversCommittedTeam1RangeSliderLowerValuePlayer =  Float(-10000)
        turnoversCommittedTeam2RangeSliderLowerValuePlayer =  Float(-10000)
        penaltiesCommittedTeam1RangeSliderLowerValuePlayer =  Float(-10000)
        penaltiesCommittedTeam2RangeSliderLowerValuePlayer =  Float(-10000)
        totalYardsTeam1RangeSliderLowerValuePlayer =  Float(-10000)
        totalYardsTeam2RangeSliderLowerValuePlayer =  Float(-10000)
        passingYardsTeam1RangeSliderLowerValuePlayer =  Float(-10000)
        passingYardsTeam2RangeSliderLowerValuePlayer =  Float(-10000)
        rushingYardsTeam1RangeSliderLowerValuePlayer =  Float(-10000)
        rushingYardsTeam2RangeSliderLowerValuePlayer =  Float(-10000)
        quarterbackRatingTeam1RangeSliderLowerValuePlayer =  Float(-10000)
        quarterbackRatingTeam2RangeSliderLowerValuePlayer =  Float(-10000)
        timesSackedTeam1RangeSliderLowerValuePlayer =  Float(-10000)
        timesSackedTeam2RangeSliderLowerValuePlayer =  Float(-10000)
        interceptionsThrownTeam1RangeSliderLowerValuePlayer =  Float(-10000)
        interceptionsThrownTeam2RangeSliderLowerValuePlayer =  Float(-10000)
        offensivePlaysTeam1RangeSliderLowerValuePlayer =  Float(-10000)
        offensivePlaysTeam2RangeSliderLowerValuePlayer =  Float(-10000)
        yardsPerOffensivePlayTeam1RangeSliderLowerValuePlayer =  Float(-10000)
        yardsPerOffensivePlayTeam2RangeSliderLowerValuePlayer =  Float(-10000)
        sacksTeam1RangeSliderLowerValuePlayer =  Float(-10000)
        sacksTeam2RangeSliderLowerValuePlayer =  Float(-10000)
        interceptionsTeam1RangeSliderLowerValuePlayer =  Float(-10000)
        interceptionsTeam2RangeSliderLowerValuePlayer =  Float(-10000)
        safetiesTeam1RangeSliderLowerValuePlayer =  Float(-10000)
        safetiesTeam2RangeSliderLowerValuePlayer =  Float(-10000)
        defensivePlaysTeam1RangeSliderLowerValuePlayer =  Float(-10000)
        defensivePlaysTeam2RangeSliderLowerValuePlayer =  Float(-10000)
        yardsPerDefensivePlayTeam1RangeSliderLowerValuePlayer =  Float(-10000)
        yardsPerDefensivePlayTeam2RangeSliderLowerValuePlayer =  Float(-10000)
        extraPointAttemptsTeam1RangeSliderLowerValuePlayer =  Float(-10000)
        extraPointAttemptsTeam2RangeSliderLowerValuePlayer =  Float(-10000)
        extraPointsMadeTeam1RangeSliderLowerValuePlayer =  Float(-10000)
        extraPointsMadeTeam2RangeSliderLowerValuePlayer =  Float(-10000)
        fieldGoalAttemptsTeam1RangeSliderLowerValuePlayer =  Float(-10000)
        fieldGoalAttemptsTeam2RangeSliderLowerValuePlayer =  Float(-10000)
        fieldGoalsMadeTeam1RangeSliderLowerValuePlayer =  Float(-10000)
        fieldGoalsMadeTeam2RangeSliderLowerValuePlayer =  Float(-10000)
        puntsTeam1RangeSliderLowerValuePlayer =  Float(-10000)
        puntsTeam2RangeSliderLowerValuePlayer =  Float(-10000)
        puntYardsTeam1RangeSliderLowerValuePlayer =  Float(-10000)
        puntYardsTeam2RangeSliderLowerValuePlayer =  Float(-10000)
        ////////// RANGE SLIDER UPPER VALUE VALUES //////////
        winningLosingStreakTeam1RangeSliderUpperValuePlayer =  Float(-10000)
        winningLosingStreakTeam2RangeSliderUpperValuePlayer =  Float(-10000)
        seasonWinPercentageTeam1RangeSliderUpperValuePlayer =  Float(-10000)
        seasonWinPercentageTeam2RangeSliderUpperValuePlayer =  Float(-10000)
        seasonRangeSliderUpperValuePlayer =  Float(-10000)
        gameNumberRangeSliderUpperValuePlayer =  Float(-10000)
        temperatureRangeSliderUpperValuePlayer =  Float(-10000)
        totalPointsTeam1RangeSliderUpperValuePlayer =  Float(-10000)
        totalPointsTeam2RangeSliderUpperValuePlayer =  Float(-10000)
        touchdownsTeam1RangeSliderUpperValuePlayer =  Float(-10000)
        touchdownsTeam2RangeSliderUpperValuePlayer =  Float(-10000)
        offensiveTouchdownsTeam1RangeSliderUpperValuePlayer =  Float(-10000)
        offensiveTouchdownsTeam2RangeSliderUpperValuePlayer =  Float(-10000)
        defensiveTouchdownsTeam1RangeSliderUpperValuePlayer =  Float(-10000)
        defensiveTouchdownsTeam2RangeSliderUpperValuePlayer =  Float(-10000)
        turnoversCommittedTeam1RangeSliderUpperValuePlayer =  Float(-10000)
        turnoversCommittedTeam2RangeSliderUpperValuePlayer =  Float(-10000)
        penaltiesCommittedTeam1RangeSliderUpperValuePlayer =  Float(-10000)
        penaltiesCommittedTeam2RangeSliderUpperValuePlayer =  Float(-10000)
        totalYardsTeam1RangeSliderUpperValuePlayer =  Float(-10000)
        totalYardsTeam2RangeSliderUpperValuePlayer =  Float(-10000)
        passingYardsTeam1RangeSliderUpperValuePlayer =  Float(-10000)
        passingYardsTeam2RangeSliderUpperValuePlayer =  Float(-10000)
        rushingYardsTeam1RangeSliderUpperValuePlayer =  Float(-10000)
        rushingYardsTeam2RangeSliderUpperValuePlayer =  Float(-10000)
        quarterbackRatingTeam1RangeSliderUpperValuePlayer =  Float(-10000)
        quarterbackRatingTeam2RangeSliderUpperValuePlayer =  Float(-10000)
        timesSackedTeam1RangeSliderUpperValuePlayer =  Float(-10000)
        timesSackedTeam2RangeSliderUpperValuePlayer =  Float(-10000)
        interceptionsThrownTeam1RangeSliderUpperValuePlayer =  Float(-10000)
        interceptionsThrownTeam2RangeSliderUpperValuePlayer =  Float(-10000)
        offensivePlaysTeam1RangeSliderUpperValuePlayer =  Float(-10000)
        offensivePlaysTeam2RangeSliderUpperValuePlayer =  Float(-10000)
        yardsPerOffensivePlayTeam1RangeSliderUpperValuePlayer =  Float(-10000)
        yardsPerOffensivePlayTeam2RangeSliderUpperValuePlayer =  Float(-10000)
        sacksTeam1RangeSliderUpperValuePlayer =  Float(-10000)
        sacksTeam2RangeSliderUpperValuePlayer =  Float(-10000)
        interceptionsTeam1RangeSliderUpperValuePlayer =  Float(-10000)
        interceptionsTeam2RangeSliderUpperValuePlayer =  Float(-10000)
        safetiesTeam1RangeSliderUpperValuePlayer =  Float(-10000)
        safetiesTeam2RangeSliderUpperValuePlayer =  Float(-10000)
        defensivePlaysTeam1RangeSliderUpperValuePlayer =  Float(-10000)
        defensivePlaysTeam2RangeSliderUpperValuePlayer =  Float(-10000)
        yardsPerDefensivePlayTeam1RangeSliderUpperValuePlayer =  Float(-10000)
        yardsPerDefensivePlayTeam2RangeSliderUpperValuePlayer =  Float(-10000)
        extraPointAttemptsTeam1RangeSliderUpperValuePlayer =  Float(-10000)
        extraPointAttemptsTeam2RangeSliderUpperValuePlayer =  Float(-10000)
        extraPointsMadeTeam1RangeSliderUpperValuePlayer =  Float(-10000)
        extraPointsMadeTeam2RangeSliderUpperValuePlayer =  Float(-10000)
        fieldGoalAttemptsTeam1RangeSliderUpperValuePlayer =  Float(-10000)
        fieldGoalAttemptsTeam2RangeSliderUpperValuePlayer =  Float(-10000)
        fieldGoalsMadeTeam1RangeSliderUpperValuePlayer =  Float(-10000)
        fieldGoalsMadeTeam2RangeSliderUpperValuePlayer =  Float(-10000)
        puntsTeam1RangeSliderUpperValuePlayer =  Float(-10000)
        puntsTeam2RangeSliderUpperValuePlayer =  Float(-10000)
        puntYardsTeam1RangeSliderUpperValuePlayer =  Float(-10000)
        puntYardsTeam2RangeSliderUpperValuePlayer =  Float(-10000)
        ////////// OPERATOR VALUES //////////
        team1OperatorValuePlayer = "-10000"
        team2OperatorValuePlayer = "-10000"
        winningLosingStreakTeam1OperatorValuePlayer = "-10000"
        winningLosingStreakTeam2OperatorValuePlayer = "-10000"
        seasonWinPercentageTeam1OperatorValuePlayer = "-10000"
        seasonWinPercentageTeam2OperatorValuePlayer = "-10000"
        homeTeamOperatorValuePlayer = "-10000"
        favoriteOperatorValuePlayer = "-10000"
        playerOperatorValuePlayer = "-10000"
		playerOpponentOperatorValuePlayer = "-10000"
        seasonOperatorValuePlayer = "-10000"
        gameNumberOperatorValuePlayer = "-10000"
        dayOperatorValuePlayer = "-10000"
        stadiumOperatorValuePlayer = "-10000"
        surfaceOperatorValuePlayer = "-10000"
        temperatureOperatorValuePlayer = "-10000"
        totalPointsTeam1OperatorValuePlayer = "-10000"
        totalPointsTeam2OperatorValuePlayer = "-10000"
        touchdownsTeam1OperatorValuePlayer = "-10000"
        touchdownsTeam2OperatorValuePlayer = "-10000"
        offensiveTouchdownsTeam1OperatorValuePlayer = "-10000"
        offensiveTouchdownsTeam2OperatorValuePlayer = "-10000"
        defensiveTouchdownsTeam1OperatorValuePlayer = "-10000"
        defensiveTouchdownsTeam2OperatorValuePlayer = "-10000"
        turnoversCommittedTeam1OperatorValuePlayer = "-10000"
        turnoversCommittedTeam2OperatorValuePlayer = "-10000"
        penaltiesCommittedTeam1OperatorValuePlayer = "-10000"
        penaltiesCommittedTeam2OperatorValuePlayer = "-10000"
        totalYardsTeam1OperatorValuePlayer = "-10000"
        totalYardsTeam2OperatorValuePlayer = "-10000"
        passingYardsTeam1OperatorValuePlayer = "-10000"
        passingYardsTeam2OperatorValuePlayer = "-10000"
        rushingYardsTeam1OperatorValuePlayer = "-10000"
        rushingYardsTeam2OperatorValuePlayer = "-10000"
        quarterbackRatingTeam1OperatorValuePlayer = "-10000"
        quarterbackRatingTeam2OperatorValuePlayer = "-10000"
        timesSackedTeam1OperatorValuePlayer = "-10000"
        timesSackedTeam2OperatorValuePlayer = "-10000"
        interceptionsThrownTeam1OperatorValuePlayer = "-10000"
        interceptionsThrownTeam2OperatorValuePlayer = "-10000"
        offensivePlaysTeam1OperatorValuePlayer = "-10000"
        offensivePlaysTeam2OperatorValuePlayer = "-10000"
        yardsPerOffensivePlayTeam1OperatorValuePlayer = "-10000"
        yardsPerOffensivePlayTeam2OperatorValuePlayer = "-10000"
        sacksTeam1OperatorValuePlayer = "-10000"
        sacksTeam2OperatorValuePlayer = "-10000"
        interceptionsTeam1OperatorValuePlayer = "-10000"
        interceptionsTeam2OperatorValuePlayer = "-10000"
        safetiesTeam1OperatorValuePlayer = "-10000"
        safetiesTeam2OperatorValuePlayer = "-10000"
        defensivePlaysTeam1OperatorValuePlayer = "-10000"
        defensivePlaysTeam2OperatorValuePlayer = "-10000"
        yardsPerDefensivePlayTeam1OperatorValuePlayer = "-10000"
        yardsPerDefensivePlayTeam2OperatorValuePlayer = "-10000"
        extraPointAttemptsTeam1OperatorValuePlayer = "-10000"
        extraPointAttemptsTeam2OperatorValuePlayer = "-10000"
        extraPointsMadeTeam1OperatorValuePlayer = "-10000"
        extraPointsMadeTeam2OperatorValuePlayer = "-10000"
        fieldGoalAttemptsTeam1OperatorValuePlayer = "-10000"
        fieldGoalAttemptsTeam2OperatorValuePlayer = "-10000"
        fieldGoalsMadeTeam1OperatorValuePlayer = "-10000"
        fieldGoalsMadeTeam2OperatorValuePlayer = "-10000"
        puntsTeam1OperatorValuePlayer = "-10000"
        puntsTeam2OperatorValuePlayer = "-10000"
        puntYardsTeam1OperatorValuePlayer = "-10000"
        puntYardsTeam2OperatorValuePlayer = "-10000"
        ////////// SLIDER FORM VALUES //////////
        winningLosingStreakTeam1SliderFormValuePlayer = "-10000"
        winningLosingStreakTeam2SliderFormValuePlayer = "-10000"
        seasonWinPercentageTeam1SliderFormValuePlayer = "-10000"
        seasonWinPercentageTeam2SliderFormValuePlayer = "-10000"
        seasonSliderFormValuePlayer = "-10000"
        gameNumberSliderFormValuePlayer = "-10000"
        temperatureSliderFormValuePlayer = "-10000"
        totalPointsTeam1SliderFormValuePlayer = "-10000"
        totalPointsTeam2SliderFormValuePlayer = "-10000"
        touchdownsTeam1SliderFormValuePlayer = "-10000"
        touchdownsTeam2SliderFormValuePlayer = "-10000"
        offensiveTouchdownsTeam1SliderFormValuePlayer = "-10000"
        offensiveTouchdownsTeam2SliderFormValuePlayer = "-10000"
        defensiveTouchdownsTeam1SliderFormValuePlayer = "-10000"
        defensiveTouchdownsTeam2SliderFormValuePlayer = "-10000"
        turnoversCommittedTeam1SliderFormValuePlayer = "-10000"
        turnoversCommittedTeam2SliderFormValuePlayer = "-10000"
        penaltiesCommittedTeam1SliderFormValuePlayer = "-10000"
        penaltiesCommittedTeam2SliderFormValuePlayer = "-10000"
        totalYardsTeam1SliderFormValuePlayer = "-10000"
        totalYardsTeam2SliderFormValuePlayer = "-10000"
        passingYardsTeam1SliderFormValuePlayer = "-10000"
        passingYardsTeam2SliderFormValuePlayer = "-10000"
        rushingYardsTeam1SliderFormValuePlayer = "-10000"
        rushingYardsTeam2SliderFormValuePlayer = "-10000"
        quarterbackRatingTeam1SliderFormValuePlayer = "-10000"
        quarterbackRatingTeam2SliderFormValuePlayer = "-10000"
        timesSackedTeam1SliderFormValuePlayer = "-10000"
        timesSackedTeam2SliderFormValuePlayer = "-10000"
        interceptionsThrownTeam1SliderFormValuePlayer = "-10000"
        interceptionsThrownTeam2SliderFormValuePlayer = "-10000"
        offensivePlaysTeam1SliderFormValuePlayer = "-10000"
        offensivePlaysTeam2SliderFormValuePlayer = "-10000"
        yardsPerOffensivePlayTeam1SliderFormValuePlayer = "-10000"
        yardsPerOffensivePlayTeam2SliderFormValuePlayer = "-10000"
        sacksTeam1SliderFormValuePlayer = "-10000"
        sacksTeam2SliderFormValuePlayer = "-10000"
        interceptionsTeam1SliderFormValuePlayer = "-10000"
        interceptionsTeam2SliderFormValuePlayer = "-10000"
        safetiesTeam1SliderFormValuePlayer = "-10000"
        safetiesTeam2SliderFormValuePlayer = "-10000"
        defensivePlaysTeam1SliderFormValuePlayer = "-10000"
        defensivePlaysTeam2SliderFormValuePlayer = "-10000"
        yardsPerDefensivePlayTeam1SliderFormValuePlayer = "-10000"
        yardsPerDefensivePlayTeam2SliderFormValuePlayer = "-10000"
        extraPointAttemptsTeam1SliderFormValuePlayer = "-10000"
        extraPointAttemptsTeam2SliderFormValuePlayer = "-10000"
        extraPointsMadeTeam1SliderFormValuePlayer = "-10000"
        extraPointsMadeTeam2SliderFormValuePlayer = "-10000"
        fieldGoalAttemptsTeam1SliderFormValuePlayer = "-10000"
        fieldGoalAttemptsTeam2SliderFormValuePlayer = "-10000"
        fieldGoalsMadeTeam1SliderFormValuePlayer = "-10000"
        fieldGoalsMadeTeam2SliderFormValuePlayer = "-10000"
        puntsTeam1SliderFormValuePlayer = "-10000"
        puntsTeam2SliderFormValuePlayer = "-10000"
        puntYardsTeam1SliderFormValuePlayer = "-10000"
        puntYardsTeam2SliderFormValuePlayer = "-10000"
        //////////////////// FORM VALUES ////////////////////
        formListValuePlayer = ["-10000"]
        formSliderValuePlayer = Float(-10000)
        sliderValue = "-10000"
        formRangeSliderLowerValuePlayer = Float(-10000)
        formRangeSliderUpperValuePlayer = Float(-10000)
        formOperatorValuePlayer = "-10000"
        selectedOperatorValuePlayer = "-10000"
        //////////////////////////////////////////////////////
        weekSliderValuePlayer = Float(-10000)
        weekRangeSliderLowerValuePlayer = Float(-10000)
        weekRangeSliderUpperValuePlayer = Float(-10000)
        weekOperatorValuePlayer = "-10000"
        weekSliderFormValuePlayer = "-10000"
        spreadSliderValuePlayer = Float(-10000)
        spreadRangeSliderLowerValuePlayer = Float(-10000)
        spreadRangeSliderUpperValuePlayer = Float(-10000)
        spreadOperatorValuePlayer = "-10000"
        spreadSliderFormValuePlayer = "-10000"
        overUnderSliderValuePlayer = Float(-10000)
        overUnderRangeSliderLowerValuePlayer = Float(-10000)
        overUnderRangeSliderUpperValuePlayer = Float(-10000)
        overUnderOperatorValuePlayer = "-10000"
        overUnderSliderFormValuePlayer = "-10000"
        //////////////////////////////////////////////////////
        self.tableView.reloadData()
        updateDashboardAfterClearSelections()
    }
////////////////////////////////////////////////////////////////////////////////////////////////////////
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //--------------------PICKERS----------------------//
        //////////// MATCH - UP ////////////
        if segue.identifier == "PlayerSegue" {
            tagTextPlayer = "PLAYER"
            print("New Row Selected: " + tagTextPlayer)
        }
		
        if segue.identifier == "PlayerTeam1Segue" {
            tagTextPlayer = "PLAYER TEAM"
            print("New Row Selected: " + tagTextPlayer)
        }
        if segue.identifier == "Team2Segue" {
            tagTextPlayer = "OPPONENT"
            print("New Row Selected: " + tagTextPlayer)
        }
        //////////// GAME SETTING ////////////
        if segue.identifier == "HomeTeamSegue" {
            tagTextPlayer = "HOME TEAM"
            print("New Row Selected: " + tagTextPlayer)
        }
        if segue.identifier == "DayOfWeekSegue" {
            tagTextPlayer = "DAY"
            print("New Row Selected: " + tagTextPlayer)
        }
        if segue.identifier == "StadiumSegue" {
            tagTextPlayer = "STADIUM"
            print("New Row Selected: " + tagTextPlayer)
        }
        if segue.identifier == "SurfaceSegue" {
            tagTextPlayer = "SURFACE"
            print("New Row Selected: " + tagTextPlayer)
        }
        //////////// ENTERING GAME ////////////
        if segue.identifier == "FavoriteSegue" {
            tagTextPlayer = "FAVORITE"
            print("New Row Selected: " + tagTextPlayer)
        }
        if segue.identifier == "PlayerTeamSegue" {
            tagTextPlayer = "PLAYER TEAM: PLAYERS"
            print("New Row Selected: " + tagTextPlayer)
        }
        if segue.identifier == "PlayerOpponentSegue" {
            tagTextPlayer = "OPPONENT: PLAYERS"
            print("New Row Selected: " + tagTextPlayer)
        }
        //--------------------SLIDERS----------------------//
        ////////////  GAME SETTING  ////////////
        if segue.identifier == "SeasonSegue" {
            let playerSliderViewController = segue.destination as! PlayerSliderViewController
            tagTextPlayer = "SEASON"
            playerSliderViewController.headerLabel = tagTextPlayer
            print("New Row Selected: " + tagTextPlayer)
        }
        if segue.identifier == "WeekSegue" {
            let playerSliderViewController = segue.destination as! PlayerSliderViewController
            tagTextPlayer = "WEEK"
            playerSliderViewController.headerLabel = tagTextPlayer
            print("New Row Selected: " + tagTextPlayer)
        }
        if segue.identifier == "GameNumberSegue" {
            let playerSliderViewController = segue.destination as! PlayerSliderViewController
            tagTextPlayer = "GAME NUMBER"
            playerSliderViewController.headerLabel = tagTextPlayer
            print("New Row Selected: " + tagTextPlayer)
        }
        if segue.identifier == "TemperatureSegue" {
            let playerSliderViewController = segue.destination as! PlayerSliderViewController
            tagTextPlayer = "TEMPERATURE (F)"
            playerSliderViewController.headerLabel = tagTextPlayer
            print("New Row Selected: " + tagTextPlayer)
        }
        //////////// ENTERING GAME ////////////
        if segue.identifier == "SpreadSegue" {
            let playerSliderViewController = segue.destination as! PlayerSliderViewController
            tagTextPlayer = "PLAYER TEAM: SPREAD"
            playerSliderViewController.headerLabel = tagTextPlayer
            print("New Row Selected: " + tagTextPlayer)
        }
        if segue.identifier == "OverUnderSegue" {
            let playerSliderViewController = segue.destination as! PlayerSliderViewController
            tagTextPlayer = "OVER/UNDER"
            playerSliderViewController.headerLabel = tagTextPlayer
            print("New Row Selected: " + tagTextPlayer)
        }
        if segue.identifier == "WinLossStreakTeam1Segue" {
            let playerSliderViewController = segue.destination as! PlayerSliderViewController
            tagTextPlayer = "PLAYER TEAM: STREAK"
            playerSliderViewController.headerLabel = tagTextPlayer
            print("New Row Selected: " + tagTextPlayer)
        }
        if segue.identifier == "WinLossStreakTeam2Segue" {
            let playerSliderViewController = segue.destination as! PlayerSliderViewController
            tagTextPlayer = "OPPONENT: STREAK"
            playerSliderViewController.headerLabel = tagTextPlayer
            print("New Row Selected: " + tagTextPlayer)
        }
        if segue.identifier == "SeasonWinPercentageTeam1Segue" {
            let playerSliderViewController = segue.destination as! PlayerSliderViewController
            tagTextPlayer = "PLAYER TEAM: SEASON WIN %"
            playerSliderViewController.headerLabel = tagTextPlayer
            print("New Row Selected: " + tagTextPlayer)
        }
        if segue.identifier == "SeasonWinPercentageTeam2Segue" {
            let playerSliderViewController = segue.destination as! PlayerSliderViewController
            tagTextPlayer = "OPPONENT: SEASON WIN %"
            playerSliderViewController.headerLabel = tagTextPlayer
            print("New Row Selected: " + tagTextPlayer)
        }
        //////////// TEAM ////////////
        if segue.identifier == "TotalPointsTeam1Segue" {
            let playerSliderViewController = segue.destination as! PlayerSliderViewController
            tagTextPlayer = "PLAYER TEAM: TOTAL POINTS"
            playerSliderViewController.headerLabel = tagTextPlayer
            print("New Row Selected: " + tagTextPlayer)
        }
        if segue.identifier == "TotalPointsTeam2Segue" {
            let playerSliderViewController = segue.destination as! PlayerSliderViewController
            tagTextPlayer = "OPPONENT: TOTAL POINTS"
            playerSliderViewController.headerLabel = tagTextPlayer
            print("New Row Selected: " + tagTextPlayer)
        }
        if segue.identifier == "TouchdownsTeam1Segue" {
            let playerSliderViewController = segue.destination as! PlayerSliderViewController
            tagTextPlayer = "PLAYER TEAM: TOUCHDOWNS"
            playerSliderViewController.headerLabel = tagTextPlayer
            print("New Row Selected: " + tagTextPlayer)
        }
        if segue.identifier == "TouchdownsTeam2Segue" {
            let playerSliderViewController = segue.destination as! PlayerSliderViewController
            tagTextPlayer = "OPPONENT: TOUCHDOWNS"
            playerSliderViewController.headerLabel = tagTextPlayer
            print("New Row Selected: " + tagTextPlayer)
        }
        if segue.identifier == "TurnoversCommittedTeam1Segue" {
            let playerSliderViewController = segue.destination as! PlayerSliderViewController
            tagTextPlayer = "PLAYER TEAM: TURNOVERS"
            playerSliderViewController.headerLabel = tagTextPlayer
            print("New Row Selected: " + tagTextPlayer)
        }
        if segue.identifier == "TurnoversCommittedTeam2Segue" {
            let playerSliderViewController = segue.destination as! PlayerSliderViewController
            tagTextPlayer = "OPPONENT: TURNOVERS"
            playerSliderViewController.headerLabel = tagTextPlayer
            print("New Row Selected: " + tagTextPlayer)
        }
        if segue.identifier == "PenaltiesCommittedTeam1Segue" {
            let playerSliderViewController = segue.destination as! PlayerSliderViewController
            tagTextPlayer = "PLAYER TEAM: PENALTIES"
            playerSliderViewController.headerLabel = tagTextPlayer
            print("New Row Selected: " + tagTextPlayer)
        }
        if segue.identifier == "PenaltiesCommittedTeam2Segue" {
            let playerSliderViewController = segue.destination as! PlayerSliderViewController
            tagTextPlayer = "OPPONENT: PENALTIES"
            playerSliderViewController.headerLabel = tagTextPlayer
            print("New Row Selected: " + tagTextPlayer)
        }
        //////////// OFFENSE ////////////
        if segue.identifier == "OffensiveTouchdownsTeam1Segue" {
            let playerSliderViewController = segue.destination as! PlayerSliderViewController
            tagTextPlayer = "PLAYER TEAM: OFFENSIVE TOUCHDOWNS"
            playerSliderViewController.headerLabel = tagTextPlayer
            print("New Row Selected: " + tagTextPlayer)
        }
        if segue.identifier == "OffensiveTouchdownsTeam2Segue" {
            let playerSliderViewController = segue.destination as! PlayerSliderViewController
            tagTextPlayer = "OPPONENT: OFFENSIVE TOUCHDOWNS"
            playerSliderViewController.headerLabel = tagTextPlayer
            print("New Row Selected: " + tagTextPlayer)
        }
        if segue.identifier == "TotalYardsTeam1Segue" {
            let playerSliderViewController = segue.destination as! PlayerSliderViewController
            tagTextPlayer = "PLAYER TEAM: TOTAL YARDS"
            playerSliderViewController.headerLabel = tagTextPlayer
            print("New Row Selected: " + tagTextPlayer)
        }
        if segue.identifier == "TotalYardsTeam2Segue" {
            let playerSliderViewController = segue.destination as! PlayerSliderViewController
            tagTextPlayer = "OPPONENT: TOTAL YARDS"
            playerSliderViewController.headerLabel = tagTextPlayer
            print("New Row Selected: " + tagTextPlayer)
        }
        if segue.identifier == "PassingYardsTeam1Segue" {
            let playerSliderViewController = segue.destination as! PlayerSliderViewController
            tagTextPlayer = "PLAYER TEAM: PASSING YARDS"
            playerSliderViewController.headerLabel = tagTextPlayer
            print("New Row Selected: " + tagTextPlayer)
        }
        if segue.identifier == "PassingYardsTeam2Segue" {
            let playerSliderViewController = segue.destination as! PlayerSliderViewController
            tagTextPlayer = "OPPONENT: PASSING YARDS"
            playerSliderViewController.headerLabel = tagTextPlayer
            print("New Row Selected: " + tagTextPlayer)
        }
        if segue.identifier == "RushingYardsTeam1Segue" {
            let playerSliderViewController = segue.destination as! PlayerSliderViewController
            tagTextPlayer = "PLAYER TEAM: RUSHING YARDS"
            playerSliderViewController.headerLabel = tagTextPlayer
            print("New Row Selected: " + tagTextPlayer)
        }
        if segue.identifier == "RushingYardsTeam2Segue" {
            let playerSliderViewController = segue.destination as! PlayerSliderViewController
            tagTextPlayer = "OPPONENT: RUSHING YARDS"
            playerSliderViewController.headerLabel = tagTextPlayer
            print("New Row Selected: " + tagTextPlayer)
        }
        if segue.identifier == "QuarterbackRatingTeam1Segue" {
            let playerSliderViewController = segue.destination as! PlayerSliderViewController
            tagTextPlayer = "PLAYER TEAM: QUARTERBACK RATING"
            playerSliderViewController.headerLabel = tagTextPlayer
            print("New Row Selected: " + tagTextPlayer)
        }
        if segue.identifier == "QuarterbackRatingTeam2Segue" {
            let playerSliderViewController = segue.destination as! PlayerSliderViewController
            tagTextPlayer = "OPPONENT: QUARTERBACK RATING"
            playerSliderViewController.headerLabel = tagTextPlayer
            print("New Row Selected: " + tagTextPlayer)
        }
        if segue.identifier == "TimesSackedTeam1Segue" {
            let playerSliderViewController = segue.destination as! PlayerSliderViewController
            tagTextPlayer = "PLAYER TEAM: TIMES SACKED"
            playerSliderViewController.headerLabel = tagTextPlayer
            print("New Row Selected: " + tagTextPlayer)
        }
        if segue.identifier == "TimesSackedTeam2Segue" {
            let playerSliderViewController = segue.destination as! PlayerSliderViewController
            tagTextPlayer = "OPPONENT: TIMES SACKED"
            playerSliderViewController.headerLabel = tagTextPlayer
            print("New Row Selected: " + tagTextPlayer)
        }
        if segue.identifier == "InterceptionsThrownTeam1Segue" {
            let playerSliderViewController = segue.destination as! PlayerSliderViewController
            tagTextPlayer = "PLAYER TEAM: INTERCEPTIONS THROWN"
            playerSliderViewController.headerLabel = tagTextPlayer
            print("New Row Selected: " + tagTextPlayer)
        }
        if segue.identifier == "InterceptionsThrownTeam2Segue" {
            let playerSliderViewController = segue.destination as! PlayerSliderViewController
            tagTextPlayer = "OPPONENT: INTERCEPTIONS THROWN"
            playerSliderViewController.headerLabel = tagTextPlayer
            print("New Row Selected: " + tagTextPlayer)
        }
        if segue.identifier == "OffensivePlaysTeam1Segue" {
            let playerSliderViewController = segue.destination as! PlayerSliderViewController
            tagTextPlayer = "PLAYER TEAM: OFFENSIVE PLAYS"
            playerSliderViewController.headerLabel = tagTextPlayer
            print("New Row Selected: " + tagTextPlayer)
        }
        if segue.identifier == "OffensivePlaysTeam2Segue" {
            let playerSliderViewController = segue.destination as! PlayerSliderViewController
            tagTextPlayer = "OPPONENT: OFFENSIVE PLAYS"
            playerSliderViewController.headerLabel = tagTextPlayer
            print("New Row Selected: " + tagTextPlayer)
        }
        if segue.identifier == "YardsPerOffensivePlayTeam1Segue" {
            let playerSliderViewController = segue.destination as! PlayerSliderViewController
            tagTextPlayer = "PLAYER TEAM: YARDS/OFFENSIVE PLAY"
            playerSliderViewController.headerLabel = tagTextPlayer
            print("New Row Selected: " + tagTextPlayer)
        }
        if segue.identifier == "YardsPerOffensivePlayTeam2Segue" {
            let playerSliderViewController = segue.destination as! PlayerSliderViewController
            tagTextPlayer = "OPPONENT: YARDS/OFFENSIVE PLAY"
            playerSliderViewController.headerLabel = tagTextPlayer
            print("New Row Selected: " + tagTextPlayer)
        }
        //////////// DEFENSE ////////////
        if segue.identifier == "DefensiveTouchdownsTeam1Segue" {
            let playerSliderViewController = segue.destination as! PlayerSliderViewController
            tagTextPlayer = "PLAYER TEAM: DEFENSIVE TOUCHDOWNS"
            playerSliderViewController.headerLabel = tagTextPlayer
            print("New Row Selected: " + tagTextPlayer)
        }
        if segue.identifier == "DefensiveTouchdownsTeam2Segue" {
            let playerSliderViewController = segue.destination as! PlayerSliderViewController
            tagTextPlayer = "OPPONENT: DEFENSIVE TOUCHDOWNS"
            playerSliderViewController.headerLabel = tagTextPlayer
            print("New Row Selected: " + tagTextPlayer)
        }
        if segue.identifier == "DefensiveSacksTeam1Segue" {
            let playerSliderViewController = segue.destination as! PlayerSliderViewController
            tagTextPlayer = "PLAYER TEAM: SACKS"
            playerSliderViewController.headerLabel = tagTextPlayer
            print("New Row Selected: " + tagTextPlayer)
        }
        if segue.identifier == "DefensiveSacksTeam2Segue" {
            let playerSliderViewController = segue.destination as! PlayerSliderViewController
            tagTextPlayer = "OPPONENT: SACKS"
            playerSliderViewController.headerLabel = tagTextPlayer
            print("New Row Selected: " + tagTextPlayer)
        }
        if segue.identifier == "DefensiveInterceptionsTeam1Segue" {
            let playerSliderViewController = segue.destination as! PlayerSliderViewController
            tagTextPlayer = "PLAYER TEAM: INTERCEPTIONS"
            playerSliderViewController.headerLabel = tagTextPlayer
            print("New Row Selected: " + tagTextPlayer)
        }
        if segue.identifier == "DefensiveInterceptionsTeam2Segue" {
            let playerSliderViewController = segue.destination as! PlayerSliderViewController
            tagTextPlayer = "OPPONENT: INTERCEPTIONS"
            playerSliderViewController.headerLabel = tagTextPlayer
            print("New Row Selected: " + tagTextPlayer)
        }
        if segue.identifier == "SafetiesTeam1Segue" {
            let playerSliderViewController = segue.destination as! PlayerSliderViewController
            tagTextPlayer = "PLAYER TEAM: SAFETIES"
            playerSliderViewController.headerLabel = tagTextPlayer
            print("New Row Selected: " + tagTextPlayer)
        }
        if segue.identifier == "SafetiesTeam2Segue" {
            let playerSliderViewController = segue.destination as! PlayerSliderViewController
            tagTextPlayer = "OPPONENT: SAFETIES"
            playerSliderViewController.headerLabel = tagTextPlayer
            print("New Row Selected: " + tagTextPlayer)
        }
        if segue.identifier == "DefensivePlaysTeam1Segue" {
            let playerSliderViewController = segue.destination as! PlayerSliderViewController
            tagTextPlayer = "PLAYER TEAM: DEFENSIVE PLAYS"
            playerSliderViewController.headerLabel = tagTextPlayer
            print("New Row Selected: " + tagTextPlayer)
        }
        if segue.identifier == "DefensivePlaysTeam2Segue" {
            let playerSliderViewController = segue.destination as! PlayerSliderViewController
            tagTextPlayer = "OPPONENT: DEFENSIVE PLAYS"
            playerSliderViewController.headerLabel = tagTextPlayer
            print("New Row Selected: " + tagTextPlayer)
        }
        if segue.identifier == "YardsPerDefensivePlayTeam1Segue" {
            let playerSliderViewController = segue.destination as! PlayerSliderViewController
            tagTextPlayer = "PLAYER TEAM: YARDS/DEFENSIVE PLAY"
            playerSliderViewController.headerLabel = tagTextPlayer
            print("New Row Selected: " + tagTextPlayer)
        }
        if segue.identifier == "YardsPerDefensivePlayTeam2Segue" {
            let playerSliderViewController = segue.destination as! PlayerSliderViewController
            tagTextPlayer = "OPPONENT: YARDS/DEFENSIVE PLAY"
            playerSliderViewController.headerLabel = tagTextPlayer
            print("New Row Selected: " + tagTextPlayer)
        }
        //////////// SPECIAL TEAMS ////////////
        if segue.identifier == "ExtraPointAttemptsTeam1Segue" {
            let playerSliderViewController = segue.destination as! PlayerSliderViewController
            tagTextPlayer = "PLAYER TEAM: EXTRA POINT ATTEMPTS"
            playerSliderViewController.headerLabel = tagTextPlayer
            print("New Row Selected: " + tagTextPlayer)
        }
        if segue.identifier == "ExtraPointAttemptsTeam2Segue" {
            let playerSliderViewController = segue.destination as! PlayerSliderViewController
            tagTextPlayer = "OPPONENT: EXTRA POINT ATTEMPTS"
            playerSliderViewController.headerLabel = tagTextPlayer
            print("New Row Selected: " + tagTextPlayer)
        }
        if segue.identifier == "ExtraPointsMadeTeam1Segue" {
            let playerSliderViewController = segue.destination as! PlayerSliderViewController
            tagTextPlayer = "PLAYER TEAM: EXTRA POINTS MADE"
            playerSliderViewController.headerLabel = tagTextPlayer
            print("New Row Selected: " + tagTextPlayer)
        }
        if segue.identifier == "ExtraPointsMadeTeam2Segue" {
            let playerSliderViewController = segue.destination as! PlayerSliderViewController
            tagTextPlayer = "OPPONENT: EXTRA POINTS MADE"
            playerSliderViewController.headerLabel = tagTextPlayer
            print("New Row Selected: " + tagTextPlayer)
        }
        if segue.identifier == "FieldGoalAttemptsTeam1Segue" {
            let playerSliderViewController = segue.destination as! PlayerSliderViewController
            tagTextPlayer = "PLAYER TEAM: FIELD GOAL ATTEMPTS"
            playerSliderViewController.headerLabel = tagTextPlayer
            print("New Row Selected: " + tagTextPlayer)
        }
        if segue.identifier == "FieldGoalAttemptsTeam2Segue" {
            let playerSliderViewController = segue.destination as! PlayerSliderViewController
            tagTextPlayer = "OPPONENT: FIELD GOAL ATTEMPTS"
            playerSliderViewController.headerLabel = tagTextPlayer
            print("New Row Selected: " + tagTextPlayer)
        }
        if segue.identifier == "FieldGoalsMadeTeam1Segue" {
            let playerSliderViewController = segue.destination as! PlayerSliderViewController
            tagTextPlayer = "PLAYER TEAM: FIELD GOALS MADE"
            playerSliderViewController.headerLabel = tagTextPlayer
            print("New Row Selected: " + tagTextPlayer)
        }
        if segue.identifier == "FieldGoalsMadeTeam2Segue" {
            let playerSliderViewController = segue.destination as! PlayerSliderViewController
            tagTextPlayer = "OPPONENT: FIELD GOALS MADE"
            playerSliderViewController.headerLabel = tagTextPlayer
            print("New Row Selected: " + tagTextPlayer)
        }
        if segue.identifier == "PuntsTeam1Segue" {
            let playerSliderViewController = segue.destination as! PlayerSliderViewController
            tagTextPlayer = "PLAYER TEAM: PUNTS"
            playerSliderViewController.headerLabel = tagTextPlayer
            print("New Row Selected: " + tagTextPlayer)
        }
        if segue.identifier == "PuntsTeam2Segue" {
            let playerSliderViewController = segue.destination as! PlayerSliderViewController
            tagTextPlayer = "OPPONENT: PUNTS"
            playerSliderViewController.headerLabel = tagTextPlayer
            print("New Row Selected: " + tagTextPlayer)
        }
        if segue.identifier == "PuntYardsTeam1Segue" {
            let playerSliderViewController = segue.destination as! PlayerSliderViewController
            tagTextPlayer = "PLAYER TEAM: PUNT YARDS"
            playerSliderViewController.headerLabel = tagTextPlayer
            print("New Row Selected: " + tagTextPlayer)
        }
        if segue.identifier == "PuntYardsTeam2Segue" {
            let playerSliderViewController = segue.destination as! PlayerSliderViewController
            tagTextPlayer = "OPPONENT: PUNT YARDS"
            playerSliderViewController.headerLabel = tagTextPlayer
            print("New Row Selected: " + tagTextPlayer)
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
