import UIKit

struct Student: Codable {
    let name: String
    let group: String
    let age: Int

    enum CodingKeys: String, CodingKey {
        case name = "user_name"
        case group = "user_group"
        case age = "user_age"
    }
}

let dataString = """
{
    "user_name": "Amir",
    "user_group": "11-123",
    "user_age": 12
}
"""

/*
 "2020-11-30T18:18:45.000+03:00=
 "2020-11-30, 18:18"
 */

let data = dataString.data(using: .utf8)!
let decoder = JSONDecoder()
let object = try? decoder.decode(Student.self, from: data)
print(object!)

let student = Student(name: "Hello", group: "1234", age: 123)
let encoder = JSONEncoder()
let encodedData = try! encoder.encode(student)
print(String(data: encodedData, encoding: .utf8)!)

let groupDataString = """
{
    "color": "123,255,255",
    "students": [
        {
            "user_name": "Amir",
            "user_group": "11-123",
            "user_age": 12
        },
        {
            "user_name": "Amir",
            "user_group": "11-123",
            "user_age": 12
        },
        {
            "user_name": "Amir",
            "user_group": "11-123",
            "user_age": 12
        }
    ]
}
"""

func getRed(_ red: inout Int) {
    red = 255
}

var red = 0
getRed(&red)
print(red)

enum CodingError: Error {
    case colorParsing
}

struct Group: Codable {
    let students: [Student]
    let color: UIColor

    enum CodingKeys: String, CodingKey {
        case students
        case color
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(students, forKey: .students)

        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: nil)
        try container.encode("\(Int(red * 255)),\(Int(green * 255)),\(Int(blue * 255))", forKey: .color)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let students = try container.decode([Student].self, forKey: .students)

        let colorString = try container.decode(String.self, forKey: .color)
        let colorComponents = colorString.split(separator: ",").compactMap { Int($0) }
        guard colorComponents.count == 3 else { throw CodingError.colorParsing }
        let color = UIColor(
            red: CGFloat(colorComponents[0]) / 255,
            green: CGFloat(colorComponents[1]) / 255,
            blue: CGFloat(colorComponents[2]) / 255,
            alpha: 1
        )

        self.students = students
        self.color = color
    }
}

let groupData = groupDataString.data(using: .utf8)!
do {
    let group = try decoder.decode(Group.self, from: groupData)
    print(group)
    group.color

    let encodedGroup = try encoder.encode(group)
    print(String(data: encodedGroup, encoding: .utf8)!)
} catch {
    print(error)
}
