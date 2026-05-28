//
//  ContentView.swift
//  p
//
//  Created by Jinsong Li on 2026-05-28.
//

import SwiftUI
import Charts

private extension Color {
    static let cardBackground = Color.gray.opacity(0.15)
}

// MARK: - Models

enum MuscleGroup: String, Codable, CaseIterable, Identifiable, Hashable {
    case chest, back, shoulders, biceps, triceps, forearms
    case core, quads, hamstrings, glutes, calves
    case fullBody, cardio

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .fullBody: return "Full Body"
        default: return rawValue.capitalized
        }
    }

    var color: Color {
        switch self {
        case .chest: return .red
        case .back: return .blue
        case .shoulders: return .orange
        case .biceps: return .purple
        case .triceps: return .pink
        case .forearms: return .indigo
        case .core: return .yellow
        case .quads: return .green
        case .hamstrings: return .teal
        case .glutes: return .mint
        case .calves: return .cyan
        case .fullBody: return .brown
        case .cardio: return .gray
        }
    }
}

enum ExerciseCategory: String, CaseIterable, Identifiable, Hashable {
    case push, pull, legs, core, cardio, fullBody

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .push: return "Push Day"
        case .pull: return "Pull Day"
        case .legs: return "Leg Day"
        case .core: return "Core"
        case .cardio: return "Cardio"
        case .fullBody: return "Full Body"
        }
    }

    var systemImage: String {
        switch self {
        case .push: return "figure.strengthtraining.traditional"
        case .pull: return "figure.pull.up"
        case .legs: return "figure.walk"
        case .core: return "figure.core.training"
        case .cardio: return "figure.run"
        case .fullBody: return "figure.mixed.cardio"
        }
    }

    var color: Color {
        switch self {
        case .push: return .red
        case .pull: return .blue
        case .legs: return .green
        case .core: return .yellow
        case .cardio: return .orange
        case .fullBody: return .purple
        }
    }
}

struct ExerciseTemplate: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let category: ExerciseCategory
    let primaryMuscle: MuscleGroup
    let secondaryMuscles: [MuscleGroup]

    var allMuscles: [MuscleGroup] { [primaryMuscle] + secondaryMuscles }
}

enum ExerciseLibrary {
    static let all: [ExerciseTemplate] = [
        // Push
        .init(name: "Bench Press",       category: .push,     primaryMuscle: .chest,     secondaryMuscles: [.triceps, .shoulders]),
        .init(name: "Incline Press",     category: .push,     primaryMuscle: .chest,     secondaryMuscles: [.shoulders, .triceps]),
        .init(name: "Push Up",           category: .push,     primaryMuscle: .chest,     secondaryMuscles: [.triceps, .core]),
        .init(name: "Overhead Press",    category: .push,     primaryMuscle: .shoulders, secondaryMuscles: [.triceps, .core]),
        .init(name: "Lateral Raise",     category: .push,     primaryMuscle: .shoulders, secondaryMuscles: []),
        .init(name: "Tricep Extension",  category: .push,     primaryMuscle: .triceps,   secondaryMuscles: []),
        .init(name: "Tricep Pushdown",   category: .push,     primaryMuscle: .triceps,   secondaryMuscles: []),
        // Pull
        .init(name: "Deadlift",          category: .pull,     primaryMuscle: .back,      secondaryMuscles: [.hamstrings, .glutes, .core, .forearms]),
        .init(name: "Pull Up",           category: .pull,     primaryMuscle: .back,      secondaryMuscles: [.biceps, .forearms]),
        .init(name: "Lat Pulldown",      category: .pull,     primaryMuscle: .back,      secondaryMuscles: [.biceps]),
        .init(name: "Barbell Row",       category: .pull,     primaryMuscle: .back,      secondaryMuscles: [.biceps, .forearms]),
        .init(name: "Bicep Curl",        category: .pull,     primaryMuscle: .biceps,    secondaryMuscles: [.forearms]),
        .init(name: "Hammer Curl",       category: .pull,     primaryMuscle: .biceps,    secondaryMuscles: [.forearms]),
        // Legs
        .init(name: "Squat",             category: .legs,     primaryMuscle: .quads,     secondaryMuscles: [.glutes, .hamstrings, .core]),
        .init(name: "Lunges",            category: .legs,     primaryMuscle: .quads,     secondaryMuscles: [.glutes, .hamstrings]),
        .init(name: "Leg Press",         category: .legs,     primaryMuscle: .quads,     secondaryMuscles: [.glutes, .hamstrings]),
        .init(name: "Leg Curl",          category: .legs,     primaryMuscle: .hamstrings, secondaryMuscles: []),
        .init(name: "Hip Thrust",        category: .legs,     primaryMuscle: .glutes,    secondaryMuscles: [.hamstrings]),
        .init(name: "Calf Raise",        category: .legs,     primaryMuscle: .calves,    secondaryMuscles: []),
        // Core
        .init(name: "Plank",             category: .core,     primaryMuscle: .core,      secondaryMuscles: [.shoulders]),
        .init(name: "Sit Up",            category: .core,     primaryMuscle: .core,      secondaryMuscles: []),
        .init(name: "Russian Twist",     category: .core,     primaryMuscle: .core,      secondaryMuscles: []),
        // Cardio
        .init(name: "Running",           category: .cardio,   primaryMuscle: .cardio,    secondaryMuscles: [.quads, .calves]),
        .init(name: "Cycling",           category: .cardio,   primaryMuscle: .cardio,    secondaryMuscles: [.quads, .calves]),
        .init(name: "Rowing",            category: .cardio,   primaryMuscle: .cardio,    secondaryMuscles: [.back, .core]),
        // Full body
        .init(name: "Burpees",           category: .fullBody, primaryMuscle: .fullBody,  secondaryMuscles: [.cardio, .core]),
    ]

    static func exercises(in category: ExerciseCategory) -> [ExerciseTemplate] {
        all.filter { $0.category == category }
    }
}

struct ExerciseSet: Identifiable, Codable, Hashable {
    var id = UUID()
    var reps: Int
    var weight: Double
}

struct ExerciseEntry: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
    var primaryMuscle: MuscleGroup
    var secondaryMuscles: [MuscleGroup]
    var sets: [ExerciseSet]

    var allMuscles: [MuscleGroup] { [primaryMuscle] + secondaryMuscles }

    // Volume = sum of reps * weight. If bodyweight (weight = 0), count reps as volume.
    var volume: Double {
        sets.reduce(0) { $0 + Double($1.reps) * max($1.weight, 1) }
    }

    var maxWeight: Double { sets.map(\.weight).max() ?? 0 }
    var totalReps: Int { sets.reduce(0) { $0 + $1.reps } }
}

struct WorkoutEntry: Identifiable, Codable, Hashable {
    var id = UUID()
    var date: Date
    var exercises: [ExerciseEntry]

    var totalVolume: Double { exercises.reduce(0) { $0 + $1.volume } }

    // Per-muscle volume. Primary muscle gets full credit, secondary muscles get half credit.
    var muscleVolume: [MuscleGroup: Double] {
        var dict: [MuscleGroup: Double] = [:]
        for ex in exercises {
            dict[ex.primaryMuscle, default: 0] += ex.volume
            for m in ex.secondaryMuscles {
                dict[m, default: 0] += ex.volume * 0.5
            }
        }
        return dict
    }
}

// MARK: - Store

@Observable
final class WorkoutStore {
    var workouts: [WorkoutEntry] = []

    init() { load() }

    private var fileURL: URL {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return dir.appendingPathComponent("workouts.json")
    }

    func load() {
        guard let data = try? Data(contentsOf: fileURL),
              let decoded = try? JSONDecoder().decode([WorkoutEntry].self, from: data) else { return }
        workouts = decoded
    }

    func save() {
        guard let data = try? JSONEncoder().encode(workouts) else { return }
        try? data.write(to: fileURL)
    }

    func workout(on date: Date) -> WorkoutEntry? {
        workouts.first { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }

    func hasWorkout(on date: Date) -> Bool { workout(on: date) != nil }

    func upsert(_ workout: WorkoutEntry) {
        if let idx = workouts.firstIndex(where: { $0.id == workout.id }) {
            workouts[idx] = workout
        } else {
            workouts.append(workout)
        }
        save()
    }

    func delete(_ workout: WorkoutEntry) {
        workouts.removeAll { $0.id == workout.id }
        save()
    }

    // Progress across all workouts for a given exercise name.
    func history(for exerciseName: String) -> [(date: Date, maxWeight: Double, volume: Double)] {
        workouts
            .sorted { $0.date < $1.date }
            .compactMap { w in
                guard let ex = w.exercises.first(where: { $0.name == exerciseName }) else { return nil }
                return (w.date, ex.maxWeight, ex.volume)
            }
    }

    var loggedExerciseNames: [String] {
        Array(Set(workouts.flatMap { $0.exercises.map(\.name) })).sorted()
    }
}

// MARK: - Nutrition Models

enum MealType: String, Codable, CaseIterable, Identifiable, Hashable {
    case breakfast, lunch, dinner, snack

