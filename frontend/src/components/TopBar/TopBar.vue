<template>
  <div class="user-bar flex justify-between items-center h-[70px] p-8">
    <!-- Search Bar -->
    <div
      class="search-bar flex items-center border border-gray rounded-full px-4 py-2 bg-gray-50"
    >
      <svg
        class="w-5 h-5 text-gray-400 mr-2"
        fill="none"
        stroke="currentColor"
        viewBox="0 0 24 24"
        xmlns="http://www.w3.org/2000/svg"
      >
        <path
          stroke-linecap="round"
          stroke-linejoin="round"
          stroke-width="2"
          d="M21 21l-4.35-4.35m0 0a7 7 0 10-9.9 0 7 7 0 009.9 0z"
        ></path>
      </svg>
      <input
        type="text"
        placeholder="Search"
        class="outline-none bg-transparent text-gray-700 placeholder-gray-400 w-full"
      />
    </div>

    <!-- User Profile -->
    <div class="user-profile flex items-center">
      <p class="capitalize mr-2">gilbert</p>
      <img
        class="rounded-full w-10 h-10"
        src="../../assets/Capture d’écran 2023-10-09 150736.jpg"
        alt="User Profile"
      />
    </div>
  </div>
</template>

<script>
import { defineComponent } from 'vue';

export default defineComponent({
  name: 'TopBar',
});
</script>

<style scoped></style>
