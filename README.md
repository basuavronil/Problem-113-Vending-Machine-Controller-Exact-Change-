# Problem-113-Vending-Machine-Controller-Exact-Change-
# Rupee Vending Machine Controller

## What This Code Does
This Verilog code implements a digital Finite State Machine (FSM) that acts as the brain for a vending machine. It tracks money inserted via Indian Rupee coins (₹1, ₹2, and ₹5) and automatically releases an item (`dispense` goes HIGH) the exact moment the total reaches or exceeds **₹10**.

### How the Combinations Work (Focus on State S9)
The machine tracks balances from ₹0 (`S0`) up to ₹9 (`S9`). When the machine is at **`S9` (₹9)**, adding **any** coin pushes the total to ₹10 or higher, which instantly triggers a dispense and resets the machine back to ₹0:

* **S9 (₹9) + ₹1 coin** = ₹10 $\rightarrow$ **Dispense** & Reset to S0
* **S9 (₹9) + ₹2 coin** = ₹11 $\rightarrow$ **Dispense** & Reset to S0
* **S9 (₹9) + ₹5 coin** = ₹14 $\rightarrow$ **Dispense** & Reset to S0

*(Similarly, other states near the target—like `S8` dispensing on ₹2 or ₹5, and `S5` through `S7` dispensing on a ₹5 coin—ensure that any combination reaching or exceeding ₹10 successfully releases the item without needing an explicit S10 state.)*