    var id: String { rawValue }
    var displayName: String { rawValue.capitalized }
    var systemImage: String {
        switch self {
        case .breakfast: return "sunrise.fill"
        case .lunch:     return "sun.max.fill"
        case .dinner:    return "moon.stars.fill"
        case .snack:     return "leaf.fill"
        }
    }
    var color: Color {
        switch self {
        case .breakfast: return .orange
        case .lunch:     return .yellow
        case .dinner:    return .indigo
        case .snack:     return .green
        }
    }
}

enum FoodCategory: String, Codable, CaseIterable, Identifiable, Hashable {
    case proteins, carbs, vegetables, fruits, dairy, fats, snacks, drinks, fastFood, restaurant, custom

    var id: String { rawValue }
    var displayName: String {
        switch self {
        case .fastFood:   return "Fast Food"
        case .restaurant: return "Restaurant"
        default:          return rawValue.capitalized
        }
    }
    var systemImage: String {
        switch self {
        case .proteins:   return "fish.fill"
        case .carbs:      return "fork.knife"
        case .vegetables: return "leaf.fill"
        case .fruits:     return "applelogo"
        case .dairy:      return "drop.fill"
        case .fats:       return "circle.hexagongrid.fill"
        case .snacks:     return "birthday.cake.fill"
        case .drinks:     return "cup.and.saucer.fill"
        case .fastFood:   return "takeoutbag.and.cup.and.straw.fill"
        case .restaurant: return "fork.knife.circle.fill"
        case .custom:     return "star.fill"
        }
    }
    var color: Color {
        switch self {
        case .proteins:   return .red
        case .carbs:      return .orange
        case .vegetables: return .green
        case .fruits:     return .pink
        case .dairy:      return .blue
        case .fats:       return .yellow
        case .snacks:     return .purple
        case .drinks:     return .teal
        case .fastFood:   return .brown
        case .restaurant: return .indigo
        case .custom:     return .accentColor
        }
    }
}

struct FoodTemplate: Identifiable, Hashable, Codable {
    var id: UUID = UUID()
    var name: String
    var category: FoodCategory
    var servingDescription: String
    var calories: Double
    var protein: Double
    var carbs: Double
    var fat: Double
}

enum FoodLibrary {
    static let all: [FoodTemplate] = [
        // Proteins
        .init(name: "Chicken Breast",     category: .proteins,   servingDescription: "100g cooked",       calories: 165, protein: 31, carbs: 0,  fat: 3.6),
        .init(name: "Ground Beef (85/15)", category: .proteins,  servingDescription: "100g cooked",       calories: 250, protein: 26, carbs: 0,  fat: 17),
        .init(name: "Salmon",             category: .proteins,   servingDescription: "100g cooked",       calories: 208, protein: 20, carbs: 0,  fat: 13),
        .init(name: "Tuna (canned)",      category: .proteins,   servingDescription: "100g",              calories: 132, protein: 28, carbs: 0,  fat: 1),
        .init(name: "Eggs",               category: .proteins,   servingDescription: "1 large",           calories: 72,  protein: 6.3, carbs: 0.4, fat: 5),
        .init(name: "Tofu",               category: .proteins,   servingDescription: "100g",              calories: 76,  protein: 8,  carbs: 1.9, fat: 4.8),
        .init(name: "Greek Yogurt",       category: .proteins,   servingDescription: "170g (1 container)", calories: 100, protein: 17, carbs: 6,  fat: 0),
        .init(name: "Protein Powder",     category: .proteins,   servingDescription: "1 scoop",           calories: 120, protein: 24, carbs: 3,  fat: 1.5),
        // Carbs
        .init(name: "White Rice",         category: .carbs,      servingDescription: "1 cup cooked",      calories: 205, protein: 4.3, carbs: 45, fat: 0.4),
        .init(name: "Brown Rice",         category: .carbs,      servingDescription: "1 cup cooked",      calories: 218, protein: 5,  carbs: 46, fat: 1.6),
        .init(name: "Pasta",              category: .carbs,      servingDescription: "1 cup cooked",      calories: 220, protein: 8,  carbs: 43, fat: 1.3),
        .init(name: "Bread",              category: .carbs,      servingDescription: "1 slice",           calories: 80,  protein: 4,  carbs: 14, fat: 1),
        .init(name: "Oats",               category: .carbs,      servingDescription: "1/2 cup dry",       calories: 150, protein: 5,  carbs: 27, fat: 3),
        .init(name: "Potato",             category: .carbs,      servingDescription: "1 medium",          calories: 161, protein: 4.3, carbs: 37, fat: 0.2),
        .init(name: "Sweet Potato",       category: .carbs,      servingDescription: "1 medium",          calories: 112, protein: 2,  carbs: 26, fat: 0.1),
        // Vegetables
        .init(name: "Broccoli",           category: .vegetables, servingDescription: "1 cup",             calories: 31,  protein: 2.5, carbs: 6,  fat: 0.3),
        .init(name: "Spinach",            category: .vegetables, servingDescription: "1 cup raw",         calories: 7,   protein: 1,  carbs: 1,  fat: 0),
        .init(name: "Carrots",            category: .vegetables, servingDescription: "1 cup",             calories: 52,  protein: 1.2, carbs: 12, fat: 0.3),
        .init(name: "Bell Pepper",        category: .vegetables, servingDescription: "1 medium",          calories: 24,  protein: 1,  carbs: 6,  fat: 0.2),
        // Fruits
        .init(name: "Apple",              category: .fruits,     servingDescription: "1 medium",          calories: 95,  protein: 0.5, carbs: 25, fat: 0.3),
        .init(name: "Banana",             category: .fruits,     servingDescription: "1 medium",          calories: 105, protein: 1.3, carbs: 27, fat: 0.4),
        .init(name: "Blueberries",        category: .fruits,     servingDescription: "1 cup",             calories: 84,  protein: 1.1, carbs: 21, fat: 0.5),
        .init(name: "Orange",             category: .fruits,     servingDescription: "1 medium",          calories: 62,  protein: 1.2, carbs: 15, fat: 0.2),
        // Dairy
        .init(name: "Milk (2%)",          category: .dairy,      servingDescription: "1 cup",             calories: 122, protein: 8,  carbs: 12, fat: 5),
        .init(name: "Cheddar Cheese",     category: .dairy,      servingDescription: "1 oz",              calories: 113, protein: 7,  carbs: 1,  fat: 9),
        .init(name: "Cottage Cheese",     category: .dairy,      servingDescription: "100g",              calories: 98,  protein: 11, carbs: 3.4, fat: 4.3),
        // Fats
        .init(name: "Olive Oil",          category: .fats,       servingDescription: "1 tbsp",            calories: 120, protein: 0,  carbs: 0,  fat: 14),
        .init(name: "Avocado",            category: .fats,       servingDescription: "1 medium",          calories: 234, protein: 2.9, carbs: 12, fat: 21),
        .init(name: "Almonds",            category: .fats,       servingDescription: "1 oz (~23 nuts)",   calories: 164, protein: 6,  carbs: 6,  fat: 14),
        .init(name: "Peanut Butter",      category: .fats,       servingDescription: "2 tbsp",            calories: 188, protein: 8,  carbs: 7,  fat: 16),
        // Snacks
        .init(name: "Protein Bar",        category: .snacks,     servingDescription: "1 bar",             calories: 200, protein: 20, carbs: 22, fat: 7),
        .init(name: "Granola",            category: .snacks,     servingDescription: "1/2 cup",           calories: 230, protein: 5,  carbs: 40, fat: 7),
        .init(name: "Dark Chocolate",     category: .snacks,     servingDescription: "1 oz",              calories: 170, protein: 2,  carbs: 13, fat: 12),
        // Drinks
        .init(name: "Water",              category: .drinks,     servingDescription: "1 cup",             calories: 0,   protein: 0,  carbs: 0,  fat: 0),
        .init(name: "Coffee (Black)",     category: .drinks,     servingDescription: "1 cup",             calories: 2,   protein: 0,  carbs: 0,  fat: 0),
        .init(name: "Orange Juice",       category: .drinks,     servingDescription: "1 cup",             calories: 112, protein: 2,  carbs: 26, fat: 0.5),
        .init(name: "Soda",               category: .drinks,     servingDescription: "1 can (12 oz)",     calories: 140, protein: 0,  carbs: 39, fat: 0),
        // Fast Food
        .init(name: "Big Mac",                 category: .fastFood, servingDescription: "1 burger",         calories: 563, protein: 26, carbs: 45, fat: 33),
        .init(name: "Quarter Pounder w/ Cheese", category: .fastFood, servingDescription: "1 burger",       calories: 520, protein: 30, carbs: 42, fat: 26),
        .init(name: "McChicken",               category: .fastFood, servingDescription: "1 sandwich",       calories: 400, protein: 14, carbs: 39, fat: 21),
        .init(name: "McDonald's Fries (Medium)", category: .fastFood, servingDescription: "1 order",        calories: 320, protein: 4,  carbs: 43, fat: 15),
        .init(name: "Chicken McNuggets (10 pc)", category: .fastFood, servingDescription: "1 order",        calories: 420, protein: 23, carbs: 26, fat: 25),
        .init(name: "Whopper",                 category: .fastFood, servingDescription: "1 burger",         calories: 660, protein: 28, carbs: 49, fat: 40),
        .init(name: "Wendy's Baconator",       category: .fastFood, servingDescription: "1 burger",         calories: 950, protein: 60, carbs: 39, fat: 62),
        .init(name: "Chick-fil-A Sandwich",    category: .fastFood, servingDescription: "1 sandwich",       calories: 440, protein: 28, carbs: 41, fat: 19),
        .init(name: "Chick-fil-A Nuggets (8 pc)", category: .fastFood, servingDescription: "1 order",       calories: 250, protein: 27, carbs: 11, fat: 11),
        .init(name: "Taco Bell Crunchy Taco",  category: .fastFood, servingDescription: "1 taco",           calories: 170, protein: 8,  carbs: 13, fat: 9),
        .init(name: "Chipotle Burrito Bowl",   category: .fastFood, servingDescription: "1 bowl (chicken)", calories: 720, protein: 45, carbs: 75, fat: 20),
        .init(name: "KFC Original (1 pc)",     category: .fastFood, servingDescription: "1 piece",          calories: 320, protein: 30, carbs: 11, fat: 19),
        .init(name: "Subway 6\" Turkey",       category: .fastFood, servingDescription: "1 sub",            calories: 280, protein: 18, carbs: 46, fat: 3.5),
        .init(name: "Domino's Cheese Slice",   category: .fastFood, servingDescription: "1 slice (medium)", calories: 200, protein: 8,  carbs: 27, fat: 7),
        .init(name: "Five Guys Burger",        category: .fastFood, servingDescription: "1 burger",         calories: 700, protein: 39, carbs: 39, fat: 43),
        // Restaurant
        .init(name: "Spaghetti Bolognese",     category: .restaurant, servingDescription: "1 plate",        calories: 650, protein: 30, carbs: 90, fat: 18),
        .init(name: "Pasta Carbonara",         category: .restaurant, servingDescription: "1 plate",        calories: 720, protein: 25, carbs: 85, fat: 30),
        .init(name: "Fettuccine Alfredo",      category: .restaurant, servingDescription: "1 plate",        calories: 800, protein: 22, carbs: 75, fat: 45),
        .init(name: "Margherita Pizza Slice",  category: .restaurant, servingDescription: "1 slice",        calories: 270, protein: 12, carbs: 35, fat: 9),
        .init(name: "Pepperoni Pizza Slice",   category: .restaurant, servingDescription: "1 slice",        calories: 313, protein: 14, carbs: 36, fat: 12),
        .init(name: "California Roll",         category: .restaurant, servingDescription: "8 pieces",       calories: 255, protein: 9,  carbs: 38, fat: 7),
        .init(name: "Spicy Tuna Roll",         category: .restaurant, servingDescription: "8 pieces",       calories: 290, protein: 13, carbs: 41, fat: 8),
        .init(name: "Salmon Nigiri",           category: .restaurant, servingDescription: "2 pieces",       calories: 130, protein: 13, carbs: 13, fat: 3),
        .init(name: "Ramen Bowl",              category: .restaurant, servingDescription: "1 bowl",         calories: 600, protein: 25, carbs: 80, fat: 18),
        .init(name: "Pad Thai (Chicken)",      category: .restaurant, servingDescription: "1 plate",        calories: 700, protein: 30, carbs: 80, fat: 25),
        .init(name: "Beef Pho",                category: .restaurant, servingDescription: "1 bowl",         calories: 350, protein: 20, carbs: 45, fat: 8),
        .init(name: "General Tso's Chicken",   category: .restaurant, servingDescription: "1 plate",        calories: 760, protein: 25, carbs: 60, fat: 45),
        .init(name: "Chicken Tikka Masala",    category: .restaurant, servingDescription: "1 plate",        calories: 530, protein: 32, carbs: 30, fat: 30),
        .init(name: "Caesar Salad w/ Chicken", category: .restaurant, servingDescription: "1 salad",        calories: 450, protein: 35, carbs: 12, fat: 25),
        .init(name: "Restaurant Cheeseburger", category: .restaurant, servingDescription: "1 burger",       calories: 700, protein: 35, carbs: 45, fat: 40),
    ]

