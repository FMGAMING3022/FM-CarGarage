Config = {
    Core = 'qb-core',
    Input = 'qb-input',
}

Config.Framework = 'qb' -- options: 'qb', 'esx'
Config.Target = 'custom' -- options: qb-target, ox_target, custom
Config.Menu = 'wasabi_uikit'  -- options: qb-menu, ox_lib, wasabi_uikit
Config.Progressbar = 'ox_lib'  -- options: qb_progressbar, ox_lib, wasabi_uikit

Config.Color = '#27F5BE'


Config.Departments = {
    ["police"] = {
        job = "police",
        Peds = {
            {
                model = "s_m_y_cop_01",
                location = vector4(1868.22, 3691.96, 33.69, 315.85),
                spawnLocation = vector4(1872.7, 3693.14, 33.54, 206.65)
            },
            {
                model = "s_m_y_cop_01",
                location = vector4(1865.96, 3695.77, 33.69, 294.9),
                spawnLocation = vector4(1869.04, 3698.24, 33.5, 31.6)
            },
        },
        Vehicles = {
            {
                label = "Police",
                model = "police",
                livery = 0,
                extras = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13},
                colors = {},
                mods = {},
                license = false,
                tint = false,
                grade = {1, 2, 3, 4},
                trunkItems = {
                        { name = "police_stormram", amount = 2, info = {}},
                        { name = "empty_evidence_bag", amount = 2, info = {}},
                }
            },
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
    },
    ["ambulance"] = {
        job = "ambulance",
        Peds = {
            {
                model = "s_m_m_paramedic_01",
                location = vector4(1862.15, 3701.69, 33.59, 299.51),
                spawnLocation = vector4(1866.0, 3703.63, 33.37, 24.26)
            },
        },
        Vehicles = {
            {
                label = "Ambulance",
                model = "ambulance",
                livery = 0,
                extras = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13},
                colors = {},
                mods = {},
                license = false,
                tint = false,
                grade = {1, 2, 3, 4},
                trunkItems = {
                        { name = "firstaid", amount = 2, info = {}},
                        { name = "bandage", amount = 2, info = {}},
                }
            },
        }
    },

}
