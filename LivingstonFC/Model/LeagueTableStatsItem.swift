//
//  LeagueTableStatsItem.swift
//  LivingstonFC
//
//  Created by Iza Ledzka on 03/05/2018.
//  Copyright © 2018 Iza Ledzka. All rights reserved.
//

import Foundation

//Model class that stores data displayed in Stats View Controller. An instance of this class has data for a single table view cell.
class LeagueTableStatsItem {
    let id: String
    let competition: String
    let competitionYearStarted: String
    let teamName: String
    let position: String
    let played: String
    let won: String
    let drawn: String
    let lost: String
    let forTimes: String
    let against: String
    let points: String
    
    init?(data: NSDictionary?){
        guard
            let id = data?.value(forKey: "id") as? Int,
            let competition = data?.value(forKey: "competition") as? String,
            let competitionYearStarted = data?.value(forKey: "competitionYearStarted") as? String,
            let teamName = data?.value(forKey: "teamName") as? String,
            let position = data?.value(forKey: "position") as? Int,
            let played = data?.value(forKey: "played") as? Int,
            let won = data?.value(forKey: "won") as? Int,
            let drawn = data?.value(forKey: "drawn") as? Int,
            let lost = data?.value(forKey: "lost") as? Int,
            let forTimes = data?.value(forKey: "for") as? Int,
            let against = data?.value(forKey: "against") as? Int,
            let points = data?.value(forKey: "points") as? Int
        else { return nil }
        
        self.id = String(id)
        self.competition = competition
        self.competitionYearStarted = competitionYearStarted
        self.teamName = teamName
        self.position = String(position)
        self.played = String(played)
        self.won = String(won)
        self.drawn = String(drawn)
        self.lost = String(lost)
        self.forTimes = String(forTimes)
        self.against = String(against)
        self.points = String(points)
    }
    
}