    static func foods(in category: FoodCategory) -> [FoodTemplate] {
        all.filter { $0.category == category }
    }
}

struct FoodEntry: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
    var category: FoodCategory
    var mealType: MealType
    var servings: Double
    var servingDescription: String
    var caloriesPerServing: Double
    var proteinPerServing: Double
    var carbsPerServing: Double
    var fatPerServing: Double

    var calories: Double { caloriesPerServing * servings }
    var protein: Double  { proteinPerServing  * servings }
    var carbs: Double    { carbsPerServing    * servings }
    var fat: Double      { fatPerServing      * servings }
}

struct DayFoodLog: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var date: Date
    var entries: [FoodEntry]
    var waterCups: Double = 0

    enum CodingKeys: String, CodingKey {
        case id, date, entries, waterCups
    }

    init(id: UUID = UUID(), date: Date, entries: [FoodEntry], waterCups: Double = 0) {
        self.id = id
        self.date = date
        self.entries = entries
        self.waterCups = waterCups
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(UUID.self, forKey: .id)
        date = try c.decode(Date.self, forKey: .date)
        entries = try c.decode([FoodEntry].self, forKey: .entries)
        waterCups = try c.decodeIfPresent(Double.self, forKey: .waterCups) ?? 0
    }

    var totalCalories: Double { entries.reduce(0) { $0 + $1.calories } }
    var totalProtein: Double  { entries.reduce(0) { $0 + $1.protein  } }
    var totalCarbs: Double    { entries.reduce(0) { $0 + $1.carbs    } }
    var totalFat: Double      { entries.reduce(0) { $0 + $1.fat      } }

    func entries(for meal: MealType) -> [FoodEntry] {
        entries.filter { $0.mealType == meal }
    }
    func calories(for meal: MealType) -> Double {
        entries(for: meal).reduce(0) { $0 + $1.calories }
    }
}

// MARK: - User Profile

enum Sex: String, Codable, CaseIterable, Identifiable, Hashable {
    case male, female
    var id: String { rawValue }
    var displayName: String { rawValue.capitalized }
}

enum ActivityLevel: String, Codable, CaseIterable, Identifiable, Hashable {
    case sedentary, light, moderate, active, veryActive
    var id: String { rawValue }
    var multiplier: Double {
        switch self {
        case .sedentary:  return 1.2
        case .light:      return 1.375
        case .moderate:   return 1.55
        case .active:     return 1.725
        case .veryActive: return 1.9
        }
    }
    var displayName: String {
        switch self {
        case .sedentary:  return "Sedentary"
        case .light:      return "Lightly Active"
        case .moderate:   return "Moderately Active"
        case .active:     return "Very Active"
        case .veryActive: return "Extremely Active"
        }
    }
    var detail: String {
        switch self {
        case .sedentary:  return "Little or no exercise"
        case .light:      return "Light exercise 1–3 days/week"
        case .moderate:   return "Moderate exercise 3–5 days/week"
        case .active:     return "Hard exercise 6–7 days/week"
        case .veryActive: return "Very hard exercise + physical job"
        }
    }
}

enum FitnessGoal: String, Codable, CaseIterable, Identifiable, Hashable {
    case lose, maintain, gain
    var id: String { rawValue }
    var displayName: String {
        switch self {
        case .lose:     return "Lose Weight"
        case .maintain: return "Maintain"
        case .gain:     return "Gain Muscle"
        }
    }
    var calorieAdjustment: Double {
        switch self {
        case .lose:     return -500
        case .maintain: return 0
        case .gain:     return 300
        }
    }
    var proteinPerLb: Double {
        switch self {
        case .lose:     return 1.0
        case .maintain: return 0.8
        case .gain:     return 1.0
        }
    }
}

struct UserProfile: Codable, Hashable {
    var heightInches: Double = 68      // 5'8"
    var weightLb: Double = 150
    var age: Int = 25
    var sex: Sex = .male
    var activityLevel: ActivityLevel = .moderate
    var fitnessGoal: FitnessGoal = .maintain

    // nil = use suggested
    var customCalorieGoal: Double? = nil
    var customProteinGoal: Double? = nil
    var customCarbsGoal: Double? = nil
    var customFatGoal: Double? = nil
    var customWaterCupsGoal: Double? = nil

    // BMR (Mifflin–St Jeor)
    var bmr: Double {
        let kg = weightLb * 0.453592
        let cm = heightInches * 2.54
        let base = 10 * kg + 6.25 * cm - 5 * Double(age)
        return sex == .male ? base + 5 : base - 161
    }
    var tdee: Double { bmr * activityLevel.multiplier }

    var suggestedCalories: Double {
        max(1200, tdee + fitnessGoal.calorieAdjustment)
    }
    var suggestedProtein: Double {
        max(40, weightLb * fitnessGoal.proteinPerLb)
    }
    var suggestedFat: Double {
        // 25% of calories from fat (9 kcal/g)
        suggestedCalories * 0.25 / 9
    }
    var suggestedCarbs: Double {
        // Remainder from carbs (4 kcal/g)
        let proteinCals = suggestedProtein * 4
        let fatCals = suggestedFat * 9
        return max(0, (suggestedCalories - proteinCals - fatCals) / 4)
    }
    var suggestedWaterCups: Double {
        // ~half body weight in oz, divided by 8 oz/cup, with a floor of 8
        max(8, (weightLb / 2) / 8)
    }

    // Effective goals
    var calorieGoal: Double  { customCalorieGoal  ?? suggestedCalories }
    var proteinGoal: Double  { customProteinGoal  ?? suggestedProtein }
    var carbsGoal: Double    { customCarbsGoal    ?? suggestedCarbs }
    var fatGoal: Double      { customFatGoal      ?? suggestedFat }
    var waterGoalCups: Double { customWaterCupsGoal ?? suggestedWaterCups }
}

