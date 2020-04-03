//File: ContentView.swift
//Project: PizzaRestaurantApp

//Created at 31.12.19 by BLCKBIRDS
//Visit www.BLCKBIRDS.com for more.

import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(entity: Order.entity(),
                  sortDescriptors: [],
                  predicate: NSPredicate(format: "status != %@", Status.completed.rawValue))
    
    var orders: FetchedResults<Order>
    
    @State var showOrderSheet = false

    var body: some View {
        NavigationView {
            List {
                ForEach(orders) { order in
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(order.pizzaType) - \(order.numberOfSlices) slices")
                                .font(.headline)
                            Text("Table \(order.tableNumber)")
                                .font(.subheadline)
                        }
                        Spacer()
                        Button(action: {self.updateOrder(order: order)}) {
                            Text(order.orderStatus == .pending ? "Prepare" : "Complete")
                                .foregroundColor(.blue)
                        }
                    }
                }
                    .onDelete { indexSet in
                        for index in indexSet {
                            self.managedObjectContext.delete(self.orders[index])
                        }
                    }
            }
                .navigationBarTitle("My Orders")
                .navigationBarItems(trailing: Button(action: {
                    self.showOrderSheet = true
                }, label: {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .frame(width: 32, height: 32, alignment: .center)
                }))
                .sheet(isPresented: $showOrderSheet) {
                    OrderSheet().environment(\.managedObjectContext, self.managedObjectContext)
                }
        }
    }
    
    func updateOrder(order: Order) {
        let newStatus = order.orderStatus == .pending ? Status.preparing : .completed
        managedObjectContext.performAndWait {
            order.orderStatus = newStatus
            try? managedObjectContext.save()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        return ContentView().environment(\.managedObjectContext, context)
    }
}
