Vehicle = {}

Vehicle.tariff = 0.3 --@comment ค่าภาษี
Vehicle.plateLetters = 3 --@comment จำนวนตัวอักษรในทะเบียน
Vehicle.plateNumbers = 3 --@comment จำนวนตัวเลขในทะเบียน

Vehicle.ListShop = {
    {
        shopName = "Car Dealer",
        typeVehicle = 'car',
        showType = { 
            type = 'npc', --@ comment npc / marker
            ped = {
                model = "s_m_y_armymech_01",
                animation = {
                    dict = "anim@amb@nightclub@djs@solomun@",
                    name = "sol_idle_left_b_sol"
                }
            },
            marker = {
                type = 23,
                r = 0,
                g = 158,
                b = 250,
                a = 255,
                x = 1.7,
                y = 1.7,
                z = 1.0,
                distance = 10
            }
        },
        blip = {
            name = "<font face='font4thai'>ร้านขายรถ</font>",
            color = 2,
            sprite = 225,
            scale = 0.7,
            show = true
        },
        DrawText3D = {
            enable = true,
            distance = 5
        },
        coords = vector4(-80.9,-1102.13,26.17,250.31),
        showCoords = vector3(-44.79, -1096.64, 26.40),
        spawnCoords = {
            vector3(-31.35, -1090.93, 26.42),
            vector3(-68.94, -1108.15, 25.97),

        },
        requireJob = {
            'unemployed',
            'police'
        },
        testDrive = {
            enable = true,
            time = 20,
            spawncoord = vector3(-966.5, -3355.7, 13.9),
            range = 1200
        },
        vehicles = {
            ['Sports'] = {
                {
                    model = 't20', --@comment ชื่อโมเดลรถ
                    label = 't20', --@comment ชื่อรถที่จะโชว์
                    price = 400000, --@comment ราคาขาย
                    stock = 10, --@comment จำนวนรถที่มีในสต๊อก ถ้าเป็น -1 จะเป็นไม่จำกัด

                },
                {
                    model = 'sultan2', --@comment ชื่อโมเดลรถ
                    label = 'sultan2', --@comment ชื่อรถที่จะโชว์
                    price = 330000, --@comment ราคาขาย
                    stock = -1, --@comment จำนวนรถที่มีในสต๊อก ถ้าเป็น -1 จะเป็นไม่จำกัด
                },
            },
            ['SUV'] = {
                {
                    model = 'bmx', --@comment ชื่อโมเดลรถ
                    label = 'bmx', --@comment ชื่อรถที่จะโชว์
                    price = 400000, --@comment ราคาขาย
                    stock = 10, --@comment จำนวนรถที่มีในสต๊อก ถ้าเป็น -1 จะเป็นไม่จำกัด
                },
                {
                    model = 'huntley', --@comment ชื่อโมเดลรถ
                    label = 'Huntley', --@comment ชื่อรถที่จะโชว์
                    price = 330000, --@comment ราคาขาย
                    stock = -1, --@comment จำนวนรถที่มีในสต๊อก ถ้าเป็น -1 จะเป็นไม่จำกัด
                },
            },
        }
    },
    {
        shopName = 'Boat Dealer',
        typeVehicle = 'boat',
        showType = { 
            type = 'npc', --@ comment npc / marker
            ped = {
                model = "s_m_y_armymech_01",
                animation = {
                    dict = "idle_e",
                    name = "idle_e"
                }
            },
            marker = {
                type = 23,
                r = 0,
                g = 158,
                b = 250,
                a = 255,
                x = 1.7,
                y = 1.7,
                z = 1.0,
                distance = 10
            }
        },
        blip = {
            name = "<font face='font4thai'>ร้านขายเรือ</font>",
            color = 1,
            sprite = 225,
            scale = 0.7,
            show = true
        },
        DrawText3D = {
            enable = true,
            distance = 5
        },
        coords = vector4(-357.11, -2427.12,2.65,238.96),
        showCoords = vector3(-372.16, -2437.18, 1),
        spawnCoords = {
            vector3(-31.35, -1090.93, 26.42),
            vector3(-68.94, -1108.15, 25.97),

        },
        requireJob = {
            'police',
        },
        testDrive = {
            enable = true,
            time = 20,
            spawncoord = vector3(-372.16, -2437.18, 1),
            range = 1200
        },
        vehicles = {
            ['Boat'] = {
                {
                    model = 'suntrap', --@comment ชื่อโมเดลรถ
                    label = 'suntrap', --@comment ชื่อรถที่จะโชว์
                    price = 400000, --@comment ราคาขาย
                    stock = 10, --@comment จำนวนรถที่มีในสต๊อก ถ้าเป็น -1 จะเป็นไม่จำกัด
                }
            },
        }
    },
}