@Observable
final class ProfileStore {
    var profile: UserProfile = UserProfile()

    init() { load() }

    private var fileURL: URL {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return dir.appendingPathComponent("profile.json")
    }

    func load() {
        guard let data = try? Data(contentsOf: fileURL),
              let decoded = try? JSONDecoder().decode(UserProfile.self, from: data) else { return }
        profile = decoded
    }

    func save() {
        if let data = try? JSONEncoder().encode(profile) {
            try? data.write(to: fileURL)
        }
    }
}

// MARK: - Nutrition Store

@Observable
final class NutritionStore {
    var logs: [DayFoodLog] = []
    var customFoods: [FoodTemplate] = []

    init() { load() }

    private var docsDir: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    private var logsURL: URL { docsDir.appendingPathComponent("nutrition.json") }
    private var customURL: URL { docsDir.appendingPathComponent("custom_foods.json") }

    func load() {
        if let data = try? Data(contentsOf: logsURL),
           let decoded = try? JSONDecoder().decode([DayFoodLog].self, from: data) {
            logs = decoded
        }
        if let data = try? Data(contentsOf: customURL),
           let decoded = try? JSONDecoder().decode([FoodTemplate].self, from: data) {
            customFoods = decoded
        }
    }

    func save() {
        if let data = try? JSONEncoder().encode(logs) {
            try? data.write(to: logsURL)
        }
    }

    func saveCustomFoods() {
        if let data = try? JSONEncoder().encode(customFoods) {
            try? data.write(to: customURL)
        }
    }

    func addCustomFood(_ food: FoodTemplate) {
        customFoods.append(food)
        saveCustomFoods()
    }

    func deleteCustomFood(_ food: FoodTemplate) {
        customFoods.removeAll { $0.id == food.id }
        saveCustomFoods()
    }

    func log(on date: Date) -> DayFoodLog? {
        logs.first { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }

    func hasLog(on date: Date) -> Bool { log(on: date) != nil }

    func upsert(_ log: DayFoodLog) {
        if let idx = logs.firstIndex(where: { $0.id == log.id }) {
            logs[idx] = log
        } else {
            logs.append(log)
        }
        save()
    }

    func delete(_ log: DayFoodLog) {
        logs.removeAll { $0.id == log.id }
        save()
    }

    // Averages over the last N days that have at least one entry (so empty days don't pull averages down).
    func averages(daysBack: Int = 7) -> (calories: Double, protein: Double, carbs: Double, fat: Double, daysCounted: Int) {
        let cutoff = Calendar.current.date(byAdding: .day, value: -daysBack, to: Date()) ?? Date()
        let recent = logs.filter { $0.date >= cutoff && !$0.entries.isEmpty }
        guard !recent.isEmpty else { return (0, 0, 0, 0, 0) }
        let n = Double(recent.count)
        let totals = recent.reduce((cal: 0.0, p: 0.0, c: 0.0, f: 0.0)) { acc, log in
            (acc.cal + log.totalCalories, acc.p + log.totalProtein, acc.c + log.totalCarbs, acc.f + log.totalFat)
        }
        return (totals.cal / n, totals.p / n, totals.c / n, totals.f / n, recent.count)
    }
}

// MARK: - Root

struct ContentView: View {
    @State private var workoutStore = WorkoutStore()
    @State private var nutritionStore = NutritionStore()
    @State private var profileStore = ProfileStore()

    var body: some View {
        TabView {
            CalendarTab()
                .tabItem { Label("Workouts", systemImage: "calendar") }
            NutritionTab()
                .tabItem { Label("Nutrition", systemImage: "fork.knife") }
            ProgressTab()
                .tabItem { Label("Progress", systemImage: "chart.line.uptrend.xyaxis") }
            YouTab()
                .tabItem { Label("You", systemImage: "person.crop.circle.fill") }
        }
        .environment(workoutStore)
        .environment(nutritionStore)
        .environment(profileStore)
        .frame(minWidth: 600, idealWidth: 720, minHeight: 700, idealHeight: 820)
    }
}

// MARK: - Month Calendar (shared)

struct MonthCalendarView: View {
    @Binding var displayedMonth: Date
    @Binding var selectedDate: Date
    var hasMarker: (Date) -> Bool
    var markerColor: Color = .accentColor

    var body: some View {
        VStack(spacing: 12) {
            monthHeader
            weekdayHeader
            calendarGrid
        }
    }

    private var monthHeader: some View {
        HStack {
            Button { shiftMonth(-1) } label: {
                Image(systemName: "chevron.left").font(.title3)
            }
            Spacer()
            Text(monthTitle).font(.title2).bold()
            Spacer()
            Button { shiftMonth(1) } label: {
                Image(systemName: "chevron.right").font(.title3)
            }
        }
    }

    private var weekdayHeader: some View {
        let symbols = Calendar.current.shortStandaloneWeekdaySymbols
        return HStack {
            ForEach(symbols, id: \.self) { s in
                Text(s).font(.caption).foregroundStyle(.secondary).frame(maxWidth: .infinity)
            }
        }
    }

    private var calendarGrid: some View {
        let days = daysInMonthGrid()
        let columns = Array(repeating: GridItem(.flexible(), spacing: 6), count: 7)
        return LazyVGrid(columns: columns, spacing: 6) {
            ForEach(Array(days.enumerated()), id: \.offset) { _, day in
                if let day = day {
                    DayCell(
                        date: day,
                        isSelected: Calendar.current.isDate(day, inSameDayAs: selectedDate),
                        hasMarker: hasMarker(day),
                        markerColor: markerColor
                    )
                    .onTapGesture {
                        selectedDate = Calendar.current.startOfDay(for: day)
                    }
                } else {
                    Color.clear.frame(height: 40)
                }
            }
        }
    }

    private var monthTitle: String {
        let f = DateFormatter()
        f.dateFormat = "MMMM yyyy"
        return f.string(from: displayedMonth)
    }

    private func shiftMonth(_ delta: Int) {
        if let new = Calendar.current.date(byAdding: .month, value: delta, to: displayedMonth) {
            displayedMonth = new
        }
    }

    private func daysInMonthGrid() -> [Date?] {
        let cal = Calendar.current
        guard let monthInterval = cal.dateInterval(of: .month, for: displayedMonth),
              let monthRange = cal.range(of: .day, in: .month, for: displayedMonth)
        else { return [] }

        let firstWeekday = cal.component(.weekday, from: monthInterval.start)
        let leading = firstWeekday - 1
        var result: [Date?] = Array(repeating: nil, count: leading)
        for day in monthRange {
            if let d = cal.date(byAdding: .day, value: day - 1, to: monthInterval.start) {
                result.append(d)
            }
        }
        while result.count % 7 != 0 { result.append(nil) }
        return result
    }
}

// MARK: - Calendar Tab

struct CalendarTab: View {
    @Environment(WorkoutStore.self) private var store
    @State private var displayedMonth: Date = Date()
    @State private var selectedDate: Date = Calendar.current.startOfDay(for: Date())

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    MonthCalendarView(
                        displayedMonth: $displayedMonth,
                        selectedDate: $selectedDate,
                        hasMarker: { store.hasWorkout(on: $0) }
                    )
                    Divider().padding(.vertical, 4)
                    DayDetailView(date: selectedDate)
                }
                .padding()
            }
            .navigationTitle("Workouts")
        }
    }
}

struct DayCell: View {
    let date: Date
    let isSelected: Bool
    let hasMarker: Bool
    var markerColor: Color = .accentColor

    var body: some View {
        let dayNum = Calendar.current.component(.day, from: date)
        let isToday = Calendar.current.isDateInToday(date)
        VStack(spacing: 2) {
            Text("\(dayNum)")
                .font(.callout)
                .fontWeight(isToday ? .bold : .regular)
                .foregroundStyle(isSelected ? .white : .primary)
            Circle()
                .fill(hasMarker ? (isSelected ? Color.white : markerColor) : Color.clear)
                .frame(width: 5, height: 5)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 40)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(isSelected ? markerColor : (isToday ? markerColor.opacity(0.15) : Color.clear))
        )
    }
}

// MARK: - Day Detail

struct DayDetailView: View {
    @Environment(WorkoutStore.self) private var store
    let date: Date
    @State private var showingAdd = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(dateTitle).font(.headline)
                Spacer()
                Button {
                    showingAdd = true
                } label: {
                    Label("Add Exercise", systemImage: "plus.circle.fill")
                }
            }

            if let workout = store.workout(on: date), !workout.exercises.isEmpty {
                ForEach(workout.exercises) { ex in
                    ExerciseRow(exercise: ex, onDelete: {
                        var updated = workout
                        updated.exercises.removeAll { $0.id == ex.id }
                        if updated.exercises.isEmpty {
                            store.delete(updated)
                        } else {
                            store.upsert(updated)
                        }
                    })
                }
                MuscleEffectivenessView(workout: workout)
            } else {
                Text("No exercises logged for this day.")
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 12)
            }
        }
        .sheet(isPresented: $showingAdd) {
            AddExerciseSheet(date: date)
        }
    }

    private var dateTitle: String {
        let f = DateFormatter()
        f.dateStyle = .full
        return f.string(from: date)
    }
}

