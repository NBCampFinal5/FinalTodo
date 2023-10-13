//
//  Protocol.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 10/13/23.
//

import UIKit

protocol MemoViewTextViewDelegate: UIViewController {
    func textViewShouldBeginEditing(textView: UITextView) -> Bool
    func textViewShouldEndEditing(textView: UITextView) -> Bool
    func textViewDidChange(textView: UITextView)

}

protocol MemoViewCollectionViewDelegate: UIViewController {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    func collectionView(collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    func collectionView(collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
}
