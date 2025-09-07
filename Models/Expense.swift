import Foundation
import CoreData

@objc(Expense)
public class Expense: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var amount: Double
    @NSManaged public var category: String?
    @NSManaged public var desc: String?
    @NSManaged public var date: Date

    public var wrappedId: UUID { id }
    public var wrappedCategory: String { category ?? "Unknown" }
    public var wrappedDescription: String { desc ?? "" }
}

extension Expense {
    static func create(
        in context: NSManagedObjectContext,
        amount: Double,
        category: String,
        description: String?,
        date: Date
    ) -> Expense {
        let expense = Expense(context: context)
        expense.id = UUID()
        expense.amount = amount
        expense.category = category
        expense.desc = description
        expense.date = date
        return expense
    }
}

extension Expense: Identifiable {}