struct ExerciseRow: View {
    let exercise: ExerciseEntry
    let onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(exercise.name).font(.headline)
                Spacer()
                Button(role: .destructive, action: onDelete) {
                    Image(systemName: "trash").font(.caption)
                }
            }
            HStack(spacing: 6) {
                ForEach(exercise.allMuscles, id: \.self) { m in
                    Text(m.displayName)
                        .font(.caption2)
                        .padding(.horizontal, 6).padding(.vertical, 2)
                        .background(m.color.opacity(0.2))
                        .foregroundStyle(m.color)
                        .clipShape(Capsule())
                }
            }
            ForEach(Array(exercise.sets.enumerated()), id: \.element.id) { idx, set in
                HStack {
                    Text("Set \(idx + 1)").font(.caption).foregroundStyle(.secondary)
                    Spacer()
                    Text("\(set.reps) reps × \(set.weight, specifier: "%.1f") lb")
                        .font(.caption.monospacedDigit())
                }
            }
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.cardBackground))
    }
}

// MARK: - Muscle Effectiveness

struct MuscleEffectivenessView: View {
    let workout: WorkoutEntry

    var body: some View {
        let entries = workout.muscleVolume.sorted { $0.value > $1.value }
        let maxVolume = entries.first?.value ?? 1
        VStack(alignment: .leading, spacing: 8) {
            Text("Muscles Worked").font(.headline).padding(.top, 8)
            ForEach(entries, id: \.key) { (muscle, vol) in
                HStack(spacing: 8) {
                    Text(muscle.displayName)
                        .font(.caption)
                        .frame(width: 90, alignment: .leading)
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(muscle.color.opacity(0.2))
                            RoundedRectangle(cornerRadius: 4)
                                .fill(muscle.color)
                                .frame(width: geo.size.width * CGFloat(vol / maxVolume))
                        }
                    }
                    .frame(height: 12)
                    Text(effectivenessLabel(vol: vol, max: maxVolume))
                        .font(.caption2.monospacedDigit())
                        .foregroundStyle(.secondary)
                        .frame(width: 40, alignment: .trailing)
                }
            }
            Text("Total volume: \(Int(workout.totalVolume))")
                .font(.caption).foregroundStyle(.secondary)
                .padding(.top, 4)
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.cardBackground))
    }

    private func effectivenessLabel(vol: Double, max: Double) -> String {
        let pct = Int((vol / max) * 100)
        return "\(pct)%"
    }
}

// MARK: - Wrap Layout (flow-wrapping HStack)

struct WrapLayout: Layout {
    var spacing: CGFloat = 6

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        var rowWidth: CGFloat = 0
        var totalHeight: CGFloat = 0
        var rowHeight: CGFloat = 0
        for sub in subviews {
            let s = sub.sizeThatFits(.unspecified)
            if rowWidth + s.width > maxWidth && rowWidth > 0 {
                totalHeight += rowHeight + spacing
                rowWidth = 0
                rowHeight = 0
            }
            rowWidth += s.width + spacing
            rowHeight = max(rowHeight, s.height)
        }
        totalHeight += rowHeight
        let width = (proposal.width ?? rowWidth)
        return CGSize(width: width, height: totalHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let maxWidth = bounds.width
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        for sub in subviews {
            let s = sub.sizeThatFits(.unspecified)
            if x + s.width > maxWidth && x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            sub.place(at: CGPoint(x: bounds.minX + x, y: bounds.minY + y),
                      proposal: ProposedViewSize(s))
            x += s.width + spacing
            rowHeight = max(rowHeight, s.height)
        }
    }
}

// MARK: - Set Editor Row

struct SetEditorRow: View {
    let index: Int
    @Binding var reps: Int
    @Binding var weight: Double
    let canDelete: Bool
    let onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Set \(index + 1)").font(.subheadline).bold()
                Spacer()
                Button(role: .destructive, action: onDelete) {
                    Image(systemName: "minus.circle")
                }
                .buttonStyle(.borderless)
                .disabled(!canDelete)
            }
            HStack(spacing: 16) {
                HStack(spacing: 8) {
                    Text("Reps").frame(width: 50, alignment: .leading)
                    Text("\(reps)").frame(minWidth: 28, alignment: .leading).monospacedDigit()
                    Stepper("", value: $reps, in: 1...100).labelsHidden()
                }
                Divider().frame(height: 20)
                HStack(spacing: 8) {
                    Text("Weight").frame(width: 60, alignment: .leading)
                    TextField("0", value: $weight, format: .number)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 80)
                        .textFieldStyle(.roundedBorder)
                    Text("lb").foregroundStyle(.secondary)
                }
            }
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 8).fill(Color.white.opacity(0.001)))
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.2)))
    }
}

// MARK: - Add Exercise Sheet

struct AddExerciseSheet: View {
    @Environment(WorkoutStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    let date: Date

    @State private var selectedCategory: ExerciseCategory = .push
    @State private var selectedTemplate: ExerciseTemplate? = nil
    @State private var sets: [ExerciseSet] = [ExerciseSet(reps: 10, weight: 0)]

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Log Exercise").font(.title2).bold()
                Spacer()
                Button("Cancel") { dismiss() }
                Button("Save", action: save)
                    .keyboardShortcut(.defaultAction)
                    .disabled(selectedTemplate == nil || sets.isEmpty)
            }
            .padding()
            Divider()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    categoryCard
                    exerciseListCard
                    if selectedTemplate != nil {
                        setsCard
                    }
                }
                .padding()
            }
        }
        .frame(minWidth: 540, idealWidth: 600, minHeight: 620, idealHeight: 740)
    }

    private var categoryCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Category").font(.headline)
            WrapLayout(spacing: 8) {
                ForEach(ExerciseCategory.allCases) { cat in
                    Button {
                        selectedCategory = cat
                        selectedTemplate = nil
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: cat.systemImage)
                            Text(cat.displayName)
                        }
                        .font(.callout)
                        .padding(.horizontal, 12).padding(.vertical, 7)
                        .background(
                            Capsule().fill(
                                selectedCategory == cat
                                ? cat.color.opacity(0.25)
                                : Color.gray.opacity(0.12)
                            )
                        )
                        .overlay(
                            Capsule().stroke(
                                selectedCategory == cat ? cat.color : Color.clear,
                                lineWidth: 1.5
                            )
                        )
                        .foregroundStyle(selectedCategory == cat ? cat.color : .primary)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.cardBackground))
    }

    private var exerciseListCard: some View {
        let exercises = ExerciseLibrary.exercises(in: selectedCategory)
        return VStack(alignment: .leading, spacing: 8) {
            Text("Exercise").font(.headline)
            VStack(spacing: 6) {
                ForEach(exercises) { ex in
                    Button {
                        selectedTemplate = ex
                    } label: {
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: selectedTemplate == ex ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(selectedTemplate == ex ? selectedCategory.color : .secondary)
                                .padding(.top, 2)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(ex.name).font(.body)
                                WrapLayout(spacing: 4) {
                                    ForEach(ex.allMuscles, id: \.self) { m in
                                        Text(m.displayName)
                                            .font(.caption2)
                                            .padding(.horizontal, 6).padding(.vertical, 2)
                                            .background(m.color.opacity(0.2))
                                            .foregroundStyle(m.color)
                                            .clipShape(Capsule())
                                    }
                                }
                            }
                            Spacer(minLength: 0)
                        }
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 8).fill(
                                selectedTemplate == ex
                                ? selectedCategory.color.opacity(0.08)
                                : Color.clear
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 8).stroke(
                                selectedTemplate == ex ? selectedCategory.color : Color.gray.opacity(0.2),
                                lineWidth: 1
                            )
                        )
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.cardBackground))
    }

    private var setsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Sets").font(.headline)
            ForEach(sets.indices, id: \.self) { idx in
                SetEditorRow(
                    index: idx,
                    reps: $sets[idx].reps,
                    weight: $sets[idx].weight,
                    canDelete: sets.count > 1,
                    onDelete: { sets.remove(at: idx) }
                )
            }
            Button {
                let last = sets.last
                sets.append(ExerciseSet(reps: last?.reps ?? 10, weight: last?.weight ?? 0))
            } label: {
                Label("Add Set", systemImage: "plus")
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.cardBackground))
    }

    private func save() {
        guard let template = selectedTemplate else { return }
        let entry = ExerciseEntry(
            name: template.name,
            primaryMuscle: template.primaryMuscle,
            secondaryMuscles: template.secondaryMuscles,
            sets: sets
        )
        var workout = store.workout(on: date) ?? WorkoutEntry(date: Calendar.current.startOfDay(for: date), exercises: [])
        workout.exercises.append(entry)
        store.upsert(workout)
        dismiss()
    }
}

// MARK: - Progress Tab

struct ProgressTab: View {
    @Environment(WorkoutStore.self) private var store
    @State private var selectedExercise: String?

