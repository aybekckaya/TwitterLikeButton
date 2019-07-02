Replicating of Twitter Like Button. 

[![](https://github.com/aybekckaya/TwitterLikeButton/blob/master/TwitterLikeVisual.gif)](https://github.com/aybekckaya/TwitterLikeButton/blob/master/TwitterLikeVisual.gif)

### Installation 
Copy LikeView.swift file to your project main folder. Currently there is no dependency manager version. 

### Usage
Usage with default configuration
```swift
viewLike = LikeView(frame: CGRect(x: 0, y: 0, width: 54, height: 51))
viewLike.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height / 2)
view.addSubview(viewLike)
```

with configuration
```swift
 var configuration = LikeViewConfiguration()
 configuration.duration = 10
 configuration.sparkleSize = CGSize(width: 10, height: 10)
 viewLike = LikeView(frame: CGRect(x: 0, y: 0, width: 54/2, height: 51/2) , configuration: configuration) 
 viewLike.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height / 2)
 view.addSubview(viewLike)
```

Delegate methods
```swift
protocol LikeViewDelegate {
    func likeViewWillChangeState(likeView:LikeView , state:LikeViewState)
    func likeViewDidChangedState(likeView:LikeView , state:LikeViewState)
}
```




