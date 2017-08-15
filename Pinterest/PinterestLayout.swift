//
//  PinterestLayout.swift
//  Pinterest
//
//  Created by chang on 2017/8/15.
//  Copyright © 2017年 Razeware LLC. All rights reserved.
//

import UIKit

protocol PinterestLayoutDelegate {
  // 1
  func collectionView(collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:NSIndexPath, withWidth:CGFloat) -> CGFloat
  // 2
  func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat
}

class PinterestLayout: UICollectionViewLayout
{
  var delegate: PinterestLayoutDelegate!
  
  var numberOfColumns = 2
  var cellPadding: CGFloat = 6.0
  
  private var cache = [UICollectionViewLayoutAttributes]()
  
  private var contentHeight: CGFloat = 0.0
  private var contentWidth: CGFloat {
    let insets = collectionView!.contentInset
    return collectionView!.bounds.width - (insets.left + insets.right)
  }
  
  override func prepare()
  {
    if cache.isEmpty{
      let columnWidth = contentWidth / CGFloat(numberOfColumns)
      var xOffset = [CGFloat]()
      for column in 0 ..< numberOfColumns {
        xOffset.append(CGFloat(column) * columnWidth)
      }
      var column = 0
      //改寫 var yOffset = [CGFloat](count: numberOfColumns, repeatedValue: 0)
      var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
      
      for item in 0 ..< collectionView!.numberOfItems(inSection: 0)
      {
        let indexPath = NSIndexPath(item: item, section: 0)
        
        let width = columnWidth - cellPadding * 2
        let photoHeight = delegate.collectionView(collectionView: collectionView!, heightForPhotoAtIndexPath: indexPath, withWidth: width)
        let annotationHeight = delegate.collectionView(collectionView: collectionView!, heightForAnnotationAtIndexPath: indexPath, withWidth: width)
        let height = cellPadding + photoHeight + annotationHeight + cellPadding
        let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
        //改寫 let insetFrame = CGRectInset(frame, cellPadding, cellPadding)
        let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
        
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath as IndexPath)
        attributes.frame = insetFrame
        cache.append(attributes)
        
        contentHeight = max(contentHeight, frame.maxY)
        yOffset[column] = yOffset[column] + height
        print(yOffset[column])
        column = column >= (numberOfColumns - 1) ? 0 : column + 1
      }
    }
  }
  
  override var collectionViewContentSize: CGSize {
    return CGSize(width: contentWidth, height: contentHeight)
  }
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    var layoutAttributes = [UICollectionViewLayoutAttributes]()
    
    for attributes in cache {
      if attributes.frame.intersects(rect) {
        layoutAttributes.append(attributes)
      }
    }
    return layoutAttributes
  }
  
  
}
