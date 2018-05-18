//
//  Player.swift
//  
//
//  Created by Iza Ledzka on 01/05/2018.
//

import Foundation
import UIKit

//  This protocol is used to group the players by their type, and add them to appropriate section and
//  in the table view. TableView's section title is also set using the sectionTitle variable.
protocol TeamMember {
    var type: PlayerType { get }
    var rowCount: Int { get }
    var sectionTitle: String  { get }
    
}

//  Model class Player is used to store data that is used to populate UITableView cells is
//  SquadViewController, StatsViewController (when Player's stats are diosplayed), and to
//  PlayerProfileViewController.
class Player: CustomStringConvertible{
    var description: String { return "Player id: \(self.id), squadNo: \(self.squadNo), team: \(self.team), name: \(self.firstName) \(self.lastName)"}
    
    var id: String
    var squadNo: String
    var team: String
    var firstName: String
    var lastName: String
    var position: String
    var dateOfBirth: String
    var height: String
    var nationality: String
    var imageIcon: String
    var backgroundImg: String
    var signed: String
    var matches: String
    var goals: String
    var assists: String
    var redCards: String
    var yellowCards: String
    
    
    init?(data: NSDictionary?)
    {
        
        guard
            let id = data?.value(forKey: "id"),
            let squadNo = data?.value(forKey: "squadNo"),
            let team = data?.value(forKey: "team"),
            let firstName = data?.value(forKey: "firstName"),
            let lastName = data?.value(forKey: "lastName"),
            let position = data?.value(forKey: "position"),
            let dateOfBirth =  data?.value(forKey: "dateOfBirth"),
            let height = data?.value(forKey: "height"),
            let nationality = data?.value(forKey: "nationality"),
            let imageUrl  = data?.value(forKey: "imageIcon"),
            let backgroundImg  = data?.value(forKey: "backgroundImg"),
            let signed = data?.value(forKey: "signed"),
            let matches = data?.value(forKey: "matches"),
            let goals = data?.value(forKey: "goals"),
            let assists = data?.value(forKey: "assists"),
            let redCards = data?.value(forKey: "redCards"),
            let yellowCards = data?.value(forKey: "yellowCards")
            else { return nil }
        
        self.id = String(describing: id)
        self.squadNo = String(describing: squadNo)
        self.team = team as! String
        self.firstName = firstName as! String
        self.lastName = lastName as! String
        self.position = position as! String
        self.dateOfBirth = dateOfBirth as! String
        self.height = height as! String
        self.nationality = nationality as! String
        self.signed = String(describing: signed)
        self.matches = String(describing: matches)
        self.goals = String(describing: goals)
        self.assists = String(describing: assists)
        self.redCards = String(describing: redCards)
        self.yellowCards = String(describing: yellowCards)
        self.imageIcon = String(describing: imageUrl)
        self.backgroundImg = String(describing: backgroundImg)
        
    }
}


class Goalkeeper: TeamMember {
    var rowCount: Int {
        return players.count
    }
    
    var sectionTitle: String {
        return "Goalkeepers"
    }
    
    var type: PlayerType {
        return .goalkeeper
    }
    
    var players: [Player]
    
    init(_ players: [Player]){
        self.players = players
    }
}

class Defender: TeamMember {
    var rowCount: Int {
        return players.count
    }
    
    var sectionTitle: String {
        return "Defenders"
    }
    
    var type: PlayerType {
        return .defender
    }
    
    var players: [Player]
    
    init(_ players: [Player]){
        self.players = players
    }
}

class Midfielder: TeamMember {
    var rowCount: Int {
        return players.count
    }
    
    var sectionTitle: String {
        return "Midfielders"
    }
    
    var type: PlayerType {
        return .midfielder
    }
    
    var players: [Player]
    
    init(_ players: [Player]){
        self.players = players
    }
}

class Forward: TeamMember {
    var rowCount: Int {
        return players.count
    }
    
    var sectionTitle: String {
        return "Forward"
    }
    
    var type: PlayerType {
        return .forward
    }
    
    var players: [Player]
    
    init(_ players: [Player]){
        self.players = players
    }
}

class Striker: TeamMember {
    var rowCount: Int {
        return players.count
    }
    
    var sectionTitle: String {
        return "Strikers"
    }
    
    var type: PlayerType {
        return .striker
    }
    
    var players: [Player]
    
    init(_ players: [Player]){
        self.players = players
    }
}

class Winger: TeamMember {
    var rowCount: Int {
        return players.count
    }
    
    var sectionTitle: String {
        return "Wingers"
    }
    
    var type: PlayerType {
        return .winger
    }
    
    var players: [Player]
    
    init(_ players: [Player]){
        self.players = players
    }
}

enum PlayerType {
    case goalkeeper
    case defender
    case midfielder
    case forward
    case striker
    case winger
}
