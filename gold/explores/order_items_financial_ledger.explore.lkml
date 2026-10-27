include: "/bronze/inventory_items.view.lkml"
include: "/bronze/inventory_items.refinement.lkml"
include: "/gold/order_items_financial_ledger.view.lkml"

explore: order_items_financial_ledger {
  label: "Order Items (Financial Margin Ledger)"
  view_name: order_items_financial_ledger
  hidden: no
  tags: ["gold"]
  fields: [
    ALL_FIELDS*,
    -order_items_financial_ledger.id
  ]

  join: _sdt_inventory_items {
    from: inventory_items
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  query: financial_margin_ledger_breakdown {
    description: "Unpivoted P&L financial ledger comparing line item volume and ledger dollars across Gross Top-Line Revenue, Wholesale Inventory COGS, and Net Realized Gross Margin."
    dimensions: [order_items_financial_ledger.financial_ledger_line]
    measures: [
      order_items_financial_ledger.count,
      order_items_financial_ledger.total_ledger_dollars
    ]
    sorts: [order_items_financial_ledger.financial_ledger_line: asc]
  }
}
