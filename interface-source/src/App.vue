<template>
  <body>
  <div class="container">

    <!-- Left -->
    <div class="tap-left" v-if="selectedVehicle" v-show="main?.ui">

      <div class="box-title">
        <span class="titleShop">{{ titleShop }}</span>
        <span class="titleDetailShop">{{ titleDetailShop }}</span>
      </div>

      <div class="box-vehicleName">
        <span class="vehicleName">{{selectedVehicle.label}}</span>
        <span class="vehicleType">Type : {{selectedVehicle.category }}</span>
      </div>

      <div class="box-customColor">
        <span class="title-color">Custom Color</span>
        <div class="box-primary-color">
          <span class="text-color">สีหลัก</span>
          <input type="color" @input="setVehicleColor('primary',$event.target.value)" :value="defaultVehicleColor.primary">
        </div>
        <div class="box-secondary-color">
          <span class="text-color">สีรอง</span>
          <input type="color" @input="setVehicleColor('secondary',$event.target.value)" :value="defaultVehicleColor.secondary">
        </div>
      </div>

      <div class="box-Information">
        <span class="title-intormation">Information</span>
        <div class="box-vehicle-information">
          <div class="box-secon-info">
            <div class="box-price">
              <i class="fa-solid fa-coins"></i>
            </div>
              <div class="box-Information-detail">
                <span class="span-1">Price</span>
                <span>{{selectedVehicle.price}}</span>
              </div>
          </div>
          <div class="box-secon-info">
            <div class="box-stock">
              <i class="fa-solid fa-car"></i>
            </div>
              <div class="box-Information-detail">
                <span class="span-1">Stock</span>
                <span>{{selectedVehicle.stock == -1 ? 'Unlimited' : selectedVehicle.stock}}</span>
              </div>
          </div>
        </div>
      </div>


      <div class="box-performance">
        <span class="title-performance">Performance</span>
        <div class="box-vehicle-performance">

          <div class="box-handling">
            <div class="text-handling">
              <span>Handling</span>
            </div>
            <div class="box-progress-handling">
              <div id="progress-handling" :style="{width: performance.handling + '%'}">
              </div>
            </div>
          </div>

          <div class="box-acceleration">
            <div class="text-acceleration">
              <span>ACCELERATION</span>
            </div>
            <div class="box-progress-acceleration">
              <div id="progress-acceleration" :style="{width: performance.acceleration + '%'}">
              </div>
            </div>
          </div>

          <div class="box-braking">
            <div class="text-braking">
              <span>BRAKING</span>
            </div>
            <div class="box-progress-braking">
              <div id="progress-braking" :style="{width: performance.braking + '%'}">
              </div>
            </div>
          </div>

          <div class="box-speed">
            <div class="text-speed">
              <span>MAX SPEED</span>
            </div>
            <div class="box-progress-speed">
              <div id="progress-speed" :style="{width: performance.speed + '%'}">
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="box-btn">
        <button class="btn-testDrive" @click="testDriveVehicle">ทดลองรถ</button>
        <button class="btn-buy" @click="GetMyMoney">ชำระเงิน</button>
        <button class="btn-exit" @click="CloseShop">ออก</button>
        
      </div>

    </div>
    <!-- endLeft -->

    <!-- Right -->
    <div class="tap-right" v-show="main?.ui">

      <div class="box-filter">
        <div class="box-categories">
          <select class="minimal" v-model="selectedCategory">
            <option :value="category" v-for="(category,idx) in categories" :key="idx">{{category}}</option>
          </select>
        </div>
        <div class="box-search">
          <input type="search" placeholder="Search" v-model="search">
        </div>
      </div>
    

      <div class="box-list-car">
        <div class="list-car">
          <button class="box-car" v-for="(model,idx) in Vehicles" :key="idx" @click='selectVehicle(model)' :class="[selectedVehicle.model == model.model ? 'box-car-Active' : '']">
            <span class="car-name">{{ model.label }}</span>
            <div class="box-car-img">
              <img :src="`./assets/car/${model.model}.png`" :alt="model.model" v-if="imageExists(`./assets/car/${model.model}.png`)">
              <img :src="`./assets/car/car-unknow.png`" :alt="model.model" class="carUnknow" v-else>
            </div>
            <div class="box-car-detail">
              <span style="display: flex; justify-content:center;align-items:center; gap: 5px;">
                <i class="fa-solid fa-coins"></i>
                <span class="price">{{ model.price }}</span>
              </span>
              <span class="stock">
                Stock : {{ model.stock == -1 ? 'Unlimited' : model.stock}}
              </span>
            </div>
          </button>
        </div>
      </div>

    </div>
    <!-- endRight -->

    <!-- Control -->
    <div class="box-control" v-show="main?.ui">
        <p>
          กด <span class="btn-control">A</span> <span class="btn-control">D</span> ค้างเพื่อหมุนยานพาหนะ
        </p>   
    </div>

    <!-- endControl -->


    <!-- Payment -->
    <div class="box-payment" v-if="payment?.ui">
      <div class="box-payment-main">
        <i class="fa-solid fa-xmark" @click="payment.ui = false"></i>
        <div class="box-my-money">
          <span>CASH : {{ payment?.cash }} $</span>
          <span>BANK : {{ payment?.bank }} $</span>
        </div>
        <div class="box-vehicle-payment">
          

          <button class="bank" @click="BuyVehicle('bank', VehiclesBankPrice)" :disabled="(payment.bank >= VehiclesBankPrice) ? false : true" :class="[(payment.bank >= VehiclesBankPrice) ? 'btn-enable' : 'btn-disable']">
            <span>
              <i class="fa-solid fa-building-columns"></i>
              BANK ( + {{ parseInt(payment.vat * 100) }} % )
            </span>
            <span> {{VehiclesBankPrice}} $</span>
          </button>

          <button class="cash" @click="BuyVehicle('cash', VehiclesCashPrice)" :disabled="(payment.cash >= VehiclesCashPrice) ? false : true" :class="[(payment.cash >= VehiclesCashPrice) ? 'btn-enable' : 'btn-disable']">
            <span>
              <i class="fa-solid fa-money-bill"></i>
              CASH
            </span>
            <span>{{VehiclesCashPrice}} $</span>
          </button>
      </div>
    </div>
  </div>
  <!-- endPayment -->

  <div class="box-testDrive" v-if='TestDrive?.ui'>
    <div class="main-testdrive">
       <div class="box-timer-testdrive">
          <span>{{ TestDrive?.timer }}</span>
       </div>
       <div class="box-text-testdrive">
          <span>Test Drive</span>
       </div>
    </div>
  </div>
  

  </div>