    var body: some View {
        NavigationStack {
            let names = store.loggedExerciseNames
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if names.isEmpty {
                        ContentUnavailableView(
                            "No data yet",
                            systemImage: "chart.line.uptrend.xyaxis",
                            description: Text("Log some workouts on the Calendar tab to see progress here.")
                        )
                        .padding(.top, 60)
                    } else {
                        Picker("Exercise", selection: $selectedExercise) {
                            ForEach(names, id: \.self) { n in
                                Text(n).tag(Optional(n))
                            }
                        }
                        .pickerStyle(.menu)
                        .padding(.horizontal)

                        if let name = selectedExercise ?? names.first {
                            ExerciseProgressChart(exerciseName: name)
                                .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Progress")
            .onAppear {
                if selectedExercise == nil { selectedExercise = names.first }
            }
        }
    }
}

struct ExerciseProgressChart: View {
    @Environment(WorkoutStore.self) private var store
    let exerciseName: String

    var body: some View {
        let data = store.history(for: exerciseName)
        VStack(alignment: .leading, spacing: 12) {
            Text(exerciseName).font(.title2).bold()

            if data.isEmpty {
                Text("No history.").foregroundStyle(.secondary)
            } else {
                Text("Max Weight Over Time").font(.headline)
                Chart {
                    ForEach(Array(data.enumerated()), id: \.offset) { _, point in
                        LineMark(
                            x: .value("Date", point.date),
                            y: .value("Max Weight (lb)", point.maxWeight)
                        )
                        .interpolationMethod(.monotone)
                        PointMark(
                            x: .value("Date", point.date),
                            y: .value("Max Weight (lb)", point.maxWeight)
                        )
                    }
                }
                .frame(height: 220)

                Text("Volume Over Time").font(.headline).padding(.top, 8)
                Chart {
                    ForEach(Array(data.enumerated()), id: \.offset) { _, point in
                        BarMark(
                            x: .value("Date", point.date, unit: .day),
                            y: .value("Volume", point.volume)
                        )
                    }
                }
                .frame(height: 180)

                let first = data.first!
                let last = data.last!
                let change = last.maxWeight - first.maxWeight
                HStack {
                    StatBox(title: "Sessions", value: "\(data.count)")
                    StatBox(title: "Current Max", value: "\(Int(last.maxWeight)) lb")
                    StatBox(
                        title: "Change",
                        value: "\(change >= 0 ? "+" : "")\(Int(change)) lb",
                        tint: change >= 0 ? .green : .red
                    )
                }
                .padding(.top, 8)
            }
        }
    }
}

struct StatBox: View {
    let title: String
    let value: String
    var tint: Color = .primary

    var body: some View {
        VStack(spacing: 4) {
            Text(value).font(.headline).foregroundStyle(tint)
            Text(title).font(.caption).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.cardBackground))
    }
}

// MARK: - Nutrition Tab

struct NutritionTab: View {
    @Environment(NutritionStore.self) private var store
    @State private var displayedMonth: Date = Date()
    @State private var selectedDate: Date = Calendar.current.startOfDay(for: Date())

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    MonthCalendarView(
                        displayedMonth: $displayedMonth,
                        selectedDate: $selectedDate,
                        hasMarker: { store.hasLog(on: $0) },
                        markerColor: .green
                    )
                    Divider().padding(.vertical, 4)
                    NutritionDayView(date: selectedDate)
                    SevenDayAveragesCard()
                }
                .padding()
            }
            .navigationTitle("Nutrition")
        }
    }
}

struct NutritionDayView: View {
    @Environment(NutritionStore.self) private var store
    let date: Date
    @State private var showingAdd = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(dateTitle).font(.headline)
                Spacer()
                Button {
                    showingAdd = true
                } label: {
                    Label("Add Food", systemImage: "plus.circle.fill")
                }
            }

            let log = store.log(on: date)
            DailyTotalsCard(log: log)
            WaterTrackerCard(date: date)
            if let log = log, !log.entries.isEmpty {
                ForEach(MealType.allCases) { meal in
                    let entries = log.entries(for: meal)
                    if !entries.isEmpty {
                        MealSection(
                            meal: meal,
                            entries: entries,
                            onDelete: { entry in
                                var updated = log
                                updated.entries.removeAll { $0.id == entry.id }
                                if updated.entries.isEmpty && updated.waterCups == 0 {
                                    store.delete(updated)
                                } else {
                                    store.upsert(updated)
                                }
                            }
                        )
                    }
                }
            } else {
                Text("No food logged for this day.")
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 12)
            }
        }
        .sheet(isPresented: $showingAdd) {
            AddFoodSheet(date: date)
        }
    }

    private var dateTitle: String {
        let f = DateFormatter()
        f.dateStyle = .full
        return f.string(from: date)
    }
}

struct DailyTotalsCard: View {
    @Environment(ProfileStore.self) private var profileStore
    let log: DayFoodLog?

    var body: some View {
        let p = profileStore.profile
        let cal = log?.totalCalories ?? 0
        let pro = log?.totalProtein ?? 0
        let car = log?.totalCarbs ?? 0
        let fat = log?.totalFat ?? 0
        VStack(alignment: .leading, spacing: 10) {
            Text("Daily Totals").font(.headline)
            HStack(spacing: 12) {
                MacroProgressBox(label: "Calories", current: cal, goal: p.calorieGoal, unit: "kcal", tint: .orange)
                MacroProgressBox(label: "Protein",  current: pro, goal: p.proteinGoal, unit: "g",    tint: .red)
                MacroProgressBox(label: "Carbs",    current: car, goal: p.carbsGoal,   unit: "g",    tint: .yellow)
                MacroProgressBox(label: "Fat",      current: fat, goal: p.fatGoal,     unit: "g",    tint: .purple)
            }
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.cardBackground))
    }
}

struct MacroProgressBox: View {
    let label: String
    let current: Double
    let goal: Double
    let unit: String
    let tint: Color

    var body: some View {
        VStack(spacing: 4) {
            Text(label).font(.caption).foregroundStyle(.secondary)
            Text("\(Int(current))").font(.title3).bold().foregroundStyle(tint).monospacedDigit()
            Text("/ \(Int(goal)) \(unit)").font(.caption2).foregroundStyle(.secondary).monospacedDigit()
            ProgressBar(value: current, total: goal, tint: tint).frame(height: 5)
        }
        .frame(maxWidth: .infinity)
        .padding(8)
        .background(RoundedRectangle(cornerRadius: 8).fill(tint.opacity(0.1)))
    }
}

struct ProgressBar: View {
    let value: Double
    let total: Double
    let tint: Color

    var body: some View {
        GeometryReader { geo in
            let ratio = total > 0 ? min(value / total, 1.0) : 0
            ZStack(alignment: .leading) {
                Capsule().fill(tint.opacity(0.25))
                Capsule().fill(tint).frame(width: geo.size.width * CGFloat(ratio))
            }
        }
    }
}

struct WaterTrackerCard: View {
    @Environment(NutritionStore.self) private var nutrition
    @Environment(ProfileStore.self) private var profileStore
    let date: Date

    var body: some View {
        let cups = currentCups
        let goal = profileStore.profile.waterGoalCups
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "drop.fill").foregroundStyle(.blue)
                Text("Water").font(.headline)
                Spacer()
                Text("\(cups, specifier: "%g") / \(goal, specifier: "%g") cups")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .monospacedDigit()
            }
            ProgressBar(value: cups, total: goal, tint: .blue).frame(height: 6)
            HStack(spacing: 6) {
                let totalCups = max(Int(ceil(goal)), 1)
                ForEach(0..<totalCups, id: \.self) { i in
                    Image(systemName: Double(i) < cups ? "drop.fill" : "drop")
                        .foregroundStyle(.blue)
                        .onTapGesture { setCups(Double(i + 1)) }
                }
                Spacer()
                Button { if cups > 0 { setCups(cups - 1) } } label: {
                    Image(systemName: "minus.circle.fill").font(.title3)
                }
                .buttonStyle(.borderless)
                .disabled(cups <= 0)
                Button { setCups(cups + 1) } label: {
                    Image(systemName: "plus.circle.fill").font(.title3)
                }
                .buttonStyle(.borderless)
            }
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.cardBackground))
    }

    private var currentCups: Double {
        nutrition.log(on: date)?.waterCups ?? 0
    }

    private func setCups(_ value: Double) {
        let clamped = max(0, value)
        var log = nutrition.log(on: date)
            ?? DayFoodLog(date: Calendar.current.startOfDay(for: date), entries: [])
        log.waterCups = clamped
        if log.waterCups == 0 && log.entries.isEmpty {
            nutrition.delete(log)
        } else {
            nutrition.upsert(log)
        }
    }
}

struct MacroBox: View {
    let label: String
    let value: String
    let unit: String
    let tint: Color

    var body: some View {
        VStack(spacing: 2) {
            Text(value).font(.title3).bold().foregroundStyle(tint).monospacedDigit()
            Text(unit).font(.caption2).foregroundStyle(.secondary)
            Text(label).font(.caption).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(RoundedRectangle(cornerRadius: 8).fill(tint.opacity(0.1)))
    }
}

struct MealSection: View {
    let meal: MealType
    let entries: [FoodEntry]
    let onDelete: (FoodEntry) -> Void

    private var calories: Double { entries.reduce(0) { $0 + $1.calories } }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: meal.systemImage).foregroundStyle(meal.color)
                Text(meal.displayName).font(.headline)
                Spacer()
                Text("\(Int(calories)) kcal").font(.subheadline).foregroundStyle(.secondary).monospacedDigit()
            }
            ForEach(entries) { entry in
                FoodRow(entry: entry, onDelete: { onDelete(entry) })
            }
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.cardBackground))
    }
}

