Default = {}


Default.event = {
    setJob = 'esx:setJob',
    playerLoaded = 'esx:playerLoaded',
    playerSpawned = 'playerSpawned',
    onDeath = 'esx:onPlayerDeath',
}

--@comment Default.logger : boolean
--@comment ใช้เพื่อเปิด print การทำงานต่างๆ
Default.logger = false

--@comment ชือเซิฟเวอร์ของท่าน
Default.SvName = "Unknowkubbrother"

Default.keybind = {
    openShop = KeyLists["E"], --@comment คีย์ที่ใช้เปิดร้าน
}

Default.VehicleColors = {
    primary = {
        r = 255,
        g = 255,
        b = 255,
    },
    secondary = {
        r = 255,
        g = 0,
        b = 0,
    },
}

Default.TestDrive = {
    Routing = 1, --@comment มิติที่จะให้เทสไดร์ฟ
}

Default.Vat = 0.07 --@comment ภาษี

Default.plateLetters = 3 --@comment จำนวนตัวอักษรในทะเบียน
Default.plateNumbers = 3 --@comment จำนวนตัวเลขในทะเบียน