</body>
</template>

<script>
export default {
  name: 'App',
  data() {
    return {
      titleShop: '',
      titleDetailShop: '',
      main: {
        ui: false
      },
      payment: {
        ui: false,
        cash: 0,
        bank: 0,
        vat: 0
      },
      search: '',
      selectedCategory: null,
      categories: [
        'All',
      ],
      vehicles: null,
      selectedVehicle: null,
      defaultVehicleColor: {
        primary: null,
        secondary: null
      },
      performance: {
        handling: 0.0,
        acceleration: 0.0,
        braking: 0.0,
        speed: 0.0
      },
      TestDrive :{
        ui: false,
        timer: 0
      }
      
    }
  },
  methods: {
        getData() {
            window.addEventListener('message', (event) => {
                if (event.data) {
                  let data = event.data;
                  if (data.action == 'openCardealer') {
                    this.main.ui = true;
                    this.titleShop = data.SvName;
                    this.titleDetailShop = data.shopName;
                    this.selectedCategory = 'All';
                    this.vehicles = data.vehicles;
                    data.vehicles.map((vehicle) => {
                      this.categories.includes(vehicle.category) ? '' : this.categories.push(vehicle.category)
                    })
                    this.selectVehicle(this.vehicles[0])
                    this.defaultVehicleColor.primary = this.rbgToHex(data.defualtColor.primary)
                    this.defaultVehicleColor.secondary = this.rbgToHex(data.defualtColor.secondary)
                  }
                  if (data.action == 'closeShop') {
                    this.CloseShop();
                  }
                  if (data.action == 'StartTestDrive') {
                    this.StartTestDrive();
                  }
                  if (data.action == 'updateTimerTestDrive') {
                      this.TestDrive.timer = data.timer;
                  }
                  if (data.action == 'BuyVehicleSuccessfully') {
                    this.BuyVehicleSuccessfully();
                  }
                }
            });
        },
        KeyDown() {
            window.addEventListener('keydown', (event) => {
              if (event.key == 'Escape') {
                    if (this.payment.ui) {
                      this.payment.ui = false;
                    }else{
                      this.CloseShop();
                    }
                }
              if (event.key == 'a') {
                  fetch(`https://${GetParentResourceName()}/setVehicleRotationLeft`, {
                  method: "POST",
                  headers: {
                    "Content-Type": "application/json",
                  },
                  body: JSON.stringify({}),
                  });
                }
                else if (event.key == 'd') {
                  fetch(`https://${GetParentResourceName()}/setVehicleRotationRight`, {
                  method: "POST",
                  headers: {
                    "Content-Type": "application/json",
                  },
                  body: JSON.stringify({}),
                  });
                }
            });
        },
        async CloseShop() {
          this.main.ui = false;
          this.payment.ui = false;
          this.vehicles = null;
          this.selectedCategory = null
          this.categories = [
            'All',
          ]
          this.search = ''
          this.vehiclesAll = []
          this.TestDrive.ui = false;
          this.TestDrive.timer = 0;
          this.payment.cash = 0;
          this.payment.money = 0;
          await fetch(`https://${GetParentResourceName()}/CloseShop`, {
            method: "POST",
            headers: {
              "Content-Type": "application/json",
            },
            body: JSON.stringify({}),
          });
        },
        async BuyVehicleSuccessfully(){
          this.main.ui = false;
          this.payment.ui = false;
          this.vehicles = null;
          this.selectedCategory = null
          this.categories = [
            'All',
          ]
          this.search = ''
          this.vehiclesAll = []
          this.TestDrive.ui = false;
          this.TestDrive.timer = 0;
          this.payment.cash = 0;
          this.payment.money = 0;
          await fetch(`https://${GetParentResourceName()}/BuyVehicleSuccessfully`, {
            method: "POST",
            headers: {
              "Content-Type": "application/json",
            },
            body: JSON.stringify({}),
          });
        },
        async selectVehicle(data){
          this.payment.ui = false;
          this.payment.cash = 0;
          this.payment.money = 0;
          this.selectedVehicle = data;
            await fetch(`https://${GetParentResourceName()}/showVehicle`, {
            method: "POST",
            headers: {
              "Content-Type": "application/json",
            },
            body: JSON.stringify(this.selectedVehicle),
            }).then((response) => response.json()).then((stats) => {
            this.performance.handling = parseFloat((stats.info.handling * 10));
            this.performance.acceleration = parseFloat((stats.info.acceleration * 10));
            this.performance.braking = parseFloat((stats.info.braking * 10));
            this.performance.speed = parseFloat((stats.info.speed * 10));
          });
          this.setVehicleColor('primary', this.defaultVehicleColor.primary)
          this.setVehicleColor('secondary', this.defaultVehicleColor.secondary)
        },
        hexToRgb(hex){
          let nexHex = hex.split('#')[1];
          var bigint = parseInt(nexHex, 16);
          var r = (bigint >> 16) & 255;
          var g = (bigint >> 8) & 255;
          var b = bigint & 255;
          
          return {
            r: r,
            g: g,
            b: b
          }

        },
        rbgToHex(rgb) {
          return "#" + ((1 << 24) + (rgb.r << 16) + (rgb.g << 8) + rgb.b).toString(16).slice(1);
        },
        async setVehicleColor(type ,value) {
          let color = this.hexToRgb(value);
          await fetch(`https://${GetParentResourceName()}/setVehicleColor`, {
            method: "POST",
            headers: {
              "Content-Type": "application/json",
            },
            body: JSON.stringify( 
              {
                type: type,
                r: color.r,
                g: color.g,
                b: color.b
              }
            ),
          });
        },
        async testDriveVehicle() {
          await fetch(`https://${GetParentResourceName()}/testDriveVehicle`, {
            method: "POST",
            headers: {
              "Content-Type": "application/json",
            },
            body: JSON.stringify({}),
          });
        },
      StartTestDrive() {
        this.main.ui = false;
        this.payment.ui = false;
        this.TestDrive.ui = true;
      },
      imageExists(image_url){
        var http = new XMLHttpRequest();
        http.open('HEAD', image_url, false);
        http.send();
        return http.status != 404;
      },
      async GetMyMoney() {
        await fetch(`https://${GetParentResourceName()}/GetMyMoney`, {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({}),
        }).then((response) => response.json()).then((res) => {
          this.payment.ui = true
          this.payment.cash = res.cash
          this.payment.bank = res.bank
          this.payment.vat = res.vat
        });
      },
      async BuyVehicle(typeMoney, price) {
        this.payment.ui = false;
        this.payment.cash = 0;
        this.payment.bank = 0;
        await fetch(`https://${GetParentResourceName()}/BuyVehicle`, {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            typeMoney: typeMoney,
            price: price
          }),
        });
      }
  },
  computed:{
    Vehicles() {
      if (this.main.ui) {
          if (this.selectedCategory == 'All' && this.search == '') {
            return this.vehicles
          } else if (this.selectedCategory != 'All' && this.search == '') {
            return this.vehicles.filter((vehicle) => {
              return vehicle.category == this.selectedCategory
            })
          } else if (this.selectedCategory == 'All' && this.search != '') {
            return this.vehicles.filter((vehicle) => {
              return vehicle.label.toLowerCase().includes(this.search.toLowerCase())
            })
          } else if (this.selectedCategory != 'All' && this.search != '') {
            return this.vehicles.filter((vehicle) => {
              return vehicle.label.toLowerCase().includes(this.search.toLowerCase()) && vehicle.category == this.selectedCategory
            })
          }
      }
    },
    VehiclesCashPrice(){
      return this.payment.ui ? this.selectedVehicle.price : 0
    },
    VehiclesBankPrice(){
      return this.payment.ui ? this.selectedVehicle.price + (this.selectedVehicle.price * this.payment.vat) : 0
    }
  },
  async mounted() {
    await this.getData();
    await this.KeyDown();
  }
}
</script>

<style></style>