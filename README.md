# For Support
**[Join Our Discord](https://discord.gg/Mu2hdZjjUg)**
# 🚓 Car Garage – Multi-Framework Vehicle Garage

---

A **modern, configurable vehicle garage system** for FiveM with **multi-framework**, **multi-inventory**, and **multi-menu** support.
Designed for **police, EMS, and job-based garages** with trunk items, liveries, extras, and grade restrictions.

---

## ✨ Features

### 🚗 Vehicle System

* Job / department based garages
* Multiple vehicles per department
* Vehicle **liveries**, **extras**, **mods**, **tints**
* Vehicle spawn safety checks
* Automatic key assignment
* Fuel system support

### 📦 Trunk Inventory

* **ox_inventory trunk support**
* **qb-inventory trunk support**
* Automatic trunk creation (QB)
* Optional default trunk items

### 🎯 Interaction

* `ox_target` or `qb-target` support
* Marker / event based fallback
* Distance-based spawn validation

### 🧠 Optimized

* No heavy loops
* Event-based logic
* Safe entity handling
* Clean thread usage

---

## 🧩 Supported Frameworks

| Framework      | Status                                  |
| -------------- | --------------------------------------- |
| **QB-Core**    | ✅ Supported                             |
| **ESX**        | ✅ Supported |
| **Standalone** | ⚠️ Limited(You Can Check)                              |

---

## 📦 Supported Inventories

| Inventory        | Status                               |
| ---------------- | ------------------------------------ |
| **ox_inventory** | ✅ Full support                       |
| **qb-inventory** | ✅ Full support (with stash creation) |

---

## 🔔 Notification Systems

* QB Notify
* ox_lib notify
* wasabi_uikit notify
* Custom notify fallback

---

## ⏳ Progress Bars

* `qb-progressbar`
* `ox_lib progressBar`
* `wasabi_uikit`
* Standalone fallback

---


---

## 📁 Installation

1. Download or clone the resource
2. Place inside your `resources` folder
3. Add to `server.cfg`:

```cfg
ensure FM-CarGarage
```

---

## ⚙️ Dependencies

### Optional

* `ox_inventory`
* `qb-inventory`
* `qb-core`
* `ox_lib`
* `LegacyFuel`
* `wasabi_uikit`
* `ox_target`
* `qb-target`

---

## 🛠 Configuration

### Department Setup

```lua
Config.Departments = {
    ["police"] = {
        job = "police",
        Peds = {
            {
                model = "s_m_y_cop_01",
                location = vector4(1868.22, 3691.96, 33.69, 315.85),
                spawnLocation = vector4(1872.7, 3693.14, 33.54, 206.65)
            }
        },
        Vehicles = {
          {
                label = "Greenwood Cruiser",
                model = "polgreenwood",
                livery = 2,
                extras = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13},
                colors = {0, 0},
                mods = {},
                license = false,
                tint = false,
                grade = {1, 2, 3, 4},
                trunkItems = {
                        { name = "police_stormram", amount = 2, info = {}},
                        { name = "empty_evidence_bag", amount = 2, info = {}},
                }
            },
        }
    }
}
```

---

## 🧪 Tested With

* QB-Core latest
* ox_inventory latest
* qb-inventory latest
* ox_target
* ox_lib

---


## 📄 License

This script is provided as-is.
Do not resell or redistribute without permission.
