import UIKit


class PointCloudLibrary {
    // empty point cloud array.
    var pointClouds = [PointCloud]()
    
    func recognizeFromLibrary(_ inputGesture:PointCloud) -> MatchResult {
        var b = Double.infinity
        var u = -1
        for (index, pointCloud) in pointClouds.enumerated() {
            if let d = inputGesture.greedyMatch(pointCloud) {
                if(d < b) {
                    b = d
                    u = index
                }
            }
        }
        if(u == -1) {
            return MatchResult(name: "No match", score: 0.0)
        } else {
            let score = round(max((b - 2.0) / -2.0, 0.0) * 100)/100
            return MatchResult(name:pointClouds[u].name, score:score)
        }
    }
    
    func recognizeoptionsFromLibrary(_ inputGesture:PointCloud) -> Array<String> {
        
        var dictionary: [Double:Int] = [:]
        var scores: [Double] = []
        var answer: [String] = []
        var b = Double.infinity
        
        var u = -1
        var i = 0
        var j = 4
        var it = 0
        var now = 0
        
        let suggestionBarMax = 10
        var suggestionBarCount : Int
        if(suggestionBarMax > self.pointClouds.count){
            suggestionBarCount = self.pointClouds.count
        } else {
            suggestionBarCount = suggestionBarMax
        }
        
        for (index, pointCloud) in pointClouds.enumerated() {
            if let l = inputGesture.greedyMatch(pointCloud) {
                if (i < suggestionBarCount){
                    dictionary.updateValue(index, forKey: l)
                    scores.append(l)
                    i = i + 1
                }
            }
        }
        scores = scores.sorted{ $0 < $1 }
        
        for (index, pointCloud) in pointClouds.enumerated() {
            
            if let d = inputGesture.greedyMatch(pointCloud) {
                if (now >= suggestionBarCount){
                    while (j >= 0){
                        if (scores[j] > d){
                            dictionary.removeValue(forKey: scores[j])
                            scores[j] = d
                            dictionary.updateValue(index, forKey: scores[j])
                            break;
                        }
                        j = j - 1
                    }
                }
                j = suggestionBarCount - 1
                
                if(d < b) {
                    b = d
                    u = index
                }
                scores = scores.sorted{ $0 < $1 }
                now = now + 1
            }
        }
        
        if(u == -1){
            var er = 0
            while (er < suggestionBarCount){
                answer.append("💩")
                er = er + 1
            }
        }
        else {
            while (it < suggestionBarCount){
                answer.append(pointClouds[dictionary[scores[it]]!].name)
                it = it + 1
            }
        }
        return answer
    }
    
    static func getDemoLibrary() -> PointCloudLibrary {
        let defaults = UserDefaults.init(suiteName: "group.swipemoji.appgroup")
        let _library = PointCloudLibrary()
        if let gestures = defaults!.array(forKey: "gestures") as? [NSMutableDictionary] {
            for gesture in gestures {
                for (key, value) in gesture {
                    var points = [] as [Point]
                    for array in value as! [NSArray] {
                        let point = Point(x:array[0] as! Double, y:array[1] as! Double, id:array[2] as! Int)
                        points.append(point)
                    }
                    _library.pointClouds.append(PointCloud(key as! String, points))
                }
            }
        }
        return _library
    }
    
    static func submitGesture(input: String, inputPoints: [Point]){
        let defaults = UserDefaults.init(suiteName: "group.swipemoji.appgroup")
        if let dicArray = defaults!.array(forKey: "gestures") as? [NSMutableDictionary] {
            var dicArrayStore = dicArray
            dicArrayStore = dicArrayStore.filter({ (dic) -> Bool in
                dic.allKeys[0] as! String != input
            })
            dicArrayStore.append([input : pointsToArray(points: inputPoints)])
            defaults!.set(dicArrayStore, forKey: "gestures")
            
        } else {
            var dicArray: [NSMutableDictionary] = []
            dicArray.append([input : pointsToArray(points: inputPoints)])
            defaults!.set(dicArray, forKey: "gestures")
        }

    }
    
    static func pointsToArray(points:[Point]) -> [NSArray] {
        var pointArray = [] as [NSArray]
        
        for point in points {
            var array = [point.x, point.y, point.id] as NSArray
            pointArray.append(array)
        }
        return pointArray
    }

}
