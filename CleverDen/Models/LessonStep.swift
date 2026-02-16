//
//  LessonStep.swift
//  CleverDen
//

import Foundation

enum LessonStep: Identifiable, Codable, Hashable {
    case multipleChoice(MultipleChoiceStep)
    case matchPairs(MatchPairsStep)
    
    var id: String {
        switch self {
        case .multipleChoice(let step): return step.id
        case .matchPairs(let step): return step.id
        }
    }
    
    // MARK: - Codable
    
    private enum CodingKeys: String, CodingKey {
        case type
    }
    
    private enum StepType: String, Codable {
        case multipleChoice
        case matchPairs
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(StepType.self, forKey: .type)
        
        let singleContainer = try decoder.singleValueContainer()
        switch type {
        case .multipleChoice:
            let step = try singleContainer.decode(MultipleChoiceStep.self)
            self = .multipleChoice(step)
        case .matchPairs:
            let step = try singleContainer.decode(MatchPairsStep.self)
            self = .matchPairs(step)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .multipleChoice(let step):
            try container.encode(StepType.multipleChoice, forKey: .type)
            try step.encode(to: encoder)
        case .matchPairs(let step):
            try container.encode(StepType.matchPairs, forKey: .type)
            try step.encode(to: encoder)
        }
    }
}