struct FoodRow: View {
    let entry: FoodEntry
    let onDelete: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text(entry.name).font(.subheadline).bold()
                    Text("× \(entry.servings, specifier: "%g") (\(entry.servingDescription))")
                        .font(.caption).foregroundStyle(.secondary)
                }
                HStack(spacing: 8) {
                    Label("\(Int(entry.calories)) kcal", systemImage: "flame.fill").foregroundStyle(.orange)
                    Text("P \(Int(entry.protein))g").foregroundStyle(.red)
                    Text("C \(Int(entry.carbs))g").foregroundStyle(.yellow)
                    Text("F \(Int(entry.fat))g").foregroundStyle(.purple)
                }
                .font(.caption.monospacedDigit())
            }
            Spacer()
            Button(role: .destructive, action: onDelete) {
                Image(systemName: "trash").font(.caption)
            }
            .buttonStyle(.borderless)
        }
        .padding(8)
        .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.gray.opacity(0.2)))
    }
}

struct SevenDayAveragesCard: View {
    @Environment(NutritionStore.self) private var store

    var body: some View {
        let a = store.averages(daysBack: 7)
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("7-Day Averages").font(.headline)
                Spacer()
                Text("\(a.daysCounted) day\(a.daysCounted == 1 ? "" : "s") logged")
                    .font(.caption).foregroundStyle(.secondary)
            }
            if a.daysCounted == 0 {
                Text("Log some meals to see averages here.")
                    .font(.caption).foregroundStyle(.secondary)
            } else {
                HStack(spacing: 12) {
                    MacroBox(label: "Calories", value: "\(Int(a.calories))", unit: "kcal/day", tint: .orange)
                    MacroBox(label: "Protein",  value: "\(Int(a.protein))",  unit: "g/day",    tint: .red)
                    MacroBox(label: "Carbs",    value: "\(Int(a.carbs))",    unit: "g/day",    tint: .yellow)
                    MacroBox(label: "Fat",      value: "\(Int(a.fat))",      unit: "g/day",    tint: .purple)
                }
            }
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.cardBackground))
    }
}

// MARK: - Add Food Sheet

struct AddFoodSheet: View {
    @Environment(NutritionStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    let date: Date

    @State private var selectedMeal: MealType = .breakfast
    @State private var selectedCategory: FoodCategory = .proteins
    @State private var selectedFood: FoodTemplate? = nil
    @State private var servings: Double = 1.0
    @State private var showingCustomEditor = false

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Log Food").font(.title2).bold()
                Spacer()
                Button("Cancel") { dismiss() }
                Button("Save", action: save)
                    .keyboardShortcut(.defaultAction)
                    .disabled(selectedFood == nil)
            }
            .padding()
            Divider()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    mealCard
                    categoryCard
                    foodListCard
                    if selectedFood != nil {
                        servingsCard
                    }
                }
                .padding()
            }
        }
        .frame(minWidth: 560, idealWidth: 620, minHeight: 640, idealHeight: 760)
        .onAppear {
            selectedMeal = defaultMealForTime()
        }
        .sheet(isPresented: $showingCustomEditor) {
            CustomFoodEditor()
        }
    }

    private var mealCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Meal").font(.headline)
            WrapLayout(spacing: 8) {
                ForEach(MealType.allCases) { meal in
                    Button {
                        selectedMeal = meal
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: meal.systemImage)
                            Text(meal.displayName)
                        }
                        .font(.callout)
                        .padding(.horizontal, 12).padding(.vertical, 7)
                        .background(
                            Capsule().fill(
                                selectedMeal == meal
                                ? meal.color.opacity(0.25)
                                : Color.gray.opacity(0.12)
                            )
                        )
                        .overlay(
                            Capsule().stroke(
                                selectedMeal == meal ? meal.color : Color.clear, lineWidth: 1.5
                            )
                        )
                        .foregroundStyle(selectedMeal == meal ? meal.color : .primary)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.cardBackground))
    }

    private var categoryCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Category").font(.headline)
            WrapLayout(spacing: 8) {
                ForEach(FoodCategory.allCases) { cat in
                    Button {
                        selectedCategory = cat
                        selectedFood = nil
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: cat.systemImage)
                            Text(cat.displayName)
                        }
                        .font(.callout)
                        .padding(.horizontal, 12).padding(.vertical, 7)
                        .background(
                            Capsule().fill(
                                selectedCategory == cat
                                ? cat.color.opacity(0.25)
                                : Color.gray.opacity(0.12)
                            )
                        )
                        .overlay(
                            Capsule().stroke(
                                selectedCategory == cat ? cat.color : Color.clear, lineWidth: 1.5
                            )
                        )
                        .foregroundStyle(selectedCategory == cat ? cat.color : .primary)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.cardBackground))
    }

    private var foodListCard: some View {
        let foods = foodsForSelectedCategory()
        return VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Food").font(.headline)
                Spacer()
                if selectedCategory == .custom {
                    Button {
                        showingCustomEditor = true
                    } label: {
                        Label("Add Custom Food", systemImage: "plus")
                    }
                }
            }
            if foods.isEmpty {
                Text(selectedCategory == .custom
                     ? "No custom foods yet. Tap “Add Custom Food” to create one."
                     : "No foods in this category.")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 12)
            } else {
                VStack(spacing: 6) {
                    ForEach(foods) { food in
                        HStack(spacing: 6) {
                            Button {
                                selectedFood = food
                            } label: {
                                HStack(alignment: .top, spacing: 10) {
                                    Image(systemName: selectedFood == food ? "checkmark.circle.fill" : "circle")
                                        .foregroundStyle(selectedFood == food ? selectedCategory.color : .secondary)
                                        .padding(.top, 2)
                                    VStack(alignment: .leading, spacing: 3) {
                                        HStack(spacing: 6) {
                                            Text(food.name).font(.body)
                                            Text("(\(food.servingDescription))")
                                                .font(.caption).foregroundStyle(.secondary)
                                        }
                                        HStack(spacing: 8) {
                                            Text("\(Int(food.calories)) kcal").foregroundStyle(.orange)
                                            Text("P \(food.protein, specifier: "%g")g").foregroundStyle(.red)
                                            Text("C \(food.carbs, specifier: "%g")g").foregroundStyle(.yellow)
                                            Text("F \(food.fat, specifier: "%g")g").foregroundStyle(.purple)
                                        }
                                        .font(.caption.monospacedDigit())
                                    }
                                    Spacer(minLength: 0)
                                }
                                .padding(10)
                                .background(
                                    RoundedRectangle(cornerRadius: 8).fill(
                                        selectedFood == food
                                        ? selectedCategory.color.opacity(0.08)
                                        : Color.clear
                                    )
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8).stroke(
                                        selectedFood == food ? selectedCategory.color : Color.gray.opacity(0.2),
                                        lineWidth: 1
                                    )
                                )
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)

                            if selectedCategory == .custom {
                                Button(role: .destructive) {
                                    if selectedFood == food { selectedFood = nil }
                                    store.deleteCustomFood(food)
                                } label: {
                                    Image(systemName: "trash")
                                        .foregroundStyle(.secondary)
                                }
                                .buttonStyle(.borderless)
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.cardBackground))
    }

    private func foodsForSelectedCategory() -> [FoodTemplate] {
        switch selectedCategory {
        case .custom: return store.customFoods
        default:      return FoodLibrary.foods(in: selectedCategory)
        }
    }

    private var servingsCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Servings").font(.headline)
            HStack(spacing: 12) {
                Text("Quantity").frame(width: 70, alignment: .leading)
                TextField("1", value: $servings, format: .number)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 80)
                    .textFieldStyle(.roundedBorder)
                Stepper("", value: $servings, in: 0.25...20, step: 0.25).labelsHidden()
                if let food = selectedFood {
                    Text("× \(food.servingDescription)").foregroundStyle(.secondary)
                }
            }
            if let food = selectedFood {
                HStack(spacing: 12) {
                    MacroBox(label: "Calories", value: "\(Int(food.calories * servings))", unit: "kcal", tint: .orange)
                    MacroBox(label: "Protein",  value: "\(Int(food.protein  * servings))", unit: "g",    tint: .red)
                    MacroBox(label: "Carbs",    value: "\(Int(food.carbs    * servings))", unit: "g",    tint: .yellow)
                    MacroBox(label: "Fat",      value: "\(Int(food.fat      * servings))", unit: "g",    tint: .purple)
                }
                .padding(.top, 4)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.cardBackground))
    }

    private func defaultMealForTime() -> MealType {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<11:  return .breakfast
        case 11..<15: return .lunch
        case 15..<18: return .snack
        default:      return .dinner
        }
    }

    private func save() {
        guard let food = selectedFood else { return }
        let entry = FoodEntry(
            name: food.name,
            category: food.category,
            mealType: selectedMeal,
            servings: servings,
            servingDescription: food.servingDescription,
            caloriesPerServing: food.calories,
            proteinPerServing: food.protein,
            carbsPerServing: food.carbs,
            fatPerServing: food.fat
        )
        var log = store.log(on: date) ?? DayFoodLog(date: Calendar.current.startOfDay(for: date), entries: [])
        log.entries.append(entry)
        store.upsert(log)
        dismiss()
    }
}

// MARK: - Custom Food Editor

struct CustomFoodEditor: View {
    @Environment(NutritionStore.self) private var store
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var servingDescription: String = "1 serving"
    @State private var calories: Double = 0
    @State private var protein: Double = 0
    @State private var carbs: Double = 0
    @State private var fat: Double = 0

