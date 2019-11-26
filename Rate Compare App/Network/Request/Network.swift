//
//  Network .swift
//  Rate Compare App
//
//  Created by Jojo Destreza on 9/11/19.
//  Copyright © 2019 Jojo Destreza. All rights reserved.
//

import UIKit

struct RequestStatusList2<T: Codable> : Codable {
    let status: Int
    let message: String
    let data : [T]?
}

struct RequestStatusList<T: Codable> : Codable {
    let status: Int
    let message: String
    let data : T?
    let dataArray : [T]?
}

struct RequestStatus : Codable {
    let status: Int
    let message: String
}
struct StatusList {
    let status: Int
    let title: String
    let message: String
    let tag : Int?
}

class NetworkService<T:Codable> : NSObject {
    var hasInternet : Bool = false

    override init() {
      self.hasInternet = true
    }
    
    func networkRequest(_ param : [String: Any],jsonUrlString: String,completionHandler: @escaping (T?,StatusList?) -> () ) {
       
        if let url = URL(string: jsonUrlString) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Active")
            guard let httpBody = try? JSONSerialization.data(withJSONObject: param, options: []) else { return }
            request.httpBody = httpBody
            print("REQUEST : \(request) \n PARAMETERES : \(param)")
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
//                print("RESPONSE : \(data) === \(response) == \(error)")
                if error == nil {
                    if let receivedData = data {
                        do {
                            let data = try JSONDecoder().decode(T.self, from: receivedData)
//                            print("DATA GET ON REQUEST :" ,data)
                                completionHandler(data,nil)
                        } catch let jsonErr {
                            print("Error serializing json:", jsonErr)
                            completionHandler(nil,StatusList(status: 0, title: "", message: "Something went wrong", tag: nil))
                        }
                        return
                    }
                }
                completionHandler(nil,StatusList(status: 0, title: "", message: "Something went wrong. Please try again.", tag: nil))
             
                
            
//                guard let httpResponse = response as? HTTPURLResponse, let receivedData = data
//                    else {
//                        print("error: not a valid http response")
//                        completionHandler(nil,StatusList(status: 0, title: "", message: "Something went wrong. Please try again.", tag: nil))
//                        return
//                }
//                    switch (httpResponse.statusCode) {
//                    case 200:
//                        do {
//                            let data = try JSONDecoder().decode(T.self, from: receivedData)
//                            print("DATA GET ON REQUEST :" ,data)
//
//                            completionHandler(data,nil)
//                        } catch let jsonErr {
//                            print("Error serializing json:", jsonErr)
//                        }
//                        break
//                    default:
//                        completionHandler(nil,StatusList(status: 0, title: "", message: "Something went wrong. Please try again.", tag: nil))
//                        break
//                    }
                
            }.resume()
            
        }
    }
    
    
}
//
//class NetworkClass: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        let parameters = ["base": "GBP","symbols": "CAD,EUR,USD,GBP"]
//        let jsonUrlString = "\(AppConfig().url)/getEquivalentRates/"
//        guard let url = URL(string: jsonUrlString) else { return }
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
//        request.httpBody = httpBody
//
//        print("REQUEST : \(request)  \\ PARAMETERES : \(parameters)")
//        URLSession.shared.dataTask(with: request) { (data, response, error) in
//
//            guard let data = data else { return }
//
//            do {
//                //                let websiteDescription = try JSONDecoder().decode(WebsiteDescription.self, from: data)
//                //                print(websiteDescription.name, websiteDescription.description)
//
////                let courses = try JSONDecoder().decode(Welcome.self, from: data)
////                print(courses)
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
//        }.resume()
//
//    }
//
//    func networkRequest(param : [String: Any],completionHandler: ([Course]) -> Void) {
//
//
//
//
//    }
//
//    func makeRequest() {
//
//    }
//
//
//    //        URLSession.shared.dataTask(with: url) { (data, response, err) in
//    //            //perhaps check err
//    //            //also perhaps check response status 200 OK
//    //
//    //            guard let data = data else { return }
//    //
//    //            //            let dataAsString = String(data: data, encoding: .utf8)
//    //            //            print(dataAsString)
//    //
//    //            do {
//    //                //                let websiteDescription = try JSONDecoder().decode(WebsiteDescription.self, from: data)
//    //                //                print(websiteDescription.name, websiteDescription.description)
//    //
//    //                let courses = try JSONDecoder().decode([Course].self, from: data)
//    //                print(courses)
//    //
//    //                //Swift 2/3/ObjC
//    //                //                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else { return }
//    //                //
//    //                //                let course = Course(json: json)
//    //                //                print(course.name)
//    //
//    //            } catch let jsonErr {
//    //                print("Error serializing json:", jsonErr)
//    //            }
//    //
//    //
//    //
//    //            }.resume()
//    //
//    //        //        let myCourse = Course(id: 1, name: "my course", link: "some link", imageUrl: "some image url")
//    //        //        print(myCourse)
//    //    }
//
//}
//
//
//
//
////class NetworkService<T: Mappable> {
////
////    var hasInternet: Bool
////
////    init() {
////        self.hasInternet = NetworkReachabilityManager()!.isReachable
////    }
////
////    func requestForNetworkDataPost(_ data : Dictionary<String, Any>) -> Observable<Response<T>> {
////        if hasInternet {
////            return Observable<Response<T>>.create { observer in
////                let request = Alamofire.request(Endpoints.APIEndpoint.api.url, method: .post, parameters : data)
////                    .validate()
////                    .responseObject(completionHandler: { (response: DataResponse<Response<T>>) in
////                        switch response.result {
////                        case .success(let object) :
////                            observer.onNext(object)
////                            observer.onCompleted()
////                        case .failure(let error) :
////                            observer.onError(error)
////                            log.info("ERROR CONNECTING TO SERVER : \(error.localizedDescription)")
////                        }
////                    })
////                return Disposables.create(with: { request.cancel() })
////            }
////        } else {
////            return Observable.error(NSError(domain:"", code:0, userInfo:[NSLocalizedDescriptionKey: "No internet connection"]))
////        }
////    }
////}
//
//
//
//
