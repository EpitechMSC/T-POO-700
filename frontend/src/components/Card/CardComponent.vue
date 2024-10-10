<template>
  <div class="skeuo-no-hover flex-col rounded-lg text-center p-8 w-64">
    <div class="text-7xl font-black">4:20{{ data }}</div>
    <div class="text-3xl">Worked today</div>
  </div>
</template>
<script>
export default {
  name: 'CardComponent',
  props: {
    data: {
      required: true,
    },
    text: {
      required: false,
    },
    icon: {
      required: false,
    },
  },
  computed: {},
};
</script>
<style>
.skeuo-no-hover div {
  font-family: 'Inter', sans-serif;
  font-optical-sizing: auto;
  font-weight: weight;
  font-style: normal;
}
.skeuo-no-hover {
  box-shadow:
    -5px -5px 10px white,
    5px 5px 10px rgba(0, 0, 0, 0.1),
    inset -5px -5px 10px white,
    inset 5px 5px 10px rgba(0, 0, 0, 0.1);
  transition: ease-in-out 0.1s;
}
</style>
