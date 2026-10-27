include: "/bronze/order_items.view.lkml"
include: "/bronze/order_items.refinement.lkml"

view: order_items_financial_ledger {
  extends: [order_items]
  label: "Order Items Financial Ledger"

  derived_table: {
    sql:
      SELECT
        'gross_revenue' AS ledger_line_code,
        {{ _table }}.*,
        {{ sale_price._sql }} AS ledger_amount
      FROM ${order_items.SQL_TABLE_NAME} AS {{ _table }}
      UNION ALL
      SELECT
        'wholesale_cogs' AS ledger_line_code,
        {{ _table }}.*,
        {{ _sdt_inventory_items.cost._sql }} AS ledger_amount
      FROM ${order_items.SQL_TABLE_NAME} AS {{ _table }}
      INNER JOIN ${inventory_items.SQL_TABLE_NAME} AS {{ _sdt_inventory_items._name }}
        ON {{ inventory_item_id._sql }} = {{ _sdt_inventory_items.id._sql }}
      UNION ALL
      SELECT
        'realized_gross_margin' AS ledger_line_code,
        {{ _table }}.*,
        {{ sale_price._sql }} - {{ _sdt_inventory_items.cost._sql }} AS ledger_amount
      FROM ${order_items.SQL_TABLE_NAME} AS {{ _table }}
      INNER JOIN ${inventory_items.SQL_TABLE_NAME} AS {{ _sdt_inventory_items._name }}
        ON {{ inventory_item_id._sql }} = {{ _sdt_inventory_items.id._sql }} ;;
  }

  dimension: compound_pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(${TABLE}.ledger_line_code, '_', CAST(${id} AS STRING)) ;;
  }

  dimension: id {
    primary_key: no
    hidden: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: financial_ledger_line {
    label: "Financial Ledger Line"
    description: "Unpivoted P&L financial ledger line stacking Gross Top-Line Revenue, Wholesale Inventory COGS, and Net Realized Gross Margin."
    synonyms: ["ledger line", "pnl line item", "margin ledger line"]
    case: {
      when: {
        sql: ${TABLE}.ledger_line_code = 'gross_revenue' ;;
        label: "Gross Top-Line Revenue"
      }
      when: {
        sql: ${TABLE}.ledger_line_code = 'wholesale_cogs' ;;
        label: "Wholesale Inventory COGS"
      }
      else: "Net Realized Gross Margin"
    }
  }

  dimension: ledger_amount {
    hidden: yes
    type: number
    value_format_name: usd
    sql: ${TABLE}.ledger_amount ;;
  }

  measure: count {
    label: "Ledger Line Item Count"
    description: "Count of order line items contributing to the financial ledger line."
    synonyms: ["line item count", "ledger items count"]
  }

  measure: total_ledger_dollars {
    label: "Ledger Dollars"
    description: "Summed dollar value for the financial ledger line (gross top-line revenue, wholesale inventory COGS, or net realized gross margin)."
    synonyms: ["ledger dollars", "ledger amount", "pnl dollars"]
    type: sum
    value_format_name: usd
    sql: ${ledger_amount} ;;
  }
}
