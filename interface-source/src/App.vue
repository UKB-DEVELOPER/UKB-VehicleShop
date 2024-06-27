<template>
  <div class="container" v-show="main?.ui">

    <!-- Left -->
    <div class="tap-left" v-if="selectedVehicle">

      <div class="box-title">
        <span class="titleShop">{{ titleShop }}</span>
        <span class="titleDetailShop">{{ titleDetailShop }}</span>
      </div>

      <div class="box-vehicleName">
        <span class="vehicleName">{{selectedVehicle.label}}</span>
        <span class="vehicleType">Type : Super</span>
      </div>

      <div class="box-customColor">
        <span class="title-color">Custom Color</span>
        <div class="box-primary-color">
          <span class="text-color">สีหลัก</span>
          <input type="color">
          <button class="resetColor">คืนค่าสีเดิม</button>
        </div>
        <div class="box-secondary-color">
          <span class="text-color">สีรอง</span>
          <input type="color">
          <button class="resetColor">คืนค่าสีเดิม</button>
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
                <span>{{selectedVehicle.stock}}</span>
              </div>
          </div>
        </div>
      </div>


      <div class="box-performance">
        <span class="title-performance">Performance</span>
        <div class="box-vehicle-performance">

          <div class="box-headling">
            <div class="text-headling">
              <span>HEADLING</span>
              <span>15.58</span>
            </div>
            <div class="box-progress-headling">
              <div id="progress-headling">
              </div>
            </div>
          </div>

          <div class="box-acceleration">
            <div class="text-acceleration">
              <span>ACCELERATION</span>
              <span>110 M/S</span>
            </div>
            <div class="box-progress-acceleration">
              <div id="progress-acceleration">
              </div>
            </div>
          </div>

          <div class="box-braking">
            <div class="text-braking">
              <span>BRAKING</span>
              <span>2 N</span>
            </div>
            <div class="box-progress-braking">
              <div id="progress-braking">
              </div>
            </div>
          </div>

          <div class="box-speed">
            <div class="text-speed">
              <span>MAX SPEED</span>
              <span>200 Km/Hr</span>
            </div>
            <div class="box-progress-speed">
              <div id="progress-speed">
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="box-btn">
        <button class="btn-testDrive">ทดลองรถ</button>
        <button class="btn-buy">ชำระเงิน</button>
        <button class="btn-exit" @click="CloseShop">ออก</button>
        
      </div>

    </div>
    <!-- endLeft -->

    <!-- Right -->
    <div class="tap-right">

      <div class="box-filter">
        <div class="box-categories">
          <select class="minimal" v-model="selectedCategory">
            <option :value="category" v-for="(category,idx) in categories" :key="idx">{{category}}</option>
          </select>
        </div>
        <div class="box-search">
          <input type="text" placeholder="Search" v-model="search">
        </div>
      </div>

      <div class="box-list-car">
        <div class="list-car">
          <button class="box-car" v-for="(model,idx) in Vehicles" :key="idx" @click='selectVehicle(model)'>
            <span class="car-name">{{ model.label }}</span>
            <div class="box-car-img">
              <img :src="'/assets/car/' + model.model + '.png'" :alt="model.model">
            </div>
            <div class="box-car-detail">
              <span style="display: flex; justify-content:center;align-items:center; gap: 5px;">
                <i class="fa-solid fa-coins"></i>
                <span class="price">{{ model.price }}</span>
              </span>
              <span class="stock">
                Stock : {{ model.stock }}
              </span>
            </div>
          </button>
        </div>
      </div>

    </div>
    <!-- endRight -->

    <!-- Control -->
    <div class="box-control">
        <p>
          กด <span class="btn-control">A</span> <span class="btn-control">D</span> ค้างเพื่อหมุนยานพาหนะ <span>|</span> กด <span class="btn-control">W</span>เพื่อทดสอบเครื่องยนต์
        </p>   
    </div>

    <!-- endControl -->


    <!-- Payment -->
    <div class="box-payment" v-show="payment?.ui">
      <div class="box-payment-main">
        <i class="fa-solid fa-xmark"></i>
        <div class="box-my-money">
          <span>CASH : 1200000 $</span>
          <span>BANK : 1200000 $</span>
        </div>
        <div class="box-vehicle-payment">
          
          <button class="bank">
            <span>
              <i class="fa-solid fa-building-columns"></i>
              BANK (+3%)
            </span>
            <span>9999999 $</span>
          </button>

          <button class="cash">
            <span>
              <i class="fa-solid fa-money-bill"></i>
              CASH
            </span>
            <span>9999999 $</span>
          </button>
      </div>
    </div>
  </div>

  <!-- endPayment -->

  </div>
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
        ui: false
      },
      search: '',
      selectedCategory: null,
      categories: [
        'All',
      ],
      vehiclesAll: [],
      vehicles: null,
      selectedVehicle: null,
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
                    for (const [key, value] of Object.entries(data.vehicles)) {
                      this.categories.push(key)
                    }
                    for (const [key, value] of Object.entries(data.vehicles)) {
                      for (const [key2, value2] of Object.entries(value)) {
                        this.vehiclesAll.push(value2)
                      }
                    }
                    this.selectVehicle(this.vehiclesAll[0])
                  }
                }
            });
        },
        KeyDown() {
            window.addEventListener('keydown', (event) => {
              if (event.key == 'Escape') {
                    this.CloseShop();
                }
              if (event.key == 'a') {
                  fetch(`https://${GetParentResourceName()}/carRotationLeft`, {
                  method: "POST",
                  headers: {
                    "Content-Type": "application/json",
                  },
                  body: JSON.stringify({}),
                  });
                }
                else if (event.key == 'd') {
                  fetch(`https://${GetParentResourceName()}/carRotationRight`, {
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
          await fetch(`https://${GetParentResourceName()}/CloseShop`, {
            method: "POST",
            headers: {
              "Content-Type": "application/json",
            },
            body: JSON.stringify({}),
          });
        },
        async selectVehicle(data){
          this.selectedVehicle = data;
          await fetch(`https://${GetParentResourceName()}/showVehicle`, {
            method: "POST",
            headers: {
              "Content-Type": "application/json",
            },
            body: JSON.stringify(this.selectedVehicle),
          });
          
        }
  },
  computed:{
    Vehicles() {
      if (this.main.ui) {
        if (this.selectedCategory == 'All' && this.search != '') {
          return this.vehiclesAll.filter((vehicle) => {
          return vehicle.label.toLowerCase().includes(this.search.toLowerCase())
          })
        } else if (this.selectedCategory != 'All' && this.search != '') {
            return this.vehicles[this.selectedCategory].filter((vehicle) => {
            return vehicle.label.toLowerCase().includes(this.search.toLowerCase())
          })
        }
        else if (this.selectedCategory == 'All'){
           return this.vehiclesAll
        }else if (this.selectedCategory != 'All') {
            return this.vehicles[this.selectedCategory]
        }
      }
    }
  },
  async mounted() {
    await this.getData();
    await this.KeyDown();
  }
}
</script>

<style></style>