import SwiftUI
import SwiftData

struct MonthlyTotalIncomeView: View {
    @Query private var transactions: [Transaction]
    @Query private var budgets: [Budget]
    @Query private var subscriptions: [Subscription]
    @Binding var selectedMonth: Int
    @Binding var selectedYear: Int
    @State private var displayPercentage: Bool = false
    
    var incomeToDate: Double {
        transactions
            .filter { transaction in
                let calendar = Calendar.current
                let transactionDate = transaction.date
                let month = calendar.component(.month, from: transactionDate)
                let year = calendar.component(.year, from: transactionDate)
                return month == selectedMonth && year == selectedYear && transaction.type == "Income"
            }
            .map { $0.amount }
            .reduce(0, +)
    }
    
    var totalIncome: Double {
        let transactionIncome = transactions
            .filter { transaction in
                let calendar = Calendar.current
                let transactionDate = transaction.date
                let month = calendar.component(.month, from: transactionDate)
                let year = calendar.component(.year, from: transactionDate)
                return month == selectedMonth && year == selectedYear && transaction.type == "Income"
            }
            .map { $0.amount }
            .reduce(0, +)
        
        var subscriptionIncome: Double = 0.0
        var processedSubscriptions = Set<String>()
        
        for subscription in subscriptions where subscription.type == "Income" {
            if processedSubscriptions.contains(subscription.id) {
                continue
            }
            
            switch subscription.repeatFrequency {
            case "Weekly":
                subscriptionIncome += subscription.amount * 4
            case "Yearly":
                subscriptionIncome += subscription.amount / 12
            case "Monthly":
                subscriptionIncome += subscription.amount
            default:
                break
            }
            
            processedSubscriptions.insert(subscription.id)
        }
        
        return transactionIncome + subscriptionIncome
    }
    
    var totalTransactionAmount: Double {
        transactions
            .filter {
                let transactionDate = $0.date
                let transactionMonth = Calendar.current.component(.month, from: transactionDate)
                let transactionYear = Calendar.current.component(.year, from: transactionDate)
                return transactionMonth == selectedMonth && transactionYear == selectedYear && $0.type == "Expenditure"
            }
            .reduce(0) { $0 + $1.amount }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text(incomeToDate, format: .currency(code: Locale.current.currency?.identifier ?? "GBP"))
                .font(.system(size: 32))
                .fontWeight(.bold)
            
            Text("Total Income")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(.gray)
        }
        .fontDesign(.rounded)
        .frame(height: 62)
    }
}

#Preview {
    MonthlyTotalIncomeView(selectedMonth: .constant(5), selectedYear: .constant(2024))
}
