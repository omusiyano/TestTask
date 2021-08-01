import Foundation

struct decodePrivat:Decodable{
    var date:String?
    var exchangeRate:[ exchangeRate ]
}

struct exchangeRate:Decodable {
    var currency:String?
    var saleRate:Float?
    var purchaseRate:Float?
}
struct decodingNBU:Codable{
    var txt:String
    var rate:Float
    var cc:String
}
