//
//  Verb.swift
//  SWVerbs
//
//  Created by EVYATAR DAYAN on 2026-01-05.
//

import Foundation

struct VerbData: Codable {
    let metadata: Metadata
    let verbs: [Verb]
}

struct Metadata: Codable {
    let language: String
    let translation: String
    let verbCount: Int
    let offline: Bool
    let license: String
}

struct Verb: Codable, Identifiable, Equatable {
    var id: String { infinitive }
    let infinitive: String
    let base: String
    let english: [String]
    let regular: Bool
    let examples: VerbExamples
    
    static func == (lhs: Verb, rhs: Verb) -> Bool {
        lhs.id == rhs.id
    }
}

struct VerbExamples: Codable, Equatable {
    let present: Example
    let past: Example
    let perfect: Example
}

struct Example: Codable, Equatable {
    let sv: String
    let en: String
}

