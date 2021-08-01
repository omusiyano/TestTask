import Foundation

func requestCurrencies(urlString:String, completion: @escaping (Result<decodePrivat, Error>)->Void){
    guard let url = URL(string: urlString) else {return}
    URLSession.shared.dataTask(with: url) { data, response, error in
        DispatchQueue.main.async {
            if let error = error{
                print("Some error \(error)")
                completion(.failure(error))
                return
            }
            guard let data = data else {return}
            do {
                let valuesCurrencies = try JSONDecoder().decode(decodePrivat.self, from: data)
                completion(.success(valuesCurrencies))
            } catch let jsonError {
                print("Failed to decode JSON", jsonError)
                completion(.failure(jsonError))
            }
        }
    }.resume()
}

func requestCurrenciesNBU(urlStringNBU:String, completion: @escaping (Result<[decodingNBU], Error>)->Void){
    guard let url = URL(string: urlStringNBU) else {return}
    URLSession.shared.dataTask(with: url) { data, response, error in
        DispatchQueue.main.async {
            if let error = error{
                print("Some error \(error)")
                completion(.failure(error))
                return
            }
            guard let data = data else {return}
            do {
                let valuesCurrenciesNBU = try JSONDecoder().decode([decodingNBU].self, from: data)
                completion(.success(valuesCurrenciesNBU))
            } catch let jsonError {
                print("Failed to decode JSON", jsonError)
                completion(.failure(jsonError))
            }
        }
    }.resume()
}