    private var trimmedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("New Custom Food").font(.title2).bold()
                Spacer()
                Button("Cancel") { dismiss() }
                Button("Save", action: save)
                    .keyboardShortcut(.defaultAction)
                    .disabled(trimmedName.isEmpty)
            }
            .padding()
            Divider()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Details").font(.headline)
                        labeledTextField(label: "Name", placeholder: "e.g. Mom's Lasagna", text: $name)
                        labeledTextField(label: "Serving", placeholder: "e.g. 1 cup, 100g, 1 slice", text: $servingDescription)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.cardBackground))

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Nutrition (per serving)").font(.headline)
                        macroEntryRow(label: "Calories", unit: "kcal", value: $calories, tint: .orange)
                        macroEntryRow(label: "Protein",  unit: "g",    value: $protein,  tint: .red)
                        macroEntryRow(label: "Carbs",    unit: "g",    value: $carbs,    tint: .yellow)
                        macroEntryRow(label: "Fat",      unit: "g",    value: $fat,      tint: .purple)

                        HStack(spacing: 12) {
                            MacroBox(label: "Calories", value: "\(Int(calories))", unit: "kcal", tint: .orange)
                            MacroBox(label: "Protein",  value: "\(Int(protein))",  unit: "g",    tint: .red)
                            MacroBox(label: "Carbs",    value: "\(Int(carbs))",    unit: "g",    tint: .yellow)
                            MacroBox(label: "Fat",      value: "\(Int(fat))",      unit: "g",    tint: .purple)
                        }
                        .padding(.top, 6)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.cardBackground))
                }
                .padding()
            }
        }
        .frame(minWidth: 500, idealWidth: 560, minHeight: 540, idealHeight: 600)
    }

    private func labeledTextField(label: String, placeholder: String, text: Binding<String>) -> some View {
        HStack(spacing: 12) {
            Text(label).frame(width: 80, alignment: .leading)
            TextField(placeholder, text: text)
                .textFieldStyle(.roundedBorder)
        }
    }

    private func macroEntryRow(label: String, unit: String, value: Binding<Double>, tint: Color) -> some View {
        HStack(spacing: 12) {
            Text(label).frame(width: 80, alignment: .leading).foregroundStyle(tint)
            TextField("0", value: value, format: .number)
                .multilineTextAlignment(.trailing)
                .frame(width: 100)
                .textFieldStyle(.roundedBorder)
            Text(unit).foregroundStyle(.secondary)
            Spacer()
        }
    }

    private func save() {
        let food = FoodTemplate(
            name: trimmedName,
            category: .custom,
            servingDescription: servingDescription.isEmpty ? "1 serving" : servingDescription,
            calories: calories,
            protein: protein,
            carbs: carbs,
            fat: fat
        )
        store.addCustomFood(food)
        dismiss()
    }
}

// MARK: - You Tab

struct YouTab: View {
    @Environment(ProfileStore.self) private var store

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    ProfileCard()
                    SuggestedGoalsCard()
                    GoalsCard()
                }
                .padding()
            }
            .navigationTitle("You")
        }
    }
}

struct ProfileCard: View {
    @Environment(ProfileStore.self) private var store

    var body: some View {
        @Bindable var s = store
        VStack(alignment: .leading, spacing: 14) {
            Text("Profile").font(.headline)

            row(label: "Height") {
                HStack(spacing: 6) {
                    TextField("5", value: Binding(
                        get: { Int(s.profile.heightInches) / 12 },
                        set: { feet in
                            let inches = Int(s.profile.heightInches.rounded()) % 12
                            s.profile.heightInches = Double(max(0, feet) * 12 + inches)
                        }
                    ), format: .number)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 50)
                        .textFieldStyle(.roundedBorder)
                    Text("ft").foregroundStyle(.secondary)
                    TextField("8", value: Binding(
                        get: { Int(s.profile.heightInches.rounded()) % 12 },
                        set: { inches in
                            let feet = Int(s.profile.heightInches) / 12
                            let clamped = min(max(0, inches), 11)
                            s.profile.heightInches = Double(feet * 12 + clamped)
                        }
                    ), format: .number)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 50)
                        .textFieldStyle(.roundedBorder)
                    Text("in").foregroundStyle(.secondary)
                }
            }

            row(label: "Weight") {
                HStack(spacing: 8) {
                    TextField("Weight", value: $s.profile.weightLb, format: .number)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 80)
                        .textFieldStyle(.roundedBorder)
                    Text("lb").foregroundStyle(.secondary)
                }
            }

            row(label: "Age") {
                HStack(spacing: 8) {
                    TextField("Age", value: $s.profile.age, format: .number)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 80)
                        .textFieldStyle(.roundedBorder)
                    Text("years").foregroundStyle(.secondary)
                }
            }

            row(label: "Sex") {
                Picker("", selection: $s.profile.sex) {
                    ForEach(Sex.allCases) { Text($0.displayName).tag($0) }
                }
                .pickerStyle(.segmented)
                .frame(width: 180)
                .labelsHidden()
            }

            row(label: "Activity") {
                Picker("", selection: $s.profile.activityLevel) {
                    ForEach(ActivityLevel.allCases) {
                        Text($0.displayName).tag($0)
                    }
                }
                .labelsHidden()
            }

            Text(s.profile.activityLevel.detail)
                .font(.caption).foregroundStyle(.secondary)
                .padding(.leading, 100)

            row(label: "Goal") {
                Picker("", selection: $s.profile.fitnessGoal) {
                    ForEach(FitnessGoal.allCases) { Text($0.displayName).tag($0) }
                }
                .pickerStyle(.segmented)
                .labelsHidden()
            }

            Button("Save Profile") { store.save() }
                .keyboardShortcut(.defaultAction)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.cardBackground))
    }

    @ViewBuilder
    private func row<Content: View>(label: String, @ViewBuilder content: () -> Content) -> some View {
        HStack(alignment: .center, spacing: 12) {
            Text(label).frame(width: 90, alignment: .leading)
            content()
            Spacer()
        }
    }
}

struct SuggestedGoalsCard: View {
    @Environment(ProfileStore.self) private var store

    var body: some View {
        @Bindable var s = store
        let p = s.profile
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Suggested Goals").font(.headline)
                Spacer()
                Text("Based on Mifflin–St Jeor + activity")
                    .font(.caption).foregroundStyle(.secondary)
            }
            HStack(spacing: 12) {
                MacroBox(label: "Calories", value: "\(Int(p.suggestedCalories))", unit: "kcal", tint: .orange)
                MacroBox(label: "Protein",  value: "\(Int(p.suggestedProtein))",  unit: "g",    tint: .red)
                MacroBox(label: "Carbs",    value: "\(Int(p.suggestedCarbs))",    unit: "g",    tint: .yellow)
                MacroBox(label: "Fat",      value: "\(Int(p.suggestedFat))",      unit: "g",    tint: .purple)
                MacroBox(label: "Water",    value: "\(Int(p.suggestedWaterCups))", unit: "cups", tint: .blue)
            }
            Text("BMR: \(Int(p.bmr)) kcal · TDEE: \(Int(p.tdee)) kcal")
                .font(.caption).foregroundStyle(.secondary)
            Button {
                s.profile.customCalorieGoal = nil
                s.profile.customProteinGoal = nil
                s.profile.customCarbsGoal = nil
                s.profile.customFatGoal = nil
                s.profile.customWaterCupsGoal = nil
                store.save()
            } label: {
                Label("Use Suggested Goals", systemImage: "wand.and.stars")
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.cardBackground))
    }
}

struct GoalsCard: View {
    @Environment(ProfileStore.self) private var store

    var body: some View {
        @Bindable var s = store
        let p = s.profile
        VStack(alignment: .leading, spacing: 12) {
            Text("My Goals").font(.headline)
            goalRow(
                label: "Calories", unit: "kcal", tint: .orange,
                suggested: p.suggestedCalories,
                custom: $s.profile.customCalorieGoal
            )
            goalRow(
                label: "Protein", unit: "g", tint: .red,
                suggested: p.suggestedProtein,
                custom: $s.profile.customProteinGoal
            )
            goalRow(
                label: "Carbs", unit: "g", tint: .yellow,
                suggested: p.suggestedCarbs,
                custom: $s.profile.customCarbsGoal
            )
            goalRow(
                label: "Fat", unit: "g", tint: .purple,
                suggested: p.suggestedFat,
                custom: $s.profile.customFatGoal
            )
            goalRow(
                label: "Water", unit: "cups", tint: .blue,
                suggested: p.suggestedWaterCups,
                custom: $s.profile.customWaterCupsGoal
            )
            Text("Leave blank to use the suggested value. Edit to set a custom goal.")
                .font(.caption).foregroundStyle(.secondary)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.cardBackground))
    }

    private func goalRow(
        label: String,
        unit: String,
        tint: Color,
        suggested: Double,
        custom: Binding<Double?>
    ) -> some View {
        HStack(spacing: 12) {
            Text(label).foregroundStyle(tint).frame(width: 80, alignment: .leading)
            TextField(
                "Suggested \(Int(suggested))",
                value: custom,
                format: .number.precision(.fractionLength(0...1))
            )
            .multilineTextAlignment(.trailing)
            .frame(width: 100)
            .textFieldStyle(.roundedBorder)
            Text(unit).foregroundStyle(.secondary)
            Text("Suggested: \(Int(suggested))")
                .font(.caption).foregroundStyle(.secondary)
            Spacer()
            Button {
                custom.wrappedValue = nil
                store.save()
            } label: {
                Image(systemName: "arrow.counterclockwise")
            }
            .buttonStyle(.borderless)
            .help("Reset to suggested")
            .disabled(custom.wrappedValue == nil)
        }
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
