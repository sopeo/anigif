
import UIKit
import Photos

class LivePhotoViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate  {
    
    @IBOutlet weak var photoListView: UICollectionView!
    var thumbs = [UIImage]()
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let assets: PHFetchResult = PHAsset.fetchAssetsWithMediaType(.Image, options: nil)
        var photoAsset: PHAsset?

        assets.enumerateObjectsUsingBlock { (obj, index, stop) -> Void in
            
            let asset = obj as! PHAsset
            if asset.mediaSubtypes.contains(.PhotoLive) {
                photoAsset = asset

                let resources = PHAssetResource.assetResourcesForAsset(asset)

                
                for resource in resources {
                    if resource.type == .PairedVideo {

                        print(photoAsset)
                        self.dispatch_async_global {
                            
                            let image = self.getAssetThumbnail(photoAsset!)
                            self.thumbs.append(image)
                            

                            self.dispatch_async_main {
                                self.photoListView.reloadData()
                            }
                        }
                        
                        //let image = self.getAssetThumbnail(photoAsset!)
                        //self.thumbs.append(image)
                    }
                    
                }

            }
        }
        
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UICollectionViewDelegate Protocol
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:CustomCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CustomCell
        let width = thumbs[indexPath.row].size.width
        let height = thumbs[indexPath.row].size.height
        cell.image.frame = CGRect(x: cell.frame.width / 2 - width / 2, y: cell.frame.height / 2 - height / 2, width: width, height: height)
        cell.image.image = thumbs[indexPath.row]
        
        cell.image.translatesAutoresizingMaskIntoConstraints = true

        cell.backgroundColor = UIColor.blackColor()
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //print(thumbs[indexPath.row])
        let cell:CustomCell = collectionView.cellForItemAtIndexPath(indexPath) as! CustomCell
        //cell!.frame = CGRect(x: 0, y: (cell?.frame.origin.y)!, width: self.view.frame.width, height: self.view.frame.width)

        print(thumbs.count)
        print(thumbs)
        
        
//        print(cell)
//        print(cell.image)
//        print(cell.image.image)
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print(thumbs.count)
        return thumbs.count
    }
    
    
    
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.defaultManager()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.synchronous = true
        
        manager.requestImageForAsset(asset,
                                     targetSize: CGSize(width: asset.pixelWidth.hashValue / 16, height: asset.pixelHeight.hashValue / 16),
                                     contentMode: .AspectFit, options: option, resultHandler: {(result, info) -> Void in
            thumbnail = result!
        })
        return thumbnail
    }
}
