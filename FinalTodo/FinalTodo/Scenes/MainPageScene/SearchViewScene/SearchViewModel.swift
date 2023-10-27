//
//  SearchViewModel.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 10/27/23.
//

import Foundation

class SearchViewModel {
    let coredataManager = CoreDataManager.shared
    
    lazy var filterData:Observable<[MemoData]> = Observable(coredataManager.getMemos())
}
