<template>
  <div v-if="batSignalStatus">
    <div class="police-tape">
      <div class="moving-text w-full flex justify-around">
        <span>Batsignal is on</span>
      </div>
    </div>
  </div>
</template>
<script>
import { defineComponent, ref, onMounted } from 'vue';
import { useSignalStore } from '../../app/store/store';

export default defineComponent({
  name: 'BatSignal',
  setup() {
    const signalStore = useSignalStore();

    const batSignalStatus = ref('');

    const updateStatus = async () => {
      batSignalStatus.value = await signalStore.getStatus();
    };
    const repeatText = () => {
      const movingText = document.querySelector('.moving-text');
      if (movingText) {
        const span = movingText.querySelector('span');
        if (span) {
          const containerWidth =
            document.querySelector('.police-tape').offsetWidth;
          const textWidth = span.offsetWidth;

          // Calculate how many times to repeat the text to ensure multiple instances are visible
          const repeatCount = Math.ceil(containerWidth / textWidth) + 5; // +5 ensures extra repetition to cover width

          // Repeat the text multiple times to fill the container
          movingText.innerHTML = span.outerHTML.repeat(repeatCount);
        }
      }
    };
    onMounted(() => {
      updateStatus();
      setInterval(updateStatus, 1000);
      setInterval(() => {
        if (batSignalStatus.value) {
          repeatText();
        }
      }, 100);
    });
    return {
      batSignalStatus,
    };
  },
});
</script>
<style>
@import url('https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&display=swap');

.police-tape {
  background-color: yellow;
  color: black;
  font-size: 1.5rem;
  font-weight: bold;
  text-align: center;
  padding: 10px 0;
  background-image: linear-gradient(
    45deg,
    transparent 25%,
    black 25%,
    black 50%,
    transparent 50%,
    transparent 75%,
    black 75%,
    black 100%
  );
  background-size: 40px 40px;
  text-transform: uppercase;
  letter-spacing: 2px;
  border-radius: 5px;
  overflow: hidden;
}
.moving-text {
  background-color: yellow;
  display: inline-block;
  white-space: nowrap;
  animation: scroll-right 10s linear infinite;
}

.moving-text span {
  background-color: yellow;
  display: inline-block;
  padding-right: 50px; /* Space between repeated phrases */
}

@keyframes scroll-right {
  0% {
    transform: translateX(0);
  }
  100% {
    transform: translateX(-50%);
  }
}
</style>
