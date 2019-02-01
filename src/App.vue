<template>
  <b-container class="mb-5">
    <b-row class="header-row">
      <b-col>
        <h1>CryptoVipers</h1>
        <p>Collect and breed digital vipers.</p>
      </b-col>
    </b-row>

    <b-row>
      <b-col class="action-container text-center">
        <h4>Buy a random Viper</h4>
        <img :src="unknownViperImg" class="unknown-viper">
        <b-button type="button" v-on:click="buyViper()">Buy</b-button>
        <p>Each Viper costs 0.02 Ether</p>
      </b-col>
      <b-col cols="2" class="middle-container">
        <img v-if="isLoading" src="https://media.giphy.com/media/2A6xoqXc9qML9gzBUE/giphy.gif">
        <h3 v-if="!isLoading">or</h3>
      </b-col>
      <b-col class="action-container">
        <h4>Breed two of the Vipers you own to make a new one!</h4>
        <b-form>
          <b-form-group id="matron"
                        label="Matron ID:"
                        label-for="matron">
            <b-form-input id="matron"
                          v-model="matron"
                          required
                          placeholder="Enter Matron ID">
            </b-form-input>
          </b-form-group>
          <b-form-group id="sire"
                        label="Sire ID:"
                        label-for="sire">
            <b-form-input id="sire"
                          v-model="sire"
                          required
                          placeholder="Enter Sire ID">
            </b-form-input>
          </b-form-group>
          <b-button v-on:click="breedVipers" type="button">Breed Vipers</b-button>
          <p>Breeding Vipers cost 0.05 Ether</p>
        </b-form>
      </b-col>
    </b-row>

    <hr>
    <h2 class="mb-5">Owned Vipers</h2>

    <b-row v-if="vipers.length == 0">
      <b-col>
        <h2>No Vipers owned yet!</h2>
      </b-col>
    </b-row>

    <b-row v-for="i in Math.ceil(vipers.length / 3)" v-bind:key="i">
      <b-col cols="4" v-for="item in vipers.slice((i - 1) * 3, i * 3)"
             v-bind:item="item"
             v-bind:key="item.id">
        <b-card style="height:400px;" class="mb-2">
          <b-img thumbnail fluid :src="item.url" class="image"/>
          <p class="card-text mt-2 text-center">
            <b>ID:</b> {{ item.id }}
            <br>
            <b>Origin:</b>
            <span v-if="item.matron == 0 && item.sire == 0">Bought</span>
            <span v-else>{{ item.matron }} & {{ item.sire }}</span>
          </p>
        </b-card>
      </b-col>
    </b-row>
  </b-container>
</template>

<script>
import getWeb3 from '../contracts/web3';
import contractAbi from '../contracts/abi';
import Viper1 from './assets/Viper/1.png';
import Viper2 from './assets/Viper/2.png';
import Viper3 from './assets/Viper/3.png';
import Viper4 from './assets/Viper/4.png';
import Viper5 from './assets/Viper/5.png';
import Viper6 from './assets/Viper/6.png';
import ViperX from './assets/Viper/unknown.png';

const contractAddress = ''; // Your deployed contract's address goes here
// Example:
// const contractAddress = '0x09r80cnasjfaks93m9v2';
const vipersMap = [null, Viper1, Viper2, Viper3, Viper4, Viper5, Viper6];

export default {
  name: 'App',
  data() {
    return {
      web3: null,
      account: null,
      contractInstance: null,
      gene: null,
      matron: null,
      sire: null,
      unknownViperImg: ViperX,
      vipers: [],
      isLoading: false,
    };
  },
  mounted() {
    getWeb3().then((res) => {
      this.web3 = res;
      this.contractInstance = new this.web3.eth.Contract(contractAbi, contractAddress);
      this.web3.eth.getAccounts().then((accounts) => {
        [this.account] = accounts;
        this.getVipers();
      }).catch((err) => {
        console.log(err, 'err!!');
      });
    });
  },
  methods: {
    // You can remove the console.log() in each function later :) 
    buyViper() {
      // Operations for buying a viper will be here!
      console.log('Buy viper!');
    },
    breedVipers() {
      // Operations for breeding vipers will be here!
      console.log('Breed vipers!');
    },
    getVipers() {
      // Operations for getting your owned will be here!
      console.log('Get viper details!');
    },
    addViperFromReceipt(receipt) {
      // Utility function to add a newly created viper to our list
      this.vipers.push({
        id: receipt.events.Birth.returnValues.viperId,
        genes: receipt.events.Birth.returnValues.genes,
        matron: receipt.events.Birth.returnValues.matronId,
        sire: receipt.events.Birth.returnValues.sireId,
        url: vipersMap[receipt.events.Birth.returnValues.genes],
      });
    },
  },
};
</script>

<style lang="css">
@import url('https://fonts.googleapis.com/css?family=Poppins:400,500');

* {
  font-family: 'Poppins', sans-serif;
}
button {
  width: 100%;
}
.header-row {
  text-align: center;
  margin: 30px 0;
}
.action-container h4 {
  text-align: center;
  margin-bottom: 30px;
}
.action-container p {
  text-align: center;
  margin-top: 10px;
}
.middle-container {
  display: flex;
  justify-content: center;
  align-items: center;
}
.middle-container img {
  height: 100px;
}
.unknown-viper {
  height: 180px;
  width: 180px;
  margin: 9px 0;
}
</style>
