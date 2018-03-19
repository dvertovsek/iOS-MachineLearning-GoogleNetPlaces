import UIKit

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override var sectionInset: UIEdgeInsets {
        set {

        }
        get {
            return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
    }

    override var minimumLineSpacing: CGFloat {
        set {}
        get { return 5 }
    }

    override var minimumInteritemSpacing: CGFloat {
        set {}
        get { return 5 }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)

        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }

            layoutAttribute.frame.origin.x = leftMargin

            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }

        return attributes
    }
}
