//
//  SearchViewModel.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 10/27/23.
//

import Foundation

class SearchViewModel {
    let coredataManager = CoreDataManager.shared

    lazy var filterData: Observable<[MemoData]> = Observable(coredataManager.getMemos())

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    func getMemosSortedByDateDescending() -> [MemoData] {
        return coredataManager.getMemos().sorted { memo1, memo2 in
            // notificationDate를 사용하여 정렬
            guard let date1 = memo1.notificationDate, let date2 = memo2.notificationDate else {
                return false
            }
            return date1 < date2
        }
    }
}
