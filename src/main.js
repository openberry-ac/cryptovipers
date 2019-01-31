/* eslint-disable no-unused-vars */
import Vue from 'vue';
import BootstrapVue from 'bootstrap-vue';
import 'bootstrap/dist/css/bootstrap.min.css';
import 'bootstrap-vue/dist/bootstrap-vue.css';

import App from './App.vue';


Vue.use(BootstrapVue);

// So we don't encounter eslint rule no-new
// Reference: https://vuejs.org/v2/api/#vm-mount
const vm = new Vue({
  transformToRequire: {
    img: 'src',
    image: 'xlink:href',
  },
  render: h => h(App),
});
vm.$mount('#app');
