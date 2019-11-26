//
//  Network .swift
//  Rate Compare App
//
//  Created by Jojo Destreza on 9/11/19.
//  Copyright © 2019 Jojo Destreza. All rights reserved.
//

import Foundation

struct WebsiteDescription: Decodable {
    let name: String
    let description: String
    let courses: [Course]
}

struct Course: Decodable {
    let id: Int?
    let name: String?
    let link: String?
    let imageUrl: String?
    
    //    init(json: [String: Any]) {
    //        id = json["id"] as? Int ?? -1
    //        name = json["name"] as? String ?? ""
    //        link = json["link"] as? String ?? ""
    //        imageUrl = json["imageUrl"] as? String ?? ""
    //    }
}

class NetworkClass: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let parameters = ["username": "@kilo_loco", "tweet": "HelloWorld"]
        let jsonUrlString = AppConfig().url
        guard let url = URL(string: jsonUrlString) else { return }
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
             guard let data = data else { return }
            //            let dataAsString = String(data: data, encoding: .utf8)
            //            print(dataAsString)
            
            do {
                //                let websiteDescription = try JSONDecoder().decode(WebsiteDescription.self, from: data)
                //                print(websiteDescription.name, websiteDescription.description)
                
                let courses = try JSONDecoder().decode([Course].self, from: data)
                print(courses)
                
                //Swift 2/3/ObjC
                //                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else { return }
                //
                //                let course = Course(json: json)
                //                print(course.name)
                
            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }
            
            
            
        }.resume()
        
    }
    
    func networkRequest(param : [String: Any],completionHandler: ([Course]) -> Void) {
        
        
        
        
    }
    
    func makeRequest() {
        
    }
    
        
//        URLSession.shared.dataTask(with: url) { (data, response, err) in
//            //perhaps check err
//            //also perhaps check response status 200 OK
//
//            guard let data = data else { return }
//
//            //            let dataAsString = String(data: data, encoding: .utf8)
//            //            print(dataAsString)
//
//            do {
//                //                let websiteDescription = try JSONDecoder().decode(WebsiteDescription.self, from: data)
//                //                print(websiteDescription.name, websiteDescription.description)
//
//                let courses = try JSONDecoder().decode([Course].self, from: data)
//                print(courses)
//
//                //Swift 2/3/ObjC
//                //                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else { return }
//                //
//                //                let course = Course(json: json)
//                //                print(course.name)
//
//            } catch let jsonErr {
//                print("Error serializing json:", jsonErr)
//            }
//
//
//
//            }.resume()
//
//        //        let myCourse = Course(id: 1, name: "my course", link: "some link", imageUrl: "some image url")
//        //        print(myCourse)
//    }
    
}




class NetworkService<T: Mappable> {
    
    var hasInternet: Bool
    
    init() {
        self.hasInternet = NetworkReachabilityManager()!.isReachable
    }
    
    func requestForNetworkDataPost(_ data : Dictionary<String, Any>) -> Observable<Response<T>> {
        if hasInternet {
            return Observable<Response<T>>.create { observer in
                let request = Alamofire.request(Endpoints.APIEndpoint.api.url, method: .post, parameters : data)
                    .validate()
                    .responseObject(completionHandler: { (response: DataResponse<Response<T>>) in
                        switch response.result {
                        case .success(let object) :
                            observer.onNext(object)
                            observer.onCompleted()
                        case .failure(let error) :
                            observer.onError(error)
                            log.info("ERROR CONNECTING TO SERVER : \(error.localizedDescription)")
                        }
                    })
                return Disposables.create(with: { request.cancel() })
            }
        } else {
            return Observable.error(NSError(domain:"", code:0, userInfo:[NSLocalizedDescriptionKey: "No internet connection"]))
        }
    }
}




