//
//  TeamDashboardViewController.swift
//  TrendPlay
//
//  Created by Chelsea Smith on 1/31/17.
//  Copyright © 2017 Trending Productions LLC. All rights reserved.
//

import UIKit
//import Eureka
import MaterialComponents
import Foundation
import FMDB

extension UIProgressView {
    func animate(duration: Double, progress: Float) {
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: {
            self.setProgress(progress, animated: true) }, completion: nil)
    }
}

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension BinaryInteger {
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
}

class TeamDashboardViewController: UIViewController {
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var team1Label: UILabel! 
    @IBOutlet weak var team1WinPercentageLabel: UILabel!
    @IBOutlet weak var team1RecordLabel: UILabel!
    @IBOutlet weak var team1PointsLabel: UILabel!
    @IBOutlet weak var team1DifferentialLabel: UILabel!
    @IBOutlet weak var team2Label: UILabel!
    @IBOutlet weak var team2WinPercentageLabel: UILabel!
    @IBOutlet weak var team2RecordLabel: UILabel!
    @IBOutlet weak var team2PointsLabel: UILabel!
    @IBOutlet weak var team2DifferentialLabel: UILabel!
    @IBOutlet weak var team1ATSLabel: UILabel!
    @IBOutlet weak var team2ATSLabel: UILabel!
    @IBOutlet weak var gamesSampledLabel: UILabel!
    @IBOutlet var teamDashboardView: ShadowedView!
    let numberFormatter = NumberFormatter()
    public let teamDashboardNotification = Notification.Name("NotificationIdentifier")
    var errorIndicator: String = ""
    var progressViewProgress: Float = 0.0
    var queryWinsTeam1: String = ""
    var queryWinsTeam2: String = ""
    var queryLossesTeam1: String = ""
    var queryLossesTeam2: String = ""
    var queryTiesTeam1: String = ""
    var queryTiesTeam2: String = ""
    var queryCoveredTeam1: String = ""
    var queryCoveredTeam2: String = ""
    var queryNotCoveredTeam1: String = ""
    var queryNotCoveredTeam2: String = ""
    var queryPushTeam1: String = ""
    var queryPushTeam2: String = ""
    var team1WinPercentageLabelText: String = ""
    var team2WinPercentageLabelText: String = ""
    var team1RecordLabelText: String = ""
    var team2RecordLabelText: String = ""
    var team1ATSLabelText: String = ""
    var team2ATSLabelText: String = ""
    var team1PointsLabelText: String = ""
    var team2PointsLabelText: String = ""
    var team1DifferentialLabelText: String = ""
    var team2DifferentialLabelText: String = ""
    var team1LabelText: String = ""
    var team2LabelText: String = ""
    var gamesSampledLabelText: String = ""
    var team1DifferentialPrefix: String = ""
    var team2DifferentialPrefix: String = ""
    var gamesSampled: Int = 0
    var winsTeam1: Int = 0
    var lossesTeam1: Int = 0
    var tiesTeam1: Int = 0
    var winsTeam2: Int = 0
    var lossesTeam2: Int = 0
    var tiesTeam2: Int = 0
    var coveredTeam1: Int = 0
    var notCoveredTeam1: Int = 0
    var pushTeam1: Int = 0
    var coveredTeam2: Int = 0
    var notCoveredTeam2: Int = 0
    var pushTeam2: Int = 0
    var dashboardPointsTeam1: Float = 0.0
    var dashboardPointsTeam2: Float = 0.0
    let queryColumnTeam1: String = "TeamNameToday"
    let queryColumnTeam2: String = "OpponentNameToday"
    let queryColumnSpreadTeam1: String = "Spread"
    let queryColumnOverUnder: String = "OverUnder"
    let queryColumnWinningLosingStreakTeam1: String = "StreakValueTeam"
    let queryColumnWinningLosingStreakTeam2: String = "StreakValueOpponent"
    let queryColumnSeasonWinPercentageTeam1: String = "SeasonWinPercentageTeam"
    let queryColumnSeasonWinPercentageTeam2: String = "SeasonWinPercentageOpponent"
    let queryColumnHomeTeam: String = "HomeTeam"
    let queryColumnFavorite: String = "Favorite"
    let queryColumnPlayers: String = "PlayerID"
	let queryColumnplayerOpponent: String = "PlayerID"
    let queryColumnSeason: String = "Season"
    let queryColumnWeek: String = "WeekNumber"
    let queryColumnGameNumber: String = "GameNumberTeam"
    let queryColumnDay: String = "Day"
    let queryColumnStadium: String = "RoofType"
    let queryColumnSurface: String = "SurfaceType"
    let queryColumnTemperature: String = "Temperature"
    let queryColumnTotalPointsTeam1: String = "PointsTeam"
    let queryColumnTotalPointsTeam2: String = "PointsOpponent"
    let queryColumnTouchdownsTeam1: String = "TouchdownsTeam"
    let queryColumnTouchdownsTeam2: String = "TouchdownsOpponent"
    let queryColumnOffensiveTouchdownsTeam1: String = "OffensiveTouchdownsTeam"
    let queryColumnOffensiveTouchdownsTeam2: String = "OffensiveTouchdownsOpponent"
    let queryColumnDefensiveTouchdownsTeam1: String = "DefensiveTouchdownsTeam"
    let queryColumnDefensiveTouchdownsTeam2: String = "DefensiveTouchdownsOpponent"
    let queryColumnTurnoversCommittedTeam1: String = "TurnoversTeam"
    let queryColumnTurnoversCommittedTeam2: String = "TurnoversOpponent"
    let queryColumnPenaltiesCommittedTeam1: String = "PenaltiesTeam"
    let queryColumnPenaltiesCommittedTeam2: String = "PenaltiesOpponent"
    let queryColumnTotalYardsTeam1: String = "TotalYardsTeam"
    let queryColumnTotalYardsTeam2: String = "TotalYardsOpponent"
    let queryColumnPassingYardsTeam1: String = "PassingYardsTeam"
    let queryColumnPassingYardsTeam2: String = "PassingYardsOpponent"
    let queryColumnRushingYardsTeam1: String = "RushingYardsTeam"
    let queryColumnRushingYardsTeam2: String = "RushingYardsOpponent"
    let queryColumnQuarterbackRatingTeam1: String = "QuarterbackRatingTeam"
    let queryColumnQuarterbackRatingTeam2: String = "QuarterbackRatingOpponent"
    let queryColumnTimesSackedTeam1: String = "TimesSackedTeam"
    let queryColumnTimesSackedTeam2: String = "TimesSackedOpponent"
    let queryColumnInterceptionsThrownTeam1: String = "InterceptionsThrownTeam"
    let queryColumnInterceptionsThrownTeam2: String = "InterceptionsThrownOpponent"
    let queryColumnOffensivePlaysTeam1: String = "OffensivePlaysTeam"
    let queryColumnOffensivePlaysTeam2: String = "OffensivePlaysOpponent"
    let queryColumnYardsPerOffensivePlayTeam1: String = "YardsPerOffensivePlayTeam"
    let queryColumnYardsPerOffensivePlayTeam2: String = "YardsPerOffensivePlayOpponent"
    let queryColumnSacksTeam1: String = "TimesSackedOpponent"
    let queryColumnSacksTeam2: String = "TimesSackedTeam"
    let queryColumnInterceptionsTeam1: String = "InterceptionsThrownOpponent"
    let queryColumnInterceptionsTeam2: String = "InterceptionsThrownTeam"
    let queryColumnSafetiesTeam1: String = "SafetiesTeam"
    let queryColumnSafetiesTeam2: String = "SafetiesOpponent"
    let queryColumnDefensivePlaysTeam1: String = "OffensivePlaysOpponent"
    let queryColumnDefensivePlaysTeam2: String = "OffensivePlaysTeam"
    let queryColumnYardsPerDefensivePlayTeam1: String = "YardsPerOffensivePlayOpponent"
    let queryColumnYardsPerDefensivePlayTeam2: String = "YardsPerOffensivePlayTeam"
    let queryColumnExtraPointAttemptsTeam1: String = "ExtraPointAttemptsTeam"
    let queryColumnExtraPointAttemptsTeam2: String = "ExtraPointAttemptsOpponent"
    let queryColumnExtraPointsMadeTeam1: String = "ExtraPointsMadeTeam"
    let queryColumnExtraPointsMadeTeam2: String = "ExtraPointsMadeOpponent"
    let queryColumnFieldGoalAttemptsTeam1: String = "FieldGoalAttemptsTeam"
    let queryColumnFieldGoalAttemptsTeam2: String = "FieldGoalAttemptsOpponent"
    let queryColumnFieldGoalsMadeTeam1: String = "FieldGoalsMadeTeam"
    let queryColumnFieldGoalsMadeTeam2: String = "FieldGoalsMadeOpponent"
    let queryColumnPuntsTeam1: String = "PuntsTeam"
    let queryColumnPuntsTeam2: String = "PuntsOpponent"
    let queryColumnPuntYardsTeam1: String = "PuntYardsTeam"
    let queryColumnPuntYardsTeam2: String = "PuntYardsOpponent"
    var queryOperatorTeam1: String = ""
    var queryOperatorTeam2: String = ""
    var queryOperatorSpreadTeam1: String = ""
    var queryOperatorOverUnder: String = ""
    var queryOperatorWinningLosingStreakTeam1: String = ""
    var queryOperatorWinningLosingStreakTeam2: String = ""
    var queryOperatorSeasonWinPercentageTeam1: String = ""
    var queryOperatorSeasonWinPercentageTeam2: String = ""
    var queryOperatorHomeTeam: String = ""
    var queryOperatorFavorite: String = ""
    var queryOperatorSeason: String = ""
    var queryOperatorWeek: String = ""
    var queryOperatorGameNumber: String = ""
    var queryOperatorDay: String = ""
    var queryOperatorStadium: String = ""
    var queryOperatorSurface: String = ""
    var queryOperatorPlayers: String = ""
	var queryOperatorplayerOpponent: String = ""
    var queryOperatorTemperature: String = ""
    var queryOperatorTotalPointsTeam1: String = ""
    var queryOperatorTotalPointsTeam2: String = ""
    var queryOperatorTouchdownsTeam1: String = ""
    var queryOperatorTouchdownsTeam2: String = ""
    var queryOperatorOffensiveTouchdownsTeam1: String = ""
    var queryOperatorOffensiveTouchdownsTeam2: String = ""
    var queryOperatorDefensiveTouchdownsTeam1: String = ""
    var queryOperatorDefensiveTouchdownsTeam2: String = ""
    var queryOperatorTurnoversCommittedTeam1: String = ""
    var queryOperatorTurnoversCommittedTeam2: String = ""
    var queryOperatorPenaltiesCommittedTeam1: String = ""
    var queryOperatorPenaltiesCommittedTeam2: String = ""
    var queryOperatorTotalYardsTeam1: String = ""
    var queryOperatorTotalYardsTeam2: String = ""
    var queryOperatorPassingYardsTeam1: String = ""
    var queryOperatorPassingYardsTeam2: String = ""
    var queryOperatorRushingYardsTeam1: String = ""
    var queryOperatorRushingYardsTeam2: String = ""
    var queryOperatorQuarterbackRatingTeam1: String = ""
    var queryOperatorQuarterbackRatingTeam2: String = ""
    var queryOperatorTimesSackedTeam1: String = ""
    var queryOperatorTimesSackedTeam2: String = ""
    var queryOperatorInterceptionsThrownTeam1: String = ""
    var queryOperatorInterceptionsThrownTeam2: String = ""
    var queryOperatorOffensivePlaysTeam1: String = ""
    var queryOperatorOffensivePlaysTeam2: String = ""
    var queryOperatorYardsPerOffensivePlayTeam1: String = ""
    var queryOperatorYardsPerOffensivePlayTeam2: String = ""
    var queryOperatorSacksTeam1: String = ""
    var queryOperatorSacksTeam2: String = ""
    var queryOperatorInterceptionsTeam1: String = ""
    var queryOperatorInterceptionsTeam2: String = ""
    var queryOperatorSafetiesTeam1: String = ""
    var queryOperatorSafetiesTeam2: String = ""
    var queryOperatorDefensivePlaysTeam1: String = ""
    var queryOperatorDefensivePlaysTeam2: String = ""
    var queryOperatorYardsPerDefensivePlayTeam1: String = ""
    var queryOperatorYardsPerDefensivePlayTeam2: String = ""
    var queryOperatorExtraPointAttemptsTeam1: String = ""
    var queryOperatorExtraPointAttemptsTeam2: String = ""
    var queryOperatorExtraPointsMadeTeam1: String = ""
    var queryOperatorExtraPointsMadeTeam2: String = ""
    var queryOperatorFieldGoalAttemptsTeam1: String = ""
    var queryOperatorFieldGoalAttemptsTeam2: String = ""
    var queryOperatorFieldGoalsMadeTeam1: String = ""
    var queryOperatorFieldGoalsMadeTeam2: String = ""
    var queryOperatorPuntsTeam1: String = ""
    var queryOperatorPuntsTeam2: String = ""
    var queryOperatorPuntYardsTeam1: String = ""
    var queryOperatorPuntYardsTeam2: String = ""
    var queryValueTeam1: String = ""
    var queryValueTeam2: String = ""
    var queryValueSpreadTeam1: String = ""
    var queryValueOverUnder: String = ""
    var queryValueWinningLosingStreakTeam1: String = ""
    var queryValueWinningLosingStreakTeam2: String = ""
    var queryValueSeasonWinPercentageTeam1: String = ""
    var queryValueSeasonWinPercentageTeam2: String = ""
    var queryValueHomeTeam: String = ""
    var queryValueFavorite: String = ""
    var queryValuePlayers: String = ""
	var queryValueplayerOpponent: String = ""
    var queryValueSeason: String = ""
    var queryValueWeek: String = ""
    var queryValueGameNumber: String = ""
    var queryValueDay: String = ""
    var queryValueStadium: String = ""
    var queryValueSurface: String = ""
    var queryValueTemperature: String = ""
    var queryValueTotalPointsTeam1: String = ""
    var queryValueTotalPointsTeam2: String = ""
    var queryValueTouchdownsTeam1: String = ""
    var queryValueTouchdownsTeam2: String = ""
    var queryValueOffensiveTouchdownsTeam1: String = ""
    var queryValueOffensiveTouchdownsTeam2: String = ""
    var queryValueDefensiveTouchdownsTeam1: String = ""
    var queryValueDefensiveTouchdownsTeam2: String = ""
    var queryValueTurnoversCommittedTeam1: String = ""
    var queryValueTurnoversCommittedTeam2: String = ""
    var queryValuePenaltiesCommittedTeam1: String = ""
    var queryValuePenaltiesCommittedTeam2: String = ""
    var queryValueTotalYardsTeam1: String = ""
    var queryValueTotalYardsTeam2: String = ""
    var queryValuePassingYardsTeam1: String = ""
    var queryValuePassingYardsTeam2: String = ""
    var queryValueRushingYardsTeam1: String = ""
    var queryValueRushingYardsTeam2: String = ""
    var queryValueQuarterbackRatingTeam1: String = ""
    var queryValueQuarterbackRatingTeam2: String = ""
    var queryValueTimesSackedTeam1: String = ""
    var queryValueTimesSackedTeam2: String = ""
    var queryValueInterceptionsThrownTeam1: String = ""
    var queryValueInterceptionsThrownTeam2: String = ""
    var queryValueOffensivePlaysTeam1: String = ""
    var queryValueOffensivePlaysTeam2: String = ""
    var queryValueYardsPerOffensivePlayTeam1: String = ""
    var queryValueYardsPerOffensivePlayTeam2: String = ""
    var queryValueSacksTeam1: String = ""
    var queryValueSacksTeam2: String = ""
    var queryValueInterceptionsTeam1: String = ""
    var queryValueInterceptionsTeam2: String = ""
    var queryValueSafetiesTeam1: String = ""
    var queryValueSafetiesTeam2: String = ""
    var queryValueDefensivePlaysTeam1: String = ""
    var queryValueDefensivePlaysTeam2: String = ""
    var queryValueYardsPerDefensivePlayTeam1: String = ""
    var queryValueYardsPerDefensivePlayTeam2: String = ""
    var queryValueExtraPointAttemptsTeam1: String = ""
    var queryValueExtraPointAttemptsTeam2: String = ""
    var queryValueExtraPointsMadeTeam1: String = ""
    var queryValueExtraPointsMadeTeam2: String = ""
    var queryValueFieldGoalAttemptsTeam1: String = ""
    var queryValueFieldGoalAttemptsTeam2: String = ""
    var queryValueFieldGoalsMadeTeam1: String = ""
    var queryValueFieldGoalsMadeTeam2: String = ""
    var queryValuePuntsTeam1: String = ""
    var queryValuePuntsTeam2: String = ""
    var queryValuePuntYardsTeam1: String = ""
    var queryValuePuntYardsTeam2: String = ""
    var queryStringTeam1: String = ""
    var queryStringTeam2: String = ""
    var queryStringSpreadTeam1: String = ""
    var queryStringOverUnder: String = ""
    var queryStringWinningLosingStreakTeam1: String = ""
    var queryStringWinningLosingStreakTeam2: String = ""
    var queryStringSeasonWinPercentageTeam1: String = ""
    var queryStringSeasonWinPercentageTeam2: String = ""
    var queryStringHomeTeam: String = ""
    var queryStringFavorite: String = ""
    var queryStringPlayers: String = ""
	var queryStringplayerOpponent: String = ""
    var queryStringSeason: String = ""
    var queryStringWeek: String = ""
    var queryStringGameNumber: String = ""
    var queryStringDay: String = ""
    var queryStringStadium: String = ""
    var queryStringSurface: String = ""
    var queryStringTemperature: String = ""
    var queryStringTotalPointsTeam1: String = ""
    var queryStringTotalPointsTeam2: String = ""
    var queryStringTouchdownsTeam1: String = ""
    var queryStringTouchdownsTeam2: String = ""
    var queryStringOffensiveTouchdownsTeam1: String = ""
    var queryStringOffensiveTouchdownsTeam2: String = ""
    var queryStringDefensiveTouchdownsTeam1: String = ""
    var queryStringDefensiveTouchdownsTeam2: String = ""
    var queryStringTurnoversCommittedTeam1: String = ""
    var queryStringTurnoversCommittedTeam2: String = ""
    var queryStringPenaltiesCommittedTeam1: String = ""
    var queryStringPenaltiesCommittedTeam2: String = ""
    var queryStringTotalYardsTeam1: String = ""
    var queryStringTotalYardsTeam2: String = ""
    var queryStringPassingYardsTeam1: String = ""
    var queryStringPassingYardsTeam2: String = ""
    var queryStringRushingYardsTeam1: String = ""
    var queryStringRushingYardsTeam2: String = ""
    var queryStringQuarterbackRatingTeam1: String = ""
    var queryStringQuarterbackRatingTeam2: String = ""
    var queryStringTimesSackedTeam1: String = ""
    var queryStringTimesSackedTeam2: String = ""
    var queryStringInterceptionsThrownTeam1: String = ""
    var queryStringInterceptionsThrownTeam2: String = ""
    var queryStringOffensivePlaysTeam1: String = ""
    var queryStringOffensivePlaysTeam2: String = ""
    var queryStringYardsPerOffensivePlayTeam1: String = ""
    var queryStringYardsPerOffensivePlayTeam2: String = ""
    var queryStringSacksTeam1: String = ""
    var queryStringSacksTeam2: String = ""
    var queryStringInterceptionsTeam1: String = ""
    var queryStringInterceptionsTeam2: String = ""
    var queryStringSafetiesTeam1: String = ""
    var queryStringSafetiesTeam2: String = ""
    var queryStringDefensivePlaysTeam1: String = ""
    var queryStringDefensivePlaysTeam2: String = ""
    var queryStringYardsPerDefensivePlayTeam1: String = ""
    var queryStringYardsPerDefensivePlayTeam2: String = ""
    var queryStringExtraPointAttemptsTeam1: String = ""
    var queryStringExtraPointAttemptsTeam2: String = ""
    var queryStringExtraPointsMadeTeam1: String = ""
    var queryStringExtraPointsMadeTeam2: String = ""
    var queryStringFieldGoalAttemptsTeam1: String = ""
    var queryStringFieldGoalAttemptsTeam2: String = ""
    var queryStringFieldGoalsMadeTeam1: String = ""
    var queryStringFieldGoalsMadeTeam2: String = ""
    var queryStringPuntsTeam1: String = ""
    var queryStringPuntsTeam2: String = ""
    var queryStringPuntYardsTeam1: String = ""
    var queryStringPuntYardsTeam2: String = ""
    var playersQuery: String = ""
	var playerOpponentQuery: String = ""
    var queryFromFilters: String = "GameCount IN (SELECT MIN(GameCount) FROM TeamGameData GROUP BY Date_ATeam_vs_ZTeam)"
    var queryFromFiltersPrefix: String = ""
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TeamDashboardVC viewDidLoad()")
            NotificationCenter.default.addObserver(self, selector: #selector(TeamDashboardViewController.updateTeamDashboardValues), name: NSNotification.Name(rawValue: "teamDashboardNotification"), object: nil)
            self.progressView.addObserver(self, forKeyPath: "progress", options: [.old, .new], context: nil)
            numberFormatter.groupingSeparator = nil
            numberFormatter.numberStyle = .decimal
            numberFormatter.maximumFractionDigits = 0
            progressView.clipsToBounds = true
            errorIndicator = "No"
            teamDashboardView.setDefaultElevation()
            teamDashboardView.backgroundColor = dashboardGreyColor

            queryWinsTeam1 = queryFromFilters + " AND WinLoseTieValueTeam = 1.0"
            queryLossesTeam1 = queryFromFilters + " AND WinLoseTieValueTeam = 0.0"
            queryTiesTeam1 = queryFromFilters + " AND WinLoseTieValueTeam = 0.5"
            queryWinsTeam2 = queryFromFilters + " AND WinLoseTieValueOpponent = 1.0"
            queryLossesTeam2 = queryFromFilters + " AND WinLoseTieValueOpponent = 0.0"
            queryTiesTeam2 = queryFromFilters + " AND WinLoseTieValueOpponent = 0.5"
            queryCoveredTeam1 = queryFromFilters + " AND SpreadVsLine = 'covered'"
            queryNotCoveredTeam1 = queryFromFilters + " AND SpreadVsLine = 'not covered'"
            queryPushTeam1 = queryFromFilters + " AND SpreadVsLine = 'push'"
            
            queryFromFilters = "GameCount IN (SELECT MIN(GameCount) FROM TeamGameData GROUP BY Date_ATeam_vs_ZTeam)"
            //print("queryFromFilters: " + queryFromFilters)
            let pathStatsDatabase = Bundle.main.path(forResource: "StatsDatabase", ofType:"db")
            let db = FMDatabase(path: pathStatsDatabase)
            guard db.open() else {
                print("Unable to open database 'StatsDatabase'")
                return
            }
            do {
                let executeGamesSampled = try db.executeQuery("SELECT COUNT(*) FROM TeamGameData WHERE \(queryFromFilters)", values: nil)
                while executeGamesSampled.next() {
                    gamesSampled = executeGamesSampled.long(forColumnIndex: 0)
                    print("SELECT COUNT(*) FROM TeamGameData WHERE \(queryFromFilters)")
                    //print("gamesSampled: " + String(gamesSampled))
                }
            } catch let error as NSError {
                errorIndicator = "Yes"
                print("Query failed: \(error.localizedDescription)")
            }
            do {
                let executeWinsTeam1 = try db.executeQuery("SELECT COUNT(*) FROM TeamGameData WHERE \(queryWinsTeam1)", values: nil)
                while executeWinsTeam1.next() {
                    winsTeam1 = executeWinsTeam1.long(forColumnIndex: 0)
                    //print("winsTeam1: " + String(winsTeam1))
                    print("SELECT COUNT(*) FROM TeamGameData WHERE" + queryWinsTeam1)
                }
            } catch let error as NSError {
                errorIndicator = "Yes"
                print("Query failed: \(error.localizedDescription)")
            }
            do {
                let executeLossesTeam1 = try db.executeQuery("SELECT COUNT(*) FROM TeamGameData WHERE \(queryLossesTeam1)", values: nil)
                while executeLossesTeam1.next() {
                    lossesTeam1 = executeLossesTeam1.long(forColumnIndex: 0)
                    //print("lossesTeam1: " + String(lossesTeam1))
                    print("SELECT COUNT(*) FROM TeamGameData WHERE" + queryLossesTeam1)
                }
            } catch let error as NSError {
                errorIndicator = "Yes"
                print("Query failed: \(error.localizedDescription)")
            }
            do {
                let executeTiesTeam1 = try db.executeQuery("SELECT COUNT(*) FROM TeamGameData WHERE \(queryTiesTeam1)", values: nil)
                while executeTiesTeam1.next() {
                    tiesTeam1 = executeTiesTeam1.long(forColumnIndex: 0)
                    //print("tiesTeam1: " + String(tiesTeam1))
                }
            } catch let error as NSError {
                errorIndicator = "Yes"
                print("Query failed: \(error.localizedDescription)")
            }
            do {
                let executeWinsTeam2 = try db.executeQuery("SELECT COUNT(*) FROM TeamGameData WHERE \(queryWinsTeam2)", values: nil)
                while executeWinsTeam2.next() {
                    winsTeam2 = executeWinsTeam2.long(forColumnIndex: 0)
                    //print("winsTeam2: " + String(winsTeam2))
                }
            } catch let error as NSError {
                errorIndicator = "Yes"
                print("Query failed: \(error.localizedDescription)")
            }
            do {
                let executeLossesTeam2 = try db.executeQuery("SELECT COUNT(*) FROM TeamGameData WHERE \(queryLossesTeam2)", values: nil)
                while executeLossesTeam2.next() {
                    lossesTeam2 = executeLossesTeam2.long(forColumnIndex: 0)
                    //print("lossesTeam2: " + String(lossesTeam2))
                }
            } catch let error as NSError {
                errorIndicator = "Yes"
                print("Query failed: \(error.localizedDescription)")
            }
            do {
                let executeTiesTeam2 = try db.executeQuery("SELECT COUNT(*) FROM TeamGameData WHERE \(queryTiesTeam2)", values: nil)
                while executeTiesTeam2.next() {
                    tiesTeam2 = executeTiesTeam2.long(forColumnIndex: 0)
                    //print("tiesTeam2: " + String(tiesTeam2))
                }
            } catch let error as NSError {
                errorIndicator = "Yes"
                print("Query failed: \(error.localizedDescription)")
            }
            do {
                let executePointsTeam1 = try db.executeQuery("SELECT AVG(pointsTeam) FROM TeamGameData WHERE \(queryFromFilters)", values: nil)
                while executePointsTeam1.next() {
                    dashboardPointsTeam1 = Float(executePointsTeam1.double(forColumnIndex: 0))
                    //print("dashboardPointsTeam1: " + String(dashboardPointsTeam1))
                }
            } catch let error as NSError {
                errorIndicator = "Yes"
                print("Query failed: \(error.localizedDescription)")
            }
            do {
                let executePointsTeam2 = try db.executeQuery("SELECT AVG(pointsOpponent) FROM TeamGameData WHERE \(queryFromFilters)", values: nil)
                while executePointsTeam2.next() {
                    dashboardPointsTeam2 = Float(executePointsTeam2.double(forColumnIndex: 0))
                    //print("dashboardPointsTeam2: " + String(dashboardPointsTeam2))
                }
            } catch let error as NSError {
                errorIndicator = "Yes"
                print("Query failed: \(error.localizedDescription)")
            }
            do {
                let executeCoveredTeam1 = try db.executeQuery("SELECT COUNT(*) FROM TeamGameData WHERE \(queryCoveredTeam1)", values: nil)
                while executeCoveredTeam1.next() {
                    coveredTeam1 = executeCoveredTeam1.long(forColumnIndex: 0)
                    notCoveredTeam2 = executeCoveredTeam1.long(forColumnIndex: 0)
                }
            } catch let error as NSError {
                errorIndicator = "Yes"
                print("Query failed: \(error.localizedDescription)")
            }
            do {
                let executeNotCoveredTeam1 = try db.executeQuery("SELECT COUNT(*) FROM TeamGameData WHERE \(queryNotCoveredTeam1)", values: nil)
                while executeNotCoveredTeam1.next() {
                    notCoveredTeam1 = executeNotCoveredTeam1.long(forColumnIndex: 0)
                    coveredTeam2 = executeNotCoveredTeam1.long(forColumnIndex: 0)
                }
            } catch let error as NSError {
                errorIndicator = "Yes"
                print("Query failed: \(error.localizedDescription)")
            }
            do {
                let executePushTeam1 = try db.executeQuery("SELECT COUNT(*) FROM TeamGameData WHERE \(queryPushTeam1)", values: nil)
                while executePushTeam1.next() {
                    pushTeam1 = executePushTeam1.long(forColumnIndex: 0)
                    pushTeam2 = executePushTeam1.long(forColumnIndex: 0)
                }
            } catch let error as NSError {
                errorIndicator = "Yes"
                print("Query failed: \(error.localizedDescription)")
            }
            
            if dashboardPointsTeam1 > dashboardPointsTeam2 {
                team1DifferentialPrefix = "- "
                team2DifferentialPrefix = "+ "
            } else if dashboardPointsTeam1 < dashboardPointsTeam2 {
                team1DifferentialPrefix = "+ "
                team2DifferentialPrefix = "- "
            }
            progressViewProgress = Float((Double(winsTeam1) + (0.5 * (Double(tiesTeam1))))/Double(gamesSampled))
            team1LabelText = "TEAM"
            team2LabelText = "OPPONENT"
            team1WinPercentageLabelText = String(format: "%.1f%%", (100.00 * ((Double(winsTeam1) + (0.5 * (Double(tiesTeam1))))/Double(gamesSampled))))
            team2WinPercentageLabelText = String(format: "%.1f%%", (100.00 * ((Double(winsTeam2) + (0.5 * (Double(tiesTeam2))))/Double(gamesSampled))))
            team1RecordLabelText = "(" + winsTeam1.formattedWithSeparator + "-" + lossesTeam1.formattedWithSeparator + "-" + tiesTeam1.formattedWithSeparator + ")"
            team2RecordLabelText = "(" + winsTeam2.formattedWithSeparator + "-" + lossesTeam2.formattedWithSeparator + "-" + tiesTeam2.formattedWithSeparator + ")"
            team1ATSLabelText = "(" + coveredTeam1.formattedWithSeparator + "-" + notCoveredTeam1.formattedWithSeparator + "-" + pushTeam1.formattedWithSeparator + ")"
            team2ATSLabelText = "(" + coveredTeam2.formattedWithSeparator + "-" + notCoveredTeam2.formattedWithSeparator + "-" + pushTeam2.formattedWithSeparator + ")"
            team1PointsLabelText = String(format: "%.1f", dashboardPointsTeam1)
            team2PointsLabelText = String(format: "%.1f", dashboardPointsTeam2)
            team1DifferentialLabelText = team1DifferentialPrefix + String(format: "%.1f", (abs((dashboardPointsTeam2 - dashboardPointsTeam1))))
            team2DifferentialLabelText = team2DifferentialPrefix + String(format: "%.1f", (abs((dashboardPointsTeam1 - dashboardPointsTeam2))))
            gamesSampledLabelText = numberFormatter.string(from: NSNumber(value: gamesSampled))!
            gamesSampledLabel.text = gamesSampledLabelText + " GAMES SAMPLED"
            team1WinPercentageLabel.text = team1WinPercentageLabelText
            team2WinPercentageLabel.text = team2WinPercentageLabelText
            team1RecordLabel.text = team1RecordLabelText
            team2RecordLabel.text = team2RecordLabelText
            team1ATSLabel.text = team1ATSLabelText
            team2ATSLabel.text = team2ATSLabelText
            team1PointsLabel.text = team1PointsLabelText
            team2PointsLabel.text = team2PointsLabelText
            team1DifferentialLabel.text = team1DifferentialLabelText
            team2DifferentialLabel.text = team2DifferentialLabelText
            progressView.progress = progressViewProgress
            team1Label.text = team1LabelText
            team2Label.text = team2LabelText
            //print("progressViewProgress: " + "\(progressViewProgress)")
            if errorIndicator == "Yes" {
                print("errorIndicator = Yes")
            } else {
                print("")
            }
            db.close()
            //print("TeamDashboardViewController teamPlayerIndicator: ")
            //print(teamPlayerIndicator)
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "progress" {
            if let newValue = change?[.newKey] as? NSNumber {
                if let oldValue = change?[.oldKey] as? NSNumber {
                    if newValue.floatValue != oldValue.floatValue {
                        progressView.setProgress(0.0, animated: true)
                        progressView.setProgress(progressViewProgress, animated: true)
                    } else {
                        progressView.animate(duration: 1.0, progress: progressViewProgress)
                    }
                }
            }
            
        } else {
            print("observeValue(): Wrong keyPath")
        }
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    @objc func updateTeamDashboardValues() {
        print("updateTeamDashboardValues()")
        //print("overUnderRangeSliderLowerValue: ")
        //print(spreadRangeSliderLowerValue)
        
        queryOperatorTeam1 = " = "
        
        if clearMultiSelectIndicator == "TEAM" {
            queryStringTeam1 = ""
        } else {
            if team1ListValue == ["-10000"] || team1ListValue == [] || team1ListValue == [""] {
                team1LabelText = "TEAM"
                queryStringTeam1 = ""
            } else {
                queryValueTeam1 = "'" + team1ListValue[0] + "'"
                team1LabelText = team1ListValue[0]
                var team1LabelTextArray = team1LabelText.components(separatedBy: " ")
                let team1LabelTextArrayLength = team1LabelTextArray.count
                team1LabelTextArray.remove(at: team1LabelTextArrayLength - 1)
                team1LabelText = team1LabelTextArray.joined(separator: " ")
                queryStringTeam1 = queryColumnTeam1 + queryOperatorTeam1 + queryValueTeam1
            }
        }
        
        if clearMultiSelectIndicator == "OPPONENT" {
            queryStringTeam2 = ""
        } else {
            if team2ListValue == ["-10000"] || team2ListValue == [] || team2ListValue.count == 32 || team2ListValue == [""] {
                team2LabelText = "OPPONENT"
                queryStringTeam2 = ""
            } else {
                if team2ListValue.count > 1 || team2OperatorValue == "≠" {
                    team2LabelText = "OPPONENT"
                } else {
                    team2LabelText = team2ListValue[0]
                    var team2LabelTextArray = team2LabelText.components(separatedBy: " ")
                    let team2LabelTextArrayLength = team2LabelTextArray.count
                    team2LabelTextArray.remove(at: team2LabelTextArrayLength - 1)
                    team2LabelText = team2LabelTextArray.joined(separator: " ")
                }
                if team2OperatorValue == "=" {
                    queryOperatorTeam2 = " IN "
                } else if team2OperatorValue == "≠" {
                    queryOperatorTeam2 = " NOT IN "
                }
                queryValueTeam2 = "('" + team2ListValue.joined(separator: "', '") + "')"
                queryStringTeam2 = " AND " + queryColumnTeam2 + queryOperatorTeam2 + queryValueTeam2
            }
        }
        
        if clearMultiSelectIndicator == "TEAM: PLAYERS" {
            queryStringPlayers = ""
        } else {
            if playerListValue == ["-10000"] || playerListValue == [] || playerListValue == [""] {
                queryStringPlayers = ""
            } else {
                playerIDsListValue.removeAll()
                for player in playerListValue {
                    playerIDsListValue.append(playerDictionary[player]!)
                }
                queryValuePlayers = "('" + playerIDsListValue.joined(separator: "', '") + "')"
                playersQuery = "SELECT TeamDateUniqueID FROM PlayerGameLogs WHERE PlayerID IN " + queryValuePlayers
                if playerOperatorValue == "=" {
                    queryOperatorPlayers = " IN "
                    queryStringPlayers = " AND TeamDateUniqueID" + queryOperatorPlayers + "(" + playersQuery + ")"
                } else if playerOperatorValue == "≠" {
                    queryOperatorPlayers = " NOT IN "
                    queryStringPlayers = " AND TeamDateUniqueID" + queryOperatorPlayers + "(" + playersQuery + ") AND OpponentDateUniqueID" + queryOperatorPlayers + "(" + playersQuery + ") "
                }
                print("queryStringPlayers: " + queryStringPlayers)
            }
        }
		
        if clearMultiSelectIndicator == "OPPONENT: PLAYERS" {
            queryStringplayerOpponent = ""
        } else {
            if playerOpponentListValue == ["-10000"] || playerOpponentListValue == [] || playerOpponentListValue == [""] {
                queryStringplayerOpponent = ""
            } else {
                playerOpponentIDsListValue.removeAll()
                for playerOpponent in playerOpponentListValue {
                    playerOpponentIDsListValue.append(playerOpponentDictionary[playerOpponent]!)
                }
                queryValueplayerOpponent = "('" + playerOpponentIDsListValue.joined(separator: "', '") + "')"
                playerOpponentQuery = "SELECT TeamDateUniqueID FROM PlayerGameLogs WHERE PlayerID IN " + queryValueplayerOpponent
                if playerOpponentOperatorValue == "=" {
                    queryOperatorplayerOpponent = " IN "
                    queryStringplayerOpponent = " AND OpponentDateUniqueID" + queryOperatorplayerOpponent + "(" + playerOpponentQuery + ")"
                } else if playerOpponentOperatorValue == "≠" {
                    queryOperatorplayerOpponent = " NOT IN "
                    queryStringplayerOpponent = " AND OpponentDateUniqueID" + queryOperatorplayerOpponent + "(" + playerOpponentQuery + ") AND TeamDateUniqueID" + queryOperatorplayerOpponent + "(" + playerOpponentQuery + ") "
                }
                print("queryStringPlayers: " + queryStringPlayers)
            }
        }
        
        //print("spreadSliderFormValue: ")
        //print(spreadSliderFormValue)
        if clearSliderIndicator == "TEAM: SPREAD" || spreadSliderFormValue == "-30.0 & 30.0" {
            queryStringSpreadTeam1 = ""
        } else {
            if spreadOperatorValue == "< >" {
                queryOperatorSpreadTeam1 = " BETWEEN "
                let queryLowerValueSpreadTeam1 = spreadRangeSliderLowerValue
                let queryUpperValueSpreadTeam1 = spreadRangeSliderUpperValue
                queryValueSpreadTeam1 = String(queryLowerValueSpreadTeam1) + " AND " + String(queryUpperValueSpreadTeam1)
                queryStringSpreadTeam1 = " AND " + queryColumnSpreadTeam1 + queryOperatorSpreadTeam1 + queryValueSpreadTeam1
            } else {
                if spreadSliderValue == -10000 {
                    queryStringSpreadTeam1 = ""
                } else {
                    if spreadOperatorValue == "≠" {
                        queryOperatorSpreadTeam1 = " != "
                    } else {
                        queryOperatorSpreadTeam1 = " " + spreadOperatorValue + " "
                    }
                    queryValueSpreadTeam1 = String(spreadSliderValue)
                    queryStringSpreadTeam1 = " AND LENGTH(\(queryColumnSpreadTeam1)) !=0 AND " + queryColumnSpreadTeam1 + queryOperatorSpreadTeam1 + queryValueSpreadTeam1
                }
            }
        }
        
        //print("overUnderSliderFormValue: ")
        //print(overUnderSliderFormValue)
        if clearSliderIndicator == "OVER/UNDER" || overUnderSliderFormValue == "0.0 & 75.0" {
            queryStringOverUnder = ""
        } else {
            if overUnderOperatorValue == "< >" {
                queryOperatorOverUnder = " BETWEEN "
                let queryLowerValueOverUnder = overUnderRangeSliderLowerValue
                let queryUpperValueOverUnder = overUnderRangeSliderUpperValue
                queryValueOverUnder = String(queryLowerValueOverUnder) + " AND " + String(queryUpperValueOverUnder)
                queryStringOverUnder = " AND " + queryColumnOverUnder + queryOperatorOverUnder + queryValueOverUnder
            } else {
                if overUnderSliderValue == -10000 {
                    queryStringOverUnder = ""
                } else {
                    if overUnderOperatorValue == "≠" {
                        queryOperatorOverUnder = " != "
                    } else {
                        queryOperatorOverUnder = " " + overUnderOperatorValue + " "
                    }
                    queryValueOverUnder = String(overUnderSliderValue)
                    queryStringOverUnder = " AND LENGTH(\(queryColumnOverUnder)) !=0 AND " + queryColumnOverUnder + queryOperatorOverUnder + queryValueOverUnder
                }
            }
        }

        //print("winningLosingStreakTeam1SliderFormValue: ")
        //print(winningLosingStreakTeam1SliderFormValue)
        if clearSliderIndicator == "TEAM: STREAK" || winningLosingStreakTeam1SliderFormValue == "-16 & 20" {
            queryStringWinningLosingStreakTeam1 = ""
        } else {
            if winningLosingStreakTeam1OperatorValue == "< >" {
                queryOperatorWinningLosingStreakTeam1 = " BETWEEN "
                let queryLowerValueWinningLosingStreakTeam1 = winningLosingStreakTeam1RangeSliderLowerValue
                let queryUpperValueWinningLosingStreakTeam1 = winningLosingStreakTeam1RangeSliderUpperValue
                queryValueWinningLosingStreakTeam1 = String(queryLowerValueWinningLosingStreakTeam1) + " AND " + String(queryUpperValueWinningLosingStreakTeam1)
                queryStringWinningLosingStreakTeam1 = " AND " + queryColumnWinningLosingStreakTeam1 + queryOperatorWinningLosingStreakTeam1 + queryValueWinningLosingStreakTeam1
            } else {
                if winningLosingStreakTeam1SliderValue == -10000 {
                    queryStringWinningLosingStreakTeam1 = ""
                } else {
                    if winningLosingStreakTeam1OperatorValue == "≠" {
                        queryOperatorWinningLosingStreakTeam1 = " != "
                    } else {
                        queryOperatorWinningLosingStreakTeam1 = " " + winningLosingStreakTeam1OperatorValue + " "
                    }
                    queryValueWinningLosingStreakTeam1 = String(winningLosingStreakTeam1SliderValue)
                    queryStringWinningLosingStreakTeam1 = " AND LENGTH(\(queryColumnWinningLosingStreakTeam1)) !=0 AND " + queryColumnWinningLosingStreakTeam1 + queryOperatorWinningLosingStreakTeam1 + queryValueWinningLosingStreakTeam1
                }
            }
        }

        //print("winningLosingStreakTeam2SliderFormValue: ")
        //print(winningLosingStreakTeam2SliderFormValue)
        if clearSliderIndicator == "OPPONENT: STREAK" || winningLosingStreakTeam2SliderFormValue == "-16 & 20" {
            queryStringWinningLosingStreakTeam2 = ""
        } else {
            if winningLosingStreakTeam2OperatorValue == "< >" {
                queryOperatorWinningLosingStreakTeam2 = " BETWEEN "
                let queryLowerValueWinningLosingStreakTeam2 = winningLosingStreakTeam2RangeSliderLowerValue
                let queryUpperValueWinningLosingStreakTeam2 = winningLosingStreakTeam2RangeSliderUpperValue
                queryValueWinningLosingStreakTeam2 = String(queryLowerValueWinningLosingStreakTeam2) + " AND " + String(queryUpperValueWinningLosingStreakTeam2)
                queryStringWinningLosingStreakTeam2 = " AND " + queryColumnWinningLosingStreakTeam2 + queryOperatorWinningLosingStreakTeam2 + queryValueWinningLosingStreakTeam2
            } else {
                if winningLosingStreakTeam2SliderValue == -10000 {
                    queryStringWinningLosingStreakTeam2 = ""
                } else {
                    if winningLosingStreakTeam2OperatorValue == "≠" {
                        queryOperatorWinningLosingStreakTeam2 = " != "
                    } else {
                        queryOperatorWinningLosingStreakTeam2 = " " + winningLosingStreakTeam2OperatorValue + " "
                    }
                    queryValueWinningLosingStreakTeam2 = String(winningLosingStreakTeam2SliderValue)
                    queryStringWinningLosingStreakTeam2 = " AND LENGTH(\(queryColumnWinningLosingStreakTeam2)) !=0 AND " + queryColumnWinningLosingStreakTeam2 + queryOperatorWinningLosingStreakTeam2 + queryValueWinningLosingStreakTeam2
                }
            }
        }
        
        //print("seasonWinPercentageTeam1SliderFormValue: ")
        //print(seasonWinPercentageTeam1SliderFormValue)
        if clearSliderIndicator == "TEAM: SEASON WIN %" || seasonWinPercentageTeam1SliderFormValue == "0% & 100%" {
            queryStringSeasonWinPercentageTeam1 = ""
        } else {
            if seasonWinPercentageTeam1OperatorValue == "< >" {
                queryOperatorSeasonWinPercentageTeam1 = " BETWEEN "
                let queryLowerValueSeasonWinPercentageTeam1 = (Double(seasonWinPercentageTeam1RangeSliderLowerValue) / 100.00)
                let queryUpperValueSeasonWinPercentageTeam1 = (Double(seasonWinPercentageTeam1RangeSliderUpperValue) / 100.00)
                queryValueSeasonWinPercentageTeam1 = String(queryLowerValueSeasonWinPercentageTeam1) + " AND " + String(queryUpperValueSeasonWinPercentageTeam1)
                queryStringSeasonWinPercentageTeam1 = " AND " + queryColumnSeasonWinPercentageTeam1 + queryOperatorSeasonWinPercentageTeam1 + queryValueSeasonWinPercentageTeam1
            } else {
                if seasonWinPercentageTeam1SliderValue == -10000 {
                    queryStringSeasonWinPercentageTeam1 = ""
                } else {
                    if seasonWinPercentageTeam1OperatorValue == "≠" {
                        queryOperatorSeasonWinPercentageTeam1 = " != "
                    } else {
                        queryOperatorSeasonWinPercentageTeam1 = " " + seasonWinPercentageTeam1OperatorValue + " "
                    }
                    queryValueSeasonWinPercentageTeam1 = String(seasonWinPercentageTeam1SliderValue)
                    queryStringSeasonWinPercentageTeam1 = " AND LENGTH(\(queryColumnSeasonWinPercentageTeam1)) !=0 AND " + queryColumnSeasonWinPercentageTeam1 + queryOperatorSeasonWinPercentageTeam1 + String((Double(queryValueSeasonWinPercentageTeam1)! / 100.00))
                }
            }
        }
      
        if clearSliderIndicator == "OPPONENT: SEASON WIN %" || seasonWinPercentageTeam2SliderFormValue == "0% & 100%" {
            queryStringSeasonWinPercentageTeam2 = ""
        } else {
            if seasonWinPercentageTeam2OperatorValue == "< >" {
                queryOperatorSeasonWinPercentageTeam2 = " BETWEEN "
                let queryLowerValueSeasonWinPercentageTeam2 = (Double(seasonWinPercentageTeam2RangeSliderLowerValue) / 100.00)
                let queryUpperValueSeasonWinPercentageTeam2 = (Double(seasonWinPercentageTeam2RangeSliderUpperValue) / 100.00)
                queryValueSeasonWinPercentageTeam2 = String(queryLowerValueSeasonWinPercentageTeam2) + " AND " + String(queryUpperValueSeasonWinPercentageTeam2)
                queryStringSeasonWinPercentageTeam2 = " AND " + queryColumnSeasonWinPercentageTeam2 + queryOperatorSeasonWinPercentageTeam2 + queryValueSeasonWinPercentageTeam2
            } else {
                if seasonWinPercentageTeam2SliderValue == -10000 {
                    queryStringSeasonWinPercentageTeam2 = ""
                } else {
                    if seasonWinPercentageTeam2OperatorValue == "≠" {
                        queryOperatorSeasonWinPercentageTeam2 = " != "
                    } else {
                        queryOperatorSeasonWinPercentageTeam2 = " " + seasonWinPercentageTeam2OperatorValue + " "
                    }
                    queryValueSeasonWinPercentageTeam2 = String(seasonWinPercentageTeam2SliderValue)
                    queryStringSeasonWinPercentageTeam2 = " AND LENGTH(\(queryColumnSeasonWinPercentageTeam2)) !=0 AND " + queryColumnSeasonWinPercentageTeam2 + queryOperatorSeasonWinPercentageTeam2 + String((Double(queryValueSeasonWinPercentageTeam2)! / 100.00))
                }
            }
        }
		
        if clearMultiSelectIndicator == "HOME TEAM" {
            queryStringHomeTeam = ""
        } else {
            if homeTeamListValue == ["-10000"] || homeTeamListValue == [] || homeTeamListValue.count == 3 {
                queryStringHomeTeam = ""
            } else {
                queryOperatorHomeTeam = " IN "
                let homeTeamDictionary = [
                    "TEAM" : "TEAM 1",
                    "OPPONENT" : "TEAM 2",
                    "NEUTRAL" : "NEUTRAL"
                ]
                var homeTeamListValuesMapped = [String]()
                for homeTeam in homeTeamListValue {
                    homeTeamListValuesMapped.append(homeTeamDictionary[homeTeam]!)
                }
                queryValueHomeTeam = "('" + homeTeamListValuesMapped.joined(separator: "', '") + "')"
                queryStringHomeTeam = " AND " + queryColumnHomeTeam + queryOperatorHomeTeam + queryValueHomeTeam
            }
        }
        
        if clearMultiSelectIndicator == "FAVORITE" {
            queryStringFavorite = ""
        } else {
            if favoriteListValue == ["-10000"] || favoriteListValue == [] || favoriteListValue.count == 3 {
                queryStringFavorite = ""
			} else {
				queryOperatorFavorite = " IN "
				let favoriteDictionary = [
					"TEAM" : "TEAM 1",
					"OPPONENT" : "TEAM 2",
					"PUSH" : "NEITHER"
				]
                var favoriteListValuesMapped = [String]()
                for favorite in favoriteListValue {
                    favoriteListValuesMapped.append(favoriteDictionary[favorite]!)
					
			}
                queryValueFavorite = "('" + favoriteListValuesMapped.joined(separator: "', '") + "')"
                queryStringFavorite = " AND " + queryColumnFavorite + queryOperatorFavorite + queryValueFavorite
            }
        }

        if clearSliderIndicator == "SEASON" || seasonSliderFormValue == "1940 & 2018" {
            queryStringSeason = ""
        } else {
            if seasonOperatorValue == "< >" {
                queryOperatorSeason = " BETWEEN "
                let queryLowerValueSeason = seasonRangeSliderLowerValue
                let queryUpperValueSeason = seasonRangeSliderUpperValue
                queryValueSeason = String(queryLowerValueSeason) + " AND " + String(queryUpperValueSeason)
                queryStringSeason = " AND " + queryColumnSeason + queryOperatorSeason + queryValueSeason
            } else {
                if seasonSliderValue == -10000 {
                    queryStringSeason = ""
                } else {
                    if seasonOperatorValue == "≠" {
                        queryOperatorSeason = " != "
                    } else {
                        queryOperatorSeason = " " + seasonOperatorValue + " "
                    }
                    queryValueSeason = String(seasonSliderValue)
                    queryStringSeason = " AND LENGTH(\(queryColumnSeason)) !=0 AND " + queryColumnSeason + queryOperatorSeason + queryValueSeason
                }
            }
        }
        
        //print("weekSliderFormValue: ")
        //print(weekSliderFormValue)
        if clearSliderIndicator == "WEEK" || weekSliderFormValue == "1 & 20" {
            queryStringWeek = ""
        } else {
            if weekOperatorValue == "< >" {
                queryOperatorWeek = " BETWEEN "
                let queryLowerValueWeek = weekRangeSliderLowerValue
                let queryUpperValueWeek = weekRangeSliderUpperValue
                queryValueWeek = String(queryLowerValueWeek) + " AND " + String(queryUpperValueWeek)
                queryStringWeek = " AND " + queryColumnWeek + queryOperatorWeek + queryValueWeek
            } else {
                if weekSliderValue == -10000 {
                    queryStringWeek = ""
                } else {
                    if weekOperatorValue == "≠" {
                        queryOperatorWeek = " != "
                    } else {
                        queryOperatorWeek = " " + weekOperatorValue + " "
                    }
                    queryValueWeek = String(weekSliderValue)
                    queryStringWeek = " AND LENGTH(\(queryColumnWeek)) !=0 AND " + queryColumnWeek + queryOperatorWeek + queryValueWeek
                }
            }
        }
        
        //print("gameNumberSliderFormValue: ")
        //print(gameNumberSliderFormValue)
        if clearSliderIndicator == "GAME NUMBER" || gameNumberSliderFormValue == "1 & 20" {
            queryStringGameNumber = ""
        } else {
            if gameNumberOperatorValue == "< >" {
                queryOperatorGameNumber = " BETWEEN "
                let queryLowerValueGameNumber = gameNumberRangeSliderLowerValue
                let queryUpperValueGameNumber = gameNumberRangeSliderUpperValue
                queryValueGameNumber = String(queryLowerValueGameNumber) + " AND " + String(queryUpperValueGameNumber)
                queryStringGameNumber = " AND " + queryColumnGameNumber + queryOperatorGameNumber + queryValueGameNumber
            } else {
                if gameNumberSliderValue == -10000 {
                    queryStringGameNumber = ""
                } else {
                    if gameNumberOperatorValue == "≠" {
                        queryOperatorGameNumber = " != "
                    } else {
                        queryOperatorGameNumber = " " + gameNumberOperatorValue + " "
                    }
                    queryValueGameNumber = String(gameNumberSliderValue)
                    queryStringGameNumber = " AND LENGTH(\(queryColumnGameNumber)) !=0 AND " + queryColumnGameNumber + queryOperatorGameNumber + queryValueGameNumber
                }
            }
        }
        
        if clearMultiSelectIndicator == "DAY" {
            queryStringDay = ""
        } else {
            if dayListValue == ["-10000"] || dayListValue == [] || dayListValue.count == 7 {
                queryStringDay = ""
            } else {
                queryOperatorDay = " IN "
                queryValueDay = "('" + dayListValue.joined(separator: "', '") + "')"
                queryStringDay = " AND " + queryColumnDay + queryOperatorDay + queryValueDay
            }
        }
        
        if clearMultiSelectIndicator == "STADIUM" {
            queryStringStadium = ""
        } else {
            if stadiumListValue == ["-10000"] || stadiumListValue == [] || stadiumListValue.count == 3 {
                queryStringStadium = ""
            } else {
                queryOperatorStadium = " IN "
                let stadiumDictionary = [
                    "OUTDOORS" : "outdoors",
                    "DOME" : "dome",
                    "RETRACTABLE ROOF" : "retroof"
                ]
                var stadiumListValuesMapped = [String]()
                for stadium in stadiumListValue {
                    stadiumListValuesMapped.append(stadiumDictionary[stadium]!)
                }
                queryValueStadium = "('" + stadiumListValuesMapped.joined(separator: "', '") + "')"
                queryStringStadium = " AND " + queryColumnStadium + queryOperatorStadium + queryValueStadium
            }
        }
        
        if clearMultiSelectIndicator == "SURFACE" {
            queryStringSurface = ""
        } else {
            if surfaceListValue == ["-10000"] || surfaceListValue == [] || surfaceListValue.count == 2 {
                queryStringSurface = ""
            } else {
                if surfaceListValue == ["GRASS"] {
                    queryOperatorSurface = " IN "
                    queryValueSurface = "('grass')"
                } else {
                    queryOperatorSurface = " NOT IN "
                    queryValueSurface = "('grass')"
                }
                queryStringSurface = " AND " + queryColumnSurface + queryOperatorSurface + queryValueSurface
            }
        }
        
        //print("temperatureSliderFormValue: ")
        //print(temperatureSliderFormValue)
        if clearSliderIndicator == "TEMPERATURE (F)" || temperatureSliderFormValue == "-25° & 115°" {
            queryStringTemperature = ""
        } else {
            if temperatureOperatorValue == "< >" {
                queryOperatorTemperature = " BETWEEN "
                let queryLowerValueTemperature = temperatureRangeSliderLowerValue
                let queryUpperValueTemperature = temperatureRangeSliderUpperValue
                queryValueTemperature = String(queryLowerValueTemperature) + " AND " + String(queryUpperValueTemperature)
                queryStringTemperature = " AND " + queryColumnTemperature + queryOperatorTemperature + queryValueTemperature
            } else {
                if temperatureSliderValue == -10000 {
                    queryStringTemperature = ""
                } else {
                    if temperatureOperatorValue == "≠" {
                        queryOperatorTemperature = " != "
                    } else {
                        queryOperatorTemperature = " " + temperatureOperatorValue + " "
                    }
                    queryValueTemperature = String(temperatureSliderValue)
                    queryStringTemperature = " AND LENGTH(\(queryColumnTemperature)) !=0 AND " + queryColumnTemperature + queryOperatorTemperature + queryValueTemperature
                }
            }
        }
        
        //print("totalPointsTeam1SliderFormValue: ")
        //print(totalPointsTeam1SliderFormValue)
        if clearSliderIndicator == "TEAM: TOTAL POINTS" || totalPointsTeam1SliderFormValue == "0 & 100" {
            queryStringTotalPointsTeam1 = ""
        } else {
            if totalPointsTeam1OperatorValue == "< >" {
                queryOperatorTotalPointsTeam1 = " BETWEEN "
                let queryLowerValueTotalPointsTeam1 = totalPointsTeam1RangeSliderLowerValue
                let queryUpperValueTotalPointsTeam1 = totalPointsTeam1RangeSliderUpperValue
                queryValueTotalPointsTeam1 = String(queryLowerValueTotalPointsTeam1) + " AND " + String(queryUpperValueTotalPointsTeam1)
                queryStringTotalPointsTeam1 = " AND " + queryColumnTotalPointsTeam1 + queryOperatorTotalPointsTeam1 + queryValueTotalPointsTeam1
            } else {
                if totalPointsTeam1SliderValue == -10000 {
                    queryStringTotalPointsTeam1 = ""
                } else {
                    if totalPointsTeam1OperatorValue == "≠" {
                        queryOperatorTotalPointsTeam1 = " != "
                    } else {
                        queryOperatorTotalPointsTeam1 = " " + totalPointsTeam1OperatorValue + " "
                    }
                    queryValueTotalPointsTeam1 = String(totalPointsTeam1SliderValue)
                    queryStringTotalPointsTeam1 = " AND LENGTH(\(queryColumnTotalPointsTeam1)) !=0 AND " + queryColumnTotalPointsTeam1 + queryOperatorTotalPointsTeam1 + queryValueTotalPointsTeam1
                }
            }
        }
        
        if clearSliderIndicator == "OPPONENT: TOTAL POINTS" || totalPointsTeam2SliderFormValue == "0 & 100" {
            queryStringTotalPointsTeam2 = ""
        } else {
            if totalPointsTeam2OperatorValue == "< >" {
                queryOperatorTotalPointsTeam2 = " BETWEEN "
                let queryLowerValueTotalPointsTeam2 = totalPointsTeam2RangeSliderLowerValue
                let queryUpperValueTotalPointsTeam2 = totalPointsTeam2RangeSliderUpperValue
                queryValueTotalPointsTeam2 = String(queryLowerValueTotalPointsTeam2) + " AND " + String(queryUpperValueTotalPointsTeam2)
                queryStringTotalPointsTeam2 = " AND " + queryColumnTotalPointsTeam2 + queryOperatorTotalPointsTeam2 + queryValueTotalPointsTeam2
            } else {
                if totalPointsTeam2SliderValue == -10000 {
                    queryStringTotalPointsTeam2 = ""
                } else {
                    if totalPointsTeam2OperatorValue == "≠" {
                        queryOperatorTotalPointsTeam2 = " != "
                    } else {
                        queryOperatorTotalPointsTeam2 = " " + totalPointsTeam2OperatorValue + " "
                    }
                    queryValueTotalPointsTeam2 = String(totalPointsTeam2SliderValue)
                    queryStringTotalPointsTeam2 = " AND LENGTH(\(queryColumnTotalPointsTeam2)) !=0 AND " + queryColumnTotalPointsTeam2 + queryOperatorTotalPointsTeam2 + queryValueTotalPointsTeam2
                }
            }
        }
        
        //print("touchdownsTeam1SliderFormValue: ")
        //print(touchdownsTeam1SliderFormValue)
        if clearSliderIndicator == "TEAM: TOUCHDOWNS" || touchdownsTeam1SliderFormValue == "0 & 10" {
            queryStringTouchdownsTeam1 = ""
        } else {
            if touchdownsTeam1OperatorValue == "< >" {
                queryOperatorTouchdownsTeam1 = " BETWEEN "
                let queryLowerValueTouchdownsTeam1 = touchdownsTeam1RangeSliderLowerValue
                let queryUpperValueTouchdownsTeam1 = touchdownsTeam1RangeSliderUpperValue
                queryValueTouchdownsTeam1 = String(queryLowerValueTouchdownsTeam1) + " AND " + String(queryUpperValueTouchdownsTeam1)
                queryStringTouchdownsTeam1 = " AND " + queryColumnTouchdownsTeam1 + queryOperatorTouchdownsTeam1 + queryValueTouchdownsTeam1
            } else {
                if touchdownsTeam1SliderValue == -10000 {
                    queryStringTouchdownsTeam1 = ""
                } else {
                    if touchdownsTeam1OperatorValue == "≠" {
                        queryOperatorTouchdownsTeam1 = " != "
                    } else {
                        queryOperatorTouchdownsTeam1 = " " + touchdownsTeam1OperatorValue + " "
                    }
                    queryValueTouchdownsTeam1 = String(touchdownsTeam1SliderValue)
                    queryStringTouchdownsTeam1 = " AND LENGTH(\(queryColumnTouchdownsTeam1)) !=0 AND " + queryColumnTouchdownsTeam1 + queryOperatorTouchdownsTeam1 + queryValueTouchdownsTeam1
                }
            }
        }
        
        if clearSliderIndicator == "OPPONENT: TOUCHDOWNS" || touchdownsTeam2SliderFormValue == "0 & 10" {
            queryStringTouchdownsTeam2 = ""
        } else {
            if touchdownsTeam2OperatorValue == "< >" {
                queryOperatorTouchdownsTeam2 = " BETWEEN "
                let queryLowerValueTouchdownsTeam2 = touchdownsTeam2RangeSliderLowerValue
                let queryUpperValueTouchdownsTeam2 = touchdownsTeam2RangeSliderUpperValue
                queryValueTouchdownsTeam2 = String(queryLowerValueTouchdownsTeam2) + " AND " + String(queryUpperValueTouchdownsTeam2)
                queryStringTouchdownsTeam2 = " AND " + queryColumnTouchdownsTeam2 + queryOperatorTouchdownsTeam2 + queryValueTouchdownsTeam2
            } else {
                if touchdownsTeam2SliderValue == -10000 {
                    queryStringTouchdownsTeam2 = ""
                } else {
                    if touchdownsTeam2OperatorValue == "≠" {
                        queryOperatorTouchdownsTeam2 = " != "
                    } else {
                        queryOperatorTouchdownsTeam2 = " " + touchdownsTeam2OperatorValue + " "
                    }
                    queryValueTouchdownsTeam2 = String(touchdownsTeam2SliderValue)
                    queryStringTouchdownsTeam2 = " AND LENGTH(\(queryColumnTouchdownsTeam2)) !=0 AND " + queryColumnTouchdownsTeam2 + queryOperatorTouchdownsTeam2 + queryValueTouchdownsTeam2
                }
            }
        }
        
        //print("offensiveTouchdownsTeam1SliderFormValue: ")
        //print(offensiveTouchdownsTeam1SliderFormValue)
        if clearSliderIndicator == "TEAM: OFFENSIVE TOUCHDOWNS" || offensiveTouchdownsTeam1SliderFormValue == "0 & 10" {
            queryStringOffensiveTouchdownsTeam1 = ""
        } else {
            if offensiveTouchdownsTeam1OperatorValue == "< >" {
                queryOperatorOffensiveTouchdownsTeam1 = " BETWEEN "
                let queryLowerValueOffensiveTouchdownsTeam1 = offensiveTouchdownsTeam1RangeSliderLowerValue
                let queryUpperValueOffensiveTouchdownsTeam1 = offensiveTouchdownsTeam1RangeSliderUpperValue
                queryValueOffensiveTouchdownsTeam1 = String(queryLowerValueOffensiveTouchdownsTeam1) + " AND " + String(queryUpperValueOffensiveTouchdownsTeam1)
                queryStringOffensiveTouchdownsTeam1 = " AND " + queryColumnOffensiveTouchdownsTeam1 + queryOperatorOffensiveTouchdownsTeam1 + queryValueOffensiveTouchdownsTeam1
            } else {
                if offensiveTouchdownsTeam1SliderValue == -10000 {
                    queryStringOffensiveTouchdownsTeam1 = ""
                } else {
                    if offensiveTouchdownsTeam1OperatorValue == "≠" {
                        queryOperatorOffensiveTouchdownsTeam1 = " != "
                    } else {
                        queryOperatorOffensiveTouchdownsTeam1 = " " + offensiveTouchdownsTeam1OperatorValue + " "
                    }
                    queryValueOffensiveTouchdownsTeam1 = String(offensiveTouchdownsTeam1SliderValue)
                    queryStringOffensiveTouchdownsTeam1 = " AND LENGTH(\(queryColumnOffensiveTouchdownsTeam1)) !=0 AND " + queryColumnOffensiveTouchdownsTeam1 + queryOperatorOffensiveTouchdownsTeam1 + queryValueOffensiveTouchdownsTeam1
                }
            }
        }
        
        //print("offensiveTouchdownsTeam2SliderFormValue: ")
        //print(offensiveTouchdownsTeam2SliderFormValue)
        if clearSliderIndicator == "OPPONENT: OFFENSIVE TOUCHDOWNS" || offensiveTouchdownsTeam2SliderFormValue == "0 & 10" {
            queryStringOffensiveTouchdownsTeam2 = ""
        } else {
            if offensiveTouchdownsTeam2OperatorValue == "< >" {
                queryOperatorOffensiveTouchdownsTeam2 = " BETWEEN "
                let queryLowerValueOffensiveTouchdownsTeam2 = offensiveTouchdownsTeam2RangeSliderLowerValue
                let queryUpperValueOffensiveTouchdownsTeam2 = offensiveTouchdownsTeam2RangeSliderUpperValue
                queryValueOffensiveTouchdownsTeam2 = String(queryLowerValueOffensiveTouchdownsTeam2) + " AND " + String(queryUpperValueOffensiveTouchdownsTeam2)
                queryStringOffensiveTouchdownsTeam2 = " AND " + queryColumnOffensiveTouchdownsTeam2 + queryOperatorOffensiveTouchdownsTeam2 + queryValueOffensiveTouchdownsTeam2
            } else {
                if offensiveTouchdownsTeam2SliderValue == -10000 {
                    queryStringOffensiveTouchdownsTeam2 = ""
                } else {
                    if offensiveTouchdownsTeam2OperatorValue == "≠" {
                        queryOperatorOffensiveTouchdownsTeam2 = " != "
                    } else {
                        queryOperatorOffensiveTouchdownsTeam2 = " " + offensiveTouchdownsTeam2OperatorValue + " "
                    }
                    queryValueOffensiveTouchdownsTeam2 = String(offensiveTouchdownsTeam2SliderValue)
                    queryStringOffensiveTouchdownsTeam2 = " AND LENGTH(\(queryColumnOffensiveTouchdownsTeam2)) !=0 AND " + queryColumnOffensiveTouchdownsTeam2 + queryOperatorOffensiveTouchdownsTeam2 + queryValueOffensiveTouchdownsTeam2
                }
            }
        }
        
        //print("defensiveTouchdownsTeam1SliderFormValue: ")
        //print(defensiveTouchdownsTeam1SliderFormValue)
        if clearSliderIndicator == "TEAM: DEFENSIVE TOUCHDOWNS" || defensiveTouchdownsTeam1SliderFormValue == "0 & 10" {
            queryStringDefensiveTouchdownsTeam1 = ""
        } else {
            if defensiveTouchdownsTeam1OperatorValue == "< >" {
                queryOperatorDefensiveTouchdownsTeam1 = " BETWEEN "
                let queryLowerValueDefensiveTouchdownsTeam1 = defensiveTouchdownsTeam1RangeSliderLowerValue
                let queryUpperValueDefensiveTouchdownsTeam1 = defensiveTouchdownsTeam1RangeSliderUpperValue
                queryValueDefensiveTouchdownsTeam1 = String(queryLowerValueDefensiveTouchdownsTeam1) + " AND " + String(queryUpperValueDefensiveTouchdownsTeam1)
                queryStringDefensiveTouchdownsTeam1 = " AND " + queryColumnDefensiveTouchdownsTeam1 + queryOperatorDefensiveTouchdownsTeam1 + queryValueDefensiveTouchdownsTeam1
            } else {
                if defensiveTouchdownsTeam1SliderValue == -10000 {
                    queryStringDefensiveTouchdownsTeam1 = ""
                } else {
                    if defensiveTouchdownsTeam1OperatorValue == "≠" {
                        queryOperatorDefensiveTouchdownsTeam1 = " != "
                    } else {
                        queryOperatorDefensiveTouchdownsTeam1 = " " + defensiveTouchdownsTeam1OperatorValue + " "
                    }
                    queryValueDefensiveTouchdownsTeam1 = String(defensiveTouchdownsTeam1SliderValue)
                    queryStringDefensiveTouchdownsTeam1 = " AND LENGTH(\(queryColumnDefensiveTouchdownsTeam1)) !=0 AND " + queryColumnDefensiveTouchdownsTeam1 + queryOperatorDefensiveTouchdownsTeam1 + queryValueDefensiveTouchdownsTeam1
                }
            }
        }
        
        //print("defensiveTouchdownsTeam2SliderFormValue: ")
        //print(defensiveTouchdownsTeam2SliderFormValue)
        if clearSliderIndicator == "OPPONENT: DEFENSIVE TOUCHDOWNS" || defensiveTouchdownsTeam2SliderFormValue == "0 & 10" {
            queryStringDefensiveTouchdownsTeam2 = ""
        } else {
            if defensiveTouchdownsTeam2OperatorValue == "< >" {
                queryOperatorDefensiveTouchdownsTeam2 = " BETWEEN "
                let queryLowerValueDefensiveTouchdownsTeam2 = defensiveTouchdownsTeam2RangeSliderLowerValue
                let queryUpperValueDefensiveTouchdownsTeam2 = defensiveTouchdownsTeam2RangeSliderUpperValue
                queryValueDefensiveTouchdownsTeam2 = String(queryLowerValueDefensiveTouchdownsTeam2) + " AND " + String(queryUpperValueDefensiveTouchdownsTeam2)
                queryStringDefensiveTouchdownsTeam2 = " AND " + queryColumnDefensiveTouchdownsTeam2 + queryOperatorDefensiveTouchdownsTeam2 + queryValueDefensiveTouchdownsTeam2
            } else {
                if defensiveTouchdownsTeam2SliderValue == -10000 {
                    queryStringDefensiveTouchdownsTeam2 = ""
                } else {
                    if defensiveTouchdownsTeam2OperatorValue == "≠" {
                        queryOperatorDefensiveTouchdownsTeam2 = " != "
                    } else {
                        queryOperatorDefensiveTouchdownsTeam2 = " " + defensiveTouchdownsTeam2OperatorValue + " "
                    }
                    queryValueDefensiveTouchdownsTeam2 = String(defensiveTouchdownsTeam2SliderValue)
                    queryStringDefensiveTouchdownsTeam2 = " AND LENGTH(\(queryColumnDefensiveTouchdownsTeam2)) !=0 AND " + queryColumnDefensiveTouchdownsTeam2 + queryOperatorDefensiveTouchdownsTeam2 + queryValueDefensiveTouchdownsTeam2
                }
            }
        }
        
        
        //print("turnoversCommittedTeam1SliderFormValue: ")
        //print(turnoversCommittedTeam1SliderFormValue)
        if clearSliderIndicator == "TEAM: TURNOVERS" || turnoversCommittedTeam1SliderFormValue == "0 & 15" {
            queryStringTurnoversCommittedTeam1 = ""
        } else {
            if turnoversCommittedTeam1OperatorValue == "< >" {
                queryOperatorTurnoversCommittedTeam1 = " BETWEEN "
                let queryLowerValueTurnoversCommittedTeam1 = turnoversCommittedTeam1RangeSliderLowerValue
                let queryUpperValueTurnoversCommittedTeam1 = turnoversCommittedTeam1RangeSliderUpperValue
                queryValueTurnoversCommittedTeam1 = String(queryLowerValueTurnoversCommittedTeam1) + " AND " + String(queryUpperValueTurnoversCommittedTeam1)
                queryStringTurnoversCommittedTeam1 = " AND " + queryColumnTurnoversCommittedTeam1 + queryOperatorTurnoversCommittedTeam1 + queryValueTurnoversCommittedTeam1
            } else {
                if turnoversCommittedTeam1SliderValue == -10000 {
                    queryStringTurnoversCommittedTeam1 = ""
                } else {
                    if turnoversCommittedTeam1OperatorValue == "≠" {
                        queryOperatorTurnoversCommittedTeam1 = " != "
                    } else {
                        queryOperatorTurnoversCommittedTeam1 = " " + turnoversCommittedTeam1OperatorValue + " "
                    }
                    queryValueTurnoversCommittedTeam1 = String(turnoversCommittedTeam1SliderValue)
                    queryStringTurnoversCommittedTeam1 = " AND LENGTH(\(queryColumnTurnoversCommittedTeam1)) !=0 AND " + queryColumnTurnoversCommittedTeam1 + queryOperatorTurnoversCommittedTeam1 + queryValueTurnoversCommittedTeam1
                }
            }
        }
        
        if clearSliderIndicator == "OPPONENT: TURNOVERS" || turnoversCommittedTeam2SliderFormValue == "0 & 15" {
            queryStringTurnoversCommittedTeam2 = ""
        } else {
            if turnoversCommittedTeam2OperatorValue == "< >" {
                queryOperatorTurnoversCommittedTeam2 = " BETWEEN "
                let queryLowerValueTurnoversCommittedTeam2 = turnoversCommittedTeam2RangeSliderLowerValue
                let queryUpperValueTurnoversCommittedTeam2 = turnoversCommittedTeam2RangeSliderUpperValue
                queryValueTurnoversCommittedTeam2 = String(queryLowerValueTurnoversCommittedTeam2) + " AND " + String(queryUpperValueTurnoversCommittedTeam2)
                queryStringTurnoversCommittedTeam2 = " AND " + queryColumnTurnoversCommittedTeam2 + queryOperatorTurnoversCommittedTeam2 + queryValueTurnoversCommittedTeam2
            } else {
                if turnoversCommittedTeam2SliderValue == -10000 {
                    queryStringTurnoversCommittedTeam2 = ""
                } else {
                    if turnoversCommittedTeam2OperatorValue == "≠" {
                        queryOperatorTurnoversCommittedTeam2 = " != "
                    } else {
                        queryOperatorTurnoversCommittedTeam2 = " " + turnoversCommittedTeam2OperatorValue + " "
                    }
                    queryValueTurnoversCommittedTeam2 = String(turnoversCommittedTeam2SliderValue)
                    queryStringTurnoversCommittedTeam2 = " AND LENGTH(\(queryColumnPenaltiesCommittedTeam1)) !=0 AND " + queryColumnTurnoversCommittedTeam2 + queryOperatorTurnoversCommittedTeam2 + queryValueTurnoversCommittedTeam2
                }
            }
        }
        
        //print("penaltiesCommittedTeam1SliderFormValue: ")
        //print(penaltiesCommittedTeam1SliderFormValue)
        if clearSliderIndicator == "TEAM: PENALTIES" || penaltiesCommittedTeam1SliderFormValue == "0 & 15" {
            queryStringPenaltiesCommittedTeam1 = ""
        } else {
            if penaltiesCommittedTeam1OperatorValue == "< >" {
                queryOperatorPenaltiesCommittedTeam1 = " BETWEEN "
                let queryLowerValuePenaltiesCommittedTeam1 = penaltiesCommittedTeam1RangeSliderLowerValue
                let queryUpperValuePenaltiesCommittedTeam1 = penaltiesCommittedTeam1RangeSliderUpperValue
                queryValuePenaltiesCommittedTeam1 = String(queryLowerValuePenaltiesCommittedTeam1) + " AND " + String(queryUpperValuePenaltiesCommittedTeam1)
                queryStringPenaltiesCommittedTeam1 = " AND " + queryColumnPenaltiesCommittedTeam1 + queryOperatorPenaltiesCommittedTeam1 + queryValuePenaltiesCommittedTeam1
            } else {
                if penaltiesCommittedTeam1SliderValue == -10000 {
                    queryStringPenaltiesCommittedTeam1 = ""
                } else {
                    if penaltiesCommittedTeam1OperatorValue == "≠" {
                        queryOperatorPenaltiesCommittedTeam1 = " != "
                    } else {
                        queryOperatorPenaltiesCommittedTeam1 = " " + penaltiesCommittedTeam1OperatorValue + " "
                    }
                    queryValuePenaltiesCommittedTeam1 = String(penaltiesCommittedTeam1SliderValue)
                    queryStringPenaltiesCommittedTeam1 = " AND LENGTH(\(queryColumnPenaltiesCommittedTeam1)) !=0 AND " + queryColumnPenaltiesCommittedTeam1 + queryOperatorPenaltiesCommittedTeam1 + queryValuePenaltiesCommittedTeam1
                }
            }
        }
        
        if clearSliderIndicator == "OPPONENT: PENALTIES" || penaltiesCommittedTeam2SliderFormValue == "0 & 15" {
            queryStringPenaltiesCommittedTeam2 = ""
        } else {
            if penaltiesCommittedTeam2OperatorValue == "< >" {
                queryOperatorPenaltiesCommittedTeam2 = " BETWEEN "
                let queryLowerValuePenaltiesCommittedTeam2 = penaltiesCommittedTeam2RangeSliderLowerValue
                let queryUpperValuePenaltiesCommittedTeam2 = penaltiesCommittedTeam2RangeSliderUpperValue
                queryValuePenaltiesCommittedTeam2 = String(queryLowerValuePenaltiesCommittedTeam2) + " AND " + String(queryUpperValuePenaltiesCommittedTeam2)
                queryStringPenaltiesCommittedTeam2 = " AND " + queryColumnPenaltiesCommittedTeam2 + queryOperatorPenaltiesCommittedTeam2 + queryValuePenaltiesCommittedTeam2
            } else {
                if penaltiesCommittedTeam2SliderValue == -10000 {
                    queryStringPenaltiesCommittedTeam2 = ""
                } else {
                    if penaltiesCommittedTeam2OperatorValue == "≠" {
                        queryOperatorPenaltiesCommittedTeam2 = " != "
                    } else {
                        queryOperatorPenaltiesCommittedTeam2 = " " + penaltiesCommittedTeam2OperatorValue + " "
                    }
                    queryValuePenaltiesCommittedTeam2 = String(penaltiesCommittedTeam2SliderValue)
                    queryStringPenaltiesCommittedTeam2 = " AND LENGTH(\(queryColumnPenaltiesCommittedTeam2)) !=0 AND " + queryColumnPenaltiesCommittedTeam2 + queryOperatorPenaltiesCommittedTeam2 + queryValuePenaltiesCommittedTeam2
                }
            }
        }
        
        //print("totalYardsTeam1SliderFormValue: ")
        //print(totalYardsTeam1SliderFormValue)
        if clearSliderIndicator == "TEAM: TOTAL YARDS" || totalYardsTeam1SliderFormValue == "-50 & 800" {
            queryStringTotalYardsTeam1 = ""
        } else {
            if totalYardsTeam1OperatorValue == "< >" {
                queryOperatorTotalYardsTeam1 = " BETWEEN "
                let queryLowerValueTotalYardsTeam1 = totalYardsTeam1RangeSliderLowerValue
                let queryUpperValueTotalYardsTeam1 = totalYardsTeam1RangeSliderUpperValue
                queryValueTotalYardsTeam1 = String(queryLowerValueTotalYardsTeam1) + " AND " + String(queryUpperValueTotalYardsTeam1)
                queryStringTotalYardsTeam1 = " AND " + queryColumnTotalYardsTeam1 + queryOperatorTotalYardsTeam1 + queryValueTotalYardsTeam1
            } else {
                if totalYardsTeam1SliderValue == -10000 {
                    queryStringTotalYardsTeam1 = ""
                } else {
                    if totalYardsTeam1OperatorValue == "≠" {
                        queryOperatorTotalYardsTeam1 = " != "
                    } else {
                        queryOperatorTotalYardsTeam1 = " " + totalYardsTeam1OperatorValue + " "
                    }
                    queryValueTotalYardsTeam1 = String(totalYardsTeam1SliderValue)
                    queryStringTotalYardsTeam1 = " AND LENGTH(\(queryColumnTotalYardsTeam1)) !=0 AND " + queryColumnTotalYardsTeam1 + queryOperatorTotalYardsTeam1 + queryValueTotalYardsTeam1
                }
            }
        }
        
        if clearSliderIndicator == "OPPONENT: TOTAL YARDS" || totalYardsTeam2SliderFormValue == "-50 & 800" {
            queryStringTotalYardsTeam2 = ""
        } else {
            if totalYardsTeam2OperatorValue == "< >" {
                queryOperatorTotalYardsTeam2 = " BETWEEN "
                let queryLowerValueTotalYardsTeam2 = totalYardsTeam2RangeSliderLowerValue
                let queryUpperValueTotalYardsTeam2 = totalYardsTeam2RangeSliderUpperValue
                queryValueTotalYardsTeam2 = String(queryLowerValueTotalYardsTeam2) + " AND " + String(queryUpperValueTotalYardsTeam2)
                queryStringTotalYardsTeam2 = " AND " + queryColumnTotalYardsTeam2 + queryOperatorTotalYardsTeam2 + queryValueTotalYardsTeam2
            } else {
                if totalYardsTeam2SliderValue == -10000 {
                    queryStringTotalYardsTeam2 = ""
                } else {
                    if totalYardsTeam2OperatorValue == "≠" {
                        queryOperatorTotalYardsTeam2 = " != "
                    } else {
                        queryOperatorTotalYardsTeam2 = " " + totalYardsTeam2OperatorValue + " "
                    }
                    queryValueTotalYardsTeam2 = String(totalYardsTeam2SliderValue)
                    queryStringTotalYardsTeam2 = " AND LENGTH(\(queryColumnTotalYardsTeam2)) !=0 AND " + queryColumnTotalYardsTeam2 + queryOperatorTotalYardsTeam2 + queryValueTotalYardsTeam2
                }
            }
        }
        
        //print("passingYardsTeam1SliderFormValue: ")
        //print(passingYardsTeam1SliderFormValue)
        if clearSliderIndicator == "TEAM: PASSING YARDS" || passingYardsTeam1SliderFormValue == "-100 & 700" {
            queryStringPassingYardsTeam1 = ""
        } else {
            if passingYardsTeam1OperatorValue == "< >" {
                queryOperatorPassingYardsTeam1 = " BETWEEN "
                let queryLowerValuePassingYardsTeam1 = passingYardsTeam1RangeSliderLowerValue
                let queryUpperValuePassingYardsTeam1 = passingYardsTeam1RangeSliderUpperValue
                queryValuePassingYardsTeam1 = String(queryLowerValuePassingYardsTeam1) + " AND " + String(queryUpperValuePassingYardsTeam1)
                queryStringPassingYardsTeam1 = " AND " + queryColumnPassingYardsTeam1 + queryOperatorPassingYardsTeam1 + queryValuePassingYardsTeam1
            } else {
                if passingYardsTeam1SliderValue == -10000 {
                    queryStringPassingYardsTeam1 = ""
                } else {
                    if passingYardsTeam1OperatorValue == "≠" {
                        queryOperatorPassingYardsTeam1 = " != "
                    } else {
                        queryOperatorPassingYardsTeam1 = " " + passingYardsTeam1OperatorValue + " "
                    }
                    queryValuePassingYardsTeam1 = String(passingYardsTeam1SliderValue)
                    queryStringPassingYardsTeam1 = " AND LENGTH(\(queryColumnPassingYardsTeam1)) !=0 AND " + queryColumnPassingYardsTeam1 + queryOperatorPassingYardsTeam1 + queryValuePassingYardsTeam1
                }
            }
        }
        
        if clearSliderIndicator == "OPPONENT: PASSING YARDS" || passingYardsTeam2SliderFormValue == "-100 & 700" {
            queryStringPassingYardsTeam2 = ""
        } else {
            if passingYardsTeam2OperatorValue == "< >" {
                queryOperatorPassingYardsTeam2 = " BETWEEN "
                let queryLowerValuePassingYardsTeam2 = passingYardsTeam2RangeSliderLowerValue
                let queryUpperValuePassingYardsTeam2 = passingYardsTeam2RangeSliderUpperValue
                queryValuePassingYardsTeam2 = String(queryLowerValuePassingYardsTeam2) + " AND " + String(queryUpperValuePassingYardsTeam2)
                queryStringPassingYardsTeam2 = " AND " + queryColumnPassingYardsTeam2 + queryOperatorPassingYardsTeam2 + queryValuePassingYardsTeam2
            } else {
                if passingYardsTeam2SliderValue == -10000 {
                    queryStringPassingYardsTeam2 = ""
                } else {
                    if passingYardsTeam2OperatorValue == "≠" {
                        queryOperatorPassingYardsTeam2 = " != "
                    } else {
                        queryOperatorPassingYardsTeam2 = " " + passingYardsTeam2OperatorValue + " "
                    }
                    queryValuePassingYardsTeam2 = String(passingYardsTeam2SliderValue)
                    queryStringPassingYardsTeam2 = " AND LENGTH(\(queryColumnPassingYardsTeam2)) !=0 AND " + queryColumnPassingYardsTeam2 + queryOperatorPassingYardsTeam2 + queryValuePassingYardsTeam2
                }
            }
        }
        
        //print("rushingYardsTeam1SliderFormValue: ")
        //print(rushingYardsTeam1SliderFormValue)
        if clearSliderIndicator == "TEAM: RUSHING YARDS" || rushingYardsTeam1SliderFormValue == "-100 & 500" {
            queryStringRushingYardsTeam1 = ""
        } else {
            if rushingYardsTeam1OperatorValue == "< >" {
                queryOperatorRushingYardsTeam1 = " BETWEEN "
                let queryLowerValueRushingYardsTeam1 = rushingYardsTeam1RangeSliderLowerValue
                let queryUpperValueRushingYardsTeam1 = rushingYardsTeam1RangeSliderUpperValue
                queryValueRushingYardsTeam1 = String(queryLowerValueRushingYardsTeam1) + " AND " + String(queryUpperValueRushingYardsTeam1)
                queryStringRushingYardsTeam1 = " AND " + queryColumnRushingYardsTeam1 + queryOperatorRushingYardsTeam1 + queryValueRushingYardsTeam1
            } else {
                if rushingYardsTeam1SliderValue == -10000 {
                    queryStringRushingYardsTeam1 = ""
                } else {
                    if rushingYardsTeam1OperatorValue == "≠" {
                        queryOperatorRushingYardsTeam1 = " != "
                    } else {
                        queryOperatorRushingYardsTeam1 = " " + rushingYardsTeam1OperatorValue + " "
                    }
                    queryValueRushingYardsTeam1 = String(rushingYardsTeam1SliderValue)
                    queryStringRushingYardsTeam1 = " AND LENGTH(\(queryColumnRushingYardsTeam1)) !=0 AND " + queryColumnRushingYardsTeam1 + queryOperatorRushingYardsTeam1 + queryValueRushingYardsTeam1
                }
            }
        }
        
        if clearSliderIndicator == "OPPONENT: RUSHING YARDS" || rushingYardsTeam2SliderFormValue == "-100 & 500" {
            queryStringRushingYardsTeam2 = ""
        } else {
            if rushingYardsTeam2OperatorValue == "< >" {
                queryOperatorRushingYardsTeam2 = " BETWEEN "
                let queryLowerValueRushingYardsTeam2 = rushingYardsTeam2RangeSliderLowerValue
                let queryUpperValueRushingYardsTeam2 = rushingYardsTeam2RangeSliderUpperValue
                queryValueRushingYardsTeam2 = String(queryLowerValueRushingYardsTeam2) + " AND " + String(queryUpperValueRushingYardsTeam2)
                queryStringRushingYardsTeam2 = " AND " + queryColumnRushingYardsTeam2 + queryOperatorRushingYardsTeam2 + queryValueRushingYardsTeam2
            } else {
                if rushingYardsTeam2SliderValue == -10000 {
                    queryStringRushingYardsTeam2 = ""
                } else {
                    if rushingYardsTeam2OperatorValue == "≠" {
                        queryOperatorRushingYardsTeam2 = " != "
                    } else {
                        queryOperatorRushingYardsTeam2 = " " + rushingYardsTeam2OperatorValue + " "
                    }
                    queryValueRushingYardsTeam2 = String(rushingYardsTeam2SliderValue)
                    queryStringRushingYardsTeam2 = " AND LENGTH(\(queryColumnRushingYardsTeam2)) !=0 AND " + queryColumnRushingYardsTeam2 + queryOperatorRushingYardsTeam2 + queryValueRushingYardsTeam2
                }
            }
        }
        
        //print("quarterbackRatingTeam1SliderFormValue: ")
        //print(quarterbackRatingTeam1SliderFormValue)
        if clearSliderIndicator == "TEAM: QUARTERBACK RATING" || quarterbackRatingTeam1SliderFormValue == "0 & 159" {
            queryStringQuarterbackRatingTeam1 = ""
        } else {
            if quarterbackRatingTeam1OperatorValue == "< >" {
                queryOperatorQuarterbackRatingTeam1 = " BETWEEN "
                let queryLowerValueQuarterbackRatingTeam1 = quarterbackRatingTeam1RangeSliderLowerValue
                let queryUpperValueQuarterbackRatingTeam1 = quarterbackRatingTeam1RangeSliderUpperValue
                queryValueQuarterbackRatingTeam1 = String(queryLowerValueQuarterbackRatingTeam1) + " AND " + String(queryUpperValueQuarterbackRatingTeam1)
                queryStringQuarterbackRatingTeam1 = " AND " + queryColumnQuarterbackRatingTeam1 + queryOperatorQuarterbackRatingTeam1 + queryValueQuarterbackRatingTeam1
            } else {
                if quarterbackRatingTeam1SliderValue == -10000 {
                    queryStringQuarterbackRatingTeam1 = ""
                } else {
                    if quarterbackRatingTeam1OperatorValue == "≠" {
                        queryOperatorQuarterbackRatingTeam1 = " != "
                    } else {
                        queryOperatorQuarterbackRatingTeam1 = " " + quarterbackRatingTeam1OperatorValue + " "
                    }
                    queryValueQuarterbackRatingTeam1 = String(quarterbackRatingTeam1SliderValue)
                    queryStringQuarterbackRatingTeam1 = " AND LENGTH(\(queryColumnQuarterbackRatingTeam1)) !=0 AND " + queryColumnQuarterbackRatingTeam1 + queryOperatorQuarterbackRatingTeam1 + queryValueQuarterbackRatingTeam1
                }
            }
        }
        
        if clearSliderIndicator == "OPPONENT: QUARTERBACK RATING" || quarterbackRatingTeam2SliderFormValue == "0 & 159" {
            queryStringQuarterbackRatingTeam2 = ""
        } else {
            if quarterbackRatingTeam2OperatorValue == "< >" {
                queryOperatorQuarterbackRatingTeam2 = " BETWEEN "
                let queryLowerValueQuarterbackRatingTeam2 = quarterbackRatingTeam2RangeSliderLowerValue
                let queryUpperValueQuarterbackRatingTeam2 = quarterbackRatingTeam2RangeSliderUpperValue
                queryValueQuarterbackRatingTeam2 = String(queryLowerValueQuarterbackRatingTeam2) + " AND " + String(queryUpperValueQuarterbackRatingTeam2)
                queryStringQuarterbackRatingTeam2 = " AND " + queryColumnQuarterbackRatingTeam2 + queryOperatorQuarterbackRatingTeam2 + queryValueQuarterbackRatingTeam2
            } else {
                if quarterbackRatingTeam2SliderValue == -10000 {
                    queryStringQuarterbackRatingTeam2 = ""
                } else {
                    if quarterbackRatingTeam2OperatorValue == "≠" {
                        queryOperatorQuarterbackRatingTeam2 = " != "
                    } else {
                        queryOperatorQuarterbackRatingTeam2 = " " + quarterbackRatingTeam2OperatorValue + " "
                    }
                    queryValueQuarterbackRatingTeam2 = String(quarterbackRatingTeam2SliderValue)
                    queryStringQuarterbackRatingTeam2 = " AND LENGTH(\(queryColumnQuarterbackRatingTeam2)) !=0 AND " + queryColumnQuarterbackRatingTeam2 + queryOperatorQuarterbackRatingTeam2 + queryValueQuarterbackRatingTeam2
                }
            }
        }
        
        //print("timesSackedTeam1SliderFormValue: ")
        //print(timesSackedTeam1SliderFormValue)
        if clearSliderIndicator == "TEAM: TIMES SACKED" || timesSackedTeam1SliderFormValue == "0 & 15" {
            queryStringTimesSackedTeam1 = ""
        } else {
            if timesSackedTeam1OperatorValue == "< >" {
                queryOperatorTimesSackedTeam1 = " BETWEEN "
                let queryLowerValueTimesSackedTeam1 = timesSackedTeam1RangeSliderLowerValue
                let queryUpperValueTimesSackedTeam1 = timesSackedTeam1RangeSliderUpperValue
                queryValueTimesSackedTeam1 = String(queryLowerValueTimesSackedTeam1) + " AND " + String(queryUpperValueTimesSackedTeam1)
                queryStringTimesSackedTeam1 = " AND " + queryColumnTimesSackedTeam1 + queryOperatorTimesSackedTeam1 + queryValueTimesSackedTeam1
            } else {
                if timesSackedTeam1SliderValue == -10000 {
                    queryStringTimesSackedTeam1 = ""
                } else {
                    if timesSackedTeam1OperatorValue == "≠" {
                        queryOperatorTimesSackedTeam1 = " != "
                    } else {
                        queryOperatorTimesSackedTeam1 = " " + timesSackedTeam1OperatorValue + " "
                    }
                    queryValueTimesSackedTeam1 = String(timesSackedTeam1SliderValue)
                    queryStringTimesSackedTeam1 = " AND LENGTH(\(queryColumnTimesSackedTeam1)) !=0 AND " + queryColumnTimesSackedTeam1 + queryOperatorTimesSackedTeam1 + queryValueTimesSackedTeam1
                }
            }
        }
        
        if clearSliderIndicator == "OPPONENT: TIMES SACKED" || timesSackedTeam2SliderFormValue == "0 & 15" {
            queryStringTimesSackedTeam2 = ""
        } else {
            if timesSackedTeam2OperatorValue == "< >" {
                queryOperatorTimesSackedTeam2 = " BETWEEN "
                let queryLowerValueTimesSackedTeam2 = timesSackedTeam2RangeSliderLowerValue
                let queryUpperValueTimesSackedTeam2 = timesSackedTeam2RangeSliderUpperValue
                queryValueTimesSackedTeam2 = String(queryLowerValueTimesSackedTeam2) + " AND " + String(queryUpperValueTimesSackedTeam2)
                queryStringTimesSackedTeam2 = " AND " + queryColumnTimesSackedTeam2 + queryOperatorTimesSackedTeam2 + queryValueTimesSackedTeam2
            } else {
                if timesSackedTeam2SliderValue == -10000 {
                    queryStringTimesSackedTeam2 = ""
                } else {
                    if timesSackedTeam2OperatorValue == "≠" {
                        queryOperatorTimesSackedTeam2 = " != "
                    } else {
                        queryOperatorTimesSackedTeam2 = " " + timesSackedTeam2OperatorValue + " "
                    }
                    queryValueTimesSackedTeam2 = String(timesSackedTeam2SliderValue)
                    queryStringTimesSackedTeam2 = " AND LENGTH(\(queryColumnTimesSackedTeam2)) !=0 AND " + queryColumnTimesSackedTeam2 + queryOperatorTimesSackedTeam2 + queryValueTimesSackedTeam2
                }
            }
        }
        
        //print("interceptionsThrownTeam1SliderFormValue: ")
        //print(interceptionsThrownTeam1SliderFormValue)
        if clearSliderIndicator == "TEAM: INTERCEPTIONS THROWN" || interceptionsThrownTeam1SliderFormValue == "0 & 15" {
            queryStringInterceptionsThrownTeam1 = ""
        } else {
            if interceptionsThrownTeam1OperatorValue == "< >" {
                queryOperatorInterceptionsThrownTeam1 = " BETWEEN "
                let queryLowerValueInterceptionsThrownTeam1 = interceptionsThrownTeam1RangeSliderLowerValue
                let queryUpperValueInterceptionsThrownTeam1 = interceptionsThrownTeam1RangeSliderUpperValue
                queryValueInterceptionsThrownTeam1 = String(queryLowerValueInterceptionsThrownTeam1) + " AND " + String(queryUpperValueInterceptionsThrownTeam1)
                queryStringInterceptionsThrownTeam1 = " AND " + queryColumnInterceptionsThrownTeam1 + queryOperatorInterceptionsThrownTeam1 + queryValueInterceptionsThrownTeam1
            } else {
                if interceptionsThrownTeam1SliderValue == -10000 {
                    queryStringInterceptionsThrownTeam1 = ""
                } else {
                    if interceptionsThrownTeam1OperatorValue == "≠" {
                        queryOperatorInterceptionsThrownTeam1 = " != "
                    } else {
                        queryOperatorInterceptionsThrownTeam1 = " " + interceptionsThrownTeam1OperatorValue + " "
                    }
                    queryValueInterceptionsThrownTeam1 = String(interceptionsThrownTeam1SliderValue)
                    queryStringInterceptionsThrownTeam1 = " AND LENGTH(\(queryColumnInterceptionsThrownTeam1)) !=0 AND " + queryColumnInterceptionsThrownTeam1 + queryOperatorInterceptionsThrownTeam1 + queryValueInterceptionsThrownTeam1
                }
            }
        }
        
        if clearSliderIndicator == "OPPONENT: INTERCEPTIONS THROWN" || interceptionsThrownTeam2SliderFormValue == "0 & 15" {
            queryStringInterceptionsThrownTeam2 = ""
        } else {
            if interceptionsThrownTeam2OperatorValue == "< >" {
                queryOperatorInterceptionsThrownTeam2 = " BETWEEN "
                let queryLowerValueInterceptionsThrownTeam2 = interceptionsThrownTeam2RangeSliderLowerValue
                let queryUpperValueInterceptionsThrownTeam2 = interceptionsThrownTeam2RangeSliderUpperValue
                queryValueInterceptionsThrownTeam2 = String(queryLowerValueInterceptionsThrownTeam2) + " AND " + String(queryUpperValueInterceptionsThrownTeam2)
                queryStringInterceptionsThrownTeam2 = " AND " + queryColumnInterceptionsThrownTeam2 + queryOperatorInterceptionsThrownTeam2 + queryValueInterceptionsThrownTeam2
            } else {
                if interceptionsThrownTeam2SliderValue == -10000 {
                    queryStringInterceptionsThrownTeam2 = ""
                } else {
                    if interceptionsThrownTeam2OperatorValue == "≠" {
                        queryOperatorInterceptionsThrownTeam2 = " != "
                    } else {
                        queryOperatorInterceptionsThrownTeam2 = " " + interceptionsThrownTeam2OperatorValue + " "
                    }
                    queryValueInterceptionsThrownTeam2 = String(interceptionsThrownTeam2SliderValue)
                    queryStringInterceptionsThrownTeam2 = " AND LENGTH(\(queryColumnInterceptionsThrownTeam2)) !=0 AND " + queryColumnInterceptionsThrownTeam2 + queryOperatorInterceptionsThrownTeam2 + queryValueInterceptionsThrownTeam2
                }
            }
        }
        
        //print("offensivePlaysTeam1SliderValue: ")
        //print(interceptionsTeam1SliderValue)
        if clearSliderIndicator == "TEAM: OFFENSIVE PLAYS" || offensivePlaysTeam1SliderFormValue == "1 & 120" {
            queryStringOffensivePlaysTeam1 = ""
        } else {
            if offensivePlaysTeam1OperatorValue == "< >" {
                queryOperatorOffensivePlaysTeam1 = " BETWEEN "
                let queryLowerValueOffensivePlaysTeam1 = offensivePlaysTeam1RangeSliderLowerValue
                let queryUpperValueOffensivePlaysTeam1 = offensivePlaysTeam1RangeSliderUpperValue
                queryValueOffensivePlaysTeam1 = String(queryLowerValueOffensivePlaysTeam1) + " AND " + String(queryUpperValueOffensivePlaysTeam1)
                queryStringOffensivePlaysTeam1 = " AND " + queryColumnOffensivePlaysTeam1 + queryOperatorOffensivePlaysTeam1 + queryValueOffensivePlaysTeam1
            } else {
                if offensivePlaysTeam1SliderValue == -10000 {
                    queryStringOffensivePlaysTeam1 = ""
                } else {
                    if offensivePlaysTeam1OperatorValue == "≠" {
                        queryOperatorOffensivePlaysTeam1 = " != "
                    } else {
                        queryOperatorOffensivePlaysTeam1 = " " + offensivePlaysTeam1OperatorValue + " "
                    }
                    queryValueOffensivePlaysTeam1 = String(offensivePlaysTeam1SliderValue)
                    queryStringOffensivePlaysTeam1 = " AND LENGTH(\(queryColumnOffensivePlaysTeam1)) !=0 AND " + queryColumnOffensivePlaysTeam1 + queryOperatorOffensivePlaysTeam1 + queryValueOffensivePlaysTeam1
                }
            }
        }
        
        if clearSliderIndicator == "OPPONENT: OFFENSIVE PLAYS" || offensivePlaysTeam2SliderFormValue == "1 & 120" {
            queryStringOffensivePlaysTeam2 = ""
        } else {
            if offensivePlaysTeam2OperatorValue == "< >" {
                queryOperatorOffensivePlaysTeam2 = " BETWEEN "
                let queryLowerValueOffensivePlaysTeam2 = offensivePlaysTeam2RangeSliderLowerValue
                let queryUpperValueOffensivePlaysTeam2 = offensivePlaysTeam2RangeSliderUpperValue
                queryValueOffensivePlaysTeam2 = String(queryLowerValueOffensivePlaysTeam2) + " AND " + String(queryUpperValueOffensivePlaysTeam2)
                queryStringOffensivePlaysTeam2 = " AND " + queryColumnOffensivePlaysTeam2 + queryOperatorOffensivePlaysTeam2 + queryValueOffensivePlaysTeam2
            } else {
                if offensivePlaysTeam2SliderValue == -10000 {
                    queryStringOffensivePlaysTeam2 = ""
                } else {
                    if offensivePlaysTeam2OperatorValue == "≠" {
                        queryOperatorOffensivePlaysTeam2 = " != "
                    } else {
                        queryOperatorOffensivePlaysTeam2 = " " + offensivePlaysTeam2OperatorValue + " "
                    }
                    queryValueOffensivePlaysTeam2 = String(offensivePlaysTeam2SliderValue)
                    queryStringOffensivePlaysTeam2 = " AND LENGTH(\(queryColumnOffensivePlaysTeam2)) !=0 AND " + queryColumnOffensivePlaysTeam2 + queryOperatorOffensivePlaysTeam2 + queryValueOffensivePlaysTeam2
                }
            }
        }
        
        //print("yardsPerOffensivePlayTeam1SliderFormValue: ")
        //print(yardsPerOffensivePlayTeam1SliderFormValue)
        if clearSliderIndicator == "TEAM: YARDS/OFFENSIVE PLAY" || yardsPerOffensivePlayTeam1SliderFormValue == "-5 & 75" {
            queryStringYardsPerOffensivePlayTeam1 = ""
        } else {
            if yardsPerOffensivePlayTeam1OperatorValue == "< >" {
                queryOperatorYardsPerOffensivePlayTeam1 = " BETWEEN "
                let queryLowerValueYardsPerOffensivePlayTeam1 = yardsPerOffensivePlayTeam1RangeSliderLowerValue
                let queryUpperValueYardsPerOffensivePlayTeam1 = yardsPerOffensivePlayTeam1RangeSliderUpperValue
                queryValueYardsPerOffensivePlayTeam1 = String(queryLowerValueYardsPerOffensivePlayTeam1) + " AND " + String(queryUpperValueYardsPerOffensivePlayTeam1)
                queryStringYardsPerOffensivePlayTeam1 = " AND " + queryColumnYardsPerOffensivePlayTeam1 + queryOperatorYardsPerOffensivePlayTeam1 + queryValueYardsPerOffensivePlayTeam1
            } else {
                if yardsPerOffensivePlayTeam1SliderValue == -10000 {
                    queryStringYardsPerOffensivePlayTeam1 = ""
                } else {
                    if yardsPerOffensivePlayTeam1OperatorValue == "≠" {
                        queryOperatorYardsPerOffensivePlayTeam1 = " != "
                    } else {
                        queryOperatorYardsPerOffensivePlayTeam1 = " " + yardsPerOffensivePlayTeam1OperatorValue + " "
                    }
                    queryValueYardsPerOffensivePlayTeam1 = String(yardsPerOffensivePlayTeam1SliderValue)
                    queryStringYardsPerOffensivePlayTeam1 = " AND LENGTH(\(queryColumnYardsPerOffensivePlayTeam1)) !=0 AND " + queryColumnYardsPerOffensivePlayTeam1 + queryOperatorYardsPerOffensivePlayTeam1 + queryValueYardsPerOffensivePlayTeam1
                }
            }
        }
        
        if clearSliderIndicator == "OPPONENT: YARDS/OFFENSIVE PLAY" || yardsPerOffensivePlayTeam2SliderFormValue == "-5 & 75" {
            queryStringYardsPerOffensivePlayTeam2 = ""
        } else {
            if yardsPerOffensivePlayTeam2OperatorValue == "< >" {
                queryOperatorYardsPerOffensivePlayTeam2 = " BETWEEN "
                let queryLowerValueYardsPerOffensivePlayTeam2 = yardsPerOffensivePlayTeam2RangeSliderLowerValue
                let queryUpperValueYardsPerOffensivePlayTeam2 = yardsPerOffensivePlayTeam2RangeSliderUpperValue
                queryValueYardsPerOffensivePlayTeam2 = String(queryLowerValueYardsPerOffensivePlayTeam2) + " AND " + String(queryUpperValueYardsPerOffensivePlayTeam2)
                queryStringYardsPerOffensivePlayTeam2 = " AND " + queryColumnYardsPerOffensivePlayTeam2 + queryOperatorYardsPerOffensivePlayTeam2 + queryValueYardsPerOffensivePlayTeam2
            } else {
                if yardsPerOffensivePlayTeam2SliderValue == -10000 {
                    queryStringYardsPerOffensivePlayTeam2 = ""
                } else {
                    if yardsPerOffensivePlayTeam2OperatorValue == "≠" {
                        queryOperatorYardsPerOffensivePlayTeam2 = " != "
                    } else {
                        queryOperatorYardsPerOffensivePlayTeam2 = " " + yardsPerOffensivePlayTeam2OperatorValue + " "
                    }
                    queryValueYardsPerOffensivePlayTeam2 = String(yardsPerOffensivePlayTeam2SliderValue)
                    queryStringYardsPerOffensivePlayTeam2 = " AND LENGTH(\(queryColumnYardsPerOffensivePlayTeam2)) !=0 AND " + queryColumnYardsPerOffensivePlayTeam2 + queryOperatorYardsPerOffensivePlayTeam2 + queryValueYardsPerOffensivePlayTeam2
                }
            }
        }
        
        //print("sacksTeam1SliderFormValue: ")
        //print(sacksTeam1SliderFormValue)
        if clearSliderIndicator == "TEAM: SACKS" || sacksTeam1SliderFormValue == "0 & 15" {
            queryStringSacksTeam1 = ""
        } else {
            if sacksTeam1OperatorValue == "< >" {
                queryOperatorSacksTeam1 = " BETWEEN "
                let queryLowerValueSacksTeam1 = sacksTeam1RangeSliderLowerValue
                let queryUpperValueSacksTeam1 = sacksTeam1RangeSliderUpperValue
                queryValueSacksTeam1 = String(queryLowerValueSacksTeam1) + " AND " + String(queryUpperValueSacksTeam1)
                queryStringSacksTeam1 = " AND " + queryColumnSacksTeam1 + queryOperatorSacksTeam1 + queryValueSacksTeam1
            } else {
                if sacksTeam1SliderValue == -10000 {
                    queryStringSacksTeam1 = ""
                } else {
                    if sacksTeam1OperatorValue == "≠" {
                        queryOperatorSacksTeam1 = " != "
                    } else {
                        queryOperatorSacksTeam1 = " " + sacksTeam1OperatorValue + " "
                    }
                    queryValueSacksTeam1 = String(sacksTeam1SliderValue)
                    queryStringSacksTeam1 = " AND LENGTH(\(queryColumnSacksTeam1)) !=0 AND " + queryColumnSacksTeam1 + queryOperatorSacksTeam1 + queryValueSacksTeam1
                }
            }
        }
        
        if clearSliderIndicator == "OPPONENT: SACKS" || sacksTeam2SliderFormValue == "0 & 15" {
            queryStringSacksTeam2 = ""
        } else {
            if sacksTeam2OperatorValue == "< >" {
                queryOperatorSacksTeam2 = " BETWEEN "
                let queryLowerValueSacksTeam2 = sacksTeam2RangeSliderLowerValue
                let queryUpperValueSacksTeam2 = sacksTeam2RangeSliderUpperValue
                queryValueSacksTeam2 = String(queryLowerValueSacksTeam2) + " AND " + String(queryUpperValueSacksTeam2)
                queryStringSacksTeam2 = " AND " + queryColumnSacksTeam2 + queryOperatorSacksTeam2 + queryValueSacksTeam2
            } else {
                if sacksTeam2SliderValue == -10000 {
                    queryStringSacksTeam2 = ""
                } else {
                    if sacksTeam2OperatorValue == "≠" {
                        queryOperatorSacksTeam2 = " != "
                    } else {
                        queryOperatorSacksTeam2 = " " + sacksTeam2OperatorValue + " "
                    }
                    queryValueSacksTeam2 = String(sacksTeam2SliderValue)
                    queryStringSacksTeam2 = " AND LENGTH(\(queryColumnSacksTeam2)) !=0 AND " + queryColumnSacksTeam2 + queryOperatorSacksTeam2 + queryValueSacksTeam2
                }
            }
        }
        
        //print("interceptionsTeam1SliderFormValue: ")
        //print(interceptionsTeam1SliderFormValue)
        if clearSliderIndicator == "TEAM: INTERCEPTIONS" || interceptionsTeam1SliderFormValue == "0 & 15" {
            queryStringInterceptionsTeam1 = ""
        } else {
            if interceptionsTeam1OperatorValue == "< >" {
                queryOperatorInterceptionsTeam1 = " BETWEEN "
                let queryLowerValueInterceptionsTeam1 = interceptionsTeam1RangeSliderLowerValue
                let queryUpperValueInterceptionsTeam1 = interceptionsTeam1RangeSliderUpperValue
                queryValueInterceptionsTeam1 = String(queryLowerValueInterceptionsTeam1) + " AND " + String(queryUpperValueInterceptionsTeam1)
                queryStringInterceptionsTeam1 = " AND " + queryColumnInterceptionsTeam1 + queryOperatorInterceptionsTeam1 + queryValueInterceptionsTeam1
            } else {
                if interceptionsTeam1SliderValue == -10000 {
                    queryStringInterceptionsTeam1 = ""
                } else {
                    if interceptionsTeam1OperatorValue == "≠" {
                        queryOperatorInterceptionsTeam1 = " != "
                    } else {
                        queryOperatorInterceptionsTeam1 = " " + interceptionsTeam1OperatorValue + " "
                    }
                    queryValueInterceptionsTeam1 = String(interceptionsTeam1SliderValue)
                    queryStringInterceptionsTeam1 = " AND LENGTH(\(queryColumnInterceptionsTeam1)) !=0 AND " + queryColumnInterceptionsTeam1 + queryOperatorInterceptionsTeam1 + queryValueInterceptionsTeam1
                }
            }
        }
        
        if clearSliderIndicator == "OPPONENT: INTERCEPTIONS" || interceptionsTeam2SliderFormValue == "0 & 15" {
            queryStringInterceptionsTeam2 = ""
        } else {
            if interceptionsTeam2OperatorValue == "< >" {
                queryOperatorInterceptionsTeam2 = " BETWEEN "
                let queryLowerValueInterceptionsTeam2 = interceptionsTeam2RangeSliderLowerValue
                let queryUpperValueInterceptionsTeam2 = interceptionsTeam2RangeSliderUpperValue
                queryValueInterceptionsTeam2 = String(queryLowerValueInterceptionsTeam2) + " AND " + String(queryUpperValueInterceptionsTeam2)
                queryStringInterceptionsTeam2 = " AND " + queryColumnInterceptionsTeam2 + queryOperatorInterceptionsTeam2 + queryValueInterceptionsTeam2
            } else {
                if interceptionsTeam2SliderValue == -10000 {
                    queryStringInterceptionsTeam2 = ""
                } else {
                    if interceptionsTeam2OperatorValue == "≠" {
                        queryOperatorInterceptionsTeam2 = " != "
                    } else {
                        queryOperatorInterceptionsTeam2 = " " + interceptionsTeam2OperatorValue + " "
                    }
                    queryValueInterceptionsTeam2 = String(interceptionsTeam2SliderValue)
                    queryStringInterceptionsTeam2 = " AND LENGTH(\(queryColumnInterceptionsTeam2)) !=0 AND " + queryColumnInterceptionsTeam2 + queryOperatorInterceptionsTeam2 + queryValueInterceptionsTeam2
                }
                
            }
        }
        
        //print("safetiesTeam1SliderFormValue: ")
        //print(safetiesTeam1SliderFormValue)
        if clearSliderIndicator == "TEAM: SAFETIES" || safetiesTeam1SliderFormValue == "0 & 10" {
            queryValueSafetiesTeam1 = ""
        } else {
            if safetiesTeam1OperatorValue == "< >" {
                queryOperatorSafetiesTeam1 = " BETWEEN "
                let queryLowerValueSafetiesTeam1 = safetiesTeam1RangeSliderLowerValue
                let queryUpperValueSafetiesTeam1 = safetiesTeam1RangeSliderUpperValue
                queryValueSafetiesTeam1 = String(queryLowerValueSafetiesTeam1) + " AND " + String(queryUpperValueSafetiesTeam1)
                queryStringSafetiesTeam1 = " AND " + queryColumnSafetiesTeam1 + queryOperatorSafetiesTeam1 + queryValueSafetiesTeam1
            } else {
                if safetiesTeam1SliderValue == -10000 {
                    queryStringSafetiesTeam1 = ""
                } else {
                    if safetiesTeam1OperatorValue == "≠" {
                        queryOperatorSafetiesTeam1 = " != "
                    } else {
                        queryOperatorSafetiesTeam1 = " " + safetiesTeam1OperatorValue + " "
                    }
                    queryValueSafetiesTeam1 = String(safetiesTeam1SliderValue)
                    queryStringSafetiesTeam1 = " AND LENGTH(\(queryColumnSafetiesTeam1)) !=0 AND " + queryColumnSafetiesTeam1 + queryOperatorSafetiesTeam1 + queryValueSafetiesTeam1
                }
                
            }
        }
        
        if clearSliderIndicator == "OPPONENT: SAFETIES" || safetiesTeam2SliderFormValue == "0 & 10" {
            queryValueSafetiesTeam2 = ""
        } else {
            if safetiesTeam2OperatorValue == "< >" {
                queryOperatorSafetiesTeam2 = " BETWEEN "
                let queryLowerValueSafetiesTeam2 = safetiesTeam2RangeSliderLowerValue
                let queryUpperValueSafetiesTeam2 = safetiesTeam2RangeSliderUpperValue
                queryValueSafetiesTeam2 = String(queryLowerValueSafetiesTeam2) + " AND " + String(queryUpperValueSafetiesTeam2)
                queryStringSafetiesTeam2 = " AND " + queryColumnSafetiesTeam2 + queryOperatorSafetiesTeam2 + queryValueSafetiesTeam2
            } else {
                if safetiesTeam2SliderValue == -10000 {
                    queryStringSafetiesTeam2 = ""
                } else {
                    if safetiesTeam2OperatorValue == "≠" {
                        queryOperatorSafetiesTeam2 = " != "
                    } else {
                        queryOperatorSafetiesTeam2 = " " + safetiesTeam2OperatorValue + " "
                    }
                    queryValueSafetiesTeam2 = String(safetiesTeam2SliderValue)
                    queryStringSafetiesTeam2 = " AND LENGTH(\(queryColumnSafetiesTeam2)) !=0 AND " + queryColumnSafetiesTeam2 + queryOperatorSafetiesTeam2 + queryValueSafetiesTeam2
                }
            }
        }
        
        //print("defensivePlaysTeam1SliderFormValue: ")
        //print(defensivePlaysTeam1SliderFormValue)
        if clearSliderIndicator == "TEAM: DEFENSIVE PLAYS" || defensivePlaysTeam1SliderFormValue == "1 & 120" {
            queryStringDefensivePlaysTeam1 = ""
        } else {
            if defensivePlaysTeam1OperatorValue == "< >" {
                queryOperatorDefensivePlaysTeam1 = " BETWEEN "
                let queryLowerValueDefensivePlaysTeam1 = defensivePlaysTeam1RangeSliderLowerValue
                let queryUpperValueDefensivePlaysTeam1 = defensivePlaysTeam1RangeSliderUpperValue
                queryValueDefensivePlaysTeam1 = String(queryLowerValueDefensivePlaysTeam1) + " AND " + String(queryUpperValueDefensivePlaysTeam1)
                queryStringDefensivePlaysTeam1 = " AND " + queryColumnDefensivePlaysTeam1 + queryOperatorDefensivePlaysTeam1 + queryValueDefensivePlaysTeam1
            } else {
                if defensivePlaysTeam1SliderValue == -10000 {
                    queryStringDefensivePlaysTeam1 = ""
                } else {
                    if defensivePlaysTeam1OperatorValue == "≠" {
                        queryOperatorDefensivePlaysTeam1 = " != "
                    } else {
                        queryOperatorDefensivePlaysTeam1 = " " + defensivePlaysTeam1OperatorValue + " "
                    }
                    queryValueDefensivePlaysTeam1 = String(defensivePlaysTeam1SliderValue)
                    queryStringDefensivePlaysTeam1 = " AND LENGTH(\(queryColumnDefensivePlaysTeam1)) !=0 AND " + queryColumnDefensivePlaysTeam1 + queryOperatorDefensivePlaysTeam1 + queryValueDefensivePlaysTeam1
                }
            }
        }
        
        if clearSliderIndicator == "OPPONENT: DEFENSIVE PLAYS" || defensivePlaysTeam2SliderFormValue == "1 & 120" {
            queryStringDefensivePlaysTeam2 = ""
        } else {
            if defensivePlaysTeam2OperatorValue == "< >" {
                queryOperatorDefensivePlaysTeam2 = " BETWEEN "
                let queryLowerValueDefensivePlaysTeam2 = defensivePlaysTeam2RangeSliderLowerValue
                let queryUpperValueDefensivePlaysTeam2 = defensivePlaysTeam2RangeSliderUpperValue
                queryValueDefensivePlaysTeam2 = String(queryLowerValueDefensivePlaysTeam2) + " AND " + String(queryUpperValueDefensivePlaysTeam2)
                queryStringDefensivePlaysTeam2 = " AND " + queryColumnDefensivePlaysTeam2 + queryOperatorDefensivePlaysTeam2 + queryValueDefensivePlaysTeam2
            } else {
                if defensivePlaysTeam2SliderValue == -10000 {
                    queryStringDefensivePlaysTeam2 = ""
                } else {
                    if defensivePlaysTeam2OperatorValue == "≠" {
                        queryOperatorDefensivePlaysTeam2 = " != "
                    } else {
                        queryOperatorDefensivePlaysTeam2 = " " + defensivePlaysTeam2OperatorValue + " "
                    }
                    queryValueDefensivePlaysTeam2 = String(defensivePlaysTeam2SliderValue)
                    queryStringDefensivePlaysTeam2 = " AND LENGTH(\(queryColumnDefensivePlaysTeam2)) !=0 AND " + queryColumnDefensivePlaysTeam2 + queryOperatorDefensivePlaysTeam2 + queryValueDefensivePlaysTeam2
                }
            }
        }
        
        //print("yardsPerDefensivePlayTeam1SliderFormValue: ")
        //print(yardsPerDefensivePlayTeam1SliderFormValue)
        if clearSliderIndicator == "TEAM: YARDS/DEFENSIVE PLAY" || yardsPerDefensivePlayTeam1SliderFormValue == "5 & 75" {
            queryStringYardsPerDefensivePlayTeam1 = ""
        } else {
            if yardsPerDefensivePlayTeam1OperatorValue == "< >" {
                queryOperatorYardsPerDefensivePlayTeam1 = " BETWEEN "
                let queryLowerValueYardsPerDefensivePlayTeam1 = yardsPerDefensivePlayTeam1RangeSliderLowerValue
                let queryUpperValueYardsPerDefensivePlayTeam1 = yardsPerDefensivePlayTeam1RangeSliderUpperValue
                queryValueYardsPerDefensivePlayTeam1 = String(queryLowerValueYardsPerDefensivePlayTeam1) + " AND " + String(queryUpperValueYardsPerDefensivePlayTeam1)
                queryStringYardsPerDefensivePlayTeam1 = " AND " + queryColumnYardsPerDefensivePlayTeam1 + queryOperatorYardsPerDefensivePlayTeam1 + queryValueYardsPerDefensivePlayTeam1
            } else {
                if yardsPerDefensivePlayTeam1SliderValue == -10000 {
                    queryStringYardsPerDefensivePlayTeam1 = ""
                } else {
                    if yardsPerDefensivePlayTeam1OperatorValue == "≠" {
                        queryOperatorYardsPerDefensivePlayTeam1 = " != "
                    } else {
                        queryOperatorYardsPerDefensivePlayTeam1 = " " + yardsPerDefensivePlayTeam1OperatorValue + " "
                    }
                    queryValueYardsPerDefensivePlayTeam1 = String(yardsPerDefensivePlayTeam1SliderValue)
                    queryStringYardsPerDefensivePlayTeam1 = " AND LENGTH(\(queryColumnYardsPerDefensivePlayTeam1)) !=0 AND " + queryColumnYardsPerDefensivePlayTeam1 + queryOperatorYardsPerDefensivePlayTeam1 + queryValueYardsPerDefensivePlayTeam1
                }
            }
        }
        
        if clearSliderIndicator == "OPPONENT: YARDS/DEFENSIVE PLAY" || yardsPerDefensivePlayTeam2SliderFormValue == "5 & 75" {
            queryStringYardsPerDefensivePlayTeam2 = ""
        } else {
            if yardsPerDefensivePlayTeam2OperatorValue == "< >" {
                queryOperatorYardsPerDefensivePlayTeam2 = " BETWEEN "
                let queryLowerValueYardsPerDefensivePlayTeam2 = yardsPerDefensivePlayTeam2RangeSliderLowerValue
                let queryUpperValueYardsPerDefensivePlayTeam2 = yardsPerDefensivePlayTeam2RangeSliderUpperValue
                queryValueYardsPerDefensivePlayTeam2 = String(queryLowerValueYardsPerDefensivePlayTeam2) + " AND " + String(queryUpperValueYardsPerDefensivePlayTeam2)
                queryStringYardsPerDefensivePlayTeam2 = " AND " + queryColumnYardsPerDefensivePlayTeam2 + queryOperatorYardsPerDefensivePlayTeam2 + queryValueYardsPerDefensivePlayTeam2
            } else {
                if yardsPerDefensivePlayTeam2SliderValue == -10000 {
                    queryStringYardsPerDefensivePlayTeam2 = ""
                } else {
                    if yardsPerDefensivePlayTeam2OperatorValue == "≠" {
                        queryOperatorYardsPerDefensivePlayTeam2 = " != "
                    } else {
                        queryOperatorYardsPerDefensivePlayTeam2 = " " + yardsPerDefensivePlayTeam2OperatorValue + " "
                    }
                    queryValueYardsPerDefensivePlayTeam2 = String(yardsPerDefensivePlayTeam2SliderValue)
                    queryStringYardsPerDefensivePlayTeam2 = " AND LENGTH(\(queryColumnYardsPerDefensivePlayTeam2)) !=0 AND " + queryColumnYardsPerDefensivePlayTeam2 + queryOperatorYardsPerDefensivePlayTeam2 + queryValueYardsPerDefensivePlayTeam2
                }
            }
        }
        
        //print("extraPointAttemptsTeam1SliderFormValue: ")
        //print(extraPointAttemptsTeam1SliderFormValue)
        if clearSliderIndicator == "TEAM: EXTRA POINT ATTEMPTS" || extraPointAttemptsTeam1SliderFormValue == "0 & 15" {
            queryStringExtraPointAttemptsTeam1 = ""
        } else {
            if extraPointAttemptsTeam1OperatorValue == "< >" {
                queryOperatorExtraPointAttemptsTeam1 = " BETWEEN "
                let queryLowerValueExtraPointAttemptsTeam1 = extraPointAttemptsTeam1RangeSliderLowerValue
                let queryUpperValueExtraPointAttemptsTeam1 = extraPointAttemptsTeam1RangeSliderUpperValue
                queryValueExtraPointAttemptsTeam1 = String(queryLowerValueExtraPointAttemptsTeam1) + " AND " + String(queryUpperValueExtraPointAttemptsTeam1)
                queryStringExtraPointAttemptsTeam1 = " AND " + queryColumnExtraPointAttemptsTeam1 + queryOperatorExtraPointAttemptsTeam1 + queryValueExtraPointAttemptsTeam1
            } else {
                if extraPointAttemptsTeam1SliderValue == -10000 {
                    queryStringExtraPointAttemptsTeam1 = ""
                } else {
                    if extraPointAttemptsTeam1OperatorValue == "≠" {
                        queryOperatorExtraPointAttemptsTeam1 = " != "
                    } else {
                        queryOperatorExtraPointAttemptsTeam1 = " " + extraPointAttemptsTeam1OperatorValue + " "
                    }
                    queryValueExtraPointAttemptsTeam1 = String(extraPointAttemptsTeam1SliderValue)
                    queryStringExtraPointAttemptsTeam1 = " AND LENGTH(\(queryColumnExtraPointAttemptsTeam1)) !=0 AND " + queryColumnExtraPointAttemptsTeam1 + queryOperatorExtraPointAttemptsTeam1 + queryValueExtraPointAttemptsTeam1
                }
            }
        }
        
        if clearSliderIndicator == "OPPONENT: EXTRA POINTS ATTEMPTS" || extraPointAttemptsTeam2SliderFormValue == "0 & 15" {
            queryStringExtraPointAttemptsTeam2 = ""
        } else {
            if extraPointAttemptsTeam2OperatorValue == "< >" {
                queryOperatorExtraPointAttemptsTeam2 = " BETWEEN "
                let queryLowerValueExtraPointAttemptsTeam2 = extraPointAttemptsTeam2RangeSliderLowerValue
                let queryUpperValueExtraPointAttemptsTeam2 = extraPointAttemptsTeam2RangeSliderUpperValue
                queryValueExtraPointAttemptsTeam2 = String(queryLowerValueExtraPointAttemptsTeam2) + " AND " + String(queryUpperValueExtraPointAttemptsTeam2)
                queryStringExtraPointAttemptsTeam2 = " AND " + queryColumnExtraPointAttemptsTeam2 + queryOperatorExtraPointAttemptsTeam2 + queryValueExtraPointAttemptsTeam2
            } else {
                if extraPointAttemptsTeam2SliderValue == -10000 {
                    queryStringExtraPointAttemptsTeam2 = ""
                } else {
                    if extraPointAttemptsTeam2OperatorValue == "≠" {
                        queryOperatorExtraPointAttemptsTeam2 = " != "
                    } else {
                        queryOperatorExtraPointAttemptsTeam2 = " " + extraPointAttemptsTeam2OperatorValue + " "
                    }
                    queryValueExtraPointAttemptsTeam2 = String(extraPointAttemptsTeam2SliderValue)
                    queryStringExtraPointAttemptsTeam2 = " AND LENGTH(\(queryColumnExtraPointAttemptsTeam2)) !=0 AND " + queryColumnExtraPointAttemptsTeam2 + queryOperatorExtraPointAttemptsTeam2 + queryValueExtraPointAttemptsTeam2
                }
            }
        }
        
        //print("extraPointsMadeTeam1SliderFormValue: ")
        //print(extraPointsMadeTeam1SliderFormValue)
        if clearSliderIndicator == "TEAM: EXTRA POINTS MADE" || extraPointsMadeTeam1SliderFormValue == "0 & 15" {
            queryStringExtraPointsMadeTeam1 = ""
        } else {
            if extraPointsMadeTeam1OperatorValue == "< >" {
                queryOperatorExtraPointsMadeTeam1 = " BETWEEN "
                let queryLowerValueExtraPointsMadeTeam1 = extraPointsMadeTeam1RangeSliderLowerValue
                let queryUpperValueExtraPointsMadeTeam1 = extraPointsMadeTeam1RangeSliderUpperValue
                queryValueExtraPointsMadeTeam1 = String(queryLowerValueExtraPointsMadeTeam1) + " AND " + String(queryUpperValueExtraPointsMadeTeam1)
                queryStringExtraPointsMadeTeam1 = " AND " + queryColumnExtraPointsMadeTeam1 + queryOperatorExtraPointsMadeTeam1 + queryValueExtraPointsMadeTeam1
            } else {
                if extraPointsMadeTeam1SliderValue == -10000 {
                    queryStringExtraPointsMadeTeam1 = ""
                } else {
                    if extraPointsMadeTeam1OperatorValue == "≠" {
                        queryOperatorExtraPointsMadeTeam1 = " != "
                    } else {
                        queryOperatorExtraPointsMadeTeam1 = " " + extraPointsMadeTeam1OperatorValue + " "
                    }
                    queryValueExtraPointsMadeTeam1 = String(extraPointsMadeTeam1SliderValue)
                    queryStringExtraPointsMadeTeam1 = " AND LENGTH(\(queryColumnExtraPointsMadeTeam1)) !=0 AND " + queryColumnExtraPointsMadeTeam1 + queryOperatorExtraPointsMadeTeam1 + queryValueExtraPointsMadeTeam1
                }
            }
        }
        
        if clearSliderIndicator == "OPPONENT: EXTRA POINTS MADE" || extraPointsMadeTeam2SliderFormValue == "0 & 15" {
            queryStringExtraPointsMadeTeam2 = ""
        } else {
            if extraPointsMadeTeam2OperatorValue == "< >" {
                queryOperatorExtraPointsMadeTeam2 = " BETWEEN "
                let queryLowerValueExtraPointsMadeTeam2 = extraPointsMadeTeam2RangeSliderLowerValue
                let queryUpperValueExtraPointsMadeTeam2 = extraPointsMadeTeam2RangeSliderUpperValue
                queryValueExtraPointsMadeTeam2 = String(queryLowerValueExtraPointsMadeTeam2) + " AND " + String(queryUpperValueExtraPointsMadeTeam2)
                queryStringExtraPointsMadeTeam2 = " AND " + queryColumnExtraPointsMadeTeam2 + queryOperatorExtraPointsMadeTeam2 + queryValueExtraPointsMadeTeam2
            } else {
                if extraPointsMadeTeam2SliderValue == -10000 {
                    queryStringExtraPointsMadeTeam2 = ""
                } else {
                    if extraPointsMadeTeam2OperatorValue == "≠" {
                        queryOperatorExtraPointsMadeTeam2 = " != "
                    } else {
                        queryOperatorExtraPointsMadeTeam2 = " " + extraPointsMadeTeam2OperatorValue + " "
                    }
                    queryValueExtraPointsMadeTeam2 = String(extraPointsMadeTeam2SliderValue)
                    queryStringExtraPointsMadeTeam2 = " AND LENGTH(\(queryColumnExtraPointsMadeTeam2)) !=0 AND " + queryColumnExtraPointsMadeTeam2 + queryOperatorExtraPointsMadeTeam2 + queryValueExtraPointsMadeTeam2
                }
            }
        }
        
        //print("fieldGoalAttemptsTeam1SliderFormValue: ")
        //print(fieldGoalAttemptsTeam1SliderFormValue)
        if clearSliderIndicator == "TEAM: FIELD GOAL ATTEMPTS" || fieldGoalAttemptsTeam1SliderFormValue == "0 & 15" {
            queryStringFieldGoalAttemptsTeam1 = ""
        } else {
            if fieldGoalAttemptsTeam1OperatorValue == "< >" {
                queryOperatorFieldGoalAttemptsTeam1 = " BETWEEN "
                let queryLowerValueFieldGoalAttemptsTeam1 = fieldGoalAttemptsTeam1RangeSliderLowerValue
                let queryUpperValueFieldGoalAttemptsTeam1 = fieldGoalAttemptsTeam1RangeSliderUpperValue
                queryValueFieldGoalAttemptsTeam1 = String(queryLowerValueFieldGoalAttemptsTeam1) + " AND " + String(queryUpperValueFieldGoalAttemptsTeam1)
                queryStringFieldGoalAttemptsTeam1 = " AND " + queryColumnFieldGoalAttemptsTeam1 + queryOperatorFieldGoalAttemptsTeam1 + queryValueFieldGoalAttemptsTeam1
            } else {
                if fieldGoalAttemptsTeam1SliderValue == -10000 {
                    queryStringFieldGoalAttemptsTeam1 = ""
                } else {
                    if fieldGoalAttemptsTeam1OperatorValue == "≠" {
                        queryOperatorFieldGoalAttemptsTeam1 = " != "
                    } else {
                        queryOperatorFieldGoalAttemptsTeam1 = " " + fieldGoalAttemptsTeam1OperatorValue + " "
                    }
                    queryValueFieldGoalAttemptsTeam1 = String(fieldGoalAttemptsTeam1SliderValue)
                    queryStringFieldGoalAttemptsTeam1 = " AND LENGTH(\(queryColumnFieldGoalAttemptsTeam1)) !=0 AND " + queryColumnFieldGoalAttemptsTeam1 + queryOperatorFieldGoalAttemptsTeam1 + queryValueFieldGoalAttemptsTeam1
                }
            }
        }
        
        if clearSliderIndicator == "OPPONENT: FIELD GOAL ATTEMPTS" || fieldGoalAttemptsTeam2SliderFormValue == "0 & 15" {
            queryStringFieldGoalAttemptsTeam2 = ""
        } else {
            if fieldGoalAttemptsTeam2OperatorValue == "< >" {
                queryOperatorFieldGoalAttemptsTeam2 = " BETWEEN "
                let queryLowerValueFieldGoalAttemptsTeam2 = fieldGoalAttemptsTeam2RangeSliderLowerValue
                let queryUpperValueFieldGoalAttemptsTeam2 = fieldGoalAttemptsTeam2RangeSliderUpperValue
                queryValueFieldGoalAttemptsTeam2 = String(queryLowerValueFieldGoalAttemptsTeam2) + " AND " + String(queryUpperValueFieldGoalAttemptsTeam2)
                queryStringFieldGoalAttemptsTeam2 = " AND " + queryColumnFieldGoalAttemptsTeam2 + queryOperatorFieldGoalAttemptsTeam2 + queryValueFieldGoalAttemptsTeam2
            } else {
                if fieldGoalAttemptsTeam2SliderValue == -10000 {
                    queryStringFieldGoalAttemptsTeam2 = ""
                } else {
                    if fieldGoalAttemptsTeam2OperatorValue == "≠" {
                        queryOperatorFieldGoalAttemptsTeam2 = " != "
                    } else {
                        queryOperatorFieldGoalAttemptsTeam2 = " " + fieldGoalAttemptsTeam2OperatorValue + " "
                    }
                    queryValueFieldGoalAttemptsTeam2 = String(fieldGoalAttemptsTeam2SliderValue)
                    queryStringFieldGoalAttemptsTeam2 = " AND LENGTH(\(queryColumnFieldGoalAttemptsTeam2)) !=0 AND " + queryColumnFieldGoalAttemptsTeam2 + queryOperatorFieldGoalAttemptsTeam2 + queryValueFieldGoalAttemptsTeam2
                }
            }
        }
        
        //print("fieldGoalsMadeTeam1SliderFormValue: ")
        //print(fieldGoalsMadeTeam1SliderFormValue)
        if clearSliderIndicator == "TEAM: FIELD GOALS MADE" || fieldGoalsMadeTeam1SliderFormValue == "0 & 15" {
            queryStringFieldGoalsMadeTeam1 = ""
        } else {
            if fieldGoalsMadeTeam1OperatorValue == "< >" {
                queryOperatorFieldGoalsMadeTeam1 = " BETWEEN "
                let queryLowerValueFieldGoalsMadeTeam1 = fieldGoalsMadeTeam1RangeSliderLowerValue
                let queryUpperValueFieldGoalsMadeTeam1 = fieldGoalsMadeTeam1RangeSliderUpperValue
                queryValueFieldGoalsMadeTeam1 = String(queryLowerValueFieldGoalsMadeTeam1) + " AND " + String(queryUpperValueFieldGoalsMadeTeam1)
                queryStringFieldGoalsMadeTeam1 = " AND " + queryColumnFieldGoalsMadeTeam1 + queryOperatorFieldGoalsMadeTeam1 + queryValueFieldGoalsMadeTeam1
            } else {
                if fieldGoalsMadeTeam1SliderValue == -10000 {
                    queryStringFieldGoalsMadeTeam1 = ""
                } else {
                    if fieldGoalsMadeTeam1OperatorValue == "≠" {
                        queryOperatorFieldGoalsMadeTeam1 = " != "
                    } else {
                        queryOperatorFieldGoalsMadeTeam1 = " " + fieldGoalsMadeTeam1OperatorValue + " "
                    }
                    queryValueFieldGoalsMadeTeam1 = String(fieldGoalsMadeTeam1SliderValue)
                    queryStringFieldGoalsMadeTeam1 = " AND LENGTH(\(queryColumnFieldGoalsMadeTeam1)) !=0 AND " + queryColumnFieldGoalsMadeTeam1 + queryOperatorFieldGoalsMadeTeam1 + queryValueFieldGoalsMadeTeam1
                }
            }
        }
        
        if clearSliderIndicator == "OPPONENT: FIELD GOALS MADE" || fieldGoalsMadeTeam2SliderFormValue == "0 & 15" {
            queryStringFieldGoalsMadeTeam2 = ""
        } else {
            if fieldGoalsMadeTeam2OperatorValue == "< >" {
                queryOperatorFieldGoalsMadeTeam2 = " BETWEEN "
                let queryLowerValueFieldGoalsMadeTeam2 = fieldGoalsMadeTeam2RangeSliderLowerValue
                let queryUpperValueFieldGoalsMadeTeam2 = fieldGoalsMadeTeam2RangeSliderUpperValue
                queryValueFieldGoalsMadeTeam2 = String(queryLowerValueFieldGoalsMadeTeam2) + " AND " + String(queryUpperValueFieldGoalsMadeTeam2)
                queryStringFieldGoalsMadeTeam2 = " AND " + queryColumnFieldGoalsMadeTeam2 + queryOperatorFieldGoalsMadeTeam2 + queryValueFieldGoalsMadeTeam2
            } else {
                if fieldGoalsMadeTeam2SliderValue == -10000 {
                    queryStringFieldGoalsMadeTeam2 = ""
                } else {
                    if fieldGoalsMadeTeam2OperatorValue == "≠" {
                        queryOperatorFieldGoalsMadeTeam2 = " != "
                    } else {
                        queryOperatorFieldGoalsMadeTeam2 = " " + fieldGoalsMadeTeam2OperatorValue + " "
                    }
                    queryValueFieldGoalsMadeTeam2 = String(fieldGoalsMadeTeam2SliderValue)
                    queryStringFieldGoalsMadeTeam2 = " AND LENGTH(\(queryColumnFieldGoalsMadeTeam2)) !=0 AND " + queryColumnFieldGoalsMadeTeam2 + queryOperatorFieldGoalsMadeTeam2 + queryValueFieldGoalsMadeTeam2
                }
            }
        }
        
        //print("puntsTeam1SliderValue: ")
        //print(puntsTeam1SliderValue)
        if clearSliderIndicator == "TEAM: PUNTS" || puntsTeam1SliderFormValue == "0 & 15" {
            queryStringPuntsTeam1 = ""
        } else {
            if puntsTeam1OperatorValue == "< >" {
                queryOperatorPuntsTeam1 = " BETWEEN "
                let queryLowerValuePuntsTeam1 = puntsTeam1RangeSliderLowerValue
                let queryUpperValuePuntsTeam1 = puntsTeam1RangeSliderUpperValue
                queryValuePuntsTeam1 = String(queryLowerValuePuntsTeam1) + " AND " + String(queryUpperValuePuntsTeam1)
                queryStringPuntsTeam1 = " AND " + queryColumnPuntsTeam1 + queryOperatorPuntsTeam1 + queryValuePuntsTeam1
            } else {
                if puntsTeam1SliderValue == -10000 {
                    queryStringPuntsTeam1 = ""
                } else {
                    if puntsTeam1OperatorValue == "≠" {
                        queryOperatorPuntsTeam1 = " != "
                    } else {
                        queryOperatorPuntsTeam1 = " " + puntsTeam1OperatorValue + " "
                    }
                    queryValuePuntsTeam1 = String(puntsTeam1SliderValue)
                    queryStringPuntsTeam1 = " AND LENGTH(\(queryColumnPuntsTeam1)) !=0 AND " + queryColumnPuntsTeam1 + queryOperatorPuntsTeam1 + queryValuePuntsTeam1
                }
            }
        }
        
        if clearSliderIndicator == "OPPONENT: PUNTS" || puntsTeam2SliderFormValue == "0 & 15" {
            queryStringPuntsTeam2 = ""
        } else {
            if puntsTeam2OperatorValue == "< >" {
                queryOperatorPuntsTeam2 = " BETWEEN "
                let queryLowerValuePuntsTeam2 = puntsTeam2RangeSliderLowerValue
                let queryUpperValuePuntsTeam2 = puntsTeam2RangeSliderUpperValue
                queryValuePuntsTeam2 = String(queryLowerValuePuntsTeam2) + " AND " + String(queryUpperValuePuntsTeam2)
                queryStringPuntsTeam2 = " AND " + queryColumnPuntsTeam2 + queryOperatorPuntsTeam2 + queryValuePuntsTeam2
            } else {
                if puntsTeam2SliderValue == -10000 {
                    queryStringPuntsTeam2 = ""
                } else {
                    if puntsTeam2OperatorValue == "≠" {
                        queryOperatorPuntsTeam2 = " != "
                    } else {
                        queryOperatorPuntsTeam2 = " " + puntsTeam2OperatorValue + " "
                    }
                    queryValuePuntsTeam2 = String(puntsTeam2SliderValue)
                    queryStringPuntsTeam2 = " AND LENGTH(\(queryColumnPuntsTeam2)) !=0 AND " + queryColumnPuntsTeam2 + queryOperatorPuntsTeam2 + queryValuePuntsTeam2
                }
            }
        }
        
        //print("puntYardsTeam1SliderValue: ")
        //print(puntYardsTeam1SliderValue)
        if clearSliderIndicator == "TEAM: PUNT YARDS" || puntYardsTeam1SliderFormValue == "0 & 300" {
            queryStringPuntYardsTeam1 = ""
        } else {
            if puntYardsTeam1OperatorValue == "< >" {
                queryOperatorPuntYardsTeam1 = " BETWEEN "
                let queryLowerValuePuntYardsTeam1 = puntYardsTeam1RangeSliderLowerValue
                let queryUpperValuePuntYardsTeam1 = puntYardsTeam1RangeSliderUpperValue
                queryValuePuntYardsTeam1 = String(queryLowerValuePuntYardsTeam1) + " AND " + String(queryUpperValuePuntYardsTeam1)
                queryStringPuntYardsTeam1 = " AND " + queryColumnPuntYardsTeam1 + queryOperatorPuntYardsTeam1 + queryValuePuntYardsTeam1
            } else {
                if puntYardsTeam1SliderValue == -10000 {
                    queryStringPuntYardsTeam1 = ""
                } else {
                    if puntYardsTeam1OperatorValue == "≠" {
                        queryOperatorPuntYardsTeam1 = " != "
                    } else {
                        queryOperatorPuntYardsTeam1 = " " + puntYardsTeam1OperatorValue + " "
                    }
                    queryValuePuntYardsTeam1 = String(puntYardsTeam1SliderValue)
                    queryStringPuntYardsTeam1 = " AND LENGTH(\(queryColumnPuntYardsTeam1)) !=0 AND " + queryColumnPuntYardsTeam1 + queryOperatorPuntYardsTeam1 + queryValuePuntYardsTeam1
                }
            }
        }
        
        if clearSliderIndicator == "OPPONENT: PUNT YARDS" || puntYardsTeam2SliderFormValue == "0 & 300" {
            queryStringPuntYardsTeam2 = ""
        } else {
            if puntYardsTeam2OperatorValue == "< >" {
                queryOperatorPuntYardsTeam2 = " BETWEEN "
                let queryLowerValuePuntYardsTeam2 = puntYardsTeam2RangeSliderLowerValue
                let queryUpperValuePuntYardsTeam2 = puntYardsTeam2RangeSliderUpperValue
                queryValuePuntYardsTeam2 = String(queryLowerValuePuntYardsTeam2) + " AND " + String(queryUpperValuePuntYardsTeam2)
                queryStringPuntYardsTeam2 = " AND " + queryColumnPuntYardsTeam2 + queryOperatorPuntYardsTeam2 + queryValuePuntYardsTeam2
            } else {
                if puntYardsTeam2SliderValue == -10000 {
                    queryStringPuntYardsTeam2 = ""
                } else {
                    if puntYardsTeam2OperatorValue == "≠" {
                        queryOperatorPuntYardsTeam2 = " != "
                    } else {
                        queryOperatorPuntYardsTeam2 = " " + puntYardsTeam2OperatorValue + " "
                    }
                    queryValuePuntYardsTeam2 = String(puntYardsTeam2SliderValue)
                    queryStringPuntYardsTeam2 = " AND LENGTH(\(queryColumnPuntYardsTeam2)) !=0 AND " + queryColumnPuntYardsTeam2 + queryOperatorPuntYardsTeam2 + queryValuePuntYardsTeam2
                }
            }
        }
        if queryStringTeam1 == "" && queryStringTeam2 != "" && queryStringPlayers == "" && queryStringplayerOpponent == "" {
            print("-1- queryStringTeam1 == [BLANK] && queryStringTeam2 != [BLANK] && queryStringPlayers == [BLANK]")
            queryFromFilters = queryColumnTeam2 + queryOperatorTeam2 + queryValueTeam2 + queryStringTeam1 + queryStringSpreadTeam1 + queryStringOverUnder + queryStringWinningLosingStreakTeam1 + queryStringWinningLosingStreakTeam2 + queryStringSeasonWinPercentageTeam1 + queryStringSeasonWinPercentageTeam2 + queryStringHomeTeam + queryStringFavorite + queryStringPlayers + queryStringplayerOpponent + queryStringSeason + queryStringWeek + queryStringGameNumber + queryStringDay + queryStringStadium + queryStringSurface + queryStringTemperature + queryStringTotalPointsTeam1 + queryStringTotalPointsTeam2 + queryStringTouchdownsTeam1 + queryStringTouchdownsTeam2 + queryStringOffensiveTouchdownsTeam1 + queryStringDefensiveTouchdownsTeam1 + queryStringOffensiveTouchdownsTeam2 + queryStringDefensiveTouchdownsTeam2 + queryStringTurnoversCommittedTeam1 + queryStringTurnoversCommittedTeam2 + queryStringPenaltiesCommittedTeam1 + queryStringPenaltiesCommittedTeam2 + queryStringTotalYardsTeam1 + queryStringTotalYardsTeam2 + queryStringPassingYardsTeam1 + queryStringPassingYardsTeam2 + queryStringRushingYardsTeam1 + queryStringRushingYardsTeam2 + queryStringQuarterbackRatingTeam1 + queryStringQuarterbackRatingTeam2 + queryStringTimesSackedTeam1 + queryStringTimesSackedTeam2 + queryStringInterceptionsThrownTeam1 + queryStringInterceptionsThrownTeam2 + queryStringOffensivePlaysTeam1 + queryStringOffensivePlaysTeam2 + queryStringYardsPerOffensivePlayTeam1 + queryStringYardsPerOffensivePlayTeam2 + queryStringSacksTeam1 + queryStringSacksTeam2 + queryStringInterceptionsTeam1 + queryStringInterceptionsTeam2 + queryStringSafetiesTeam1 + queryStringSafetiesTeam2 + queryStringDefensivePlaysTeam1 + queryStringDefensivePlaysTeam2 + queryStringYardsPerDefensivePlayTeam1 + queryStringYardsPerDefensivePlayTeam2 + queryStringExtraPointAttemptsTeam1 + queryStringExtraPointAttemptsTeam2 + queryStringExtraPointsMadeTeam1 + queryStringExtraPointsMadeTeam2 + queryStringFieldGoalAttemptsTeam1 + queryStringFieldGoalAttemptsTeam2 + queryStringFieldGoalsMadeTeam1 + queryStringFieldGoalsMadeTeam2 + queryStringPuntsTeam1 + queryStringPuntsTeam2 + queryStringPuntYardsTeam1 + queryStringPuntYardsTeam2
        } else if queryStringTeam1 == "" && queryStringTeam2 != "" && (queryStringPlayers != "" || queryStringplayerOpponent != "") {
            print("-2- queryStringTeam1 == [BLANK] && queryStringTeam2 != [BLANK] && queryStringPlayers != [BLANK]")
            queryFromFilters = queryColumnTeam2 + queryOperatorTeam2 + queryValueTeam2 + queryStringTeam1 + queryStringSpreadTeam1 + queryStringOverUnder + queryStringWinningLosingStreakTeam1 + queryStringWinningLosingStreakTeam2 + queryStringSeasonWinPercentageTeam1 + queryStringSeasonWinPercentageTeam2 + queryStringHomeTeam + queryStringFavorite + queryStringPlayers + queryStringplayerOpponent + queryStringSeason + queryStringWeek + queryStringGameNumber + queryStringDay + queryStringStadium + queryStringSurface + queryStringTemperature + queryStringTotalPointsTeam1 + queryStringTotalPointsTeam2 + queryStringTouchdownsTeam1 + queryStringTouchdownsTeam2 + queryStringOffensiveTouchdownsTeam1 + queryStringDefensiveTouchdownsTeam1 + queryStringOffensiveTouchdownsTeam2 + queryStringDefensiveTouchdownsTeam2 + queryStringTurnoversCommittedTeam1 + queryStringTurnoversCommittedTeam2 + queryStringPenaltiesCommittedTeam1 + queryStringPenaltiesCommittedTeam2 + queryStringTotalYardsTeam1 + queryStringTotalYardsTeam2 + queryStringPassingYardsTeam1 + queryStringPassingYardsTeam2 + queryStringRushingYardsTeam1 + queryStringRushingYardsTeam2 + queryStringQuarterbackRatingTeam1 + queryStringQuarterbackRatingTeam2 + queryStringTimesSackedTeam1 + queryStringTimesSackedTeam2 + queryStringInterceptionsThrownTeam1 + queryStringInterceptionsThrownTeam2 + queryStringOffensivePlaysTeam1 + queryStringOffensivePlaysTeam2 + queryStringYardsPerOffensivePlayTeam1 + queryStringYardsPerOffensivePlayTeam2 + queryStringSacksTeam1 + queryStringSacksTeam2 + queryStringInterceptionsTeam1 + queryStringInterceptionsTeam2 + queryStringSafetiesTeam1 + queryStringSafetiesTeam2 + queryStringDefensivePlaysTeam1 + queryStringDefensivePlaysTeam2 + queryStringYardsPerDefensivePlayTeam1 + queryStringYardsPerDefensivePlayTeam2 + queryStringExtraPointAttemptsTeam1 + queryStringExtraPointAttemptsTeam2 + queryStringExtraPointsMadeTeam1 + queryStringExtraPointsMadeTeam2 + queryStringFieldGoalAttemptsTeam1 + queryStringFieldGoalAttemptsTeam2 + queryStringFieldGoalsMadeTeam1 + queryStringFieldGoalsMadeTeam2 + queryStringPuntsTeam1 + queryStringPuntsTeam2 + queryStringPuntYardsTeam1 + queryStringPuntYardsTeam2
        } else if queryStringTeam1 != "" && queryStringTeam2 == "" && queryStringPlayers == "" && queryStringplayerOpponent == "" {
            print("-3- queryStringTeam1 != [BLANK] && queryStringTeam2 == [BLANK] && queryStringPlayers == [BLANK]")
            queryFromFilters = queryColumnTeam1 + queryOperatorTeam1 + queryValueTeam1 + queryStringTeam2 + queryStringSpreadTeam1 + queryStringOverUnder + queryStringWinningLosingStreakTeam1 + queryStringWinningLosingStreakTeam2 + queryStringSeasonWinPercentageTeam1 + queryStringSeasonWinPercentageTeam2 + queryStringHomeTeam + queryStringFavorite + queryStringPlayers + queryStringplayerOpponent + queryStringSeason + queryStringWeek + queryStringGameNumber + queryStringDay + queryStringStadium + queryStringSurface + queryStringTemperature + queryStringTotalPointsTeam1 + queryStringTotalPointsTeam2 + queryStringTouchdownsTeam1 + queryStringTouchdownsTeam2 + queryStringOffensiveTouchdownsTeam1 + queryStringDefensiveTouchdownsTeam1 + queryStringOffensiveTouchdownsTeam2 + queryStringDefensiveTouchdownsTeam2 + queryStringTurnoversCommittedTeam1 + queryStringTurnoversCommittedTeam2 + queryStringPenaltiesCommittedTeam1 + queryStringPenaltiesCommittedTeam2 + queryStringTotalYardsTeam1 + queryStringTotalYardsTeam2 + queryStringPassingYardsTeam1 + queryStringPassingYardsTeam2 + queryStringRushingYardsTeam1 + queryStringRushingYardsTeam2 + queryStringQuarterbackRatingTeam1 + queryStringQuarterbackRatingTeam2 + queryStringTimesSackedTeam1 + queryStringTimesSackedTeam2 + queryStringInterceptionsThrownTeam1 + queryStringInterceptionsThrownTeam2 + queryStringOffensivePlaysTeam1 + queryStringOffensivePlaysTeam2 + queryStringYardsPerOffensivePlayTeam1 + queryStringYardsPerOffensivePlayTeam2 + queryStringSacksTeam1 + queryStringSacksTeam2 + queryStringInterceptionsTeam1 + queryStringInterceptionsTeam2 + queryStringSafetiesTeam1 + queryStringSafetiesTeam2 + queryStringDefensivePlaysTeam1 + queryStringDefensivePlaysTeam2 + queryStringYardsPerDefensivePlayTeam1 + queryStringYardsPerDefensivePlayTeam2 + queryStringExtraPointAttemptsTeam1 + queryStringExtraPointAttemptsTeam2 + queryStringExtraPointsMadeTeam1 + queryStringExtraPointsMadeTeam2 + queryStringFieldGoalAttemptsTeam1 + queryStringFieldGoalAttemptsTeam2 + queryStringFieldGoalsMadeTeam1 + queryStringFieldGoalsMadeTeam2 + queryStringPuntsTeam1 + queryStringPuntsTeam2 + queryStringPuntYardsTeam1 + queryStringPuntYardsTeam2
        } else if queryStringTeam1 != "" && queryStringTeam2 == "" && (queryStringPlayers != "" || queryStringplayerOpponent != "") {
            print("-4- queryStringTeam1 != [BLANK] && queryStringTeam2 == [BLANK] && queryStringPlayers != [BLANK]")
            queryFromFilters = queryColumnTeam1 + queryOperatorTeam1 + queryValueTeam1 + queryStringTeam2 + queryStringSpreadTeam1 + queryStringOverUnder + queryStringWinningLosingStreakTeam1 + queryStringWinningLosingStreakTeam2 + queryStringSeasonWinPercentageTeam1 + queryStringSeasonWinPercentageTeam2 + queryStringHomeTeam + queryStringFavorite + queryStringPlayers + queryStringplayerOpponent + queryStringSeason + queryStringWeek + queryStringGameNumber + queryStringDay + queryStringStadium + queryStringSurface + queryStringTemperature + queryStringTotalPointsTeam1 + queryStringTotalPointsTeam2 + queryStringTouchdownsTeam1 + queryStringTouchdownsTeam2 + queryStringOffensiveTouchdownsTeam1 + queryStringDefensiveTouchdownsTeam1 + queryStringOffensiveTouchdownsTeam2 + queryStringDefensiveTouchdownsTeam2 + queryStringTurnoversCommittedTeam1 + queryStringTurnoversCommittedTeam2 + queryStringPenaltiesCommittedTeam1 + queryStringPenaltiesCommittedTeam2 + queryStringTotalYardsTeam1 + queryStringTotalYardsTeam2 + queryStringPassingYardsTeam1 + queryStringPassingYardsTeam2 + queryStringRushingYardsTeam1 + queryStringRushingYardsTeam2 + queryStringQuarterbackRatingTeam1 + queryStringQuarterbackRatingTeam2 + queryStringTimesSackedTeam1 + queryStringTimesSackedTeam2 + queryStringInterceptionsThrownTeam1 + queryStringInterceptionsThrownTeam2 + queryStringOffensivePlaysTeam1 + queryStringOffensivePlaysTeam2 + queryStringYardsPerOffensivePlayTeam1 + queryStringYardsPerOffensivePlayTeam2 + queryStringSacksTeam1 + queryStringSacksTeam2 + queryStringInterceptionsTeam1 + queryStringInterceptionsTeam2 + queryStringSafetiesTeam1 + queryStringSafetiesTeam2 + queryStringDefensivePlaysTeam1 + queryStringDefensivePlaysTeam2 + queryStringYardsPerDefensivePlayTeam1 + queryStringYardsPerDefensivePlayTeam2 + queryStringExtraPointAttemptsTeam1 + queryStringExtraPointAttemptsTeam2 + queryStringExtraPointsMadeTeam1 + queryStringExtraPointsMadeTeam2 + queryStringFieldGoalAttemptsTeam1 + queryStringFieldGoalAttemptsTeam2 + queryStringFieldGoalsMadeTeam1 + queryStringFieldGoalsMadeTeam2 + queryStringPuntsTeam1 + queryStringPuntsTeam2 + queryStringPuntYardsTeam1 + queryStringPuntYardsTeam2
        } else if queryStringTeam1 != "" && queryStringTeam2 != ""  && queryStringPlayers == "" && queryStringplayerOpponent == "" {
            print("-5- queryStringTeam1 != [BLANK] && queryStringTeam2 != [BLANK]  && queryStringPlayers == [BLANK]")
            queryFromFilters = queryStringTeam1 + queryStringTeam2 + queryStringSpreadTeam1 + queryStringOverUnder + queryStringWinningLosingStreakTeam1 + queryStringWinningLosingStreakTeam2 + queryStringSeasonWinPercentageTeam1 + queryStringSeasonWinPercentageTeam2 + queryStringHomeTeam + queryStringFavorite + queryStringPlayers + queryStringplayerOpponent + queryStringSeason + queryStringWeek + queryStringGameNumber + queryStringDay + queryStringStadium + queryStringSurface + queryStringTemperature + queryStringTotalPointsTeam1 + queryStringTotalPointsTeam2 + queryStringTouchdownsTeam1 + queryStringTouchdownsTeam2 + queryStringOffensiveTouchdownsTeam1 + queryStringDefensiveTouchdownsTeam1 + queryStringOffensiveTouchdownsTeam2 + queryStringDefensiveTouchdownsTeam2 + queryStringTurnoversCommittedTeam1 + queryStringTurnoversCommittedTeam2 + queryStringPenaltiesCommittedTeam1 + queryStringPenaltiesCommittedTeam2 + queryStringTotalYardsTeam1 + queryStringTotalYardsTeam2 + queryStringPassingYardsTeam1 + queryStringPassingYardsTeam2 + queryStringRushingYardsTeam1 + queryStringRushingYardsTeam2 + queryStringQuarterbackRatingTeam1 + queryStringQuarterbackRatingTeam2 + queryStringTimesSackedTeam1 + queryStringTimesSackedTeam2 + queryStringInterceptionsThrownTeam1 + queryStringInterceptionsThrownTeam2 + queryStringOffensivePlaysTeam1 + queryStringOffensivePlaysTeam2 + queryStringYardsPerOffensivePlayTeam1 + queryStringYardsPerOffensivePlayTeam2 + queryStringSacksTeam1 + queryStringSacksTeam2 + queryStringInterceptionsTeam1 + queryStringInterceptionsTeam2 + queryStringSafetiesTeam1 + queryStringSafetiesTeam2 + queryStringDefensivePlaysTeam1 + queryStringDefensivePlaysTeam2 + queryStringYardsPerDefensivePlayTeam1 + queryStringYardsPerDefensivePlayTeam2 + queryStringExtraPointAttemptsTeam1 + queryStringExtraPointAttemptsTeam2 + queryStringExtraPointsMadeTeam1 + queryStringExtraPointsMadeTeam2 + queryStringFieldGoalAttemptsTeam1 + queryStringFieldGoalAttemptsTeam2 + queryStringFieldGoalsMadeTeam1 + queryStringFieldGoalsMadeTeam2 + queryStringPuntsTeam1 + queryStringPuntsTeam2 + queryStringPuntYardsTeam1 + queryStringPuntYardsTeam2
        } else if queryStringTeam1 != "" && queryStringTeam2 != ""  && (queryStringPlayers != "" || queryStringplayerOpponent != "") {
            print("-6- queryStringTeam1 != [BLANK] && queryStringTeam2 != [BLANK]  && queryStringPlayers != [BLANK]")
            queryFromFilters = queryStringTeam1 + queryStringTeam2 + queryStringSpreadTeam1 + queryStringOverUnder + queryStringWinningLosingStreakTeam1 + queryStringWinningLosingStreakTeam2 + queryStringSeasonWinPercentageTeam1 + queryStringSeasonWinPercentageTeam2 + queryStringHomeTeam + queryStringFavorite + queryStringPlayers + queryStringplayerOpponent + queryStringSeason + queryStringWeek + queryStringGameNumber + queryStringDay + queryStringStadium + queryStringSurface + queryStringTemperature + queryStringTotalPointsTeam1 + queryStringTotalPointsTeam2 + queryStringTouchdownsTeam1 + queryStringTouchdownsTeam2 + queryStringOffensiveTouchdownsTeam1 + queryStringDefensiveTouchdownsTeam1 + queryStringOffensiveTouchdownsTeam2 + queryStringDefensiveTouchdownsTeam2 + queryStringTurnoversCommittedTeam1 + queryStringTurnoversCommittedTeam2 + queryStringPenaltiesCommittedTeam1 + queryStringPenaltiesCommittedTeam2 + queryStringTotalYardsTeam1 + queryStringTotalYardsTeam2 + queryStringPassingYardsTeam1 + queryStringPassingYardsTeam2 + queryStringRushingYardsTeam1 + queryStringRushingYardsTeam2 + queryStringQuarterbackRatingTeam1 + queryStringQuarterbackRatingTeam2 + queryStringTimesSackedTeam1 + queryStringTimesSackedTeam2 + queryStringInterceptionsThrownTeam1 + queryStringInterceptionsThrownTeam2 + queryStringOffensivePlaysTeam1 + queryStringOffensivePlaysTeam2 + queryStringYardsPerOffensivePlayTeam1 + queryStringYardsPerOffensivePlayTeam2 + queryStringSacksTeam1 + queryStringSacksTeam2 + queryStringInterceptionsTeam1 + queryStringInterceptionsTeam2 + queryStringSafetiesTeam1 + queryStringSafetiesTeam2 + queryStringDefensivePlaysTeam1 + queryStringDefensivePlaysTeam2 + queryStringYardsPerDefensivePlayTeam1 + queryStringYardsPerDefensivePlayTeam2 + queryStringExtraPointAttemptsTeam1 + queryStringExtraPointAttemptsTeam2 + queryStringExtraPointsMadeTeam1 + queryStringExtraPointsMadeTeam2 + queryStringFieldGoalAttemptsTeam1 + queryStringFieldGoalAttemptsTeam2 + queryStringFieldGoalsMadeTeam1 + queryStringFieldGoalsMadeTeam2 + queryStringPuntsTeam1 + queryStringPuntsTeam2 + queryStringPuntYardsTeam1 + queryStringPuntYardsTeam2
        } else if queryStringTeam1 == "" && queryStringTeam2 == "" {
            print("-7- queryStringTeam1 == [BLANK] && queryStringTeam2 == [BLANK] && queryStringPlayers == [BLANK]")
            queryFromFiltersPrefix = "GameCount IN (SELECT MIN(GameCount) FROM TeamGameData WHERE GameCount <> ''" + queryStringTeam1 + queryStringTeam2 + queryStringSpreadTeam1 + queryStringOverUnder + queryStringWinningLosingStreakTeam1 + queryStringWinningLosingStreakTeam2 + queryStringSeasonWinPercentageTeam1 + queryStringSeasonWinPercentageTeam2 + queryStringHomeTeam + queryStringFavorite + queryStringPlayers + queryStringplayerOpponent + queryStringSeason + queryStringWeek + queryStringGameNumber + queryStringDay + queryStringStadium + queryStringSurface + queryStringTemperature + queryStringTotalPointsTeam1 + queryStringTotalPointsTeam2 + queryStringTouchdownsTeam1 + queryStringTouchdownsTeam2 + queryStringOffensiveTouchdownsTeam1 + queryStringDefensiveTouchdownsTeam1 + queryStringOffensiveTouchdownsTeam2 + queryStringDefensiveTouchdownsTeam2 + queryStringTurnoversCommittedTeam1 + queryStringTurnoversCommittedTeam2 + queryStringPenaltiesCommittedTeam1 + queryStringPenaltiesCommittedTeam2 + queryStringTotalYardsTeam1 + queryStringTotalYardsTeam2 + queryStringPassingYardsTeam1 + queryStringPassingYardsTeam2 + queryStringRushingYardsTeam1 + queryStringRushingYardsTeam2 + queryStringQuarterbackRatingTeam1 + queryStringQuarterbackRatingTeam2 + queryStringTimesSackedTeam1 + queryStringTimesSackedTeam2 + queryStringInterceptionsThrownTeam1 + queryStringInterceptionsThrownTeam2 + queryStringOffensivePlaysTeam1 + queryStringOffensivePlaysTeam2 + queryStringYardsPerOffensivePlayTeam1 + queryStringYardsPerOffensivePlayTeam2 + queryStringSacksTeam1 + queryStringSacksTeam2 + queryStringInterceptionsTeam1 + queryStringInterceptionsTeam2 + queryStringSafetiesTeam1 + queryStringSafetiesTeam2 + queryStringDefensivePlaysTeam1 + queryStringDefensivePlaysTeam2 + queryStringYardsPerDefensivePlayTeam1 + queryStringYardsPerDefensivePlayTeam2 + queryStringExtraPointAttemptsTeam1 + queryStringExtraPointAttemptsTeam2 + queryStringExtraPointsMadeTeam1 + queryStringExtraPointsMadeTeam2 + queryStringFieldGoalAttemptsTeam1 + queryStringFieldGoalAttemptsTeam2 + queryStringFieldGoalsMadeTeam1 + queryStringFieldGoalsMadeTeam2 + queryStringPuntsTeam1 + queryStringPuntsTeam2 + queryStringPuntYardsTeam1 + queryStringPuntYardsTeam2
            queryFromFilters = queryFromFiltersPrefix + " GROUP BY Date_ATeam_vs_ZTeam)"
        }
        /*else if queryStringTeam1 == "" && queryStringTeam2 == "" && (queryStringPlayers != "" || queryStringplayerOpponent != "") {
            print("-8- queryStringTeam1 == [BLANK] && queryStringTeam2 == [BLANK] && queryStringPlayers != [BLANK]")
            queryFromFilters = "GameCount <> ''" + queryStringPlayers + queryStringplayerOpponent + queryStringTeam1 + queryStringTeam2 + queryStringSpreadTeam1 + queryStringOverUnder + queryStringWinningLosingStreakTeam1 + queryStringWinningLosingStreakTeam2 + queryStringSeasonWinPercentageTeam1 + queryStringSeasonWinPercentageTeam2 + queryStringHomeTeam + queryStringFavorite + queryStringSeason + queryStringWeek + queryStringGameNumber + queryStringDay + queryStringStadium + queryStringSurface + queryStringTemperature + queryStringTotalPointsTeam1 + queryStringTotalPointsTeam2 + queryStringTouchdownsTeam1 + queryStringTouchdownsTeam2 + queryStringOffensiveTouchdownsTeam1 + queryStringDefensiveTouchdownsTeam1 + queryStringOffensiveTouchdownsTeam2 + queryStringDefensiveTouchdownsTeam2 + queryStringTurnoversCommittedTeam1 + queryStringTurnoversCommittedTeam2 + queryStringPenaltiesCommittedTeam1 + queryStringPenaltiesCommittedTeam2 + queryStringTotalYardsTeam1 + queryStringTotalYardsTeam2 + queryStringPassingYardsTeam1 + queryStringPassingYardsTeam2 + queryStringRushingYardsTeam1 + queryStringRushingYardsTeam2 + queryStringQuarterbackRatingTeam1 + queryStringQuarterbackRatingTeam2 + queryStringTimesSackedTeam1 + queryStringTimesSackedTeam2 + queryStringInterceptionsThrownTeam1 + queryStringInterceptionsThrownTeam2 + queryStringOffensivePlaysTeam1 + queryStringOffensivePlaysTeam2 + queryStringYardsPerOffensivePlayTeam1 + queryStringYardsPerOffensivePlayTeam2 + queryStringSacksTeam1 + queryStringSacksTeam2 + queryStringInterceptionsTeam1 + queryStringInterceptionsTeam2 + queryStringSafetiesTeam1 + queryStringSafetiesTeam2 + queryStringDefensivePlaysTeam1 + queryStringDefensivePlaysTeam2 + queryStringYardsPerDefensivePlayTeam1 + queryStringYardsPerDefensivePlayTeam2 + queryStringExtraPointAttemptsTeam1 + queryStringExtraPointAttemptsTeam2 + queryStringExtraPointsMadeTeam1 + queryStringExtraPointsMadeTeam2 + queryStringFieldGoalAttemptsTeam1 + queryStringFieldGoalAttemptsTeam2 + queryStringFieldGoalsMadeTeam1 + queryStringFieldGoalsMadeTeam2 + queryStringPuntsTeam1 + queryStringPuntsTeam2 + queryStringPuntYardsTeam1 + queryStringPuntYardsTeam2
        }*/
        
            print("queryFromFilters: SELECT * FROM TeamGameData WHERE " + queryFromFilters)
            queryWinsTeam1 = queryFromFilters + " AND winLoseTieValueTeam = 1.0"
            queryLossesTeam1 = queryFromFilters + " AND winLoseTieValueTeam = 0.0"
            queryTiesTeam1 = queryFromFilters + " AND winLoseTieValueTeam = 0.5"
            queryWinsTeam2 = queryFromFilters + " AND winLoseTieValueOpponent = 1.0"
            queryLossesTeam2 = queryFromFilters + " AND winLoseTieValueOpponent = 0.0"
            queryTiesTeam2 = queryFromFilters + " AND winLoseTieValueOpponent = 0.5"
            queryCoveredTeam1 = queryFromFilters + " AND SpreadVsLine = 'covered'"
            queryNotCoveredTeam1 = queryFromFilters + " AND SpreadVsLine = 'not covered'"
            queryPushTeam1 = queryFromFilters + " AND SpreadVsLine = 'push'"
        
        let pathStatsDatabase = Bundle.main.path(forResource: "StatsDatabase", ofType:"db")
        let db = FMDatabase(path: pathStatsDatabase)
        guard db.open() else {
            print("Unable to open database 'StatsDatabase'")
            return
        }
        do {
            let executeGamesSampled = try db.executeQuery("SELECT COUNT(*) FROM TeamGameData WHERE \(queryFromFilters)", values: nil)
            while executeGamesSampled.next() {
                gamesSampled = executeGamesSampled.long(forColumnIndex: 0)
                //print("gamesSampled: " + String(gamesSampled))
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        do {
            let executeWinsTeam1 = try db.executeQuery("SELECT COUNT(*) FROM TeamGameData WHERE \(queryWinsTeam1)", values: nil)
            while executeWinsTeam1.next() {
                winsTeam1 = executeWinsTeam1.long(forColumnIndex: 0)
                //print("winsTeam1: " + String(winsTeam1))
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        do {
            let executeLossesTeam1 = try db.executeQuery("SELECT COUNT(*) FROM TeamGameData WHERE \(queryLossesTeam1)", values: nil)
            while executeLossesTeam1.next() {
                lossesTeam1 = executeLossesTeam1.long(forColumnIndex: 0)
                //print("lossesTeam1: " + String(lossesTeam1))
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        do {
            let executeTiesTeam1 = try db.executeQuery("SELECT COUNT(*) FROM TeamGameData WHERE \(queryTiesTeam1)", values: nil)
            while executeTiesTeam1.next() {
                tiesTeam1 = executeTiesTeam1.long(forColumnIndex: 0)
                //print("tiesTeam1: " + String(tiesTeam1))
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        do {
            let executeWinsTeam2 = try db.executeQuery("SELECT COUNT(*) FROM TeamGameData WHERE \(queryWinsTeam2)", values: nil)
            while executeWinsTeam2.next() {
                winsTeam2 = executeWinsTeam2.long(forColumnIndex: 0)
                //print("winsTeam2: " + String(winsTeam2))
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        do {
            let executeLossesTeam2 = try db.executeQuery("SELECT COUNT(*) FROM TeamGameData WHERE \(queryLossesTeam2)", values: nil)
            while executeLossesTeam2.next() {
                lossesTeam2 = executeLossesTeam2.long(forColumnIndex: 0)
                //print("lossesTeam2: " + String(lossesTeam2))
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        do {
            let executeTiesTeam2 = try db.executeQuery("SELECT COUNT(*) FROM TeamGameData WHERE \(queryTiesTeam2)", values: nil)
            while executeTiesTeam2.next() {
                tiesTeam2 = executeTiesTeam2.long(forColumnIndex: 0)
                //print("tiesTeam2: " + String(tiesTeam2))
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        do {
            let executePointsTeam1 = try db.executeQuery("SELECT AVG(pointsTeam) FROM TeamGameData WHERE \(queryFromFilters)", values: nil)
            while executePointsTeam1.next() {
                dashboardPointsTeam1 = Float(executePointsTeam1.double(forColumnIndex: 0))
                //print("dashboardPointsTeam1: " + String(dashboardPointsTeam1))
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        do {
            let executePointsTeam2 = try db.executeQuery("SELECT AVG(pointsOpponent) FROM TeamGameData WHERE \(queryFromFilters)", values: nil)
            while executePointsTeam2.next() {
                dashboardPointsTeam2 = Float(executePointsTeam2.double(forColumnIndex: 0))
                //print("dashboardPointsTeam2: " + String(dashboardPointsTeam2))
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        do {
            let executeCoveredTeam1 = try db.executeQuery("SELECT COUNT(*) FROM TeamGameData WHERE \(queryCoveredTeam1)", values: nil)
            while executeCoveredTeam1.next() {
                coveredTeam1 = executeCoveredTeam1.long(forColumnIndex: 0)
                notCoveredTeam2 = executeCoveredTeam1.long(forColumnIndex: 0)
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        do {
            let executeNotCoveredTeam1 = try db.executeQuery("SELECT COUNT(*) FROM TeamGameData WHERE \(queryNotCoveredTeam1)", values: nil)
            while executeNotCoveredTeam1.next() {
                notCoveredTeam1 = executeNotCoveredTeam1.long(forColumnIndex: 0)
                coveredTeam2 = executeNotCoveredTeam1.long(forColumnIndex: 0)
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        do {
            let executePushTeam1 = try db.executeQuery("SELECT COUNT(*) FROM TeamGameData WHERE \(queryPushTeam1)", values: nil)
            while executePushTeam1.next() {
                pushTeam1 = executePushTeam1.long(forColumnIndex: 0)
                pushTeam2 = executePushTeam1.long(forColumnIndex: 0)
            }
        } catch let error as NSError {
            errorIndicator = "Yes"
            print("Query failed: \(error.localizedDescription)")
        }
        
        if dashboardPointsTeam1 > dashboardPointsTeam2 {
            team1DifferentialPrefix = "- "
            team2DifferentialPrefix = "+ "
        } else if dashboardPointsTeam1 < dashboardPointsTeam2 {
            team1DifferentialPrefix = "+ "
            team2DifferentialPrefix = "- "
        }
        if gamesSampled == 0 {
            team1WinPercentageLabelText = "0.00%"
            team2WinPercentageLabelText = "0.00%"
            progressViewProgress = 0.0
        } else {
            team1WinPercentageLabelText = String(format: "%.1f%%", (100.00 * ((Double(winsTeam1) + (0.5 * (Double(tiesTeam1))))/Double(gamesSampled))))
            team2WinPercentageLabelText = String(format: "%.1f%%", (100.00 * ((Double(winsTeam2) + (0.5 * (Double(tiesTeam2))))/Double(gamesSampled))))
            progressViewProgress = Float((Double(winsTeam1) + (0.5 * (Double(tiesTeam1))))/Double(gamesSampled))
        }
        team1RecordLabelText = "(" + winsTeam1.formattedWithSeparator + "-" + lossesTeam1.formattedWithSeparator + "-" + tiesTeam1.formattedWithSeparator + ")"
        team2RecordLabelText = "(" + winsTeam2.formattedWithSeparator + "-" + lossesTeam2.formattedWithSeparator + "-" + tiesTeam2.formattedWithSeparator + ")"
        team1PointsLabelText = String(format: "%.1f", dashboardPointsTeam1)
        team2PointsLabelText = String(format: "%.1f", dashboardPointsTeam2)
        team1DifferentialLabelText = team1DifferentialPrefix + String(format: "%.1f", (abs((dashboardPointsTeam2 - dashboardPointsTeam1))))
        team2DifferentialLabelText = team2DifferentialPrefix + String(format: "%.1f", (abs((dashboardPointsTeam1 - dashboardPointsTeam2))))
        team1ATSLabelText = "(" + coveredTeam1.formattedWithSeparator + "-" + notCoveredTeam1.formattedWithSeparator + "-" + pushTeam1.formattedWithSeparator + ")"
        team2ATSLabelText = "(" + coveredTeam2.formattedWithSeparator + "-" + notCoveredTeam2.formattedWithSeparator + "-" + pushTeam2.formattedWithSeparator + ")"
        gamesSampledLabelText = numberFormatter.string(from: NSNumber(value: gamesSampled))!
        gamesSampledLabel.text = gamesSampledLabelText + " GAMES SAMPLED"
        team1WinPercentageLabel.text = team1WinPercentageLabelText
        team2WinPercentageLabel.text = team2WinPercentageLabelText
        team1RecordLabel.text = team1RecordLabelText
        team2RecordLabel.text = team2RecordLabelText
        team1ATSLabel.text = team1ATSLabelText
        team2ATSLabel.text = team2ATSLabelText
        team1PointsLabel.text = team1PointsLabelText
        team2PointsLabel.text = team2PointsLabelText
        team1DifferentialLabel.text = team1DifferentialLabelText
        team2DifferentialLabel.text = team2DifferentialLabelText
        progressView.progress = 0.01
        progressView.progress = progressViewProgress
        //team1Label.text = team1LabelText
        if team1ListValue != [] {
            if team1ListValue[0] == "NEW YORK GIANTS" {
                team1Label.text = "NEW YORK (G)"
            } else if team1ListValue[0] == "NEW YORK JETS" {
                team1Label.text = "NEW YORK (J)"
            } else if team1ListValue[0] == "LOS ANGELES CHARGERS" {
                team1Label.text = "LOS ANGELES (C)"
            } else if team1ListValue[0] == "LOS ANGELES RAMS" {
                team1Label.text = "LOS ANGELES (R)"
            } else {
                team1Label.text = team1LabelText
            }
        } else {
            team1Label.text = team1LabelText
        }
        
        if team2ListValue != [] {
            if team2ListValue.count == 1 {
                if team2ListValue[0] == "NEW YORK GIANTS" {
                    team2Label.text = "NEW YORK (G)"
                } else if team2ListValue[0] == "NEW YORK JETS" {
                    team2Label.text = "NEW YORK (J)"
                } else if team2ListValue[0] == "LOS ANGELES CHARGERS" {
                    team2Label.text = "LOS ANGELES (C)"
                } else if team2ListValue[0] == "LOS ANGELES RAMS" {
                    team2Label.text = "LOS ANGELES (R)"
                } else {
                    team2Label.text = team2LabelText
                }
            } else {
                team2Label.text = team2LabelText
            }
        } else {
            team2Label.text = team2LabelText
        }
        print("progressViewProgress: " + "\(progressViewProgress)")
        if errorIndicator == "Yes" {
            print("errorIndicator = Yes")
        }
        db.close()
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
}
