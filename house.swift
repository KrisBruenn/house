import Foundation

extension String: Error {}

func maybe() -> Bool {
    /*
      Randomly return true or false
    */
    let result = Int.random(in: 0 ... 1)
    if result == 1 {
        return true
    }
    else {
        return false
    }
}

func readJSONFile(forName name: String) throws -> [String: Any] {
    /*
      Read the given local JSON file and return a dictionary of the file data.
    */
    do {
      if let bundlePath = Bundle.main.path(forResource: name, ofType: "json"),
      let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {           
         if let json = try JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves) as? [String: Any] {
            // return OK
            return json
         } else {
            throw "Given JSON is not a valid dictionary object."
         }
      }
    } catch {
      throw error
    }
    // return empty dictionary
    return [:]
}

func describeDoor(forHouse aHouse: [String: Any], forDoor aDoor: String) -> String {
    /*
      The String aDoor is actually an integer that is the key for the door in the JSON file.
      Print a description of the given door and return the "name" value.
    */

    if let aList = (aHouse["doors"] as? [String: Any]) {
        let doorProps = (aList[aDoor] as! [String: Any])
        let doorName = doorProps["name"] as! String
        let doorString = "There is the " + doorName
        print(doorString + ".")
        // return OK
        return doorName
    }
    // return empty string
    return ""
}

func describeRoom(forHouse aHouse: [String: Any], forRoom aRoom: Int) -> [String] {
    /*
      Describe the given room in the house. The list of doors in the room 
      is used to generate a list of choices, which is returned.
    */
    if let aList = aHouse["rooms"] as? [Any] {
        let myRoom = aList[aRoom] as! [String : Any]
        let myName: [String: Any] = myRoom 
        let roomName = myName["name"] as! String
        let firstString = "You are in the " + roomName 
        print(firstString + ".")

        let furnitureList = myName["furniture"] as! [String]
        let secondString = "It contains a " + furnitureList.joined(separator:", ")
        print(secondString + ".")

        let doorList = myName["doors"] as! [String]
        var choices: [String] = []
        for door in doorList {
            let dn = describeDoor(forHouse: aHouse, forDoor: door)
            choices.append("enter the " + dn)
        }
        if roomName == "porch" {
            // leave game only from the porch
            choices.append("quit")
        }
        // return OK
        return choices
    }
    // return empty list of choices
    return []
}

/* **********************************************
   *                MAIN ROUTINE                * 
   ********************************************** */
var current = 0
var numberOfRooms = 0
var numberOfEvents = 0
var c: [String]
var cx: String
var ce = -1

let arguments = CommandLine.arguments
let fName = arguments[1]

let x = try readJSONFile(forName: fName)
let xRooms = x["rooms"] as! [Any]
numberOfRooms = xRooms.count - 1
let xEvents = x["events"] as! [Any]
let myEvents = xEvents[0] as! [String: String]
numberOfEvents = myEvents.count - 1

// loop until user selects "quit" choice
while (true) {
    ce = Int.random(in: 0 ... numberOfEvents)
    let c = describeRoom(forHouse: x, forRoom: current)
    if (maybe()) {
        let anEvent = myEvents[String(ce)] ?? "Oops!" 
        print(anEvent)
    }
    print(" ")
    var ch = 0
    for cx in c {
        print(String(ch) + ") " + cx)
        ch = ch + 1
    }
    print("Enter choice: ")
    let cz = Int(readLine(strippingNewline: true)!)!
    if c[cz] == "quit" {
        print("bye")
        break
    }
    else { // navigate house...
        current = Int.random(in: 0 ... numberOfRooms)
        // print(current)
    }
} 
