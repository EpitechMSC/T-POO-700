<template>
  <div>
    <img alt="Vue logo" src="./assets/logo.png" />
    <nav>
      <ul>
        <li><router-link to="/home">Home</router-link></li>
      </ul>
    </nav>
    <router-view />
  </div>
</template>

<script lang="ts">
import { Options, Vue } from 'vue-class-component';

@Options({})
export default class App extends Vue {}
</script>
