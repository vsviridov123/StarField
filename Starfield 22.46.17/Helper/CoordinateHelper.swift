//
//  CoordinateHelper.swift
//  Starfield
//
//  Created by Влад Свиридов on 13/09/2019.
//  Copyright © 2019 Developer. All rights reserved.
//

import CoreGraphics

extension CGPoint {
    /**
     Функция возвращает точку относительно текущего фрейма, с теми же пропорциями в новом фрейме как и в текущем. Фреймы должны лежать на общем родителе.
     */
    func getNewPositionInNewFrame(oldFrame: CGRect, newFrame: CGRect) -> CGPoint {
        let newX_inNewRect = (newFrame.width * self.x) / oldFrame.width
        let newY_inNewRect = (newFrame.height * self.y) / oldFrame.height
        
        let newXAbsolute = newFrame.origin.x + newX_inNewRect
        let newYAbsolute = newFrame.origin.y + newY_inNewRect
        
        return CGPoint(x: newXAbsolute - oldFrame.origin.x, y: newYAbsolute - oldFrame.origin.y)
    }
    
    func offset(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: self.x + dx, y: self.y + dy)
    }
    
    func outParentFrame(parentSize: CGSize) -> Bool {
        return self.x < 0 || self.y < 0 || self.x > parentSize.width || self.y > parentSize.height
    }
    
    func distance(to point: CGPoint) -> CGSize {
        return CGSize(width: point.x - self.x,
                      height: point.y - self.y)
    }
    
    func absoluteDistance(to point: CGPoint) -> CGFloat {
        return sqrt((point.x - self.x) * (point.x - self.x) + (point.y - self.y) * (point.y - self.y))
    }
}

extension CGRect {
    
    typealias WorkWithSize = (_ width: CGFloat) -> (_ height: CGFloat) -> CGSize
    
    /**
     Фукнция возвращает фрейм,который изменяется относительно себя (то есть не меняет центер, но меняет размеры) и в котором указанная точка будет лежать вне пределах родителя.
     */
    static func getNewFrameAndPointWherePointNoSee(point: CGPoint, oldFrame: CGRect, parentSize: CGSize) -> (newFrame: CGRect, newPoint: CGPoint) {
        var newFrame: CGRect = oldFrame
        var changePoint: CGPoint = point
        
        while changePoint.x < parentSize.width && changePoint.x > 0 && changePoint.y < parentSize.height && changePoint.y > 0 {
            newFrame = newFrame.increasedSizeWithoudChangeCenter(howChangeSize: { (width) -> (CGFloat) -> CGSize in 
                return { CGSize(width: width * 1.01, height: $0 * 1.01) }
            })
            changePoint = point.getNewPositionInNewFrame(oldFrame: oldFrame, newFrame: newFrame)
        }
        
        return (newFrame, changePoint)
    }
    
    /**
     Функция изменяет размеры, но не меняет точку центра
     */
    func increasedSizeWithoudChangeCenter(howChangeSize: WorkWithSize) -> CGRect {
        let newSize = howChangeSize(self.size.width)(self.size.height)
        let dX = abs(self.size.width - newSize.width)
        let dY = abs(self.size.height - newSize.height)
        return CGRect(x: self.origin.x - dX/2,
                      y: self.origin.y - dY/2,
                      width: newSize.width,
                      height: newSize.height)
    }
}
