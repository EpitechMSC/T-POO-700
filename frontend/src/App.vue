<script setup lang="ts"></script>

<template>
  <div>
    <nav>
      <ul>
        <li>
          <router-link to="/home">
            Home
          </router-link>
        </li>
        <li>
          <router-link to="/login">
            login
          </router-link>
        </li>
      </ul>
    </nav>
    <router-view />
  </div>
</template>

<style scoped></style>
